#include "screen.h"
#include "../kernel/io/port.h"
#include "../kernel/util.h"

/**
 * Prints a character to VGA memory. 
 */
void print_char(char character, int col, int row, char attributes)
{
    unsigned char *vid_mem = (unsigned char*) VIDEO_ADDRESS;
    int offset;

    if (!attributes) {
        attributes = WHITE_ON_BLACK;
    }

    if (col >= 0 && row >= 0) {
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

/**
 * Prints a string to the current offset of the cursor
 * 
 * @param str the string to print
 */
void print(char* str)
{
    print_at(str, -1, -1);   
}

/**
 * Prints a string at the given column/row
 * 
 * @param str pointer to the string
 * @param col the column to print at
 * @param row the row to print at
 */
void print_at(char* str, int col, int row)
{
    int i = 0;

    if (col >= 0 && row >= 0) {
        set_cursor(get_offset(col, row));
    }

    for (i; str[i] != '\0'; i++) {
        print_char(str[i], col, row, WHITE_ON_BLACK);
    }
}

void set_cursor(int offset)
{
    //we need to convert from cell offset to char offset
    offset = (offset / 2);

    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char) offset);
}

/**
 * Gets the location of the cursor within video memory
 * 
 */
int get_cursor()
{
    int offset;
    
    /*
     * The device uses it's control register as an index
     * to select its internal registers:
     *  reg 14: high byte of the cursors offset
     *  reg 15: low byte of the cursors offset
     */
    port_byte_out(REG_SCREEN_CTRL, 14);

    /*
     * not sure why we shift here
     * assuming we shift because we want the high byte
     */    
    offset = port_byte_in(REG_SCREEN_DATA) << 8;
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);

    //account for the attribute bytes
    return offset * 2;
}

/**
 * Returns the offset within video memory
 * to place a character.
 * 
 * @param col the column where you want to place the character
 * @param row the row where you want to place the cahracter
 * @return the int offset with video memory 
 */
int get_offset(int col, int row)
{
    return ((row * MAX_COLUMNS) + col) * 2;
}

/**
 * Clears the screen by printing spaces to every column and row
 */
void clear_screen()
{
    int row = 0;
    int col = 0;

    for (row; row < MAX_ROWS; row++) {
        for (col; col < MAX_COLUMNS; col++) {
            print_char(' ', col, row, WHITE_ON_BLACK);
        }
    }

    set_cursor(get_offset(0, 0));
}

int handle_scrolling(int offset)
{
    //not past the end of the screen yet
    if (offset <= MAX_COLUMNS * MAX_ROWS * 2) {
        return offset;
    }

    /*
     * shuffles the rows back one
     * we start at 1 because we don't want to 
     * move the the first row beyond the start of VGA memory
     */
    int i = 1;
    for (i; i < MAX_ROWS; i++) {
        mem_copy(get_offset(0, i) + VIDEO_ADDRESS, get_offset(0, i - 1) + VIDEO_ADDRESS, MAX_COLUMNS * 2);
    }

    //zero out the last row of video memory to delete it
    char* last_line = get_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS;
    for (i = 0; i < MAX_COLUMNS * 2; i++) {
        last_line[i] = 0;
    }

    /*
     * move the cursor back one row so it is at the start
     * of the last row instead of off the edge of video memory
     */
    offset -= MAX_COLUMNS * 2;

    return offset;
}