#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

void generate_osu(const char *text, int x, int y, float size_x, float size_y, const char *savepath);

const unsigned char *generate_osu_b(const char *text,
                                    int x,
                                    int y,
                                    float size_x,
                                    float size_y,
                                    int *byte_len);

int test_useable(void);
