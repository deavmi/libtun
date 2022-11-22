API
===

This document contains documentation on each user-facing component of the libtun library.

## Creating a new Adapter

Firstly add the following import line to your project:

```d
import libtun.adapter;
```

Now we can spawn a new `TUNAdapter` with the following parameters. This will
create a new interface named `myTun0` and we can choose between creating either
a TUN adapter or a TAP adapter by setting the second argument to one or the other
of:

1. `AdapterType.TUN`
2. `AdapterType.TAP`

```d
TUNAdapter adapter = new TUNAdapter("myTun0", AdapterType.TUN);
```

If one does not specify the second argument then it defaults to TAP mode.

## Using the adapter

This section describes how to use the adapter now that it is setup.

### Receiving from the adapter

One can use the `receive(ref byte[])` method in order to receive a frame/packet
from the adapter. This takes in a pointer to a vriable holding a buffer
(albeit automatically due to pass by `ref`-erence) and will assign a new
buffer to it of the correct size matching the received frame/packet.

Below we will receive a frame/packet:

```d
byte[] frameBuff;

adapter.receive(frameBuff);
```

If the read fails for some reason then a `TUNException` will be thrown.

### Sending via the adapter

One can use the `send(byte[])` method in order to send a frame/packet via
the adapter. All one needs to do is to provide the frame/packet to be sent
as follows:

```d
byte[] myData = [1,2,3,4];

adapter.send(myData);
```