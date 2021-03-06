ifeq ($(AOS_2NDBOOT_SUPPORT), yes)
EXTRA_POST_BUILD_TARGETS += gen_standard_images_2ndboot
endif

#OTA_OUTPUT_DIR := $(OUTPUT_DIR)/binary/ota
2NDBOOT_BIN_FILE := $(LINK_OUTPUT_FILE:$(LINK_OUTPUT_SUFFIX)=$(BIN_OUTPUT_SUFFIX))

MOC_APP_BIN_OUTPUT_FILE :=$(LINK_OUTPUT_FILE:.2ndboot$(LINK_OUTPUT_SUFFIX)=$(BIN_OUTPUT_SUFFIX))
#MOC_ALL_BIN_OUTPUT_FILE :=$(LINK_OUTPUT_FILE:.2ndboot$(LINK_OUTPUT_SUFFIX)=.factory$(BIN_OUTPUT_SUFFIX))
MOC_ALL_BIN_OUTPUT_FILE := $(MOC_APP_BIN_OUTPUT_FILE)
#TMP_OTA_BIN_OUTPUT_FILE :=$(OUTPUT_DIR)/binary/$(notdir $(LINK_OUTPUT_FILE:.2ndboot$(LINK_OUTPUT_SUFFIX)=.ota$(BIN_OUTPUT_SUFFIX)))
#MOC_OTA_BIN_OUTPUT_FILE :=$(OUTPUT_DIR)/binary/$(subst @,_,$(notdir $(TMP_OTA_BIN_OUTPUT_FILE)))
MOC_OTA_BIN_OUTPUT_FILE :=$(LINK_OUTPUT_FILE:.2ndboot$(LINK_OUTPUT_SUFFIX)=.ota$(BIN_OUTPUT_SUFFIX))

1BOOT_BIN_FILE :=$(SOURCE_ROOT)/platform/board/board_legacy/developerkit/boot_1st.bin
2NDBOOT_BIN_OUTPUT_FILE := $(OUTPUT_DIR)/binary/developerkit.2ndboot.bin

BANK1_BOOT_OFFSET:= 0x0
BANK1_2NDBOOT_OFFSET:= 0x1800
BANK1_APP_OFFSET := 0x9000
BANK2_BOOT_OFFSET:= 0x80000
BANK2_2NDBOOT_OFFSET:= 0x81800
BANK2_APP_OFFSET := 0x89000

# Required to build Full binary file
GEN_COMMON_BIN_OUTPUT_FILE_SCRIPT:= $(SCRIPTS_PATH)/gen_common_bin_output_file.py

gen_standard_images_2ndboot:
	$(QUIET)$(CP) $(MOC_APP_BIN_OUTPUT_FILE) $(MOC_OTA_BIN_OUTPUT_FILE)
	$(QUIET)$(RM) $(MOC_APP_BIN_OUTPUT_FILE)
	$(QUIET)$(CP) $(2NDBOOT_BIN_FILE) $(2NDBOOT_BIN_OUTPUT_FILE)
	$(QUIET)$(RM) $(2NDBOOT_BIN_FILE)
	$(QUIET)$(ECHO) Generate Second Boot Standard Flash Images: $(2NDBOOT_BIN_OUTPUT_FILE)
	$(QUIET)$(ECHO) Generate ALL Standard Flash Images: $(MOC_ALL_BIN_OUTPUT_FILE)
	$(QUIET)$(RM) $(MOC_ALL_BIN_OUTPUT_FILE)
	$(PYTHON) $(GEN_COMMON_BIN_OUTPUT_FILE_SCRIPT) -o $(MOC_ALL_BIN_OUTPUT_FILE) -f $(BANK1_BOOT_OFFSET) $(1BOOT_BIN_FILE)
	$(PYTHON) $(GEN_COMMON_BIN_OUTPUT_FILE_SCRIPT) -o $(MOC_ALL_BIN_OUTPUT_FILE) -f $(BANK1_2NDBOOT_OFFSET) $(2NDBOOT_BIN_OUTPUT_FILE)
	$(PYTHON) $(GEN_COMMON_BIN_OUTPUT_FILE_SCRIPT) -o $(MOC_ALL_BIN_OUTPUT_FILE) -f $(BANK1_APP_OFFSET) $(MOC_OTA_BIN_OUTPUT_FILE)
	$(PYTHON) $(GEN_COMMON_BIN_OUTPUT_FILE_SCRIPT) -o $(MOC_ALL_BIN_OUTPUT_FILE) -f $(BANK2_BOOT_OFFSET)  $(1BOOT_BIN_FILE)
	$(PYTHON) $(GEN_COMMON_BIN_OUTPUT_FILE_SCRIPT) -o $(MOC_ALL_BIN_OUTPUT_FILE) -f $(BANK2_2NDBOOT_OFFSET) $(2NDBOOT_BIN_OUTPUT_FILE)
	$(PYTHON) $(GEN_COMMON_BIN_OUTPUT_FILE_SCRIPT) -o $(MOC_ALL_BIN_OUTPUT_FILE) -f $(BANK2_APP_OFFSET) $(MOC_OTA_BIN_OUTPUT_FILE)
	$(QUIET)$(RM) $(MOC_OTA_BIN_OUTPUT_FILE)
