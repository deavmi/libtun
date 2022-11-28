Notes
=====

Finally works

TUNTAP is message-oriented, now I did allocate a huge amount. I could have possibly tried using PEEK if it implements it but the thing is that then I would have to mangle that fucking horried ethernet frame format (not str8 forward like IP)

It appears you canot use PEEK on fd's that are not sockets.

Regardless of whether they implement queuoing or not, it would be nice
if that was allowed. And if tuntap did it. THEN I could make a system
that doesn't allocate something huge and THEN I could go ahead
and also PEEK read.


## TODO

- [ ] Adapter settings
 - [ ] `up`/`down` interface
 - [ ] Set address on interface
    - [ ] For source address selection
    - [ ] For possible automatic route addition