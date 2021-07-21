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
extern (C) int tunRead(int fd, char* data, int amount);

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
        tunFD = createTun(cast(char*)interfaceName, 4096|2);
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

        ushort mtu = cast(ushort)-1;

        /* Temporary scratchpad buffer */
        byte[] scratch;
        scratch.length = mtu;

        /**
        * We read with a request of maximum possible
        * Ethernet frame size (-1 -> 2 bytes) 65535,
        * this ensures our buffer fills up in all cases
        * but we get returned either < 0 or > 0.
        *
        * Former, systemcall read error
        * Latter, ethernet frame size
        */
        int status = tunRead(tunFD, cast(char*)scratch.ptr, mtu);

      
        if(status < 0)
        {

        }
        else if(status == 0)
        {
            assert(false);
        }
        else
        {
            /* Copy the data into their buffer (and of correct length) */
            buffer = scratch[0..status];
        }

        

      




        
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

public enum AdapterType : ushort
{
    TUN = 1,
    TAP = 0
}