
.PHONY: all info clean lib compile run

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
gitroot_dir := $(shell git rev-parse --show-toplevel)
test1 := $(dir $(mkfile_path))
test2 = $(patsubst %/,%,$(test1))
cur_dir := $(dir $(test2))
MODELSIM_VERSION_SHORT := $(shell vsim -version | sed -n 's/^.*ModelSim[^0-9]*\([0-9.]*[a-z]*\).*$$/\1/p')


fp_transcript = $(cur_dir)transcript
fp_modelsimini = $(cur_dir)modelsim.ini
fp_proj_ini = $(cur_dir)cfg/modelsim.ini
fp_dutlib = $(cur_dir)lib/dut_lib
fp_tblib = $(cur_dir)lib/tb_lib
fp_wave = $(cur_dir)waves

slash_to_backslash = $(subst /,\\,$(1))

define CLEAN_FILE
	@echo "cleaning $(1)..."
	@rm $(1)
endef

define CLEAN_DIR
	@echo "cleaning $(1)..."
	@rm -rf $(1)
endef

all: clean info lib compile compile run


ifeq ($(wildcard $(fp_modelsimini)),$(fp_modelsimini))
print:
	$(info "got it")
else
print:
	$(info "doesn't exists")
	$(info $(fp_modelsimini))
endif

info:
	@echo "git root directory: $(gitroot_dir)"
	@echo "current directory:  $(cur_dir)"
	@echo "Modelsim Version:   $(MODELSIM_VERSION_SHORT)"

clean:
ifeq ($(wildcard $(fp_transcript)),$(fp_transcript))
	$(call CLEAN_FILE,$(fp_transcript))
endif
ifeq ($(wildcard $(fp_modelsimini)),$(fp_modelsimini))
	$(call CLEAN_FILE,$(fp_modelsimini))
endif
ifeq ($(wildcard $(fp_dutlib)),$(fp_dutlib))
	$(call CLEAN_DIR,$(fp_dutlib))
endif
ifeq ($(wildcard $(fp_tblib)),$(fp_tblib))
	$(call CLEAN_DIR,$(fp_tblib))
endif

lib:
	@vlib -dirpath lib $(fp_dutlib)
	@vlib -dirpath lib $(fp_tblib)
	@vmap -modelsimini $(fp_proj_ini) dut_lib $(fp_dutlib)
	@vmap -modelsimini $(fp_proj_ini) tb_lib $(fp_tblib)

compile:
	# dut
	@vcom -2008 -work dut_lib -quiet -modelsimini $(fp_proj_ini) source/dut/synchronizer.vhd
	@#
	# tb
	@vlog -sv -work tb_lib -quiet -modelsimini $(fp_proj_ini) source/tb/rst_gen.sv
	@vlog -sv -work tb_lib -quiet -modelsimini $(fp_proj_ini) source/tb/clk_gen.sv
	@vlog -sv -work tb_lib -quiet -modelsimini $(fp_proj_ini) source/tb/i2c_driver.sv
	@vlog -sv -work tb_lib -quiet -modelsimini $(fp_proj_ini) source/tb/tb.sv

run:
	@vsim -c -modelsimini $(fp_proj_ini) -wlf $(fp_wave)/test1.wlf -do "./scripts/run.tcl"

load:
	@vsim -modelsimini $(fp_proj_ini) -l ./log/test1.log -view $(fp_wave)/test1.wlf
