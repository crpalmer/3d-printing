#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include "config.h"
#include "group.h"
#include "utils.h"

static group_t *group_new()
{
    group_t *g = Malloc(sizeof(*g));
    g->base = NULL;
    g->c = Malloc(1);
    g->n_c = 0;
    return g;
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

    while((entry = readdir(dp))) {
	char *fname;

	if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;

        fname = Malloc(strlen(entry->d_name) + strlen(dir) + 2);
	sprintf(fname, "%s/%s", dir, entry->d_name);

	if (entry->d_type == DT_DIR) {
	    add_to_groups(groups, n_groups, fname);
	} else if (ends_with(entry->d_name, ".ini")) {
	    config_t *c = config_load(fname);
	    if (c) {
		if (strcmp(entry->d_name, "base.ini") == 0) {
		    g->base = c;
		} else {
		    g->n_c++;
		    g->c = Realloc(g->c, sizeof(*g->c) * g->n_c);
		    g->c[g->n_c-1] = c;
		}
	    }
	}
	free(fname);
    }

    closedir(dp);
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

group_t *group_find(group_t **groups, size_t n_groups, const char *target, size_t *i_ret)
{
    if (! target) return NULL;

    for (size_t g_i = 0; g_i < n_groups; g_i++) {
	group_t *g = groups[g_i];

	for (*i_ret = 0; *i_ret < g->n_c; (*i_ret)++) {
	    const char *name = config_get_name(g->c[*i_ret]);
	    if (name && strcmp(name, target) == 0) return g;
	}
    }
    return NULL;
}
