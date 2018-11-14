void mem_copy(char* source, char* dest, int num_bytes) 
{
    int i = 0;
    for (i; i < num_bytes; i++) {
        *(dest + i) = *(source + i);
    }
}
