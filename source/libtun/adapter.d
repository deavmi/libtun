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

    /* Temporary scratchpad buffer */
    private byte[] scratch;
        

    this(string interfaceName, AdapterType adapterType = AdapterType.TAP)
    {
        init(interfaceName, adapterType);
    }

    private void init(string interfaceName, AdapterType adapterType)
    {
        tunFD = createTun(cast(char*)interfaceName, 4096|adapterType);
        if(tunFD < 0)
        {
            throw new TUNException("Error creating tun device");
        }

        /* TODO: Get device MTU and add functions for setting it */
        ushort mtu = cast(ushort)-1;
        scratch.length = mtu;
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

        

        /**
        * We read with a request of maximum possible
        * Ethernet frame size (-1 -> 2 bytes) 65535,
        * this ensures our buffer fills up in all cases
        * but we get returned either < 0 or > 0.
        *
        * Former, systemcall read error
        * Latter, ethernet frame size
        */
        int status = tunRead(tunFD, cast(char*)scratch.ptr, cast(int)scratch.length);

      
        if(status < 0)
        {
            throw new TUNException("Read failed");
        }
        else if(status == 0)
        {
            assert(false);
        }
        else
        {
            /* Copy the data into their buffer (and of correct length) */
            buffer = scratch[0..status].dup;
        }

        

      




        
    }

    public void send(byte[] buffer)
    {
        sanityCheck();

        tunWrite(tunFD, cast(char*)buffer.ptr, cast(int)buffer.length);
    }


    public void setDeviceMTU(ushort mtu)
    {
        /* TODO: Set the MTU on the device */

        /* TODO: Set the scratchpad to match the MTU */
        scratch.length = mtu;
    }

   
}

public final class TUNException : Exception
{
    this(string msg)
    {
        super(msg);
    }
}

public enum AdapterType : byte
{
    TUN = 1,
    TAP = 2
}