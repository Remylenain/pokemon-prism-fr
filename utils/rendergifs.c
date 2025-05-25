#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdarg.h>

#include "libplum.h"

enum keywords {PICS, FRAMES, BITMASKS, ANIMATIONS, EXTRA, PALETTES, STATS, STATS_NEXT, NUM_KEYWORDS};
enum config {DELAY_MAIN, DELAY_EXTRA, FRONT_IMAGES, BACK_IMAGES, DIMS_OFFSET, NUM_CONFIG};

const char * const keywords[] = {
  [PICS]       = "pics",
  [FRAMES]     = "frames",
  [BITMASKS]   = "masks",
  [ANIMATIONS] = "anim",
  [EXTRA]      = "extra",
  [PALETTES]   = "pals",
  [STATS]      = "stats",
  [STATS_NEXT] = "stats1"
};

const char * const config_keywords[] = {
  [DELAY_MAIN]   = "delay0",
  [DELAY_EXTRA]  = "delay1",
  [FRONT_IMAGES] = "ifront",
  [BACK_IMAGES]  = "iback",
  [DIMS_OFFSET]  = "dimoffs"
};

const unsigned long config_limits[] = {
  [DELAY_MAIN]   = 255,
  [DELAY_EXTRA]  = 255,
  [FRONT_IMAGES] = 2,
  [BACK_IMAGES]  = 2,
  [DIMS_OFFSET]  = 0x3fff
};

struct picdata {
  size_t count;
  unsigned char * indexes;
  char ** prefixes;
  char * symbols[NUM_KEYWORDS];
  unsigned long config[NUM_CONFIG];
  uint32_t addresses[NUM_KEYWORDS];
};

struct animation {
  uint16_t length;
  unsigned char maxframe;
  _Alignas(uint16_t) struct {
    unsigned char frame;
    unsigned char duration;
  } frames[];
};

int main(int, char **);
_Noreturn void error_exit(int, const char *, ...);
struct picdata process_picdata_file(FILE *);
void render_mon_images(char * restrict, unsigned char, const uint32_t [restrict static NUM_KEYWORDS], const unsigned char *, size_t,
                       const unsigned long [restrict static NUM_CONFIG]);
struct animation * load_animation(const unsigned char *, size_t, uint32_t, unsigned char);
void render_frame(uint8_t * restrict, const unsigned char *, const unsigned char *, unsigned char);
unsigned char * decompress(const unsigned char *, size_t, uint32_t, size_t * restrict);
FILE * open_file(const char *, const char *);
char * read_line(FILE *);
unsigned long read_value(const char *, bool);
char * duplicate_string(const char *);
unsigned char read_byte(const unsigned char *, size_t, unsigned long);
uint32_t read_near_pointer(const unsigned char *, size_t, unsigned long);
uint32_t read_far_pointer(const unsigned char *, size_t, unsigned long);
void output_front_animations(char * restrict, size_t, const uint8_t *, const uint16_t *, const struct animation *, unsigned char, unsigned char);
void output_back_pictures(char * restrict, size_t, const uint8_t *, const uint16_t *, unsigned char);

int main (int argc, char ** argv) {
  if (argc != 5) {
    fprintf(stderr, "usage: %s <file.gbc> <file.sym> <picdata.txt> <prefix>\n", *argv);
    return 4;
  }
  FILE * fp = open_file(argv[3], "r");
  struct picdata picdata = process_picdata_file(fp);
  fclose(fp);
  if (!(picdata.config[DELAY_MAIN] && picdata.config[DELAY_EXTRA])) error_exit(1, "delay parameters cannot be zero");
  unsigned char * ROM = NULL;
  size_t sizeROM = 0;
  fp = open_file(argv[1], "rb");
  while (!(feof(fp) || ferror(fp))) {
    unsigned char data[0x4000];
    int rv = fread(data, 1, sizeof data, fp);
    if (!rv) break;
    if (!(ROM = realloc(ROM, sizeROM + rv))) abort();
    memcpy(ROM + sizeROM, data, rv);
    sizeROM += rv;
  }
  fclose(fp);
  fp = open_file(argv[2], "r");
  for (char * restrict line = read_line(fp); line; free(line), line = read_line(fp)) {
    char * p = strchr(line, ';');
    if (p) *p = 0;
    char * address = line + strspn(line, " \t");
    if (!*address || *address == ';') continue;
    char * symbol = address + strcspn(address, " \t");
    if (!*symbol) continue;
    *(symbol ++) = 0;
    symbol += strspn(symbol, " \t");
    if (!*symbol) continue;
    unsigned keyword;
    for (keyword = 0; keyword < NUM_KEYWORDS; keyword ++) if (!strcmp(symbol, picdata.symbols[keyword])) break;
    if (keyword == NUM_KEYWORDS) continue;
    p = strchr(address, ':');
    if (!p) error_exit(1, "invalid address for %s: %s", picdata.symbols[keyword], address);
    *(p ++) = 0;
    unsigned long bank = read_value(address, true), offset = read_value(p, true);
    if (offset > 0x7fff || (bank && offset < 0x4000))
      error_exit(1, "invalid ROM address for %s: %02lx:%04lx", picdata.symbols[keyword], bank, offset);
    unsigned long absolute = (bank << 14) | (offset & 0x3fff);
    if (absolute >= sizeROM) error_exit(1, "address 0x%lx exceeds ROM size 0x%zx", absolute, sizeROM);
    picdata.addresses[keyword] = absolute;
  }
  fclose(fp);
  for (unsigned keyword = 0; keyword < NUM_KEYWORDS; keyword ++) {
    if (!picdata.addresses[keyword]) error_exit(1, "undefined symbol: %s", picdata.symbols[keyword]);
    free(picdata.symbols[keyword]);
  }
  if (picdata.addresses[STATS_NEXT] <= picdata.addresses[STATS]) error_exit(1, "base stats size would be non-positive");
  size_t baselen = strlen(argv[4]);
  for (size_t entry = 0; entry < picdata.count; entry ++) {
    size_t length = strlen(picdata.prefixes[entry]);
    char * filename = malloc(baselen + length + 16);
    if (!filename) abort();
    memcpy(filename, argv[4], baselen);
    memcpy(filename + baselen, picdata.prefixes[entry], length + 1);
    free(picdata.prefixes[entry]);
    render_mon_images(filename, picdata.indexes[entry], picdata.addresses, ROM, sizeROM, picdata.config);
    free(filename);
  }
  free(ROM);
  free(picdata.prefixes);
  free(picdata.indexes);
  return 0;
}

_Noreturn void error_exit (int status, const char * error, ...) {
  fputs("error: ", stderr);
  va_list ap;
  va_start(ap, error);
  vfprintf(stderr, error, ap);
  va_end(ap);
  putc('\n', stderr);
  exit(status);
}

struct picdata process_picdata_file (FILE * fp) {
  struct picdata result = {0};
  bool configloaded[NUM_CONFIG] = {0};
  for (char * restrict line = read_line(fp); line; free(line), line = read_line(fp)) {
    char * current = line + strspn(line, " \t");
    char * p = strchr(current, ';');
    if (p) *p = 0;
    if (!*current) continue;
    p = current + strcspn(current, " \t");
    if (*p) {
      *(p ++) = 0;
      p += strspn(p, " \t");
    }
    if (!*p) error_exit(1, "token without value: %s", current);
    if (*current == 'P') {
      unsigned long index = read_value(current + 1, false);
      if (!index || index > 254) error_exit(1, "invalid index: %lu", index);
      if (!(result.indexes = realloc(result.indexes, result.count + 1))) abort();
      if (!(result.prefixes = realloc(result.prefixes, (result.count + 1) * sizeof *result.prefixes))) abort();
      result.indexes[result.count] = index;
      result.prefixes[result.count ++] = duplicate_string(p);
    } else {
      unsigned keyword;
      for (keyword = 0; keyword < NUM_KEYWORDS; keyword ++) if (!strcmp(keywords[keyword], current)) {
        if (result.symbols[keyword]) error_exit(1, "keyword given twice: %s", current);
        result.symbols[keyword] = duplicate_string(p);
        break;
      }
      if (keyword == NUM_KEYWORDS) {
        for (keyword = 0; keyword < NUM_CONFIG; keyword ++) if (!strcmp(config_keywords[keyword], current)) {
          if (configloaded[keyword]) error_exit(1, "keyword given twice: %s", current);
          configloaded[keyword] = true;
          result.config[keyword] = read_value(p, false);
          if (result.config[keyword] > config_limits[keyword]) error_exit(1, "value for %s is over %lu", current, config_limits[keyword]);
          break;
        }
        if (keyword == NUM_CONFIG) error_exit(1, "unknown key: %s", current);
      }
    }
  }
  for (unsigned keyword = 0; keyword < NUM_KEYWORDS; keyword ++)
    if (!result.symbols[keyword]) error_exit(1, "no symbol for keyword: %s", keywords[keyword]);
  for (unsigned keyword = 0; keyword < NUM_CONFIG; keyword ++)
    if (!configloaded[keyword]) error_exit(1, "no data for keyword: %s", config_keywords[keyword]);
  return result;
}

void render_mon_images (char * restrict filename, unsigned char index, const uint32_t addresses[restrict static NUM_KEYWORDS],
                        const unsigned char * ROM, size_t sizeROM, const unsigned long config[restrict static NUM_CONFIG]) {
  // load the frontpic side dimensions (in tiles) from the base stats
  unsigned long address = addresses[STATS] + (addresses[STATS_NEXT] - addresses[STATS]) * (index - 1) + config[DIMS_OFFSET];
  unsigned char dimensions = read_byte(ROM, sizeROM, address);
  if (!dimensions || dimensions >= 0x80 || (dimensions & 15) != (dimensions >> 4))
    error_exit(1, "frontpic %hhu has invalid dimensions 0x%02hhx", index, dimensions);
  dimensions &= 15;
  // load the palettes (normal and shiny) used by the pics
  uint16_t palettes[8] = {[0] = 0x7fff, [4] = 0x7fff};
  address = addresses[PALETTES] + index * 8;
  if (address + 7 >= sizeROM) error_exit(1, "address 0x%lx exceeds ROM size 0x%zx", address + 7, sizeROM);
  palettes[1] = ((ROM[address + 1] & 0x7f) << 8) | ROM[address];
  palettes[2] = ((ROM[address + 3] & 0x7f) << 8) | ROM[address + 2];
  palettes[5] = ((ROM[address + 5] & 0x7f) << 8) | ROM[address + 4];
  palettes[6] = ((ROM[address + 7] & 0x7f) << 8) | ROM[address + 6];
  // load both the animation script and the extra animation script, and combine them into a single animation
  struct animation * restrict animation = load_animation(ROM, sizeROM, addresses[ANIMATIONS], index);
  struct animation * restrict extra = load_animation(ROM, sizeROM, addresses[EXTRA], index);
  animation = realloc(animation, sizeof *animation + (animation -> length + extra -> length + 2) * sizeof *animation -> frames);
  if (!animation) abort();
  if (extra -> maxframe > animation -> maxframe) animation -> maxframe = extra -> maxframe;
  animation -> frames[animation -> length].frame = 0;
  animation -> frames[animation -> length ++].duration = config[DELAY_MAIN];
  memcpy(animation -> frames + animation -> length, extra -> frames, extra -> length * sizeof *extra -> frames);
  animation -> length += extra -> length;
  free(extra);
  animation -> frames[animation -> length].frame = 0;
  animation -> frames[animation -> length ++].duration = config[DELAY_EXTRA];
  // load the tile IDs for each frame (based on the bitmasks), and set totaltiles to the number of tiles in the frontpic
  unsigned char (* frametiles)[dimensions * dimensions] = malloc((animation -> maxframe + 1) * sizeof *frametiles);
  if (!frametiles) abort();
  for (unsigned tile = 0; tile < dimensions * dimensions; tile ++) (*frametiles)[tile] = tile;
  address = read_far_pointer(ROM, sizeROM, addresses[FRAMES] + index * 3 - 3) - 2;
  uint32_t masks = read_near_pointer(ROM, sizeROM, addresses[BITMASKS] + index * 2 - 2);
  unsigned char totaltiles = dimensions * dimensions;
  for (unsigned frame = 1; frame <= animation -> maxframe; frame ++) {
    uint32_t p = read_near_pointer(ROM, sizeROM, address + frame * 2);
    unsigned char maskbytes = (dimensions * dimensions + 7) >> 3;
    uint32_t maskaddress = (read_byte(ROM, sizeROM, p ++) + 1) * maskbytes + masks;
    if (maskaddress > sizeROM) error_exit(1, "address 0x%lx exceeds ROM size 0x%zx", maskaddress - 1, sizeROM);
    uint64_t mask = 0;
    while (maskbytes --) mask = (mask << 8) | ROM[-- maskaddress];
    for (unsigned tile = 0; tile < dimensions * dimensions; tile ++)
      if (mask & (1ull << tile)) {
        unsigned char tileID = read_byte(ROM, sizeROM, p ++);
        tileID -= tileID >> 7;
        if (tileID >= totaltiles) totaltiles = tileID + 1;
        frametiles[frame][tile] = tileID;
      } else
        frametiles[frame][tile] = tile;
  }
  // load and decompress the frontpic and backpic tile data
  size_t picsize;
  address = read_far_pointer(ROM, sizeROM, addresses[PICS] + index * 6 - 3);
  unsigned char * restrict backtiles = decompress(ROM, sizeROM, address, &picsize);
  if (picsize < 0x240) error_exit(1, "backpic %hhu is not 0x240 bytes", index);
  address = read_far_pointer(ROM, sizeROM, addresses[PICS] + index * 6 - 6);
  unsigned char * restrict fronttiles = decompress(ROM, sizeROM, address, &picsize);
  if (picsize < totaltiles * 16) error_exit(1, "frontpic %hhu is not %hhu tiles", index, totaltiles);
  // render the frontpic frames and the backpic
  static const unsigned char backpic_tile_IDs[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
                                                   19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35};
  uint8_t backpic[48 * 48];
  render_frame(backpic, backtiles, backpic_tile_IDs, 6);
  free(backtiles);
  uint8_t (* frames)[dimensions * dimensions * 64] = malloc((animation -> maxframe + 1) * sizeof *frames);
  if (!frames) abort();
  for (unsigned frame = 0; frame <= animation -> maxframe; frame ++) render_frame(frames[frame], fronttiles, frametiles[frame], dimensions);
  free(frametiles);
  free(fronttiles);
  // render the actual frontpic frame sheet
  uint8_t * frontpic = malloc(sizeof *frames * (animation -> length + 1));
  if (!frontpic) abort();
  memcpy(frontpic, *frames, sizeof *frames);
  for (unsigned frame = 0; frame < animation -> length; frame ++)
    memcpy(frontpic + (frame + 1) * sizeof *frames, frames[animation -> frames[frame].frame], sizeof *frames);
  free(frames);
  // do the final output and release the buffers
  size_t namelength = strlen(filename);
  output_front_animations(filename, namelength, frontpic, palettes, animation, dimensions, config[FRONT_IMAGES]);
  free(frontpic);
  free(animation);
  output_back_pictures(filename, namelength, backpic, palettes, config[BACK_IMAGES]);
}

struct animation * load_animation (const unsigned char * ROM, size_t sizeROM, uint32_t base, unsigned char index) {
  struct animation * result = malloc(sizeof *result);
  if (!result) abort();
  result -> length = result -> maxframe = 0;
  base = read_near_pointer(ROM, sizeROM, base + index * 2 - 2);
  unsigned char frame, repeatcount = 0;
  uint32_t address = base;
  while ((frame = read_byte(ROM, sizeROM, address ++)) != 0xff) switch (frame) {
    case 0xfe:
      repeatcount = read_byte(ROM, sizeROM, address ++);
      break;
    case 0xfd:
      if (repeatcount) repeatcount --;
      if (repeatcount)
        address = base + 2 * read_byte(ROM, sizeROM, address);
      else
        address ++;
      break;
    default:
      if (result -> length >= 0x7fff) error_exit(1, "max frame count exceeded (possible infinite animation loop)");
      if (!(result = realloc(result, sizeof *result + (result -> length + 1) * sizeof *result -> frames))) abort();
      result -> frames[result -> length].frame = frame;
      if (frame > result -> maxframe) result -> maxframe = frame;
      result -> frames[result -> length ++].duration = read_byte(ROM, sizeROM, address ++);
  }
  return result;
}

void render_frame (uint8_t * restrict frame, const unsigned char * tiledata, const unsigned char * indexes, unsigned char dimensions) {
  for (unsigned char row = 0; row < 8 * dimensions; row ++) for (unsigned char tile = 0; tile < dimensions; tile ++) {
    unsigned index = indexes[(row >> 3) + dimensions * tile] * 16 + (row & 7) * 2;
    unsigned char low = tiledata[index], high = tiledata[index + 1], bitindex = 8;
    while (bitindex --) *(frame ++) = ((high & (1 << bitindex)) ? 2 : 0) + ((low & (1 << bitindex)) ? 1 : 0);
  }
}

unsigned char * decompress (const unsigned char * ROM, size_t sizeROM, uint32_t address, size_t * restrict size) {
  static const unsigned char bit_flipping_table[] = {
    0x00, 0x80, 0x40, 0xc0, 0x20, 0xa0, 0x60, 0xe0, 0x10, 0x90, 0x50, 0xd0, 0x30, 0xb0, 0x70, 0xf0,
    0x08, 0x88, 0x48, 0xc8, 0x28, 0xa8, 0x68, 0xe8, 0x18, 0x98, 0x58, 0xd8, 0x38, 0xb8, 0x78, 0xf8,
    0x04, 0x84, 0x44, 0xc4, 0x24, 0xa4, 0x64, 0xe4, 0x14, 0x94, 0x54, 0xd4, 0x34, 0xb4, 0x74, 0xf4,
    0x0c, 0x8c, 0x4c, 0xcc, 0x2c, 0xac, 0x6c, 0xec, 0x1c, 0x9c, 0x5c, 0xdc, 0x3c, 0xbc, 0x7c, 0xfc,
    0x02, 0x82, 0x42, 0xc2, 0x22, 0xa2, 0x62, 0xe2, 0x12, 0x92, 0x52, 0xd2, 0x32, 0xb2, 0x72, 0xf2,
    0x0a, 0x8a, 0x4a, 0xca, 0x2a, 0xaa, 0x6a, 0xea, 0x1a, 0x9a, 0x5a, 0xda, 0x3a, 0xba, 0x7a, 0xfa,
    0x06, 0x86, 0x46, 0xc6, 0x26, 0xa6, 0x66, 0xe6, 0x16, 0x96, 0x56, 0xd6, 0x36, 0xb6, 0x76, 0xf6,
    0x0e, 0x8e, 0x4e, 0xce, 0x2e, 0xae, 0x6e, 0xee, 0x1e, 0x9e, 0x5e, 0xde, 0x3e, 0xbe, 0x7e, 0xfe,
    0x01, 0x81, 0x41, 0xc1, 0x21, 0xa1, 0x61, 0xe1, 0x11, 0x91, 0x51, 0xd1, 0x31, 0xb1, 0x71, 0xf1,
    0x09, 0x89, 0x49, 0xc9, 0x29, 0xa9, 0x69, 0xe9, 0x19, 0x99, 0x59, 0xd9, 0x39, 0xb9, 0x79, 0xf9,
    0x05, 0x85, 0x45, 0xc5, 0x25, 0xa5, 0x65, 0xe5, 0x15, 0x95, 0x55, 0xd5, 0x35, 0xb5, 0x75, 0xf5,
    0x0d, 0x8d, 0x4d, 0xcd, 0x2d, 0xad, 0x6d, 0xed, 0x1d, 0x9d, 0x5d, 0xdd, 0x3d, 0xbd, 0x7d, 0xfd,
    0x03, 0x83, 0x43, 0xc3, 0x23, 0xa3, 0x63, 0xe3, 0x13, 0x93, 0x53, 0xd3, 0x33, 0xb3, 0x73, 0xf3,
    0x0b, 0x8b, 0x4b, 0xcb, 0x2b, 0xab, 0x6b, 0xeb, 0x1b, 0x9b, 0x5b, 0xdb, 0x3b, 0xbb, 0x7b, 0xfb,
    0x07, 0x87, 0x47, 0xc7, 0x27, 0xa7, 0x67, 0xe7, 0x17, 0x97, 0x57, 0xd7, 0x37, 0xb7, 0x77, 0xf7,
    0x0f, 0x8f, 0x4f, 0xcf, 0x2f, 0xaf, 0x6f, 0xef, 0x1f, 0x9f, 0x5f, 0xdf, 0x3f, 0xbf, 0x7f, 0xff
  };
  unsigned char buffer[0x1000];
  unsigned char * wp = buffer;
  unsigned char command;
  while ((command = read_byte(ROM, sizeROM, address ++)) != 0xff) {
    if (command >= 0xfc) error_exit(1, "invalid LZ command: 0x%02hhu", command);
    unsigned length;
    if (command >= 0xe0) {
      length = ((command & 3) << 8) + read_byte(ROM, sizeROM, address ++);
      command = (command >> 2) & 7;
    } else {
      length = command & 0x1f;
      command >>= 5;
    }
    length ++;
    if ((unsigned)(wp - buffer + length) > sizeof buffer) error_exit(1, "decompressed buffer would exceed 0x%zx bytes", sizeof buffer);
    uint16_t reference = 0;
    if (command >= 4) {
      reference = read_byte(ROM, sizeROM, address ++);
      if (reference & 0x80)
        reference = (uint16_t) (wp - buffer) - (reference - 127);
      else
        reference = (reference << 8) | read_byte(ROM, sizeROM, address ++);
      if (reference >= (wp - buffer)) error_exit(1, "invalid LZ reference to 0x%04x (at 0x%04tx)", (unsigned) reference, wp - buffer);
    }
    switch (command) {
      case 0:
        if (address + length > sizeROM) error_exit(1, "address 0x%04x is not in ROM", (unsigned) (address + length - 1));
        memcpy(wp, ROM + address, length);
        wp += length;
        address += length;
        break;
      case 1:
        reference = read_byte(ROM, sizeROM, address ++);
        // fallthrough
      case 3:
        memset(wp, reference, length);
        wp += length;
        break;
      case 2:
        reference = read_byte(ROM, sizeROM, address ++);
        reference = (reference << 8) | read_byte(ROM, sizeROM, address ++);
        while (length --) *(wp ++) = reference = (reference >> 8) | (reference << 8);
        break;
      case 4:
        while (length --) *(wp ++) = buffer[reference ++];
        break;
      case 5:
        while (length --) *(wp ++) = bit_flipping_table[buffer[reference ++]];
        break;
      case 6:
        if (length > (unsigned)(reference + 1))
          error_exit(1, "backwards LZ reference (to 0x%04x, length 0x%04x) would underflow", (unsigned) reference, length);
        while (length --) *(wp ++) = buffer[reference --];
    }
  }
  unsigned char * result = malloc(wp - buffer);
  if (!result) abort();
  memcpy(result, buffer, *size = wp - buffer);
  return result;
}

FILE * open_file (const char * filename, const char * mode) {
  FILE * result = fopen(filename, mode);
  if (!result) error_exit(3, "could not open file: %s", filename);
  return result;
}

char * read_line (FILE * fp) {
  if (feof(fp) || ferror(fp)) return NULL;
  unsigned char * result = NULL;
  size_t size = 0;
  int c;
  while ((c = getc(fp)) != '\n') {
    if (c == '\r') continue;
    if (c == EOF) {
      if (size) break;
      return NULL;
    }
    if (!(result = realloc(result, size + 1))) abort();
    result[size ++] = c;
  }
  if (!(result = realloc(result, size + 1))) abort();
  result[size] = 0;
  return (char *) result;
}

unsigned long read_value (const char * text, bool hex) {
  if (text[strspn(text, hex ? "0123456789ABCDEFabcdef" : "0123456789")]) error_exit(1, "invalid %snumber: %s", hex ? "hex " : "", text);
  unsigned long result = strtoul(text, NULL, hex ? 16 : 10);
  if (result == -1ul) error_exit(1, "%snumber too high: %s", hex ? "hex " : "", text);
  return result;
}

char * duplicate_string (const char * string) {
  size_t length = strlen(string) + 1;
  char * result = malloc(length);
  if (!result) abort();
  memcpy(result, string, length);
  return result;
}

unsigned char read_byte (const unsigned char * ROM, size_t size, unsigned long address) {
  if (address >= size) error_exit(1, "address 0x%lx exceeds ROM size 0x%zx", address, size);
  return ROM[address];
}

uint32_t read_near_pointer (const unsigned char * ROM, size_t size, unsigned long address) {
  uint16_t pointer = read_byte(ROM, size, address + 1);
  pointer = (pointer << 8) + ROM[address];
  if (pointer > 0x7fff) error_exit(1, "address 0x%04x is not in ROM", (unsigned) pointer);
  if (pointer <= 0x3fff) return pointer;
  return (address & ~0x3ffful) | (pointer & 0x3fff);
}

uint32_t read_far_pointer (const unsigned char * ROM, size_t size, unsigned long address) {
  uint32_t pointer = read_byte(ROM, size, address + 2);
  pointer = (pointer << 8) + ROM[address + 1];
  if (pointer > 0x7fff) error_exit(1, "address 0x%04x is not in ROM", (unsigned) pointer);
  if (pointer > 0x3fff) pointer += ((uint32_t) ROM[address] - 1) << 14;
  return pointer;
}

static inline void output_image (struct plum_image * image, uint16_t type, char * restrict filename, size_t offset, const char * suffix) {
  unsigned error;
  strcpy(filename + offset, suffix);
  image -> type = type;
  plum_store_image(image, filename, PLUM_MODE_FILENAME, &error);
  if (error) error_exit(2, "failed to write image to %s: %s", filename, plum_get_error_text(error));
}

void output_front_animations (char * restrict filename, size_t offset, const uint8_t * pixels, const uint16_t * palettes,
                              const struct animation * animation, unsigned char dimensions, unsigned char types) {
  uint64_t * durations = malloc((animation -> length + 1) * sizeof *durations);
  if (!durations) abort();
  *durations = 0;
  for (unsigned frame = 0; frame < animation -> length; frame ++)
    // 17,556 cycles per frame at 2^20 Hz = 16,742,706 nanoseconds per frame (or 35,112 cycles at 2^21 Hz in double-speed mode)
    durations[frame + 1] = (animation -> frames[frame].duration ? animation -> frames[frame].duration : 0x100) * 16742706ull;
  uint32_t loops = 0;
  struct plum_metadata metadata[] = {
    [0] = {.type = PLUM_METADATA_LOOP_COUNT, .data = &loops, .size = sizeof loops, .next = metadata + 1},
    [1] = {.type = PLUM_METADATA_FRAME_DURATION, .data = durations, .size = (animation -> length + 1) * sizeof *durations, .next = NULL}
  };
  struct plum_image image = {
    .color_format = PLUM_COLOR_16,
    .width = dimensions * 8,
    .height = dimensions * 8,
    .frames = animation -> length + 1,
    .palette = (void *) palettes,
    .max_palette_index = 3,
    .data = (void *) pixels,
    .metadata = metadata
  };
  if (types != 1) output_image(&image, PLUM_IMAGE_GIF, filename, offset, "-front.gif");
  if (types) output_image(&image, PLUM_IMAGE_APNG, filename, offset, "-front.png");
  image.palette = (void *) (palettes + 4);
  if (types != 1) output_image(&image, PLUM_IMAGE_GIF, filename, offset, "-shinyfront.gif");
  if (types) output_image(&image, PLUM_IMAGE_APNG, filename, offset, "-shinyfront.png");
  free(durations);
}

void output_back_pictures (char * restrict filename, size_t offset, const uint8_t * pixels, const uint16_t * palettes, unsigned char types) {
  struct plum_image image = {
    .type = PLUM_IMAGE_GIF,
    .color_format = PLUM_COLOR_16,
    .width = 48,
    .height = 48,
    .frames = 1,
    .palette = (void *) palettes,
    .max_palette_index = 3,
    .data = (void *) pixels
  };
  if (types != 1) output_image(&image, PLUM_IMAGE_GIF, filename, offset, "-back.gif");
  if (types) output_image(&image, PLUM_IMAGE_PNG, filename, offset, "-back.png");
  image.palette = (void *) (palettes + 4);
  if (types != 1) output_image(&image, PLUM_IMAGE_GIF, filename, offset, "-shinyback.gif");
  if (types) output_image(&image, PLUM_IMAGE_PNG, filename, offset, "-shinyback.png");
}
