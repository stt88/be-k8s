#!/bin/sh
#
# check for $CLIENT_URLS
if [ -z ${CLIENT_URLS+x} ]; then
    CLIENT_URLS="http://0.0.0.0:2379"
    echo "Using default CLIENT_URLS ($CLIENT_URLS)"
else
    echo "Detected new CLIENT_URLS value of $CLIENT_URLS"
fi

# check for $PEER_URLS

if [ -z ${PEER_URLS+x} ]; then
    PEER_URLS="http://0.0.0.0:2380"
    echo "Using default PEER_URLS ($PEER_URLS)"
else
    echo "Detected new PEER_URLS value of $PEER_URLS"
fi


FLANNEL_CMD="/bin/flanneld $*"

echo -e "Running '$FLANNEL_CMD'\nBEGIN FLANNELD OUTPUT\n"
exec $FLANNEL_CMD_CMD
