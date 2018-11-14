#ifndef K_UTIL_H
#define K_UTIL_H

/**
 * Copys num_bytes amount of memory from the source into the destination
 * 
 * @param source the memory address you want to start copying from
 * @param dest the memory address you want to start copying into
 * @param the number of bytes to be copied from source to dest
 */
void mem_copy(char* source, char* dest, int num_bytes);

#endif