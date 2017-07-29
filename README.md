## Splatoon-2-Drawing
Forked from a Proof-of-Concept Fightstick for the Nintendo Switch. Uses the [LUFA library](https://github.com/abcminiuser/lufa) and reverse-engineering of the Pokken Tournament Pro Pad for the Wii U to enable custom built controllers on the Switch System v3.0.0.

![http://i.imgur.com/93B1Usb.jpg](http://i.imgur.com/93B1Usb.jpg)
*image via [/u/Stofers](https://www.reddit.com/user/Stofers)*

### Wait, what?
On June 20, 2017, Nintendo released System Update v3.0.0 for the Nintendo Switch. Along with a number of additional features that were advertised or noted in the changelog, additional hidden features were added. One of those features allows for the use of compatible controllers, such as the Pokken Tournament Pro Pad, to be used on the Nintendo Switch.

Unlike the Wii U, which handles these controllers on a 'per-game' basis, the Switch treats the Pokken controller as if it was a Switch Pro Controller. Along with having the icon for the Pro Controller, it functions just like it in terms of using it in other games, apart from the lack of physical controls such as analog sticks, the buttons for the stick clicks, or other system buttons such as Home or Capture.

For my own personal use, I repurposed Switch-Fightstick to output a set sequence of inputs to systematically print Splatoon posts. This works by using the smallest size pen and D-pad inputs to plot out each pixel one-by-one.

The problem is that installing the compilers can take a really long time, so then I bundled most everything you need inside a docker container. You can install Docker from https://www.docker.com/.

#### Drawing
Draw your image 350x36 pixel black and white indexed raw image in GIMP.

TODO: better steps for how to use GIMP here

#### Programming

| MCU | | |
|---|---|---|
| mk66fx1m0   | Teensy 3.6       | [not supported by LUFA](https://github.com/abcminiuser/lufa/issues/100) |
| mk64fx512   | Teensy 3.5       | [not supported by LUFA](https://github.com/abcminiuser/lufa/issues/100) |
| mk20dx256   | Teensy 3.2 & 3.1 | [not supported by LUFA](https://github.com/abcminiuser/lufa/issues/100) |
| mk20dx128   | Teensy 3.0       | [not supported by LUFA](https://github.com/abcminiuser/lufa/issues/100) |
| mkl26z64    | Teensy LC        | [not supported by LUFA](https://github.com/abcminiuser/lufa/issues/100) |
| at90usb1286 | Teensy++ 2.0     | works! default if no MCU set |
| atmega32u4  | Teensy 2.0       | untested, but should work |
| at90usb646  | Teensy++ 1.0     | untested, but should work |
| at90usb162  | Teensy 1.0       | untested, but should work |

Linux users should be able to compile and upload the program all from docker:

    # you must customize this
    IMG="/full/path/to/your/AwesomeDrawing.data"

    # you might need to customize these
    DEV=/dev/ttyUSB0
    MCU=at90usb1286

    # then copy, paste and run this
    docker run --rm -it \
        --env "MCU=$MCU" \
        --env PROGRAM=1 \
        --device="$DEV" \
        -v "$IMG:/input.data" \
        bwstitt/splatoon-2-drawing

However, OS X and Docker and USB don't get along (https://github.com/docker/for-mac/issues/900). So, you will need to do things a little differently.

I have no idea about how to do this on Windows. Pull requests are welcome.

Install teensy_loader_cli from [Homebrew](https://brew.sh/) (with `brew install teensy_loader_cli`) or hid_bootloader_cli from LUFA. Then run commands like these:

    # you must customize these
    IMG="/full/path/to/your/AwesomeDrawing.data"
    OUTPUT=AwesomeDrawing

    # you might need to customize these
    MCU=at90usb1286
    TARGET=$(pwd)/target
    LOADER=teensy_loader_cli

    # then copy, paste and run this
    docker run --rm -it \
        --env "MCU=$MCU" \
        -v "$IMG:/input.data" \
        --env "OUTPUT=$OUTPUT" \
        -v "$TARGET:/target" \
        bwstitt/splatoon-2-drawing \
    && $LOADER -w -n -v -mmcu=$MCU $TARGET/$OUTPUT.hex

#### Printing Procedure

1. Use the analog stick to bring the cursor to the top-right corner of an empty drawing.
2. Ensure the smallest pen size is selected.
3. Press the D-pad down once to make sure the cursor is at y-position `0` instead of y-position `-1`.
4. Plug in the custom controller to the USB-C port. 
5. Wait. Printing currently takes about an hour. Each line is printed from right to left in order to avoid pixel skipping issues.

#### Known Issues

* There are issues with controller conflicts while in docked mode which are avoided by using a USB-C to USB-A adapter in handheld mode.
* There are also issues printing to the right and bottom edges.

#### Plans

* Faster printing
* More sample images
