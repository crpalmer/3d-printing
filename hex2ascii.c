#include <stdio.h>
#include <stdlib.h>

int digit(int v)
{
    if (v >= '0' && v <= '9') return v - '0';
    if (v >= 'A' && v <= 'F') return v - 'A' + 10;
    if (v >= 'a' && v <= 'f') return v - 'a' + 10;
    return -1;
}

int main(int argc, char **argv)
{
    int b1, b2;

    while ((b1 = fgetc(stdin)) != EOF && (b2 = fgetc(stdin)) != EOF) {
	b1 = digit(b1);
	b2 = digit(b2);
	printf("%c", (b1<<4) | b2);
    }

    return 0;
}
