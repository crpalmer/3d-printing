#include <stdio.h>
#include <stdlib.h>
#include <float.h>

static size_t
fatal_fread(void *ptr, size_t s, size_t n, FILE *f)
{
    size_t res;

    res = fread(ptr, s, n, f);
    if (res != n) {
	fprintf(stderr, "bad read (%d, %d) at %d: ", res, n, ftell(f));
	perror(NULL);
	exit(5);
    }
    return n;
}

static void
fread_triple(float *triple, FILE *f, float *delta)
{
    fatal_fread(triple, sizeof(triple)[0], 3, f);
}

int main(int argc, char **argv)
{
    float triple[3];
    unsigned n, i, j;
    unsigned char header[80];
    FILE *in, *out;
    float mins[3] = { FLT_MAX, FLT_MAX, FLT_MAX };
    float maxs[3] = { -FLT_MAX, -FLT_MAX, -FLT_MAX }; 
    float delta[3] = { 0, 0, 0 };

    if (argc != 3 && argc != 6) {
	fprintf(stderr, "usage: in out [deltax deltay deltaz]\n");
	exit(1);
    }

    if (argc > 3) {
	delta[0] = atof(argv[3]);
	delta[1] = atof(argv[4]);
	delta[2] = atof(argv[5]);
    }

    if ((in = fopen(argv[1], "rb")) == NULL) {
	perror(argv[1]);
	exit(2);
    }

    if ((out = fopen(argv[2], "w")) == NULL) {
	perror(argv[2]);
	exit(2);
    }

    fatal_fread(header, sizeof(header), 1, in);
    fatal_fread(&n, sizeof(n), 1, in);
    printf("# vertices: %d\n", n);
    fprintf(out, "solid \n");
    while (n-- > 0) {
	fread_triple(triple, in, delta);
	fprintf(out, "  facet normal %f %f %f\n    outer loop\n", triple[0], triple[1], triple[2]);
	for (i = 0; i < 3; i++) {
	     fread_triple(triple, in, delta);
	     triple[0] += delta[0];
	     triple[1] += delta[1];
	     triple[2] += delta[2];
	     fprintf(out, "      vertex %f %f %f\n", triple[0], triple[1], triple[2]);
	     for (j = 0; j < 3; j++) {
		if (triple[j] < mins[j]) mins[j] = triple[j];
		if (triple[j] > maxs[j]) maxs[j] = triple[j];
	     }
	}
	fatal_fread(&i, 2, 1, in);
	fprintf(out, "    endloop\n");
	fprintf(out, "  endfacet\n");
    }
    fprintf(out, "endsolid \n");
    printf("bounding box: (%f, %f, %f) -> (%f, %f, %f)\n", mins[0], mins[1], mins[2], maxs[0], maxs[1], maxs[2]);
    exit(0);
}
	
