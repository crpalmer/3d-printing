#include <stdio.h>
#include <stdlib.h>
#include "group.h"
#include "utils.h"

static int is_base_ini(config_t *c)
{
    return c != NULL && ends_with(config_get_fname(c), "/base.ini");
}

static int has_base_ini(group_t *g)
{
    for (size_t i = 0; i < g->n_c; i++) {
	if (g->c[i] && ends_with(config_get_fname(g->c[i]), "/base.ini")) return 1;
    }
    return 0;
}

static void write_config(config_t *c)
{
    config_write(c, stdout);
    printf("\n");
}

static void output_customizations(group_t *g)
{
    for (size_t i = 0; i < g->n_c; i++) {
	if (is_base_ini(g->c[i])) {
	    for (size_t j = 0; j < g->n_c; j++) {
		if (j != i && g->c[j]) {
		    config_t *c = config_new_customization(g->c[i], g->c[j]);
		    write_config(c);
		    config_destroy(c);
		}
	    }
	    return;
	}
    }
    fprintf(stderr, "Warning: no base.ini found\n");
}

static void output_configs(group_t *g)
{
    for (size_t i = 0; i < g->n_c; i++) {
	if (g->c[i]) write_config(g->c[i]);
    }
}

static void
output_group(group_t *g)
{
    if (has_base_ini(g)) output_customizations(g);
    else output_configs(g);
}

int main(int argc, char **argv)
{
    size_t n_groups;
    group_t **groups = group_load_dirs("slic3r", &n_groups);
    for (size_t i = 0; i < n_groups; i++) {
	output_group(groups[i]);
    }
}

