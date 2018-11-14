#ifndef SCREEN_H
#define SCREEN_H

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLUMNS 80
#define WHITE_ON_BLACK 0x0f

//screen device i/o ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

void print_char(char character, int col, int row, char attributes);
int get_offset(int row, int col);
int get_cursor(void);

/**
 * handles the scrolling of the screen when the cursor is at the maximum
 * memory address. it moves all rows up and deletes the last row.
 * 
 * @param offset the position of the cursor offset
 * @return the new position of the cursor offset
 */
int handle_scrolling(int offset);
void set_cursor(int offset);
void print_at(char* str, int col, int row);
void print(char* str);

#endif