#!/bin/sh
 
INTERFACE=eth0
IP=/sbin/ip
 
test -x $IP || exit 0
 
ADDR=`$IP -4 -oneline address show dev $INTERFACE | awk '{print $4}' | cut -d/ -f1`
NO_DOTS=`echo $ADDR | tr "." " "`
HEX_ADDR=`printf "%02x%02x:%02x%02x" $NO_DOTS`
 
case "$1" in
    start)
 
    echo -n "Starting 6to4."
    $IP tun add tun6to4 mode sit ttl 64 remote any local $ADDR
    $IP link set dev tun6to4 up
    $IP -6 addr add 2002:${HEX_ADDR}::1/16 dev tun6to4
    $IP -6 route add 2000::/3 via ::192.88.99.1 dev tun6to4 metric 1
    ;;
 
    stop)
     
    echo -n "Stopping 6to4."
    $IP link set dev tun6to4 down
    $IP tun del tun6to4
    ;;
 
    *)
    echo "Usage: $0 {start|stop}"
    exit 1
 
esac
