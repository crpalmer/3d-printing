#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "utils.h"

void strip_crnl(char *str)
{
    int i;

    for (i = strlen(str)-1; i >= 0 && (str[i] == '\r' || str[i] == '\n'); i--) {}
    str[i+1] = '\0';
}

void strip_trailing_ws(char *str)
{
    int i;

    for (i = strlen(str)-1; i >= 0 && isspace(str[i]); i--) {}
    str[i+1] = '\0';
}

int ends_with(const char *str, const char *suffix)
{
    size_t l_str = strlen(str);
    size_t l_suffix = strlen(suffix);

    return l_str >= l_suffix && strcmp(&str[l_str - l_suffix], suffix) == 0;
}

char *read_line(char *buf, size_t buf_size, FILE *f)
{
    if (fgets(buf, buf_size, f) == NULL) return NULL;
    strip_crnl(buf);
    return buf;
}

void ensure_array(void **array, size_t *n_array, size_t desired)
{
    if (*n_array < desired) {
	do {
	    *n_array *= 2;
	} while (*n_array < desired);
	*array = realloc(*array, sizeof(void *) * (*n_array));
    }
}

void *Malloc(size_t s)
{
    void *p = malloc(s);
    if (! p) {
	fprintf(stderr, "Failed to allocated %d bytes\n", (int) s);
	exit(1);
    }
    return p;
}

void *Realloc(void *p, size_t s)
{
    p = realloc(p, s);
    if (! p) {
	fprintf(stderr, "Failed to re-allocated %d bytes\n", (int) s);
	exit(1);
    }
    return p;
}

void *Free(void *p)
{
    free(p);
}

char *Strdup(const char *s)
{
    char *ss;

    if (s == NULL) return NULL;
    ss = strdup(s);
    if (! ss) {
	fprintf(stderr, "Failed to strdup %d bytes\n", (int) strlen(s));
	exit(1);
    }
    return ss;
}
