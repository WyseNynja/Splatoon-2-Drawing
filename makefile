#
#             LUFA Library
#     Copyright (C) Dean Camera, 2014.
#
#  dean [at] fourwalledcubicle [dot] com
#           www.lufa-lib.org
#
# --------------------------------------
#         LUFA Project Makefile.
# --------------------------------------

# Run "make help" for target help.

MCU          ?= at90usb1286
ARCH         ?= AVR8
F_CPU        ?= 16000000
F_USB        ?= $(F_CPU)
OPTIMIZATION ?= s
LUFA_PATH    ?= ./LUFA
CC_FLAGS     += -DUSE_LUFA_CONFIG_HEADER -IConfig/
LD_FLAGS     +=

LOADER_CLI       ?= hid_bootloader_cli
LOADER_CLI_FLAGS ?= -w -n -v
LOADER_CLI_FLAGS += -mmcu=$(MCU)

TARGET       = Joystick
SRC          = $(TARGET).c Descriptors.c image.c $(LUFA_SRC_USB)

# Default target
all:

# Include LUFA build script makefiles
include $(LUFA_PATH)/Build/lufa_core.mk
include $(LUFA_PATH)/Build/lufa_sources.mk
include $(LUFA_PATH)/Build/lufa_build.mk
include $(LUFA_PATH)/Build/lufa_cppcheck.mk
include $(LUFA_PATH)/Build/lufa_doxygen.mk
include $(LUFA_PATH)/Build/lufa_dfu.mk
include $(LUFA_PATH)/Build/lufa_hid.mk
include $(LUFA_PATH)/Build/lufa_avrdude.mk
include $(LUFA_PATH)/Build/lufa_atprogram.mk

# Upload the program
program: $(TARGET).hex
	$(LOADER_CLI) $(LOADER_CLI_FLAGS) $(TARGET).hex
