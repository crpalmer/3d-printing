#include <stdio.h>
#include <stdlib.h>
#include "group.h"
#include "utils.h"

static void write_config(config_t *c)
{
    config_write(c, stdout);
    printf("\n");
}

static void output_customizations(group_t *g)
{
    for (size_t i = 0; i < g->n_c; i++) {
	config_t *c = config_new_customization(g->base, g->c[i]);
	write_config(c);
	config_destroy(c);
    }
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
    if (g->base) output_customizations(g);
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

