#ifndef __GROUP_H__
#define __GROUP_H__

#include "config.h"

#define MAX_VARIANTS 4

typedef struct groupS group_t;

typedef struct {
    group_t *variants;
    config_t *fields;
} variant_t;

struct groupS {
    config_t  *base;
    variant_t  variants[MAX_VARIANTS];
    size_t     n_variants;
    config_t **c;
    size_t     n_c;
};

group_t **group_load_dirs(const char *dir, size_t *n_groups);

config_t *group_get_config(group_t *g, size_t i);

int group_replace_matching(group_t **groups, size_t n_groups, config_t *c);

void groups_destroy(group_t **groups, size_t n_groups);

#endif
