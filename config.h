#ifndef __CONFIG_H__
#define __CONFIG_H__

typedef struct configS config_t;

config_t *config_new(const char *fname, const char *name);

config_t *config_new_f(FILE *f, const char *fname);

config_t *config_load(const char *fname);

int config_save(config_t *config);

const char *config_get_fname(config_t *config);

const char *config_get_name(config_t *config);

void config_destroy(config_t *config);

#endif

