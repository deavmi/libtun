module libtun.adapter;

extern (C) int ioctl(int fd, ulong request, void* data);
extern (C) int open(char* path, int flags);

import core.stdc.stdio;


/**
* TUN maintenance routines in `tunctl.c`
*/
extern (C) int createTun(char* interfaceName, int iffFlags);
extern (C) int destroyTun(int fd);
extern (C) int tunWrite(int fd, char* data, int length);
extern (C) int tunRead(int fd, char* data);

public class TUNAdapter
{
    /* Tunnel device descriptor */
    private int tunFD;
    private bool isClosed;

    this(string interfaceName, AdapterType adapterType = AdapterType.TAP)
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

    private void sanityCheck()
    {
        if(isClosed)
        {
            throw new TUNException("Cannot operate on closed tunnel device");
        }
    }

    public void close()
    {
        sanityCheck();

        isClosed = true;
        destroyTun(tunFD);
    }

    public void receive(ref byte[] buffer)
    {
        sanityCheck();

        /* TODO: Get amount read */
        /* FIXME: For now set it length to 20 */
        buffer.length = 400;
        tunRead(tunFD, cast(char*)buffer.ptr);
    }

    public void send(byte[] buffer)
    {
        sanityCheck();

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

public enum AdapterType
{
    TUN,
    TAP
}