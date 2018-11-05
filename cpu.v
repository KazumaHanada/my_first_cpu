module cpu(
	
	input clk,
	
	input n_reset,
	
	input [7:0] instr,
	
	output [3:0] address,
	
	input [3:0] in,
	
	output [3:0] out 
	
	);
	
	
	wire load0;
	wire load1;
	wire load2;
	wire load3;
	
	reg [3:0] a_reg;
	reg [3:0] b_reg;
	reg [3:0] out_reg;
	reg [3:0] pc_reg;
	
	wire [3:0] op;
	wire [3:0] im;
	
	wire select_a;
	wire select_b;
	wire [3:0] selector_out;
	
	wire [3:0] alu_out;
	
	reg cf_reg;
	wire c;
	
	
	//Aレジスタ
	always @(posedge clk) begin
		if(n_reset == 1'b0 )
			a_reg <= 0;
		else
			a_reg <= load0 ? alu_out : a_reg;
	end
	
	
	//Bレジスタ
	always @(posedge clk) begin
		if(n_reset == 1'b0 )
			b_reg <= 0;
		else
			b_reg <= load1 ? alu_out : b_reg;
	end
	
	
	//出力ポート(元Cレジスタ)
	always @(posedge clk) begin
		if(n_reset == 1'b0 )
			out_reg <= 0; 
		else
			out_reg <= load2 ? alu_out : out_reg; 
	end
	
	assign out	= out_reg;
	
	
	//PC(元Dレジスタ)
	always @(posedge clk) begin
		if(n_reset == 1'b0 ) 
			pc_reg <= 0;
		else
			pc_reg <= load3 ? im : pc_reg + 1;
	end
	
	assign address = pc_reg;
	
	
	//デコーダ
	assign op = instr[7:4];
	assign im = instr[3:0];
	
	assign select_a = op[0] | op[3];
	assign select_b = op[1];
	
	assign load0 = !(op[2] | op[3]);
	assign load1 = !(!op[2] | op[3]); 
	assign load2 = !op[2] & op[3]; 
	assign load3 = (!cf_reg | op[0]) & op[2] & op[3];
	
	
	//データセレクタ
	data_selector ds (a_reg, b_reg, in, 4'b0000, select_a, select_b, selector_out);
	
	
	//ALU							
	assign {c, alu_out} = selector_out + im;
	
	
	//Carry Flag
	always @(posedge clk) begin
		if(n_reset == 1'b0 )
			cf_reg <= 0;
		else
			cf_reg <= c;
	end


endmodule