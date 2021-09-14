#include <stdio.h>
#include <stdlib.h>
#include <float.h>
#include "group.h"
#include "utils.h"

#define DEBUG 0

static void write_config(config_t *c)
{
    config_write(c, stdout);
    printf("\n");
    fflush(stdout);
}

static void output_one_variant(group_t *g, config_t *base, int level, double low, double high)
{
    if (DEBUG) fprintf(stderr, "%*c>> %s\n", level*3, ' ', config_get_name(base));
    if (level >= g->n_variants) {
	write_config(base);
	if (DEBUG) fprintf(stderr, "%*c   == %s\n", level*3, ' ', config_get_name(base));
	if (DEBUG) fprintf(stderr, "%*c<< %s\n", level*3, ' ', config_get_name(base));
	return;
    }

    group_t *v = g->variants[level].variants;
    for (size_t i = 0; i < v->n_c; i++) {
	double this_low, this_high;

	if (DEBUG) fprintf(stderr, "%*c   ++ %s + %s\n", level*3, ' ', config_get_name(base), config_get_name(v->c[i]));
	config_nozzle_restriction(v->c[i], &this_low, &this_high);
	if (this_low > high || this_high < low) {
	    /* inconsistent, abort! */
	    if (DEBUG) fprintf(stderr, "config %s.%d is inconsistent [%.2f..%.2f] vs. [%.2f..%.2f]\n", config_get_name(base), (int) i, this_low, this_high, low, high);
	    continue;
	}

	this_low = low < this_low ? this_low : low;
	this_high = high > this_high ? this_high : high;

	config_t *c = config_new_variant(base, v->c[i]);
	if (c != NULL) {
	    output_one_variant(g, c, level+1, this_low, this_high);
	    config_destroy(c);
	} else {
	    fprintf(stderr, "config %s + %s could not be created\n", config_get_name(base), config_get_name(v->c[i]));
	}
    }
    if (DEBUG) fprintf(stderr, "<< %s\n", config_get_name(base));
}

static void output_variants(group_t *g)
{
    for (size_t i = 0; i < g->n_c; i++) {
	output_one_variant(g, g->c[i], 0, 0, DBL_MAX);
    }
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
    if (g->n_variants) output_variants(g);
    else if (g->base) output_customizations(g);
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

