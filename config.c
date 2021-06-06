#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "config.h"
#include "utils.h"

struct configS {
    char *fname;
    char *name;
    char **s;
    size_t a_s, n_s;
};

#define MAX_LINE_LEN	(1024*1024)

config_t *config_new(const char *fname, const char *name)
{
    config_t *c = Malloc(sizeof(*c));
    c->fname = Strdup(fname);
    c->name = Strdup(name);
    c->a_s = 32;
    c->n_s = 0;
    c->s = Malloc(sizeof(*c->s) * c->a_s);
    return c;
}

static void add_item(config_t *c, const char *line)
{
    c->n_s++;
    ensure_array((void **) &c->s, &c->a_s, c->n_s);
    c->s[c->n_s-1] = Strdup(line);
}

config_t *config_new_customization(config_t *base, config_t *custom)
{
    size_t i_b, i_c;

    config_t *c = config_new(NULL, custom->name);

    for (i_b = 0, i_c = 0; i_b < base->n_s && i_c < custom->n_s; ) {
	const char *s_b = base->s[i_b];
	const char *s_c = custom->s[i_c];
	const char *e_c = strchr(s_c, '=');
	size_t l_c = e_c - s_c;

	int cmp = strncmp(s_b, s_c, l_c);
	if (cmp < 0) add_item(c, base->s[i_b]);
	else add_item(c, custom->s[i_c]);
	if (cmp <= 0) i_b++;
	if (cmp >= 0) i_c++;
    }

    while (i_b < base->n_s) add_item(c, base->s[i_b++]);
    while (i_c < custom->n_s) add_item(c, custom->s[i_c++]);

    return c;
}

void config_destroy(config_t *c)
{
    Free(c->fname);
    Free(c->name);
    for (size_t i = 0; i < c->n_s; i++) Free(c->s[i]);
    Free(c);
}

config_t *config_load(const char *fname)
{
    config_t *c;
    FILE *f;

    if ((f = fopen(fname, "r")) == NULL) {
	perror(fname);
	return NULL;
    }
    c =  config_new_f(f, fname);
    fclose(f);
    return c;
}

static int config_cmp(const void *A, const void *B)
{
    const char *a = *((const char **) A);
    const char *b = *((const char **) B);
    return strcmp(a, b);
}

config_t *config_new_f(FILE *f, const char *fname)
{
    config_t *c = config_new(fname, NULL);
    char *line = Malloc(MAX_LINE_LEN+1);

    while (read_line(line, MAX_LINE_LEN, f) != NULL && line[0] != '\0') {
	if (line[0] == '[') {
	    if (c->name != NULL) {
		fprintf(stderr, "Two names in the same config: %s and %s\n", c->name, line);
		goto error;
	    }
	    c->name = Strdup(line);
	    if (c->fname == NULL) {
		c->fname = Malloc(strlen(line) + 100);
		strcpy(c->fname, &line[1]);
		strip_trailing_ws(c->fname);
		c->fname[strlen(c->fname)-1] = '\0';
		strcat(c->fname, ".ini");
	    }
	} else {
	    add_item(c, line);
	}
    }
    if (feof(f) && c->n_s == 0) {
	goto error;
    }
    free(line);

    qsort(c->s, c->n_s, sizeof(*c->s), config_cmp);

    return c;

error:
    free(line);
    config_destroy(c);
    return NULL;
}

int config_save(config_t *c)
{
    FILE *f;
    int ret;

    if (c->fname == NULL) {
	fprintf(stderr, "Save not possible, there is no fname\n");
	return -1;
    }
    if ((f = fopen(c->fname, "w")) == NULL) {
	perror(c->fname);
	return -1;
    }

    ret = config_write(c, f);
    fclose(f);

    return ret;
}

int config_write(config_t *c, FILE *f)
{

    if (c->name) fprintf(f, "%s\n", c->name);
    for (int i = 0; i < c->n_s; i++) fprintf(f, "%s\n", c->s[i]); 

    return c->n_s;
}

const char *config_get_fname(config_t *c)
{
    return c->fname;
}

const char *config_get_name(config_t *c)
{
    return c->name;
}
