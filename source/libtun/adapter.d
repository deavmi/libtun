module libtun.adapter;

extern (C) int ioctl(int fd, ulong request, void* data);
extern (C) int open(char* path, int flags);

import std.stdio;
import core.stdc.stdio;

/**
* TUN maintenance routines in `test.c`
*/
extern (C) int createTun(char* interfaceName, short iffFlags);
extern (C) int destroyTun(int fd);

public class TUNAdapter
{
    this(string interfaceName)
    {
        init();
    }

    private void init()
    {
        int tunFD = open(cast(char*)"/dev/net/tun", _F_RDWR);
        writeln(tunFD);
        writeln(createTun(cast(char*)"", 1));
        writeln(destroyTun(1));
        ioctl(0,0,cast(void*)0);
    }

    public void receive(byte[] buffer)
    {

    }

    public void send(byte[] buffer)
    {

    }
}