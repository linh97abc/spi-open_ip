TEST_PATH := bench/verilog
IP_PATH := rtl/verilog

V_SOURCE := $(wildcard $(TEST_PATH:%=%/*.v)) $(wildcard $(IP_PATH:%=%/*.v))
INCLUDE_DIR := rtl/verilog
TEST_MODULE=tb_spi_top
