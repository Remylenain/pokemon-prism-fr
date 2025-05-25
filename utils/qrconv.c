#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "libqrgen.h"

// version 3 = 29 x 29 pixels, just enough to fit in the textbox
#define QR_VERSION 3

// blank rows to leave before the image; 0-3
#define BLANK_ROWS 3

char * read_quoted_text_from_file(const char *);

int main (int argc, char ** argv) {
  if (argc != 3) {
    fprintf(stderr, "usage: %s <input> <output>\n", *argv);
    return 1;
  }
  char * text = read_quoted_text_from_file(argv[1]);
  if (!text) return 2;
  unsigned char buffer[QR_BUFFER_SIZE(QR_VERSION) + BLANK_ROWS * QR_BYTES_PER_ROW(QR_VERSION)] = {0};
  unsigned char p = generate_QR_code(text, strlen(text), QR_VERSION, QR_VERSION, buffer + QR_BYTES_PER_ROW(QR_VERSION) * BLANK_ROWS);
  free(text);
  if (p != QR_VERSION) {
    fputs("error: could not generate QR code for input\n", stderr);
    return 3;
  }
  // shift the entire buffer one bit to the right to prepend a blank column
  // blank rows are prepended by making the buffer larger
  unsigned short index;
  p = 0;
  for (index = BLANK_ROWS * QR_BYTES_PER_ROW(QR_VERSION); index < sizeof buffer; index ++) {
    p = (p << 7) | (buffer[index] & 1);
    buffer[index] = (buffer[index] >> 1) | (p & 0x80);
  }
  FILE * fp = fopen(argv[2], "wb");
  if (!fp) {
    fprintf(stderr, "error: could not open file %s for writing\n", argv[2]);
    return 4;
  }
  unsigned char row, col;
  for (row = 0; row < (QR_PIXELS_PER_SIDE(QR_VERSION) + BLANK_ROWS); row += 8) for (col = 0; col <= QR_PIXELS_PER_SIDE(QR_VERSION); col += 8) {
    // tiles are 8 rows by 8 columns, so iterate for 8 rows within the tile
    // column checks are <=, not <, because there's an extra column inserted to create blank space
    index = (unsigned short) row * QR_BYTES_PER_ROW(QR_VERSION) + (col >> 3);
    for (p = 0; p < 8; p ++)
      if (index < sizeof buffer) {
        putc(buffer[index], fp);
        index += QR_BYTES_PER_ROW(QR_VERSION);
      } else
        putc(0, fp);
  }
  fclose(fp);
  return 0;
}

char * read_quoted_text_from_file (const char * file) {
  FILE * fp = fopen(file, "r");
  if (!fp) {
    fprintf(stderr, "error: could not open file %s for reading\n", file);
    return NULL;
  }
  char * result = NULL;
  unsigned length = 0;
  int c, quoted = 0;
  const char * error = NULL;
  while (1) {
    c = getc(fp);
    if (c == EOF) break;
    if (quoted && (c == '\n')) {
      error = "error: newline before closing quote";
      break;
    }
    if (c == '"') {
      quoted = !quoted;
      // add a space if there's already some text
      if (quoted && length) {
        result = realloc(result, length + 1);
        result[length ++] = ' ';
      }
    } else if (quoted) {
      result = realloc(result, length + 1);
      result[length ++] = c;
    }
  }
  if (quoted) error = "error: mismatched quotes";
  if (error) {
    free(result);
    fprintf(stderr, "%s\n", error);
    return NULL;
  }
  result = realloc(result, length + 1);
  result[length] = 0;
  return result;
}
