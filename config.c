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

static const char *ignore_keys[] = {
    "threads =",
};

#define N_IGNORE_KEYS (sizeof(ignore_keys) / sizeof(ignore_keys[0]))

#define MAX_LINE_LEN	(1024*1024)

static int key_cmp(const char *s1, const char *s2)
{
    const char *p = strchr(s1, '=');
    if (p == NULL) p = s1 + strlen(s1);
    size_t n_cmp = p - s1;
    return strncmp(s1, s2, n_cmp);
}

void config_add(config_t *c, const char *kv_pair)
{
    c->n_s++;
    ensure_array((void **) &c->s, &c->a_s, c->n_s);
    c->s[c->n_s-1] = Strdup(kv_pair);
}

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
	if (cmp < 0) config_add(c, base->s[i_b]);
	else config_add(c, custom->s[i_c]);
	if (cmp <= 0) i_b++;
	if (cmp >= 0) i_c++;
    }

    while (i_b < base->n_s) config_add(c, base->s[i_b++]);
    while (i_c < custom->n_s) config_add(c, custom->s[i_c++]);

    return c;
}

int advance_to(config_t *c, size_t *i, const char *target)
{
    while (*i < c->n_s && strcmp(c->s[*i], target) < 0) (*i)++;
    return *i < c->n_s && strcmp(c->s[*i], target) == 0;
}

config_t *config_new_except(config_t *c, config_t *except)
{
    size_t except_i = 0;

    config_t *c_new = config_new(c->fname, c->name);

    for (int i = 0; i < c->n_s; i++) {
	while (except_i < except->n_s && key_cmp(c->s[i], except->s[except_i]) > 0) except_i++;
	if (except_i >= except->n_s || key_cmp(c->s[i], except->s[except_i]) != 0) config_add(c_new, c->s[i]);
    }

    return c_new;
}

config_t *config_clone(config_t *c)
{
    config_t *c_new = config_new(c->fname, c->name);

    for (int i = 0; i < c->n_s; i++) config_add(c_new, c->s[i]);
    return c_new;
}

#define S(c, i) ((c)->s[(i)])

static int find_min(config_t **c, size_t *cur, int n_c)
{
    int mn = -1;

    for (size_t i = 0; i < n_c; i++) {
	if (cur[i] >= c[i]->n_s) continue;
	if (mn < 0 || strcmp(S(c[i], cur[i]), S(c[mn], cur[mn])) < 0) mn = i;
    }

    return mn;
}

static int n_equal_to(config_t **c, size_t *cur, int n_c, const char *s)
{
    int n_eq = 0;

    for (size_t i = 0; i < n_c; i++) {
	if (cur[i] >= c[i]->n_s) continue;
	if (strcmp(S(c[i], cur[i]), s) == 0) n_eq++;
    }

    return n_eq;
}

const char *config_get_by_key(config_t *c, const char *kv_pair)
{
    for (size_t i = 0; i < c->n_s; i++) {
	if (key_cmp(c->s[i], kv_pair) == 0) return c->s[i];
    }
    return NULL;
}

static void advance_same_key(config_t **c, size_t *cur, int n_c, const char *s)
{
    for (size_t i = 0; i < n_c; i++) {
	if (cur[i] >= c[i]->n_s) continue;
	if (key_cmp(s, S(c[i], cur[i])) == 0) cur[i]++;
    }
}

config_t *config_generate_base_config(const char *fname, config_t **c, size_t n_c)
{
    size_t *cur = Malloc(sizeof(*cur) * n_c);
    config_t *base = config_new(fname, NULL);

    memset(cur, 0, n_c * sizeof(size_t));

    while (1) {
	int mn = find_min(c, cur, n_c);
	if (mn < 0) break;

	const char *s_mn = S(c[mn], cur[mn]);
	int n_eq = n_equal_to(c, cur, n_c, s_mn);

	if (n_eq == n_c) config_add(base, s_mn);
	else if (n_c > 2 && n_eq >= (n_c+1)/2) config_add(base, s_mn);

	advance_same_key(c, cur, n_c, s_mn);
    }

    return base;
}

void config_destroy(config_t *c)
{
    Free(c->fname);
    Free(c->name);
    for (size_t i = 0; i < c->n_s; i++) Free(c->s[i]);
    Free(c);
}

config_t *config_load_path(const char *dir, const char *fname)
{
    char *full = Malloc(strlen(dir) + 1 + strlen(fname) + 1);
    sprintf(full, "%s/%s", dir, fname);
    config_t *c = config_load(full);
    free(full);
    return c;
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
	    config_add(c, line);
	}
    }
    if (feof(f) && c->n_s == 0 && c->name == NULL) {
	fprintf(stderr, "error: no entries and no name found in config [%s]\n", fname);
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
    config_t *except = config_new(NULL, NULL);
    int ret = config_save_except(c, except);
    config_destroy(except);
    return ret;
}

int config_save_except(config_t *c, config_t *except)
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

    ret = config_write_except(c, f, except);
    fclose(f);

    return ret;
}

int config_write(config_t *c, FILE *f)
{
    config_t *except = config_new(NULL, NULL);
    int ret = config_write_except(c, f, except);
    config_destroy(except);
    return ret;
}

static int ignored_key(const char *s)
{
    for (size_t i = 0; i < N_IGNORE_KEYS; i++) {
	if (key_cmp(ignore_keys[i], s) == 0) return 1;
    }
    return 0;
}

int config_write_except(config_t *c, FILE *f, config_t *except)
{
    size_t except_i = 0;

    if (c->name) fprintf(f, "%s\n", c->name);
    for (int i = 0; i < c->n_s; i++) {
	if (! advance_to(except, &except_i, c->s[i]) && ! ignored_key(c->s[i])) fprintf(f, "%s\n", c->s[i]); 
    }

    return c->n_s;
}

char *config_variant_name(const char *base, config_t *variant)
{
    char *s = Malloc(1 + strlen(base) + 3 + strlen(variant->name) + 1 + 1);
    const char *b = base;
    const char *v = variant->name;

    if (b[0] == '[') b++;
    if (v[0] == '[') v++;

    int b_l = strlen(b);
    int v_l = strlen(v);

    if (b_l && b[b_l-1] == ']') b_l--;
    if (v_l && v[v_l-1] == ']') v_l--;

    if (! v_l) sprintf(s, "[%.*s]", b_l, b);
    else if (b_l && b[b_l-1] == ':') sprintf(s, "[%.*s%.*s]", b_l, b, v_l, v);
    else sprintf(s, "[%.*s - %.*s]", b_l, b, v_l, v);

    return s;
}

static void add_merged_compatible_cond(config_t *c, const char *cc1, const char *cc2)
{
    const char *eq1s = strchr(cc1, '=');
    const char *eq2s = strchr(cc2, '=');
    int eq1 = eq1s - cc1;
    int eq2 = eq2s - cc2;
    const char *expr1 = &cc1[eq1+1];
    const char *expr2 = &cc2[eq2+1];

    while (*expr1 && isspace((unsigned) *expr1)) expr1++;
    while (*expr2 && isspace((unsigned) *expr2)) expr2++;

    if (*expr1 && *expr2) {
	char *new_c = Malloc(strlen(cc1) + strlen(cc2) + 20);
	sprintf(new_c, "%.*s= (%s) and (%s)", eq1, cc1, expr1, expr2);
	config_add(c, new_c);
	free(new_c);
    } else if (*expr1) {
	config_add(c, cc1);
    } else if (*expr2) {
	config_add(c, cc2);
    }
}

config_t *config_new_variant(config_t *base, config_t *variant)
{
    char *vname = config_variant_name(config_get_name(base), variant);
    config_t *c = config_new(NULL, vname);
    size_t base_i = 0;

    for (size_t i = 0; i < variant->n_s; i++) {
	const char *variant_s = variant->s[i];
        int add_variant_s = 1;

        while (base_i < base->n_s) {
	    const char *base_s = base->s[base_i];
	    int cmp = key_cmp(base_s, variant_s);

	    if (cmp == 0 && key_cmp(base_s, COMPATIBLE_COND) == 0) {
		add_merged_compatible_cond(c, base_s, variant_s);
		base_i++;
		add_variant_s = 0;
	    } else if (cmp < 0 || strcmp(base_s, variant_s) == 0) {
		config_add(c, base_s);
		base_i++;
	    } else if (cmp > 0) {
		break;
	    } else {
		/* same key, different values => conflict! */
		fprintf(stderr, "Variant [%s] of [%s] conflicts:\n%s\n%s\n", variant->name, base->name, variant_s, base_s);
		config_destroy(c);
	 	return NULL;
	    }
	}
        if (add_variant_s) config_add(c, variant_s);
    }

    while (base_i < base->n_s) config_add(c, base->s[base_i++]);

    return c;
}

const char *config_get_fname(config_t *c)
{
    return c->fname;
}

void config_set_fname(config_t *c, const char *fname)
{
    Free(c->fname);
    c->fname = Strdup(fname);
}

void config_set_name(config_t *c, const char *name)
{
    Free(c->name);
    c->name = Strdup(name);
}

const char *config_get_name(config_t *c)
{
    return c->name;
}

const char *config_get_i(config_t *c, size_t i)
{
    if (i >= c->n_s) return NULL;
    return c->s[i];
}

const void config_delete_key(config_t *c, const char *kv_pair)
{
    int j = 0;

    for (int i = 0; i < c->n_s; i++) {
	if (key_cmp(c->s[i], kv_pair) != 0) c->s[j++] = c->s[i];
	else free(c->s[i]);
    }

    c->n_s = j;
}
