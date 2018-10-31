#include "port.h"

/**
 * Reads in the port and stores it into al
 * and then returns the result 
 * 
 * mov dx, PORT
 * in al, dx 
 */
unsigned char port_byte_in(unsigned short port)
{
    unsigned char result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

/**
 * Loads the port with the data 
 * 
 * or al, DATA
 * mov PORT, al
 */
void port_byte_out(unsigned short port, unsigned char data)
{
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

/**
 * Reads the value of the port into ax
 * 
 * mov dx, PORT
 * in ax, dx 
 */
unsigned short port_word_in(unsigned short port)
{
    unsigned short result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

/**
 *  Writes the value of ax (data) into dx (port)
 * 
 * or ax, DATA
 * out PORT, ax
 */
void port_word_out(unsigned short port, unsigned short data)
{
    __asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
