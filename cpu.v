//CPUの創り方p220
//条件ジャンプ命令を実行できる回路を作成
module cpu(
	
	input clk,
	
	input n_reset,
	
	input [7:0] instr,      //プログラムメモリからの入力線
	
	output [3:0] address,   //プログラムメモリへの出力線
	
	input select_a, 	    //便宜的に入力線にする
	
	input select_b, 	    //便宜的に入力線にする
	
	input load0, 		    //便宜的に入力線にする
	
	input load1, 		    //便宜的に入力線にする
	
	input load2, 		    //便宜的に入力線にする
	
	//load3を回路の内部に
	
	//imへの入力はプログラムメモリからの入力線 下位4bit(instr[3:0])に変更

	output [3:0] tmp_out //便宜的に出力線にする
	
	);
	
	
	reg [3:0] a_reg;
	reg [3:0] b_reg;
	reg [3:0] c_reg;
	reg [3:0] pc_reg;			//DレジスタをPCにする
	
	wire [3:0] selector_out;
	wire [3:0] im; 			    //読み出した命令の下位4bitをALUに送る配線
	
	wire [3:0] alu_out;  	    //ALUの出力線
	
	reg cf_reg;					//Carry Outの値を保存するCarry Flag
	wire c;						//Carry Out用の配線
	
	wire load3;                 //load3を回路の内部に
	
	
	always @(posedge clk) begin
		
		if(n_reset == 1'b0 ) begin
			a_reg  <= 0;
			b_reg  <= 0;
			c_reg  <= 0;
			pc_reg <= 0;
			//n_resetの立下りでキャリーの値をクリア
			cf_reg <= 0;
		end
		else begin
			//ALUの出力をレジスタにロードできるようにする
			a_reg  <= load0 ? alu_out : a_reg;
			b_reg  <= load1 ? alu_out : b_reg;
			c_reg  <= load2 ? alu_out : c_reg;
			//load3 = 0 なにもしない
			//load3 = 1 imをPCへロード 条件ジャンプする
			pc_reg <= load3 ? im : pc_reg + 1;
			//クロックの立ち上がりでキャリーの値を保存
			cf_reg <= c;
		end
	
	end
	
	
	//PCの値をプログラムメモリに出力
	assign address = pc_reg;
	
	
	//cf_reg = 1 ⇒ load3 = 0 となり なにもしない
	//cf_reg = 0 ⇒ load3 = 1 となり imをPCへロード、条件ジャンプする
	assign load3	= cf_reg ? 0 : 1;
	
	
	//Dレジスタの出力線を切断し、0000に固定
	data_selector ds (a_reg, b_reg, c_reg, 4'b0000, select_a, select_b, selector_out);
	
	
	//ALU 連接演算でCarry Outした値を送る
	assign {c, alu_out} = selector_out + im;
	
	
	//読み出した命令の下位4bitをimに送る
	assign im = instr[3:0]; 
	
	
	//便宜的に出力線につなぐ
	assign tmp_out = selector_out;


endmodule