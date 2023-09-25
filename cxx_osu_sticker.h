#include <cstdarg>
#include <cstdint>
#include <cstdlib>
#include <ostream>
#include <new>

extern "C" {

void generate_osu(const char *text, int x, int y, float size_x, float size_y, const char *savepath);

} // extern "C"
