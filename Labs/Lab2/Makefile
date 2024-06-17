all : add mul cube fun

add : 
	iverilog -o adder_tb.vvp adder_tb.v
	vvp adder_tb.vvp

mul : 
	iverilog -o multiplier_tb.vvp multiplier_tb.v
	vvp multiplier_tb.vvp

cube : 
	iverilog -o cbrt_tb.vvp cbrt_tb.v
	vvp cbrt_tb.vvp

fun : 
	iverilog -o function_tb.vvp function_tb.v
	vvp function_tb.vvp

once : 
	iverilog -o function_tb_once.vvp function_tb_once.v
	vvp function_tb.vvp


clean : 
	-rm adder_tb.vvp adder.vcd
	-rm multiplier_tb.vvp multiplier.vcd
	-rm cbrt_tb.vvp cbrt.vcd
	-rm function_tb.vvp function.vcd


watcha : 
	gtkwave adder.vcd

watchc : 
	gtkwave cbrt.vcd

watchm : 
	gtkwave multiplier.vcd

watchf : 
	gtkwave function.vcd

	