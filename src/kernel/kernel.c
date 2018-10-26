void _start()
{
    char* vid_memory = (char*) 0xb8000;
    *vid_memory = 'X';
}