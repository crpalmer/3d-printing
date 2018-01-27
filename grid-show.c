#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>

int main(int argc, char **argv)
{
     unsigned size = fgetc(stdin);
     float radius;
     int x, y;
     float small = FLT_MAX;
     float big = -FLT_MAX;
     int csv_mode = 0;

     if (argc > 1) {
	if (argc == 2 && strcmp(argv[1], "--csv") == 0) csv_mode = 1;
	else {
	     fprintf(stderr, "usage: [--csv]\n");
	     exit(1);
	}
     }

     fread(&radius, sizeof(radius), 1, stdin);
     fprintf(stderr, "%dx%d grid with radius %f\n", size, size, radius);

     for (x = 0; x < size; x++) {
	for (y = 0; y < size; y++) {
	    float v;

	    fread(&v, sizeof(v), 1, stdin);

	    if (csv_mode) printf("%d %d %f\n", x, y, v);
	    else printf("%8.4f", v);

	    if (v > big) big = v;
	    if (v < small) small = v;
	}
	if (! csv_mode) printf("\n");
    }
    fprintf(stderr, "range of values: %f..%f\n", small, big);
}

