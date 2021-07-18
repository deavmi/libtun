module libtun.adapter;

extern (C) int ioctl(int fd, ulong request, void* data);
extern (C) int open(char* path, int flags);

import core.stdc.stdio;


/**
* TUN maintenance routines in `test.c`
*/
extern (C) int createTun(char* interfaceName, int iffFlags);
extern (C) int destroyTun(int fd);
extern (C) int tunWrite(int fd, char* data, int length);

public class TUNAdapter
{
    /* Tunnel device descriptor */
    private int tunFD;

    this(string interfaceName)
    {
        init(interfaceName);
    }

    private void init(string interfaceName)
    {
        tunFD = createTun(cast(char*)interfaceName, 1);
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
        tunWrite(tunFD, cast(char*)buffer.ptr, cast(int)buffer.length);
    }
}

public final class TUNException : Exception
{
    this(string msg)
    {
        super(msg);
    }
}