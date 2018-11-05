module data_selector(
	
	input [3:0] c0,
	
	input [3:0] c1,
	
	input [3:0] c2,
	
	input [3:0] c3,
	
	input select_a, select_b,
	
	output reg [3:0] y
	
);
	
	
	always @(*) begin
		
		// * (select_a = H, select_b = H) => c3を出力
		if (select_a & select_b)
			
			y = c3;
		
		// * (select_a = L, select_b = H) => c2を出力
		else if (!select_a & select_b)
			
			y = c2;
		
		// * (select_a = H, select_b = L) => c1を出力
		else if (select_a & !select_b)
			
			y = c1;
		
		// * (select_a = L, select_b = L) => c0を出力
		else
			
			y = c0;
	
	end


endmodule