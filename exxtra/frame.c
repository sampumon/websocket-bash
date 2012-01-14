#include <stdio.h>

int main() {
	char s[1024], o[1024];
	int i; 
	// unsigned int maskint;
	char *mask = s+2;
	char *payload = s+6;

	while (fgets(s, 1024, stdin)) {

		// maskint = ((unsigned int *) s)[5];
		// printf("mask: %u\n", maskint);
		printf("mask: %4c\n", mask);

		for (i=0; payload[i]; i++) {
			o[i] = payload[i] ^ mask[i % 4];
		}
		o[i] = payload[i];

		fputs(o, stdout);
	}
}
