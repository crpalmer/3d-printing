#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include "config.h"
#include "group.h"
#include "utils.h"

#define BASE_INI "base.ini"
#define VARIANTS_INI "variants.ini"
#define FIELDS_INI "fields.ini"

static group_t *group_new()
{
    group_t *g = Malloc(sizeof(*g));
    g->base = NULL;
    g->n_variants = 0;
    g->c = Malloc(1);
    g->n_c = 0;
    return g;
}

static void
load_configs(group_t *g, const char *dir)
{
    struct dirent *entry;
    DIR *dp;

    dp = opendir(dir);
    if (dp == NULL) {
	perror(dir);
	return;
    }
	
    while((entry = readdir(dp))) {
	char *fname;

	if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;

	if (strcmp(entry->d_name, BASE_INI) == 0) continue;
	if (strcmp(entry->d_name, FIELDS_INI) == 0) continue;
	if (strcmp(entry->d_name, VARIANTS_INI) == 0) continue;

	/* only variants are allowed in directories with a base.ini */
	if (entry->d_type == DT_DIR && g->base) continue;

        fname = Malloc(strlen(entry->d_name) + strlen(dir) + 2);
	sprintf(fname, "%s/%s", dir, entry->d_name);

	if (entry->d_type != DT_DIR && ends_with(entry->d_name, ".ini")) {
	    config_t *c = config_load(fname);
	    g->n_c++;
	    g->c = Realloc(g->c, sizeof(*g->c) * g->n_c);
	    g->c[g->n_c-1] = c;
	}
	free(fname);
    }

    closedir(dp);
}

static void
handle_variants(group_t *g, const char *dir)
{
    FILE *f;
    char fname[1024];

    if (g->n_variants >= MAX_VARIANTS) {
	fprintf(stderr, "error: too many variants when loading [%s]\n", dir);
	return;
    }

    char *v_name = Malloc(strlen(dir) + 1 + strlen(VARIANTS_INI) + 1);
    sprintf(v_name, "%s/%s", dir, VARIANTS_INI);

    f = fopen(v_name, "r");
    free(v_name);
    if (! f) return;

    while (fgets(fname, sizeof(fname), f) != NULL) {
        variant_t *v = &g->variants[g->n_variants];

	strip_trailing_ws(fname);

	char *new_path = Malloc(strlen(dir) +  1 + strlen(fname) + 1);
	sprintf(new_path, "%s/%s", dir, fname);

	if ((v->fields = config_load_path(new_path, FIELDS_INI)) == NULL) {
	    fprintf(stderr, "Failed to load fields configuration in [%s]\n", new_path);
	    perror(FIELDS_INI);
	    goto done;
	}

	v->variants = group_new();
	load_configs(v->variants, new_path);

	free(new_path);

	g->n_variants++;
    }

done:
    fclose(f);
}
	    
    
static void
add_to_groups(group_t ***groups, size_t *n_groups, const char *dir)
{
    struct dirent *entry;
    DIR *dp;
    group_t *g;

    dp = opendir(dir);
    if (dp == NULL) {
	perror(dir);
	return;
    }

    (*n_groups)++;
    *groups = Realloc(*groups, sizeof(*groups) * (*n_groups));
    (*groups)[*n_groups - 1] = g = group_new();

    if (file_exists_in_dir(dir, BASE_INI)) {
	g->base = config_load_path(dir, BASE_INI);
    } else {
        handle_variants(g, dir);
    }

    if (g->n_variants == 0) {
	/* no variants means load all the subdirs */
        while((entry = readdir(dp))) {

	    if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;

	    char *fname = Malloc(strlen(entry->d_name) + strlen(dir) + 2);
	    sprintf(fname, "%s/%s", dir, entry->d_name);

	    if (entry->d_type == DT_DIR ) {
		add_to_groups(groups, n_groups, fname);
	    } else {
		free(fname);
	    }
	}
    }

    closedir(dp);

    load_configs(g, dir);
}

group_t **group_load_dirs(const char *dir, size_t *n_groups)
{
    group_t **groups = Malloc(1);
    *n_groups = 0;
    add_to_groups(&groups, n_groups, dir);
    return groups;
}

static void group_destroy(group_t *g)
{
    for (size_t i = 0; i < g->n_c; i++) config_destroy(g->c[i]);
    Free(g->c);
    Free(g);
}

void groups_destroy(group_t **g, size_t n_groups)
{
    for (size_t i = 0; i < n_groups; i++) group_destroy(g[i]);
    Free(g);
}

static int replace_matching_config(group_t *g, size_t n_groups, config_t *c)
{
    const char *target = config_get_name(c);

    for (size_t i = 0; i < g->n_c; i++) {
	const char *name = config_get_name(g->c[i]);
	if (name && strcmp(name, target) == 0) {
	    config_set_fname(c, config_get_fname(g->c[i]));
	    config_destroy(g->c[i]);
	    g->c[i] = c;
	    return 1;
	}
    }

    return 0;
}

static void copy_config_item(config_t *c_new, config_t *c_old, const char *kv_pair)
{
    const char *s = config_get_by_key(c_old, kv_pair);
    if (s) config_add(c_new, s);
}

static config_t *replace_matching_variant_instances(group_t *g, config_t *c, const char *name, int level)
{
    if (level >= g->n_variants) {
	if (strcmp(name, config_get_name(c)) == 0) return config_clone(c);
	else return NULL;
    }

    group_t *variants = g->variants[level].variants;

    for (int i = 0 ; i < variants->n_c; i++) {
	config_t *gc = variants->c[i];
	char *v_name = config_variant_name(name, gc);
	config_t *found_c = replace_matching_variant_instances(g, c, v_name, level+1);
	free(v_name);

	if (found_c) {
	    config_t *c_new = config_new(config_get_fname(gc), config_get_name(gc));
	    config_t *fields = g->variants[level].fields;
	    const char *field;

	    copy_config_item(c_new, gc, COMPATIBLE_COND);
	    for (size_t j = 0; (field = config_get_i(fields, j)) != NULL; j++) {
		copy_config_item(c_new, c, field);
	    }

	    config_destroy(variants->c[i]);
	    variants->c[i] = c_new;

	    config_t *new_found_c = config_new_except(found_c, fields);
	    config_destroy(found_c);

	    return new_found_c;
	}
    }

    return NULL;
}

static int replace_matching_variant(group_t *g, config_t *c)
{
    for (size_t i = 0; i < g->n_c; i++) {
	config_t *found_c = replace_matching_variant_instances(g, c, config_get_name(g->c[i]), 0);
	if (found_c) {
	    config_set_name(found_c, config_get_name(g->c[i]));
	    config_set_fname(found_c, config_get_fname(g->c[i]));
	    config_destroy(g->c[i]);
	    config_delete_key(found_c, COMPATIBLE_COND);
	    g->c[i] = found_c;
	    config_destroy(c);
	    return 1;
	}
    }
    return 0;
}

int group_replace_matching(group_t **groups, size_t n_groups, config_t *c)
{
    const char *target = config_get_name(c);

    if (! target) return 0;

    for (size_t i = 0; i < n_groups; i++) {
	group_t *g = groups[i];
	if (g->n_variants) {
	    if (replace_matching_variant(g, c)) return 1;
	} else {
	    if (replace_matching_config(g, n_groups, c)) return 1;
	}
    }
    return 0;
}

