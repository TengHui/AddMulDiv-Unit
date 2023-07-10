all: 
	iverilog -o wave -y ./ testbench.v
	vvp -n wave -lxt2
sim:
	gtkwave *.vcd
clean:
	rm wave *.vcd