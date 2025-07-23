
.PHONY: all clean create_lib compile run

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
test1 := $(dir $(mkfile_path))
test2 = $(patsubst %/,%,$(test1))
cur_dir := $(dir $(test2))

fp_transcript = $(cur_dir)transcript
fp_modelsimini = $(cur_dir)modelsim.ini
fp_proj_ini = $(cur_dir)cfg/modelsim.ini
fp_dutlib = $(cur_dir)lib/dut_lib
fp_tblib = $(cur_dir)lib/tb_lib

slash_to_backslash = $(subst /,\\,$(1))

define CLEAN_FILE
	@echo "cleaning $(1)..."
	@rm $(1)
endef

define CLEAN_DIR
	@echo "cleaning $(1)..."
	@rm -rf $(1)
endef

all: clean create_lib compile run


ifeq ($(wildcard $(fp_modelsimini)),$(fp_modelsimini))
print:
	$(info "got it")
else
print:
	$(info "doesn't exists")
	$(info $(fp_modelsimini))
endif

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

create_lib:
	vlib -dirpath lib $(fp_dutlib)
	vlib -dirpath lib $(fp_tblib)
	vmap -modelsimini $(fp_proj_ini) dut_lib $(fp_dutlib)
	vmap -modelsimini $(fp_proj_ini) tb_lib $(fp_tblib)

compile:
	@vlog -sv -modelsimini $(fp_proj_ini) source/and_gate.sv
	@vlog -sv -modelsimini $(fp_proj_ini) source/tb.sv

run:
	echo "test3"
	vsim
