all : add mul cube fun lfsr lfsr2 crc deb bist validate

.PHONY : validate
	
add : 
	iverilog -o adder_tb.vvp adder_tb.v
	vvp adder_tb.vvp
	vvp adder_tb.vvp > "adder.test"

mul : 
	iverilog -o multiplier_tb.vvp multiplier_tb.v
	vvp multiplier_tb.vvp
	vvp multiplier_tb.vvp > "multiplier.test"

cube : 
	iverilog -o cbrt_tb.vvp cbrt_tb.v
	vvp cbrt_tb.vvp
	vvp cbrt_tb.vvp > "cbrt.test"

fun : 
	iverilog -o function_tb.vvp function_tb.v
	vvp function_tb.vvp
	vvp function_tb.vvp > "function.test"

lfsr : 
	iverilog -o lfsr_tb.vvp lfsr_tb.v
	vvp lfsr_tb.vvp
	vvp lfsr_tb.vvp > "lfsr.test"

lfsr2 : 
	iverilog -o lfsr2_tb.vvp lfsr2_tb.v
	vvp lfsr2_tb.vvp
	vvp lfsr2_tb.vvp > "lfsr2.test"

crc : 
	iverilog -o crc8_tb.vvp crc8_tb.v
	vvp crc8_tb.vvp
	vvp crc8_tb.vvp > "crc8.test"

deb : 
	iverilog -o debounce_tb.vvp debounce_tb.v
	vvp debounce_tb.vvp
	vvp debounce_tb.vvp > "debounce.test"

bist :
	iverilog -o bist_tb.vvp bist_tb.v
	vvp bist_tb.vvp
	vvp bist_tb.vvp > "bist.test"

validate : 
	gcc validate.c -o validate
	./validate
	./validate > "validate.test"

clean : 
	-rm lfsr_tb.vvp lfsr.vcd
	-rm lfsr2_tb.vvp lfsr2.vcd
	-rm crc8_tb.vvp crc8.vcd
	-rm bist_tb.vvp bist.vcd
	-rm adder_tb.vvp adder.vcd
	-rm multiplier_tb.vvp multiplier.vcd
	-rm cbrt_tb.vvp cbrt.vcd
	-rm function_tb.vvp function.vcd
	-rm debounce_tb.vvp debounce.vcd
	-rm bist_tb.vvp bist.vcd
	-rm validate

watchl : 
	gtkwave lfsr.vcd
	
watchl2 : 
	gtkwave lfsr2.vcd

watchcrc : 
	gtkwave crc8.vcd

watchb : 
	gtkwave bist.vcd
watcha : 
	gtkwave adder.vcd

watchc : 
	gtkwave cbrt.vcd

watchm : 
	gtkwave multiplier.vcd

watchf : 
	gtkwave function.vcd

watchdeb : 
	gtkwave debounce.vcd

watchbist :
	gtkwave bist.vcd
