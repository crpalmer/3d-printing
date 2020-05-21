#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static char line[1024*1024];
static char output_fname[1024*1024];
static int starting_new = 1;
static FILE *output_f;

int main(int argc, char **argv)
{
    while (fgets(line, sizeof(line), stdin) != NULL) {
        int i;

	for (i = strlen(line)-1; i >= 0 && (line[i] == '\r' || line[i] == '\n'); i--) {}
	line[i+1] = '\0';

	if (line[0] == '\0') {
	    starting_new = 1;
	    if (output_f) {
		fclose(output_f);
		output_f = NULL;
	    }
	    continue;
	}

	if (starting_new && line[0] == '[') {
	    char *output_fname = strdup(&line[1]);
	    char *dir;

	    for (i = strlen(output_fname)-1; i > 0 && (isspace(output_fname[i]) || output_fname[i] == ']'); i--) {}
	    output_fname[i+1] = '\0';

	    if (output_fname) {
		output_f = fopen(output_fname, "w");
		if (output_f == NULL) perror(output_fname);
	    }

	    free(output_fname);
	    starting_new = 0;
	}

	if (output_f) fprintf(output_f, "%s\n", line);
    }
    return 0;
}
