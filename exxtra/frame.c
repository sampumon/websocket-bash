#include <stdio.h>

int main() {
	char s[1024], o[1024];
	int i; 
	unsigned int maskint;
	char *mask = &maskint;

	while (fgets(s, 1024, stdin)) {

		maskint = ((unsigned int *) s)[5];
		printf("mask: %u\n", maskint);
		printf("mask: %4c\n", mask);

		for (i=0; s[i]; i++) {
			o[i] = s[i] ^ mask[i % 4];
		}
		o[i] = s[i];

		fputs(o, stdout);
	}
}
