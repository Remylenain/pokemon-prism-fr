#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parsemap.h"

int load_file(const char *, void **);
int generate_patch_data(const unsigned char *, const unsigned char *, const MapSection *, const MapSection *, unsigned, const char *, const char *);
int output_patch_data(const char *, const void *, unsigned);
unsigned effective_address(unsigned short, unsigned short, unsigned short);
void append_record(unsigned char **, unsigned *, unsigned char **, unsigned *, unsigned, unsigned, const unsigned char *);
void append_data_to_buffer(unsigned char **, unsigned *, const unsigned char *, unsigned);
const MapSection * find_section(const MapSection *, const char *);
unsigned char find_best_fill_byte(const unsigned char *, unsigned);

int main (int argc, char ** argv) {
  if (argc != 7) {
    fprintf(stderr, "usage: %s <base ROM> <base map> <GBS file> <GBS map> <result> <binary>\n", *argv);
    return 1;
  }
  MapSection * ROM_sections = get_sections_from_map_file(argv[2]);
  if (!ROM_sections) {
    fprintf(stderr, "error: could not load section map from file %s\n", argv[2]);
    return 2;
  }
  MapSection * GBS_sections = get_sections_from_map_file(argv[4]);
  if (!GBS_sections) {
    destroy_section_array(ROM_sections);
    fprintf(stderr, "error: could not load section map from file %s\n", argv[4]);
    return 2;
  }
  void * base_ROM;
  void * GBS;
  int ROM_size = load_file(argv[1], &base_ROM);
  int GBS_size = load_file(argv[3], &GBS);
  if ((ROM_size < 0) || (GBS_size < 0)) {
    free(base_ROM);
    free(GBS);
    destroy_section_array(ROM_sections);
    destroy_section_array(GBS_sections);
    fprintf(stderr, "error: could not load file %s\n", (ROM_size < 0) ? argv[1] : argv[3]);
    return 2;
  }
  int rv = generate_patch_data(base_ROM, GBS, ROM_sections, GBS_sections, GBS_size, argv[5], argv[6]);
  free(base_ROM);
  free(GBS);
  destroy_section_array(ROM_sections);
  destroy_section_array(GBS_sections);
  return rv;
}

int load_file (const char * filename, void ** result) {
  *result = NULL;
  FILE * fp = fopen(filename, "rb");
  if (!fp) return -1;
  char * file_data = NULL;
  unsigned result_size = 0;
  char buffer[16384];
  unsigned read_size;
  while (!feof(fp)) {
    read_size = fread(buffer, 1, 16384, fp);
    if (ferror(fp)) {
      free(file_data);
      fclose(fp);
      return -1;
    }
    if (!read_size) break;
    file_data = realloc(file_data, result_size + read_size);
    memcpy(file_data + result_size, buffer, read_size);
    result_size += read_size;
  }
  fclose(fp);
  *result = file_data;
  return result_size;
}

int generate_patch_data (const unsigned char * base_ROM, const unsigned char * GBS, const MapSection * ROM_sections, const MapSection * GBS_sections,
                         unsigned GBS_size, const char * output_file, const char * intermediate_file) {
  /*
     The patch has four parts:
     1) Home bank size. This is just a halfword.
     2) Home bank data. This is XORed with the release ROM's data at address zero. The size is given by the previous item.
     3) Data blocks. These are (length, address) pairs that indicates where to extract the GBS data from. The length is 2 bytes; the address is 3 bytes
        and points into the base ROM. This list is terminated by a 0 halfword. If the address is less than 0x100, it represents a fill byte.
     4) IPS patch. This is a (hopefully) small patch that fixes small differences between the ROM data and the GBS data (e.g., arguments to callchannel).
     This program generates the first three parts as its output. The IPS patch generation is left to ipspatch; in order to generate that patch, this
     program outputs the intermediate file resulting from applying the patch without the IPS part.
  */
  if ((ROM_sections -> type != SECTION_ROM) || (GBS_sections -> type != SECTION_ROM)) {
    fputs("error: map files contain no ROM sections\n", stderr);
    return 3;
  }
  if (GBS_sections -> bank) {
    fputs("error: GBS map file doesn't contain a home bank\n", stderr);
    return 3;
  }
  unsigned short home_load_address = GBS_sections -> address;
  unsigned current_size = 0x4000 - home_load_address;
  unsigned char * idata = malloc(current_size);
  unsigned isize = current_size;
  memcpy(idata, GBS, current_size);
  unsigned char * output = malloc(2 + current_size);
  *output = current_size;
  output[1] = current_size >> 8;
  current_size += 2; // actual size of the output buffer
  unsigned p;
  for (p = 2; p < current_size; p ++) output[p] = base_ROM[p - 2] ^ GBS[p - 2];
  while ((GBS_sections -> type == SECTION_ROM) && !(GBS_sections -> bank)) GBS_sections ++;
  if (GBS_sections -> type != SECTION_ROM) {
    free(output);
    fputs("error: GBS map file contains nothing but the home bank\n", stderr);
    return 3;
  }
  unsigned short current_bank = 1, current_load_address = 0x4000;
  const MapSection * match;
  unsigned match_length, match_location, match_limit = 0x4000 - home_load_address;
  if (match_limit < 0x100) match_limit = 0x100;
  while (GBS_sections -> type == SECTION_ROM) {
    p = effective_address(current_bank, current_load_address, home_load_address);
    if (current_bank != GBS_sections -> bank) {
      append_record(&output, &current_size, &idata, &isize, effective_address(GBS_sections -> bank, 0x4000, home_load_address) - p, GBS[p], base_ROM);
      current_bank = GBS_sections -> bank;
      current_load_address = 0x4000;
      continue;
    }
    if (current_load_address != GBS_sections -> address) {
      append_record(&output, &current_size, &idata, &isize, effective_address(current_bank, GBS_sections -> address, home_load_address) - p, GBS[p], base_ROM);
      current_load_address = GBS_sections -> address;
      continue;
    }
    match = find_section(ROM_sections, GBS_sections -> name);
    if (match && (match -> address < match_limit)) match = NULL;
    if (match) {
      match_length = (match -> length < GBS_sections -> length) ? match -> length : GBS_sections -> length;
      match_location = effective_address(match -> bank, match -> address, 0);
      append_record(&output, &current_size, &idata, &isize, match_length, match_location, base_ROM);
      current_load_address += match_length;
    } else {
      match_location = effective_address(GBS_sections -> bank, GBS_sections -> address, home_load_address);
      p = find_best_fill_byte(GBS + match_location, GBS_sections -> length);
      append_record(&output, &current_size, &idata, &isize, GBS_sections -> length, p, base_ROM);
      current_load_address += GBS_sections -> length;
    }
    GBS_sections ++;
  }
  match_location = effective_address(current_bank, current_load_address, home_load_address);
  match_length = GBS_size - match_location;
  while (match_length) {
    match_limit = (match_length > 0xffff) ? 0xffff : match_length;
    append_record(&output, &current_size, &idata, &isize, match_limit, GBS[match_location], base_ROM);
    match_location += match_limit;
    match_length -= match_limit;
  }
  append_data_to_buffer(&output, &current_size, (unsigned char []) {0, 0}, 2);
  int rv = output_patch_data(output_file, output, current_size);
  free(output);
  if (!rv) rv = output_patch_data(intermediate_file, idata, isize);
  free(idata);
  return rv;
}

int output_patch_data (const char * filename, const void * data, unsigned size) {
  FILE * fp = fopen(filename, "wb");
  if (!fp) {
    fprintf(stderr, "error: could not open file '%s' for writing\n", filename);
    return 2;
  }
  const char * current = data;
  unsigned written = 0;
  while (size) {
    clearerr(fp);
    written = fwrite(current, 1, size, fp);
    if (!written && ferror(fp)) {
      fprintf(stderr, "error: could not write data to %s\n", filename);
      break;
    }
    size -= written;
    current += written;
  }
  fclose(fp);
  return written ? 0 : 2;
}

unsigned effective_address (unsigned short bank, unsigned short address, unsigned short home_load_address) {
  unsigned result = (unsigned) bank << 14;
  if (bank)
    result += address - 0x4000;
  else
    result += address;
  return result - home_load_address;
}

void append_record (unsigned char ** output, unsigned * size, unsigned char ** idata, unsigned * isize, unsigned length, unsigned address,
                    const unsigned char * base_ROM) {
  unsigned char record_data[5];
  *record_data = length;
  record_data[1] = length >> 8;
  record_data[2] = address;
  record_data[3] = address >> 8;
  record_data[4] = address >> 16;
  append_data_to_buffer(output, size, record_data, 5);
  if (address >= 0x100)
    append_data_to_buffer(idata, isize, base_ROM + address, length);
  else {
    unsigned char * buffer = malloc(length);
    memset(buffer, address, length);
    append_data_to_buffer(idata, isize, buffer, length);
    free(buffer);
  }
}

void append_data_to_buffer (unsigned char ** buffer, unsigned * size, const unsigned char * data, unsigned length) {
  *buffer = realloc(*buffer, *size + length);
  memcpy(*buffer + *size, data, length);
  *size += length;
}

const MapSection * find_section (const MapSection * sections, const char * name) {
  for (; sections -> type == SECTION_ROM; sections ++) if (!strcmp(sections -> name, name)) return sections;
  return NULL;
}

unsigned char find_best_fill_byte (const unsigned char * buffer, unsigned length) {
  if (!length) return 0;
  if (length <= 2) return *buffer;
  unsigned counts[256] = {0};
  unsigned runs[256] = {0};
  unsigned current = 1;
  unsigned char value = *buffer;
  counts[*buffer] = 1;
  for (buffer ++, length --; length; buffer ++, length --) {
    counts[*buffer] ++;
    if (*buffer == value)
      current ++;
    else {
      if (current > 5) runs[value] += current - 5;
      current = 1;
    }
  }
  if (current > 5) runs[value] += current - 5;
  value = 0;
  for (current = 1; current <= 255; current ++)
    if ((runs[current] > runs[value]) || ((runs[current] == runs[value]) && (counts[current] > counts[value])))
      value = current;
  return value;
}
