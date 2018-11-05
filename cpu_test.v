//CPUの創り方p215
//CPUの試用環境を便宜的に作成
//Analysis & Elaborationのみ行った
module cpu_test;
	
	wire clk;
	wire n_reset;
	wire instr;
	wire address;
	wire select_a;
	wire select_b;
	wire load0;
	wire load1;
	wire load2;
	wire load3;
	wire out;
	
	cpu cpu(clk, n_reset, instr, address, select_a, select_b, load0, load1, load2, load3, out);

endmodule
