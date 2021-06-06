#ifndef __UTILS_H__
#define __UTILS_H__

void strip_crnl(char *str);

void strip_trailing_ws(char *str);

char *read_line(char *buf, size_t buf_size, FILE *f);

void ensure_array(void **array, size_t *n_array, size_t desired);

void *Malloc(size_t);
void *Realloc(void *, size_t);
void *Free(void *);
char *Strdup(const char *);

#endif

