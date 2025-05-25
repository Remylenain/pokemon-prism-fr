#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <stdbool.h>

int main(int, char **);
_Noreturn void usage(const char *);
void scan_file(const char *, bool, bool, bool);
void scan_contents(const char *, size_t, const char *, bool, bool);

int main (int argc, char ** argv) {
  bool strict = false, fatal = false;
  const char * progname = *argv;
  while (*++ argv)
    if (**argv != '-')
      break;
    else if (!strcmp(*argv, "--")) {
      argv ++;
      break;
    } else if (!strcmp(*argv, "-s") || !strcmp(*argv, "--strict"))
      strict = true;
    else if (!strcmp(*argv, "-f") || !strcmp(*argv, "--fatal"))
      fatal = true;
    else if (!strcmp(*argv, "-h") || !strcmp(*argv, "--help"))
      usage(progname);
    else {
      fprintf(stderr, "error: unknown option: %s\n", *argv);
      return 3;
    }
  if (!*argv) usage(progname);
  while (*argv) scan_file(*(argv ++), strict, fatal, false);
  putchar('\n');
  return 0;
}

_Noreturn void usage (const char * progname) {
  fprintf(stderr, "usage: %s [<options>] <filename> [<filename...>]\n"
                  "\t-s, --strict: error on missing files\n"
                  "\t-f, --fatal:  treat warnings as errors\n"
                  "\t-h, --help:   show this help and exit\n"
                  "\t--:           end of option list\n",
          progname);
  exit(3);
}

void scan_file (const char * filename, bool strict, bool fatal, bool included) {
  // RGBASM has its own idea of what newlines are, so follow it: use "rb", not "r"
  FILE * fp = fopen(filename, "rb");
  if (!fp) {
    if (included && !strict) return;
    fprintf(stderr, "error: could not open %s\n", filename);
    exit(1);
  }
  size_t size = 0, allocated = 0x4000;
  char * buffer = malloc(allocated);
  if (!buffer) abort();
  int read;
  do {
    read = fread(buffer + size, 1, allocated - size, fp);
    size += read;
    if (size == allocated) {
      allocated += 0x4000;
      buffer = realloc(buffer, allocated);
      if (!buffer) abort();
    }
  } while (read);
  bool error = ferror(fp);
  fclose(fp);
  if (error) {
    fprintf(stderr, "error: could not read %s\n", filename);
    if (!included || strict) exit(1);
  } else {
    buffer[size] = '\n'; // not an overflow because allocated > size
    scan_contents(buffer, size + 1, filename, strict, fatal);
  }
  free(buffer);
}

void scan_contents (const char * data, size_t size, const char * filename, bool strict, bool fatal) {
  #define WARN(text) do {                                              \
    fprintf(stderr, "warning: %s:%lu: " text "\n", filename, line);    \
    if (fatal) exit(2);                                                \
  } while (false)
  const char * end = data + size;
  unsigned long line = 1;
  bool including = false, recurse = false;
  while (data < end)
    if (*data == '\n') {
      // ignoring backslash continuations for simplicity (outside of literal strings)
      if (including) WARN("inclusion directive at end of line");
      including = false;
      line ++;
      data ++;
    } else if (*data == '\r' || *data == ' ' || *data == '\t')
      data += strspn(data, " \r\t");
    else if (*data == ';')
      data = memchr(data, '\n', end - data);
    else if (*data == '"') {
      const char * start = data + 1;
      data = start + strcspn(start, "\r\n\"") + 1;
      bool multiline = false, terminated = true;
      while (data[-1] != '"')
        if (data[-2] == '\\') {
          multiline = true;
          if (data[-1] == '\r' && *data == '\n') data ++;
          if (data[-1] == '\n') line ++;
          data = data + strcspn(data, "\r\n\"") + 1;
        } else {
          WARN("unterminated string");
          terminated = false;
          data --;
          break;
        }
      if (including) {
        including = false;
        if (multiline) {
          WARN("multiline filename in inclusion");
          continue;
        }
        char * filename = malloc(data - start + 1);
        if (!filename) abort();
        memcpy(filename, start, data - start);
        filename[data - start - terminated] = 0;
        printf("%s ", filename);
        if (recurse) scan_file(filename, strict, fatal, true);
        free(filename);
      }
    } else {
      if (including) WARN("inclusion directive not followed by string");
      // deliberately treat any token beginning with 'include' or 'incbin' as an inclusion
      if (end - data >= 7 && (!memcmp(data, "include", 7) || !memcmp(data, "INCLUDE", 7)))
        including = recurse = true;
      else if (end - data >= 6 && (!memcmp(data, "incbin", 6) || !memcmp(data, "INCBIN", 6)))
        including = true, recurse = false;
      else
        including = false;
      data += strcspn(data, " \t\r\n\";");
    }
  #undef WARN
}
