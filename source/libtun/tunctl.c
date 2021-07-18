/**
* This module is used just to interface between the Linux
* kernel (via GLIBC) such that the tun adpater can be setup
* and destroyed
*
* `int createTun(char* interfaceName)`
*   - This creates a tun interface with the provided name
*   - and returns the fd
* `int destroyTun(int fd)`
*   - This destroys the tun interface given
*
* Once we have the fd everything else can be done in D
* as we just read()/write() on the returned fd we got
* using `createTun`
*/

#include<linux/if.h>
#include<linux/if_tun.h>
#include<fcntl.h>

int createTun(char* interfaceName)
{
    /* TODO: Add all required error checking */
    int tunFD = open("/dev/net/tun", O_RDWR);
    return 69;
}

int destroyTun(int fd)
{
    return 68;
}

