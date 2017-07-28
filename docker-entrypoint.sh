#!/bin/bash
# TODO: handle being passed "bash" like the official libs require
set -e

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "${1:0:1}" = '-' ]; then
    set -- all "$@"
fi

# check for the expected command
if [ "$1" = 'all' ]; then
    cd /usr/src/Splatoon-2-Drawing

    if [ -e /input.data ]; then
        echo "Using custom image."

        # create a c file for the image
        python2 bin2c.py /input.data > image.c
    else
        echo "Using default image. Mount your own at /input.data"
    fi

    # this is default in the makefile, but we want it in our message
    [ -z "$MCU" ] && MCU=at90usb1286
    [ -z "$OUTPUT" ] && OUTPUT=Joystick

    # create the program
    make

    # TODO: detect if a device is available automatically
    # OSX doesn't seem to have raw USB devices: https://github.com/docker/for-mac/issues/900
    if [ "$PROGRAM" = "1" ]; then
        # if a device is connected, program it
        make program

        echo
        echo "Success!"
        echo
    else
        # copy the program to /target
        cp Joystick.hex /target/$OUTPUT.hex

        echo "Upload the image with something like:"
        echo
        echo "    teensy_loader_cli -w -n -v -mmcu=$MCU target/$OUTPUT.hex"
        echo
        echo "Or:"
        echo
        echo "    hid_bootloader_cli -w -n -v -mmcu=$MCU target/$OUTPUT.hex"
        echo
    fi

    exit 0
fi

# else default to run whatever the user wanted like "bash"
exec "$@"