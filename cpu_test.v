//CPUの創り方p272
//CPUの試用環境を便宜的に作成
//Analysis & Elaborationのみ行った
module cpu_test;
	
	wire clk;
	wire n_reset;
	wire instr;
	wire address;
	wire in;
	wire out;
	
	cpu cpu(clk, n_reset, instr, address, in, out);

endmodule
