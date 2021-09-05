#ifndef __CONFIG_H__
#define __CONFIG_H__

#define COMPATIBLE_COND "compatible_printers_condition ="

typedef struct configS config_t;

config_t *config_new(const char *fname, const char *name);
config_t *config_clone(config_t *c);

config_t *config_new_f(FILE *f, const char *fname);

config_t *config_new_customization(config_t *base, config_t *custom);

config_t *config_new_variant(config_t *base, config_t *variant);

config_t *config_new_except(config_t *base, config_t *except);

config_t *config_clone(config_t *c);

void config_add(config_t *config, const char *kv_pair);

config_t *config_load_path(const char *dir, const char *fname);
config_t *config_load(const char *fname);

config_t *config_generate_base_config(const char *fname, config_t **c, size_t n_c);

int config_save(config_t *config);

int config_save_except(config_t *config, config_t *except);

int config_write(config_t *config, FILE *f);

int config_write_except(config_t *config, FILE *f, config_t *except);

int config_conflicts(config_t *base, config_t *variant);

const char *config_get_fname(config_t *config);

void config_set_fname(config_t *config, const char *fname);

void config_set_name(config_t *config, const char *fname);

const char *config_get_name(config_t *config);

const char *config_get_i(config_t *config, size_t i);

char *config_variant_name(const char *base, config_t *variant);

const char *config_get_by_key(config_t *config, const char *kv_pair);

void config_delete_key(config_t *config, const char *kv_pair);

void config_nozzle_restriction(config_t *config, double *low, double *high);

void config_destroy(config_t *config);

#endif

