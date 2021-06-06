#ifndef __GROUP_H__
#define __GROUP_H__

#include "config.h"

typedef struct {
    config_t *base;
    config_t **c;
    size_t     n_c;
} group_t;

group_t **group_load_dirs(const char *dir, size_t *n_groups);

config_t *group_get_config(group_t *g, size_t i);

group_t *group_find(group_t **groups, size_t n_groups, const char *name, size_t *i);

void groups_destroy(group_t **groups, size_t n_groups);

#endif
