module libtun.adapter;

extern (C) int ioctl(int fd, ulong request, void* data);
extern (C) int open(char* path, int flags);

import std.stdio;


/**
* TUN maintenance routines in `test.c`
*/
extern (C) int createTun(char* interfaceName, int iffFlags);
extern (C) int destroyTun(int fd);

public class TUNAdapter
{
    this(string interfaceName)
    {
        init();
    }

    private void init()
    {
        int tunFD = createTun(cast(char*)"dd", 1);
        if(tunFD < 0)
        {
            throw new TUNException("Error creating tun device");
        }
    }

    public void receive(byte[] buffer)
    {

    }

    public void send(byte[] buffer)
    {

    }
}

public final class TUNException : Exception
{
    this(string msg)
    {
        super(msg);
    }
}