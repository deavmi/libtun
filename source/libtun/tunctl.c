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
#include<unistd.h>
#include<stdint.h>

/* TODO: Update types here using stdint */
uint32_t createTun(char* interfaceName, int32_t iffFlags)
{
    /* TODO: Add all required error checking */
    int32_t tunFD = open("/dev/net/tun", O_RDWR);

    /* If error */
    if(tunFD < 0)
    {
        return tunFD;
    }

    /* TUN properties */
    struct ifreq interfaceReqData;

    /* TODO: Do tuntype */

    /* Set the flags for the tun adapter */
    interfaceReqData.ifr_flags = iffFlags;

    /* Set the requested interface's name */
    strcpy(interfaceReqData.ifr_name, interfaceName);

    /* Attempt to bring up the tun device node */
    int32_t tunStatus = ioctl(tunFD, TUNSETIFF, &interfaceReqData);

    if(tunStatus < 0)
    {
        tunFD = tunStatus;
    }

    return tunFD;
}

uint32_t destroyTun(int fd)
{
    return close(fd);
}

uint32_t tunWrite(int fd, char* data, int length)
{
    write(fd, data, length);
}

/**
* TODO: Depending on mode we need to read a certain amount
* to get the length and then from there move onwards
*
* (FIXME: For now we just read 20 bytes)
*/
uint32_t tunRead(int fd, char* data, int amount)
{
    return read(fd, data, amount);
}
