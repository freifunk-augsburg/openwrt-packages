/** DPF firmware loader
 *
 * 12/2010 <hackfin@section5.ch>
 *
 * Based on the FX2 ihx loader
 *
 */

#include "dpf.h"
#include <stdio.h>

////////////////////////////////////////////////////////////////////////////

// Demo stuff:

void memory_dump(unsigned char *buf, unsigned int n)
{
	int i = 0;
	int c = 0;

	while (i < n) {
		printf("%02x ", buf[i]);
		c++;
		if (c == 16) { c = 0; printf("\n"); }
			i++;
	}
	if (c)
		printf("\n");
}

int demo(DPFHANDLE h)
{
	unsigned char col[2] = RGB565(0, 0, 0);
	set_screen(h, col);
	col[0] = RGB565_0(255, 255, 0);
	col[1] = RGB565_1(255, 255, 0);
	return set_screen(h, col);
}

int demo0(DPFHANDLE h)
{
	static unsigned char image[2 * 128 * 128];
	int x, y;
	int i;
	for (i = 0; i < 127; i++) {
		unsigned char *b = image;
		for (y = 0; y < 128; y++) {
			for (x = 0; x < 128; x++) {
				*b++ = RGB565_0(x * 2 + i, y * 2 + i, i);
				*b++ = RGB565_1(x * 2 + i, y * 2 + i, i);
			}
		}
		write_screen(h, image, sizeof(image));
	}
	return 0;
}


////////////////////////////////////////////////////////////////////////////


#if EXPERIMENTAL

int xmain(int argc, char **argv)
{
	int ret;
	int i;
	struct banktable *bt;

	// flash offset, offset after jump table
	unsigned int offset = 0x80000 + 0x200;


	static unsigned char buf[0x10000];
	unsigned int len = sizeof(buf);
	ret = load_ihx(argv[1], buf, &len, 0x127c, g_banktab);
	if (ret < 0) {
		fprintf(stderr, "Failed to load HEX file\n");
		return ret;
	} else {
		printf("Read %d banks\n", ret);
		for (i = 0; i < ret; i++) {
			bt = &g_banktab[i];
			printf("	{ XADDR(0x%04x), XADDR(0x%04x), FOFFS(0x%06x) },\n",
				bt->reloc, bt->reloc + bt->len, offset + bt->offset);

		}
	}
	return 0;
}

#endif

int main(int argc, char **argv)
{
	int ret;
	DPFHANDLE h;

	int i = 2;

	if (argc < 2 || argc > 3) {
		fprintf(stderr, "Usage:\n"
				"%s <generic scsi dev> <.ihx file>\n"
		        "or in USB mode:\n"
		        "%s <.ihx file>\n",
		argv[0], argv[0]);
		return -1;
	}

	if (argc == 2) {
		ret = dpf_open(NULL, &h);
		i--;
	} else
	if (argc == 3) {
		ret = dpf_open(argv[1], &h);
	}

	if (ret < 0) {
		perror("opening DPF device:");
		return ret;
	}

// 	This patches a module to init the relocated jump table on a certain
// 	menu action:
// 	ret = patch_sector(h, 0x1330, 0x4af7a, "hack2.ihx");


// 	patch_sector(h,          0x0,    0x100000, "jumptbl.ihx");

	if (0) {
		patch_sector(h,          0x0,    0x100000, "jumptbl.ihx");
		ret = patch_sector(h,       0x1330,    0x110000, "hack.ihx");
		ret = patch_sector(h, 0x132a,    0x120000, "main.ihx");
		if (ret < 0) printf("Failed.\n");
	} else {
	 // demo0(h);

	}
	ret = write_mem(h, argv[i]);
	code_go(h, 0x18a0);
	if (ret < 0) printf("Failed.\n");

	// unsigned char buf[256];
	// ret = read_mem(h, buf, 0x18a0, 64);
	// memory_dump(buf, 64);

	dpf_close(h);
	return ret;
}
