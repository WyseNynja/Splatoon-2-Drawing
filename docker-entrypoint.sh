#!/bin/bash
# TODO: handle being passed "bash" like the official libs require
set -e

# check for the expected command
if [ "$1" = "all" ]; then
    cd /usr/src/Splatoon-2-Drawing

    if [ -e /input.data ]; then
        echo
        echo "Using custom image."
        echo

        # create a c file for the image
        python2 bin2c.py /input.data > image.c
    else
        echo
        echo "Using default image. Mount your own at /input.data"
        echo
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
        echo "Success building and programming!"
        echo
    else
        # copy the program to /target
        cp Joystick.hex /target/$OUTPUT.hex

        echo
        echo "Success building!"
        echo
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