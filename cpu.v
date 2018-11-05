//CPUの創り方p189
//4bitのA,B,C,Dレジスタとデータセレクタ（2つで1つ）からなる回路
module cpu(
	
	input clk, 
	
	input n_reset, 
	
	input select_a, 	 //便宜的に入力線にする
	
	input select_b, 	 //便宜的に入力線にする
	
	input load0, 		 //便宜的に入力線にする
	
	input load1, 		 //便宜的に入力線にする
	
	input load2, 		 //便宜的に入力線にする
	
	input load3, 		 //便宜的に入力線にする
	
	output [3:0] tmp_out //便宜的に出力線にする
	
	);
	
	
	reg [3:0] a_reg;
	reg [3:0] b_reg;
	reg [3:0] c_reg;
	reg [3:0] d_reg;
	
	wire [3:0] select_out;
	
	
	always @(posedge clk) begin
		
		if(n_reset == 1'b0 ) begin
			a_reg <= 0;
			b_reg <= 0;
			c_reg <= 0;
			d_reg <= 0;
		end
		else begin
			a_reg <= load0 ? select_out : a_reg;
			b_reg <= load1 ? select_out : b_reg;
			c_reg <= load2 ? select_out : c_reg;
			d_reg <= load3 ? select_out : d_reg;
		end
	
	end
	
	
	data_selector ds (a_reg, b_reg, c_reg, d_reg, 
								select_a, select_b, select_out);
	
	
	//便宜的に出力線につなぐ
	assign tmp_out = select_out;


endmodule