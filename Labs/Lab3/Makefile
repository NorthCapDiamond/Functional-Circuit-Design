all : add mul cube fun

add : 
	iverilog -o adder_tb.vvp adder_tb.v
	vvp adder_tb.vvp > "Add.txt"

mul : 
	iverilog -o multiplier_tb.vvp multiplier_tb.v
	vvp multiplier_tb.vvp > "Mul.txt"

cube : 
	iverilog -o cbrt_tb.vvp cbrt_tb.v
	vvp cbrt_tb.vvp > "Cube.txt"

fun : 
	iverilog -o function_tb.vvp function_tb.v
	vvp function_tb.vvp > "Func.txt"

lfsr : 
	iverilog -o lfsr_tb.vvp lfsr_tb.v
	vvp lfsr_tb.vvp

lfsr2 : 
	iverilog -o lfsr2_tb.vvp lfsr2_tb.v
	vvp lfsr2_tb.vvp

crc : 
	iverilog -o crc8_tb.vvp crc8_tb.v
	vvp crc8_tb.vvp

deb : 
	iverilog -o debounce_tb.vvp debounce_tb.v
	vvp debounce_tb.vvp

bist :
	iverilog -o bist.vvp bist.v
	vvp bist.vvp

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
