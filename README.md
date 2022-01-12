libtun
======

![](branding/logo.png)

TUN/TAP adapter for D-based applications

## Usage

First add it to your dub-based project via:

```
dub add libtun
```

### `TUNAdapter`

The `TUNAdapter` class provides you with all you need to get started. One can construct a new adapter as follows:

```d
import libtun.adapter;

void main()
{
    try
    {
        TUNAdapter tun = new TUNAdapter("interface0", AdapterType.TUN);
    }
    catch(TUNException)
    {

    }
}
```

Reading and writing is easy:

```d
byte[] data;

try
{
    tun.receive(data);
    tun.write([65,66,66,65]);
}
catch(TUNException)
{

}
```

There are two types of adapters:

1. `AdapterType.TUN`
    * This is for creating a TUN device
2. `AdapterType.TAP`
    * This is for creating a TAP device

## License

LGPLv3
