DIST_DIR = /var/cache/pkg/dist

dl_cmd = wget -c $(2) -O $(notdir $(1)) -P $(dir $(1))

$(DIST_DIR)/binutils-%.tar.xz:
	$(call dl_cmd,$@,https://sourceware.org/pub/binutils/releases/$(notdir $@))
