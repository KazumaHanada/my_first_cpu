//CPUの創り方p272
//I/Oポートの追加
module cpu(
	
	input clk,
	
	input n_reset,
	
	input [7:0] instr,      //プログラムメモリからの入力線
	
	output [3:0] address,   //プログラムメモリへの出力線
	
	input [3:0] in, 		//入力ポート
	
	output [3:0] out 		//出力ポート
	
	//input select_a, 回路の内部へ
	
	//input select_b, 回路の内部へ
	
	//input load0,    回路の内部へ
	
	//input load1,    回路の内部へ
	
	//input load2,    回路の内部へ
	
	//load3を回路の内部へ
	
	//imへの入力はプログラムメモリからの入力線 下位4bit(instr[3:0])に変更
	
	//output [3:0] tmp_out 削除
	
	);
	
	
	wire load0;					//回路の内部へ
	wire load1;					//回路の内部へ
	wire load2;					//回路の内部へ
	wire load3;					//回路の内部へ
	
	reg [3:0] a_reg;
	reg [3:0] b_reg;
	reg [3:0] out_reg;		 	//Cレジスタの出力を出力ポートにする
	reg [3:0] pc_reg;			//DレジスタをPCにする
	
	wire select_a;				//回路の内部へ
	wire select_b;				//回路の内部へ
	wire [3:0] selector_out;
	
	wire [3:0] op;				 //プログラムメモリから読み取った上位4bitを命令デコーダに送る配線
	wire [3:0] im; 			     //読み出した命令の下位4bitをALUに送る配線
	wire [3:0] alu_out;  	     //ALUの出力線
	
	reg cf_reg;					 //Carry Outの値を保存するCarry Flag
	wire c;						 //Carry Out用の配線
	
	
  
  
	always @(posedge clk) begin
		
		if(n_reset == 1'b0 ) begin
			a_reg   <= 0;
			b_reg   <= 0;
			//Cレジスタの出力を出力ポートにする
			out_reg <= 0; 
			pc_reg  <= 0;
			//n_resetの立下りでキャリーの値をクリア
			cf_reg <= 0;
		end
		else begin
			//ALUの出力をレジスタにロードできるようにする
			a_reg   <= load0 ? alu_out : a_reg;
			b_reg   <= load1 ? alu_out : b_reg;
			//Cレジスタの出力を出力ポートにする
			out_reg <= load2 ? alu_out : out_reg;
			//load3 = 0 なにもしない
			//load3 = 1 imをPCへロード 条件ジャンプする
			pc_reg <= load3 ? im : pc_reg + 1;
			//クロックの立ち上がりでキャリーの値を保存
			cf_reg <= c;
		end
	
	end
	
	
	//Cレジスタの出力を出力ポートにする
	assign out	= out_reg;
	
	
	//PCの値をプログラムメモリに出力
	assign address = pc_reg;
	
	
	//Cレジスタの出力のかわりに、入力ポートをデータセレクタにつなげる
	data_selector ds (a_reg, b_reg, in, 4'b0000, select_a, select_b, selector_out);
	
	
	//ALU 連接演算でCarry Outした値を送る
	assign {c, alu_out} = selector_out + im;
	
	
	//命令をオペレーションコードとイメディエイトデータへ分割
	assign op = instr[7:4]; //オペレーションコード
	assign im = instr[3:0]; //イメディエイトデータ
	
	
	// データセレクタ制御フラグ
	assign select_a = op[0] | op[3];
	assign select_b = op[1];
	
	
	// ロードレジスタ制御フラグ
	assign load0 = !(op[2] | op[3]); 				  // Aレジスタへロード
	assign load1 = !(!op[2] | op[3]); 				  // Bレジスタへロード
	assign load2 = !op[2] & op[3]; 					  // 出力ポートへロード
	assign load3 = (!cf_reg | op[0]) & op[2] & op[3]; // PCへロード
	

endmodule