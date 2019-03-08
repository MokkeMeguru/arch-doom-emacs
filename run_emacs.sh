#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Please input your ip-addr:port for display (see. your MobaXterm)" 1>&2
    exit 1
fi

docker run -e DISPLAY=$1 -v /c/Users/elect/.ssh:/tmp/.ssh -v /:/home/emacs/mnt -it --rm arch-doom-emacs
