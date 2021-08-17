#Copyright 2021 Linh Bui Tuan <linh97abc@gmail.com>

TEST_MODULE=tb_spi_top

COV_REPORT=cov_report
OUTPUT := cov_report

RTL_SOURCE := $(addprefix rtl/verilog/,$(shell cat sim/rtl_sim/run/rtl.fl))
SIM_SOURCE := $(addprefix bench/verilog/,$(shell cat sim/rtl_sim/run/sim.fl))

INCLUDE_DIR := rtl/verilog
VLOG_FLAG := $(addprefix +incdir+,$(shell realpath --relative-to ${OUTPUT} $(INCLUDE_DIR)))
V_SOURCE_REALPATH := $(shell realpath --relative-to ${OUTPUT} ${RTL_SOURCE} ${SIM_SOURCE})

VLIB := vlib.exe
VMAP := vmap.exe
VLOG := vlog.exe
VSIM := vsim.exe
VCOVER := vcover.exe

all:
	@echo "-- Create the work library:"
	@rm -rf ${OUTPUT}
	@mkdir ${OUTPUT}
	@cd ${OUTPUT} && ${VLIB} work
	@cd ${OUTPUT} && ${VMAP} work work
	@echo "-- Compile the design and testbench..."
	@cd ${OUTPUT} && ${VLOG} -coveropt 3 +cover +acc ${V_SOURCE_REALPATH} ${VLOG_FLAG}
	@echo "-- Run the simulation for code coverage..."
	@cd ${OUTPUT} && ${VSIM} -coverage -vopt work.${TEST_MODULE} -c -do \
		"coverage save -onexit -directive -codeAll ${COV_REPORT}.ucdb;run -all;quit" \
		-l sim.log
	@echo "-- Export the code coverage to HTML file..."
	@cd ${OUTPUT} && ${VCOVER} report -html ${COV_REPORT}.ucdb

clean:
	rm -rf ${OUTPUT}
