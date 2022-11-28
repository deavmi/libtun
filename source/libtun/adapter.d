module libtun.adapter;

import libtun.tunctl;

public class Adapter
{
    /* Tunnel device descriptor */
    private int tunFD;
    private bool isClosed;

    /* Temporary scratchpad buffer */
    private byte[] scratch;
        

    /** 
     * Instantiates a new Adapter with the given interface name
     * and optionally you can specifiy the adapter type (default
     * is TAP)
     *
     * Params:
     *   interfaceName = the name of the interface to create
     *   adapterType = The AdapterType to use
     */
    this(string interfaceName, AdapterType adapterType = AdapterType.TAP)
    {
        init(interfaceName, adapterType);
    }

    private void init(string interfaceName, AdapterType adapterType)
    {
        tunFD = createTun(cast(char*)interfaceName, 4096|adapterType);
        if(tunFD < 0)
        {
            throw new AdapterException("Error creating tun device");
        }

        /* TODO: Get device MTU and add functions for setting it */
        ushort mtu = cast(ushort)-1;
        scratch.length = mtu;
    }

    private void sanityCheck()
    {
        if(isClosed)
        {
            throw new AdapterException("Cannot operate on closed tunnel device");
        }
    }

    public void setAddress()
    {
        
    }

    /** 
     * Closes the adapter
     *
     * Throws:
     *      TUNException if the operation failed
     */
    public void close()
    {
        sanityCheck();

        isClosed = true;
        destroyTun(tunFD);
    }

    /** 
     * Blocks to receive into the buffer
     *
     * Params:
     *   buffer = The buffer variable to write the received
     *            data into
     * Throws:
     *          TUNException if the read failed
     */
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
            throw new AdapterException("Read failed");
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

    /** 
     * Sends the provided data
     *
     * Params:
     *   buffer = The data to send
     * Throws:
     *      TUNException if an error occurs
     */
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

public final class AdapterException : Exception
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