#include <stdio.h>
#include <stdlib.h>
#include <float.h>

int main(int argc, char **argv)
{
     unsigned size = fgetc(stdin);
     float radius;
     int x, y;
     float small = FLT_MAX;
     float big = -FLT_MAX;

     fread(&radius, sizeof(radius), 1, stdin);
     fprintf(stderr, "%dx%d grid with radius %f\n", size, size, radius);

     for (x = 0; x < size; x++) {
	for (y = 0; y < size; y++) {
	    float v;

	    fread(&v, sizeof(v), 1, stdin);
	    printf("%d %d %f\n", x, y, v);
	    if (v > big) big = v;
	    if (v < small) small = v;
	}
    }
    fprintf(stderr, "range of values: %f..%f\n", small, big);
}

