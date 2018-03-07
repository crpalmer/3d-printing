#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <math.h>

float array[1024*1024];

int main(int argc, char **argv)
{
     int size = fgetc(stdin);
     float radius;
     int x, y;
     float small = FLT_MAX, circle_small = FLT_MAX;
     float big = -FLT_MAX, circle_big = -FLT_MAX;
     int csv_mode = 0;
     int circle_mode = 0;
     int zero_mode = 0;
     float d;

     while (argc > 1) {
	if (argc >= 2 && strcmp(argv[1], "--csv") == 0) csv_mode = 1;
	else if (argc >= 2 && strcmp(argv[1], "--circle") == 0) circle_mode = 1;
	else if (argc >= 2 && strcmp(argv[1], "--zero") == 0) zero_mode = 1;
	else {
	     fprintf(stderr, "usage: [--csv] | [--circle]\n");
	     exit(1);
	}
	argc--;
	argv++;
     }

     fread(&radius, sizeof(radius), 1, stdin);
     d = 2*radius / (size-1);
     fprintf(stderr, "%dx%d grid with radius %f (point distance %f)\n", size, size, radius, d);

     for (y = 0; y < size; y++) {
	for (x = 0; x < size; x++) {
	    fread(&array[x+y*size], sizeof(float), 1, stdin);
	}
     }

     if (zero_mode) {
	float v0 = array[size/2 + (size/2*size)];

	for (x = 0; x < size; x++) {
	    for (y = 0; y < size; y++) {
		array[x + y*size] -= v0;
	    }
	}
    }

    /* print in the order matching looking at the bed from the front (-x to left, -y to front) */
    for (y = size-1; y >= 0; y--) {
	int need_comma = 0;
	float Y = (y*d) - radius;

	for (x = 0; x < size; x++) {
	    float X = (x*d) - radius;
	    int report_it;
	    float v=array[x + y*size];

	    report_it = !circle_mode || (sqrt(X*X+Y*Y) <= radius);

	    if (csv_mode) {
		if (need_comma) printf(",");
		if (report_it) printf("%.4f", v);
		need_comma = 1;
	    } else {
		if (report_it) printf("%8.2f", v);
		else printf("%8c", ' ');
	    }

	    if (v > big) big = v;
	    if (v < small) small = v;
	    if (v > circle_big && report_it) circle_big = v;
	    if (v < circle_small && report_it) circle_small = v;
	}
	printf("\n");
    }
    fprintf(stderr, "range of values: %.4f..%.4f (probed %.4f..%.4f)\n", small, big, circle_small, circle_big);
}

