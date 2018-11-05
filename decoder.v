module decoder(

	input [3:0] port_out, 
	
	output reg[6:0] hex3,
	
	output reg[6:0] hex2,
	
	output reg[6:0] hex1,
	
	output reg[6:0] hex0
	
);
	
	
	always @(*) begin
	
		case(port_out)
		
			4'b0111:
			begin
						hex3 <= 7'b1000000;
						hex2 <= 7'b1111001;
						hex1 <= 7'b1111001;
						hex0 <= 7'b1111001;
			end
			
			4'b0110:
			begin
						hex3 <= 7'b1000000;
						hex2 <= 7'b1111001;
						hex1 <= 7'b1111001;
						hex0 <= 7'b1000000;
			end
			
			4'b0100:
			begin
						hex3 <= 7'b1000000;
						hex2 <= 7'b1111001;
						hex1 <= 7'b1000000;
						hex0 <= 7'b1000000;
			end
			
			4'b0000:
			begin
						hex3 <= 7'b1000000;
						hex2 <= 7'b1000000;
						hex1 <= 7'b1000000;
						hex0 <= 7'b1000000;
			end
			
			4'b1000:
			begin
						hex3 <= 7'b1111001;
						hex2 <= 7'b1000000;
						hex1 <= 7'b1000000;
						hex0 <= 7'b1000000;
			end
			
			default:
			begin
						hex3 <= 7'b1111111;
						hex2 <= 7'b1111111;
						hex1 <= 7'b1111111;
						hex0 <= 7'b1111111;
			end
			
		endcase
	
	end
	
endmodule