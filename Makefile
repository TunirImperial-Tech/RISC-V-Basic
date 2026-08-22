ASM = assembler/test.asm
OUT = sim/prog.hex

run:
	iverilog -g2012 -o sim/simv src/*.sv tb/cpu_tb.sv
	vvp sim/simv

wave:
	gtkwave dump.vcd

clean:
	rm -f simv dump.vcd

assemble:
	python assembler/assem.py $(ASM) $(OUT)