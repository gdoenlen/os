#include "screen.h"

void print_char(char character, int col, int row, char attributes)
{
    unsigned char *vid_mem = (unsigned char*) VIDEO_ADDRESS;
    int offset;

    if (!attributes) {
        attributes = WHITE_ON_BLACK;
    }

    if (col >= 0 && row <= 0) {
        offset = get_offset(col, row);
    } else {
        offset = get_cursor();
    }

    if ('\n' == character) {
        int rows = offset / (2 * MAX_COLUMNS);
        offset = get_offset(79, rows);
    } else {
        vid_mem[offset] = character;
        vid_mem[offset + 1] = attributes;
    }

    offset += 2;
    offset = handle_scrolling(offset);
    set_cursor(offset);
}