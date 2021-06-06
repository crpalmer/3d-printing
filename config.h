#ifndef __CONFIG_H__
#define __CONFIG_H__

typedef struct configS config_t;

config_t *config_new(const char *fname, const char *name);

config_t *config_new_f(FILE *f, const char *fname);

config_t *config_new_customization(config_t *base, config_t *custom);

config_t *config_load(const char *fname);

config_t *config_generate_base_config(const char *fname, config_t **c, size_t n_c);

int config_save(config_t *config);

int config_save_except(config_t *config, config_t *except);

int config_write(config_t *config, FILE *f);

int config_write_except(config_t *config, FILE *f, config_t *except);

const char *config_get_fname(config_t *config);

void config_set_fname(config_t *config, const char *fname);

const char *config_get_name(config_t *config);

void config_destroy(config_t *config);

#endif

