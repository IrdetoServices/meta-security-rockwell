#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>
#include <errno.h>

/* TODO: look up page size at runtime */
#define PAGE_SIZE 4096

/* Some static data */
int array[PAGE_SIZE];

int main(int argc, char* argv[])
{
	int ret = 0, carry = 0;
	void* p = (void*) array;

	memset(p, 0, sizeof(array));

	/* Verify r/w */
	ret = mprotect(p - (((unsigned long)p) % PAGE_SIZE), PAGE_SIZE, PROT_READ | PROT_WRITE);
	printf("- r/w   : %d-%d\n", ret, errno);
	carry |= 0;

	array[0] = 1;

	/* Try to make array page excutable */
	ret = mprotect(p - (((unsigned long)p) % PAGE_SIZE), PAGE_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC);
	printf("- r/w/e : %d-%d\n", ret, errno);
	carry |= 0;

	/* Verify ro */
	ret = mprotect(p - (((unsigned long)p) % PAGE_SIZE), PAGE_SIZE, PROT_READ);
	printf("- ro    : %d-%d\n", ret, errno);
	carry |= 0;

	/* Verify w/e */
	ret = mprotect(p - (((unsigned long)p) % PAGE_SIZE), PAGE_SIZE, PROT_WRITE | PROT_EXEC);
	printf("- w/e : %d-%d\n", ret, errno);
	carry |= 0;

	return carry;
}
