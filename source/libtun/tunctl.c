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
#include<string.h>
#include<sys/ioctl.h>

int createTun(char* interfaceName, int iffFlags)
{
    /* TODO: Add all required error checking */
    int tunFD = open("/dev/net/tun", O_RDWR);

    /* TUN properties */
    struct ifreq interfaceReqData;

    /* Set the flags for the tun adapter */
    interfaceReqData.ifr_flags = iffFlags;

    /* Set the requested interface's name */
    strcpy(interfaceReqData.ifr_name, interfaceName);

    /* Attempt to bring up the tun device node */
    tunFD = ioctl(tunFD, TUNSETIFF, &interfaceReqData);


    return tunFD;
}

int destroyTun(int fd)
{
    return 68;
}

