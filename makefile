all:
	
	iverilog -o pe.out testbench.v pe.v
	vvp -n 	pe.out

wave:
	gtkwave *.vcd &
clean:
	rm *.out *.vcd *.vvp