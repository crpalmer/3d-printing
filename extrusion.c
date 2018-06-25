#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct {
    enum {
	MOVE,
	START_TOWER,
	END_TOWER,
	SET_E,
	TOOL,
	DONE
    } t;
    union {
	struct {
	    double z, e;
	} move;
	double e;
	int tool;
    } x;
} token_t;

static char buf[1024*1024];

static int
find_arg(const char *buf, char arg, double *val)
{
    size_t i;

    for (i = 0; buf[i]; i++) {
	if (buf[i] == ' ' && buf[i+1] == arg) {
	     if (sscanf(&buf[i+2], "%lf", val) > 0) {
		return 1;
	     }
	     return 0;
	}
    }
}

#define STRNCMP(a, b) strncmp(a, b, strlen(b))

static token_t
get_next_token()
{
    token_t t;

    while (fgets(buf, sizeof(buf), stdin) != NULL) {
	if (STRNCMP(buf, "G1 ") == 0) {
	    t.t = MOVE;
	    if (! find_arg(buf, 'Z', &t.x.move.z)) t.x.move.z = NAN;
	    if (! find_arg(buf, 'E', &t.x.move.e)) t.x.move.e = NAN;
	    return t;
	}
	if (STRNCMP(buf, "; finishing tower layer") == 0 ||
	    STRNCMP(buf, "; finishing sparse tower layer") == 0) {
	    t.t = START_TOWER;
	    return t;
	}
	if (STRNCMP(buf, "; leaving transition tower") == 0) {
	    t.t = END_TOWER;
	    return t;
	}
	if (STRNCMP(buf, "G92 ") == 0) {
	    t.t = SET_E;
	    if (find_arg(buf, 'E', &t.x.e)) return t;
	}
	if (buf[0] == 'T' && isdigit(buf[1])) {
	    t.t = TOOL;
	    t.x.tool = atoi(&buf[1]);
	    return t;
	}
    }

    t.t = DONE;
    return t;
}

static double last_z = 0, start_e = 0, last_e = 0, acc_e = 0, last_reported_z = -1;
static int tool = 0;
static int seen_tool = 0;
static double tower_z = -1;
static int in_tower = 0;
static int validate_only = 0;

static void
accumulate()
{
    acc_e += (last_e - start_e);
}

static void
reset_state()
{
    start_e = last_e;
    acc_e = 0;
}

static void
show_extrusion(char chr, int force)
{
    int new_z = last_reported_z != last_z;
    int bad = in_tower && tower_z != last_z && acc_e > 0;

    last_reported_z = last_z;
    if ((seen_tool && new_z) || bad || acc_e > 0 || force) {
	if (validate_only && ! bad) return;

	printf("%c", chr);
	if (seen_tool) printf(" T%d", tool);
	printf(" Z %.02f", last_z);
	if (acc_e > 0) printf(" E %7.02f", acc_e);
	if (bad) printf(" *********** z delta = %.02f", last_z - tower_z);
	printf("\n");
    }
}

int main(int argc, char **argv)
{
    if (argc > 1 && strcmp(argv[1], "--validate") == 0) validate_only = 1;

    while (1) {
	token_t t = get_next_token();
	switch(t.t) {
	case MOVE:
	    if (t.x.move.e > last_e) last_e = t.x.move.e;
	    if (! isnan(t.x.move.z) && t.x.move.z != last_z) {
		accumulate();
		show_extrusion('+', 0);
		last_z = t.x.move.z;
		reset_state();
	    }
	    break;
	case START_TOWER:
	    accumulate();
	    show_extrusion('+', 0);
	    reset_state();
	    tower_z = last_z;
	    in_tower = 1;
	    show_extrusion('>', 1);
	    break;
	case END_TOWER:
	    accumulate();
	    show_extrusion('<', 1);
	    in_tower = 0;
	    reset_state();
	    break;
	case SET_E:
	    accumulate();
	    start_e = t.x.e;
	    last_e = t.x.e;
	    break;
	case TOOL:
	    if (tool != t.x.tool) {
		accumulate();
		if (validate_only && acc_e == 0) printf("Z %.02f ******* Tool change with no extrusion, chroma may screw this up\n", last_z);
		show_extrusion('+', 0);
		reset_state();
		tool = t.x.tool;
		seen_tool = 1;
	    }
	    break;
	case DONE:
	    return 0;
	}
    }
}
