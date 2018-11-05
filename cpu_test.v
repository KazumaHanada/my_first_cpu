//CPUのテストベンチ
module cpu_test;
	
	reg clk;
	reg n_reset;
	
	wire [3:0] address;
	wire [7:0] dout;
	
	reg  [3:0] port_in;
	wire [3:0] port_out;
	
	wire[6:0] HEX3;
	wire[6:0] HEX2;
	wire[6:0] HEX1;
	wire[6:0] HEX0;
	
	
	cpu cpu(clk, n_reset, dout, address, port_in, port_out);
	
	test_rom rom(address, dout);
	
	decoder dec(port_out, HEX3, HEX2, HEX1, HEX0);
	
	
	initial begin
		#0 $monitor("%t: out = %b : %b %b %b %b", $time, port_out, HEX3, HEX2, HEX1, HEX0);
	end
	
	
	initial begin
		#0 clk = 0; n_reset = 1; port_in = 4'b0101;
		#50 n_reset = 0;
		#150 n_reset = 1;
	end
	
	
	always begin
    		#100 clk = 1;
    		#100 clk = 0;
	end
	
	
	always begin
    		#60000 $finish;
	end

endmodule
