/* This tool reads framesheet.png and back.png from a directory, containing a front pic animation sheet and a back  *
 * pic, and it outputs all the relevant files (front.2bpp, back.2bpp, frames.asm, bitmask.asm, dimensions.asm,      *
 * normal.pal and shiny.pal) from those images.                                                                     *
 * The frame sheet must contain all the frames laid out vertically, followed by a small region containing 8 squares *
 * laid out horizontally that define the palette (four colors for the regular palette, four colors for the shiny);  *
 * the frames themselves must use the first four colors only, and colors #0 and #3 must be respectively white and   *
 * black for both palettes. The region is as tall as needed to make the palette squares square; in other words, the *
 * height of this region is the width of the image divided by 8.                                                    *
 * The front pic must be 40x40, 48x48 or 56x56; the frame sheet must contain a whole number of animation frames,    *
 * all the same size of the front pic (which will be the first frame in the sheet). The back pic must be 48x48 and  *
 * use the same palette as the regular (i.e., non-shiny) front pic.                                                 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include "libplum.h"

struct tile {
  uint64_t low;
  uint64_t high;
};

struct framedata {
  unsigned long long bitmask;
  unsigned char * tiles;
};

#define END 127 /* invalid tile ID, used as a sentinel */
#define NONE 255 /* no next tile, used for the deduplication hash table */

int main(int, char **);
_Noreturn void error_exit(int, const char *, ...);
void * allocate(size_t);
struct plum_image * load_framesheet(const char *, uint16_t[restrict static 4]);
struct plum_image * load_backpic(const char *, const uint16_t[restrict static 4]);
void convert_image_to_indexes(unsigned char * restrict, const uint16_t * restrict, size_t, size_t, const char *, const uint16_t[restrict static 4]);
struct tile * indexes_to_tiles(const unsigned char * restrict, size_t, size_t);
unsigned char * deduplicate_tiles(const struct tile * restrict, size_t, unsigned char, const char *, struct tile[restrict static 0xff],
                                  unsigned char * restrict);
unsigned char hash_tile(const struct tile * restrict);
struct framedata * generate_tile_lists_and_bitmasks(const unsigned char *, size_t, size_t);
unsigned long long * deduplicate_bitmasks(struct framedata * restrict, size_t, const char *, size_t * restrict);
void output_tile_data(const char *, const struct tile *, size_t);
void output_palette_data(const char *, uint16_t, uint16_t);
void output_frame_data(const char *, const struct framedata *, size_t);
void output_bitmask_data(const char *, const unsigned long long *, size_t, unsigned char);
FILE * open_file_for_writing(const char *, bool);
void close_file(FILE *, const char *);
void serialize(unsigned long long, unsigned char, unsigned char * restrict);

int main (int argc, char ** argv) {
  if (argc != 2 || !*argv[1]) {
    fprintf(stderr, "usage: %s <directory>\n", *argv);
    return 4;
  }
  size_t namelength = strlen(argv[1]);
  char * filename = allocate(namelength + 16);
  memcpy(filename, argv[1], namelength);
  char * namebuf = filename + namelength;
  if (namebuf[-1] != '/' && namebuf[-1] != '\\') *(namebuf ++) = '/';
  uint16_t palette[4]; // colors #1 and #2, normal and shiny -- #0 and #3 are forced white and black!
  strcpy(namebuf, "framesheet.png");
  struct plum_image * framesheet = load_framesheet(filename, palette);
  strcpy(namebuf, "back.png");
  struct plum_image * backpic = load_backpic(filename, palette);
  strcpy(namebuf, "framesheet.png"); // restore the framesheet filename for error messages below
  unsigned dimensions = framesheet -> width / 8, frames = framesheet -> height / framesheet -> width;
  if (frames > 253) error_exit(1, "%s: too many frames (maximum 253, got %u)", filename, frames);
  struct tile * fronttiles = indexes_to_tiles(framesheet -> userdata, dimensions, frames);
  plum_destroy_image(framesheet);
  struct tile * backtiles = indexes_to_tiles(backpic -> userdata, 6, 1);
  plum_destroy_image(backpic);
  struct tile reducedtiles[0xff];
  unsigned char reducedcount;
  unsigned char * indexes = deduplicate_tiles(fronttiles, frames, dimensions, filename, reducedtiles, &reducedcount);
  free(fronttiles);
  struct framedata * framedata = generate_tile_lists_and_bitmasks(indexes, frames, dimensions * dimensions);
  free(indexes);
  size_t bitmaskcount;
  unsigned long long * bitmasks = deduplicate_bitmasks(framedata, frames, filename, &bitmaskcount);
  strcpy(namebuf, "front.2bpp");
  output_tile_data(filename, reducedtiles, reducedcount);
  strcpy(namebuf, "back.2bpp");
  output_tile_data(filename, backtiles, 36);
  free(backtiles);
  strcpy(namebuf, "normal.pal");
  output_palette_data(filename, *palette, palette[1]);
  strcpy(namebuf, "shiny.pal");
  output_palette_data(filename, palette[2], palette[3]);
  strcpy(namebuf, "frames.asm");
  output_frame_data(filename, framedata, frames);
  free(framedata);
  strcpy(namebuf, "bitmask.asm");
  output_bitmask_data(filename, bitmasks, bitmaskcount, dimensions - (dimensions < 7));
  free(bitmasks);
  strcpy(namebuf, "dimensions.asm");
  FILE * fp = open_file_for_writing(filename, true);
  fprintf(fp, "\tdn %u, %u\n", dimensions, dimensions);
  close_file(fp, filename);
  free(filename);
  return 0;
}

_Noreturn void error_exit (int status, const char * error, ...) {
  // memory is leaked, but who cares, the program is exiting
  va_list ap;
  va_start(ap, error);
  fputs("error: ", stderr);
  vfprintf(stderr, error, ap);
  va_end(ap);
  putc('\n', stderr);
  exit(status);
}

void * allocate (size_t size) {
  void * result = malloc(size);
  if (!result) error_exit(3, "out of memory");
  return result;
}

struct plum_image * load_framesheet (const char * filename, uint16_t palette[restrict static 4]) {
  unsigned error;
  struct plum_image * framesheet = plum_load_image(filename, PLUM_MODE_FILENAME, PLUM_COLOR_16, &error);
  if (!framesheet) error_exit(1, "%s: failed to load: %s", filename, plum_get_error_text(error));
  if (framesheet -> frames > 1) error_exit(1, "%s is an animation", filename);
  if (framesheet -> width % 8) error_exit(1, "%s: width must be divisible by 8", filename);
  uint32_t tiles = framesheet -> width >> 3;
  if (tiles < 5 || tiles > 7) error_exit(1, "%s: width must be 5, 6 or 7 tiles (got: %lu)", filename, (unsigned long) tiles);
  if (framesheet -> height < framesheet -> width) error_exit(1, "%s: framesheet must be laid out vertically", filename);
  if (framesheet -> height % framesheet -> width != tiles)
    error_exit(1, "%s: framesheet must contain an integral number of frames and a palette (got %u excess rows)",
               filename, (unsigned) ((framesheet -> height - tiles) % framesheet -> width));
  const uint16_t (* pixels)[framesheet -> width] = framesheet -> data;
  const uint16_t * lastrow = pixels[framesheet -> height - 1];
  for (unsigned row = 1; row <= tiles; row ++) for (unsigned color = 0; color < 8; color ++) for (unsigned pixel = 0; pixel < tiles; pixel ++)
    if (pixels[framesheet -> height - row][color * tiles + pixel] != lastrow[color * tiles])
      error_exit(1, "%s: %spalette color #%u is not a single solid color", filename, (color > 3) ? "shiny " : "", color % 4);
  if (*lastrow != 0x7fff) error_exit(1, "%s: palette color #0 must be white", filename);
  if (lastrow[3 * tiles]) error_exit(1, "%s: palette color #3 must be black", filename);
  if (lastrow[4 * tiles] != 0x7fff) error_exit(1, "%s: shiny palette color #0 must be white", filename);
  if (lastrow[7 * tiles]) error_exit(1, "%s: shiny palette color #3 must be black", filename);
  *palette = lastrow[tiles];
  palette[1] = lastrow[2 * tiles];
  palette[2] = lastrow[5 * tiles];
  palette[3] = lastrow[6 * tiles];
  for (unsigned p = 0; p < 4; p ++) if (palette[p] & 0x8000)
    error_exit(1, "%s: %s palette color #%u is transparent", filename, (p > 1) ? "shiny " : "", p + 1);
  size_t framepixels = (size_t) (framesheet -> height - tiles) * framesheet -> width;
  framesheet -> userdata = plum_malloc(framesheet, framepixels);
  if (!framesheet -> userdata) error_exit(3, "out of memory");
  convert_image_to_indexes(framesheet -> userdata, framesheet -> data16, framepixels, framesheet -> width, filename, palette);
  return framesheet;
}

struct plum_image * load_backpic (const char * filename, const uint16_t palette[restrict static 4]) {
  unsigned error;
  struct plum_image * backpic = plum_load_image(filename, PLUM_MODE_FILENAME, PLUM_COLOR_16, &error);
  if (!backpic) error_exit(1, "%s: failed to load: %s", filename, plum_get_error_text(error));
  if (backpic -> frames > 1) error_exit(1, "%s is an animation", filename);
  if (backpic -> width != 48 || backpic -> height != 48)
    error_exit(1, "%s must be 48 x 48 pixels (got: %lu x %lu)", filename, (unsigned long) backpic -> width, (unsigned long) backpic -> height);
  backpic -> userdata = plum_malloc(backpic, 2304);
  if (!backpic -> userdata) error_exit(3, "out of memory");
  convert_image_to_indexes(backpic -> userdata, backpic -> data16, 2304, 48, filename, palette);
  return backpic;
}

void convert_image_to_indexes (unsigned char * restrict output, const uint16_t * restrict input, size_t size, size_t width,
                               const char * filename, const uint16_t palette[restrict static 4]) {
  for (size_t pixel = 0; pixel < size; pixel ++)
    if (!input[pixel])
      output[pixel] = 3;
    else if (input[pixel] == 0x7fff)
      output[pixel] = 0;
    else if (input[pixel] == *palette)
      output[pixel] = 1;
    else if (input[pixel] == palette[1])
      output[pixel] = 2;
    else {
      const char * message = "not in the palette";
      if (input[pixel] & 0x8000)
        message = "transparent";
      else if (input[pixel] == palette[2] || input[pixel] == palette[3])
        message = "only in the shiny palette";
      error_exit(1, "%s: color at (%zu, %zu) is %s", filename, pixel % width, pixel / width, message);
    }
}

struct tile * indexes_to_tiles (const unsigned char * restrict tiles, size_t dimensions, size_t frames) {
  struct tile * result = allocate(dimensions * dimensions * frames * sizeof *result);
  if (!result) error_exit(3, "out of memory");
  struct tile * current = result;
  for (size_t frame = 0; frame < frames; frame ++) for (size_t col = 0; col < dimensions; col ++) for (size_t row = 0; row < dimensions; row ++) {
    const unsigned char * tiledata = tiles + (frame * dimensions + row) * dimensions * 64 + col * 8;
    unsigned char lowdata[8];
    unsigned char highdata[8];
    for (unsigned y = 0; y < 8; y ++, tiledata += dimensions * 8) {
      lowdata[y] = highdata[y] = 0;
      for (unsigned x = 0; x < 8; x ++) {
        lowdata[y] <<= 1;
        highdata[y] <<= 1;
        if (tiledata[x] & 1) lowdata[y] ++;
        if (tiledata[x] & 2) highdata[y] ++;
      }
    }
    *current = (struct tile) {.low = 0, .high = 0};
    for (unsigned p = 0; p < 8; p ++) {
      current -> low |= (uint64_t) lowdata[p] << (8 * p);
      current -> high |= (uint64_t) highdata[p] << (8 * p);
    }
    current ++;
  }
  return result;
}

unsigned char * deduplicate_tiles (const struct tile * restrict tiles, size_t frames, unsigned char dimensions, const char * filename,
                                   struct tile output[restrict static 0xff], unsigned char * restrict outcount) {
  unsigned char framesize = dimensions * dimensions;
  unsigned char * indexes = allocate(frames * framesize);
  unsigned char hashtable[0xff];
  unsigned char tableheads[0x100];
  memset(tableheads, NONE, sizeof tableheads);
  // loop backwards, to prefer lower tile IDs for equal tiles -- the loop ends on overflow
  for (unsigned char p = framesize - 1; p < framesize; p --) {
    unsigned char hash = hash_tile(tiles + p);
    output[p] = tiles[p];
    indexes[p] = p;
    hashtable[p] = tableheads[hash];
    tableheads[hash] = p;
  }
  *outcount = framesize;
  for (size_t frame = 1; frame < frames; frame ++) for (unsigned char tile = 0; tile < framesize; tile ++) {
    size_t index = frame * framesize + tile;
    if (tiles[index].low == output[tile].low && tiles[index].high == output[tile].high) {
      indexes[index] = tile;
      continue;
    }
    unsigned char candidate, hash = hash_tile(tiles + index);
    for (candidate = tableheads[hash]; candidate != NONE; candidate = hashtable[candidate])
      if (tiles[index].low == output[candidate].low && tiles[index].high == output[candidate].high) break;
    if (candidate == NONE) {
      candidate = (*outcount) ++; // reuse the variable so the index is set correctly afterwards
      if (candidate == 0xff) error_exit(1, "%s: too many unique tiles (first excess tile at (%u, %u) on frame %zu)",
                                        filename, tile / dimensions * 8u, tile % dimensions * 8u, frame);
      output[candidate] = tiles[index];
      hashtable[candidate] = tableheads[hash];
      tableheads[hash] = candidate;
    }
    indexes[index] = candidate;
  }
  return indexes;
}

unsigned char hash_tile (const struct tile * restrict tile) {
  uint_fast64_t result = tile -> high + tile -> low;
  result += result >> 32;
  result += result >> 16;
  result += result >> 8;
  return result;
}

struct framedata * generate_tile_lists_and_bitmasks (const unsigned char * indexes, size_t frames, size_t framesize) {
  if (frames < 2) return NULL;
  struct framedata * result = allocate((frames - 1) * (sizeof *result + 1 + framesize)); // maximum possible size
  unsigned char * tiles = (void *) (result + (frames - 1));
  for (size_t frame = 1; frame < frames; frame ++) {
    const unsigned char * frametiles = indexes + frame * framesize;
    struct framedata * framedata = result + (frame - 1);
    framedata -> bitmask = 0;
    framedata -> tiles = tiles;
    for (unsigned char tile = 0; tile < framesize; tile ++) if (frametiles[tile] != tile) {
      framedata -> bitmask |= 1ull << tile;
      *(tiles ++) = frametiles[tile] + (frametiles[tile] >= END); // END itself is a reserved index (therefore used as a sentinel here)
    }
    *(tiles ++) = END;
  }
  return result;
}

unsigned long long * deduplicate_bitmasks (struct framedata * restrict framedata, size_t frames, const char * filename, size_t * restrict count) {
  if (frames < 2) return NULL;
  unsigned long long * result = allocate((frames - 1) * sizeof *result); // maximum possible size
  *result = framedata -> bitmask;
  framedata -> bitmask = 0;
  *count = 1;
  for (size_t frame = 2; frame < frames; frame ++) {
    size_t check;
    for (check = 0; check < *count; check ++) if (result[check] == framedata[frame - 1].bitmask) break;
    if (check > 0xff) error_exit(1, "%s: too many unique bitmasks", filename);
    if (!framedata[frame - 1].bitmask)
      fprintf(stderr, "warning: %s: frame %zu is identical to frame 0\n", filename, frame);
    else if (check != *count)
      for (size_t checkframe = 1; checkframe < frame; checkframe ++) if (framedata[checkframe - 1].bitmask == check) {
        const unsigned char * framevalues = framedata[frame - 1].tiles;
        const unsigned char * checkvalues = framedata[checkframe - 1].tiles;
        while (*framevalues == *checkvalues && *framevalues != END) framevalues ++, checkvalues ++;
        if (*framevalues == END) {
          fprintf(stderr, "warning: %s: frame %zu is identical to frame %zu\n", filename, frame, checkframe);
          break;
        }
      }
    if (check == *count) result[(*count) ++] = framedata[frame - 1].bitmask;
    framedata[frame - 1].bitmask = check;
  }
  return result;
}

void output_tile_data (const char * filename, const struct tile * tiles, size_t count) {
  size_t size = 16 * count;
  unsigned char * data = allocate(size);
  unsigned char * current = data;
  for (size_t tile = 0; tile < count; tile ++) {
    unsigned long long low = tiles[tile].low, high = tiles[tile].high;
    for (unsigned char p = 0; p < 8; p ++) {
      *(current ++) = low;
      low >>= 8;
      *(current ++) = high;
      high >>= 8;
    }
  }
  FILE * fp = open_file_for_writing(filename, false);
  current = data;
  while (size) {
    int result = fwrite(current, 1, size, fp);
    if (!result) break;
    current += result;
    size -= result;
  }
  free(data);
  close_file(fp, filename);
  if (size) error_exit(2, "%s: error writing file", filename); // assuming the program didn't already die in the ferror check
}

void output_palette_data (const char * filename, uint16_t first, uint16_t second) {
  FILE * fp = open_file_for_writing(filename, true);
  fprintf(fp, "\tRGB %02u, %02u, %02u\n\tRGB %02u, %02u, %02u\n",
          (unsigned) (first & 31), (unsigned) ((first >> 5) & 31), (unsigned) ((first >> 10) & 31),
          (unsigned) (second & 31), (unsigned) ((second >> 5) & 31), (unsigned) ((second >> 10) & 31));
  close_file(fp, filename);
}

void output_frame_data (const char * filename, const struct framedata * framedata, size_t frames) {
  FILE * fp = open_file_for_writing(filename, true);
  for (size_t frame = 1; frame < frames; frame ++) fprintf(fp, "\tdw .frame%zu\n", frame);
  for (size_t frame = 1; frame < frames; frame ++) {
    fprintf(fp, "\n.frame%zu\n\tdb %llu ;bitmask", frame, framedata[frame - 1].bitmask);
    unsigned char count = 0;
    const unsigned char * data = framedata[frame - 1].tiles;
    while (*data != END) {
      fprintf(fp, "%s $%02hhx", (count ++) ? "," : "\n\tdb", *(data ++));
      if (count == 12) count = 0;
    }
  }
  putc('\n', fp);
  close_file(fp, filename);
}

void output_bitmask_data (const char * filename, const unsigned long long * bitmasks, size_t count, unsigned char bytes) {
  FILE * fp = open_file_for_writing(filename, true);
  for (size_t p = 0; p < count; p ++) {
    unsigned long long bitmask = bitmasks[p];
    for (unsigned char byte = 0; byte < bytes; byte ++) {
      fprintf(fp, "%s $%02hhx", byte ? "," : "\tdb", (unsigned char) bitmask);
      bitmask >>= 8;
    }
    fprintf(fp, " ;bitmask %zu\n", p);
  }
  close_file(fp, filename);
}

FILE * open_file_for_writing (const char * filename, bool text) {
  FILE * fp = fopen(filename, text ? "w" : "wb");
  if (!fp) error_exit(2, "%s: could not open for writing", filename);
  return fp;
}

void close_file (FILE * fp, const char * filename) {
  if (ferror(fp)) error_exit(2, "%s: error writing file", filename);
  fclose(fp);
}

void serialize (unsigned long long number, unsigned char bytes, unsigned char * restrict output) {
  while (bytes --) {
    *(output ++) = number;
    number >>= 8;
  }
}
