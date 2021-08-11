-include test.mk

COV_REPORT=cov_report
OUTPUT := cov_report
VLOG_FLAG := $(addprefix +incdir+,$(shell realpath --relative-to ${OUTPUT} $(INCLUDE_DIR)))
V_SOURCE_REALPATH := $(shell realpath --relative-to ${OUTPUT} ${V_SOURCE})

all:
	@echo "-- Create the work library:"
	@rm -rf ${OUTPUT}
	@mkdir ${OUTPUT}
	@cd ${OUTPUT} && vlib work
	@cd ${OUTPUT} && vmap work work
	@echo "-- Compile the design and testbench..."
	@cd ${OUTPUT} && vlog -coveropt 3 +cover +acc ${V_SOURCE_REALPATH} ${VLOG_FLAG}
	@echo "-- Run the simulation for code coverage..."
	@cd ${OUTPUT} && vsim -coverage -vopt work.${TEST_MODULE} -c -do \
		"coverage save -onexit -directive -codeAll ${COV_REPORT}.ucdb;run -all;quit" \
		-l sim.log
	@echo "-- Export the code coverage to HTML file..."
	@cd ${OUTPUT} && vcover report -html ${COV_REPORT}.ucdb

clean:
	rm -rf ${OUTPUT}
