`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Michelle Patino && Natalie Martell
// Create Date:    08:22:41 04/25/2017 
// Design Name: 	 
// Module Name:    EELabFinal 
// Project Name: Washing machine using FMS
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module EELabFinal(
	//COIN PART
	 input clock,
    input coinIn,
	 output reg [2:0] coinState,
	 output reg [2:0] ourState,
	 output reg [3:0] washState,
	 output reg [3:0] nextWashState,	
	
    output reg [6:0] RSD,
    output reg [6:0] LSD,
	 //NORMAL WASH
	 input basicWash,
	 input normalWash,
	 input heavyWash,
	 output reg [3:0] LED,
	 input LID
//	
    );
	 
	 /***coin implementation***/
	 parameter
		c0 = 3'b000,
		c1 = 3'b001,
		c2 = 3'b010,
		c3 = 3'b011,
		c4 = 3'b100,
		c5 = 3'b101;
		
		

	 parameter
		w0 = 4'b0000,
		w1 = 4'b0001,
		w2 = 4'b0010,
		w3 = 4'b0011,
		w4 = 4'b0100,   
		w5 = 4'b0101,
		w6 = 4'b0110,
		w7 = 4'b0111,
		w8 = 4'b1000,
		w9 = 4'b1001;
		
	 always @ (posedge clock)
	 begin
		 ourState <= coinState;
	 end
	 
	 always @ (posedge clock)
	 begin
		 washState <= nextWashState;
	 end
	
		
	 always @ (*)
	 begin
		case(ourState)
			c0: begin coinState = c0; LSD = 7'b1111110; RSD = 7'b1111110; LED = 3'b000; nextWashState = w0;
				case (coinIn)  
					1:  coinState = c1;  
					0:  coinState = c0; 
				default:  begin coinState = c0; LSD = 7'b1111110; RSD = 7'b1111110; LED = 3'b000; end
				endcase
				end
			c1: begin coinState = c1; LSD = 7'b1101101; RSD = 7'b1011011; LED = 3'b000; nextWashState = w0;
				case (coinIn)  
					1:  coinState = c2;  
					0:  coinState = c1; 
				default:  begin coinState = c1; LSD = 7'b1101101; RSD = 7'b1011011; LED = 3'b000; end
				endcase
				end
			c2: begin coinState = c2; LSD = 7'b1011011; RSD = 7'b1111110; LED = 3'b000; nextWashState = w0;
					case(washState)
						w0: if(LID && basicWash) begin LSD = 7'b1111111; RSD = 7'b1111001; LED = 3'b111; nextWashState = w1; end
						w1: if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b100; nextWashState = w2; end//wash/detergent
						w2: if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b101; nextWashState = w3; end//wash/spin
						w3: if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b011; nextWashState = w4; end//rinse/spin
						w4: if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b001; nextWashState = w5; end//spin
						w5: begin coinState = c0; LED = 3'b000; end
						default: begin coinState = c0; end
					endcase
				case (coinIn)  
					1:  coinState = c3;  
					0:  begin if(nextWashState == w5) coinState = c0; else coinState = c2; end
				default: begin coinState = c2; LSD = 7'b1011011; RSD = 7'b1111110; LED = 3'b000; end
				endcase
				end
			c3: begin coinState = c3; LSD = 7'b1110000; RSD = 7'b1011011; LED = 3'b000; nextWashState = w0;
					case(washState)
						w0: if(LID && normalWash) begin LSD = 7'b1111111; RSD = 7'b1111001; LED = 3'b111; nextWashState = w1; end
							 else if(LID && basicWash) begin LSD = 7'b1111111; RSD = 7'b1111001; LED = 3'b111; nextWashState = w1; end
						w1: if(LID && normalWash) begin LSD = 7'b0010101; RSD = 7'b1111110; LED = 3'b100; nextWashState = w2; end//wash/detergent
							 else if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b100; nextWashState = w2; end//wash/detergent
						w2: if(LID && normalWash) begin LSD = 7'b0010101; RSD = 7'b1111110; LED = 3'b101; nextWashState = w3; end//wash/spin
							 else if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b101; nextWashState = w3; end//wash/spin
						w3: if(LID && normalWash) begin LSD = 7'b0010101; RSD = 7'b1111110; LED = 3'b010; nextWashState = w4; end//rinse
							 else if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b010; nextWashState = w5; end//rinse
						w4: if(LID && normalWash) begin LSD = 7'b0010101; RSD = 7'b1111110; LED = 3'b011; nextWashState = w5; end//rinse/spin
							 else if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b011; nextWashState = w5; end//rinse/spin
						w5: if(LID && normalWash) begin LSD = 7'b0010101; RSD = 7'b1111110; LED = 3'b001; nextWashState = w6; end//spin
							 else if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b001; nextWashState = w6; end//spin
						w6: begin coinState = c0; LED = 3'b000; end
						default: begin coinState = c0; end
					endcase
				
				case (coinIn)  
					1:  coinState = c4;  
					0:   if(nextWashState == w6) begin 
							if(basicWash) coinState = c1;
							else coinState = c0;
					
					
					end
				default: begin coinState = c3; LSD = 7'b1110000; RSD = 7'b1011011; LED = 3'b000; end
				endcase
				end
			c4: begin coinState = c4; LSD = 7'b0110000; RSD = 7'b1111110; LED = 3'b000; nextWashState = w0;
					case(washState)
						w0: if(heavyWash && LID) begin LSD = 7'b1111111; RSD = 7'b1111001; LED = 3'b111; nextWashState = w1; end
							 else if(LID && normalWash) begin LSD = 7'b1111111; RSD = 7'b1111001; LED = 3'b111; nextWashState = w1; end//normal c3
							 else if(LID && basicWash) begin LSD = 7'b1111111; RSD = 7'b1111001; LED = 3'b111; nextWashState = w1; end//basic c2
							 
						w1: if(heavyWash && LID) begin LSD = 7'b0110111; RSD = 7'b0111011; LED = 3'b100; nextWashState = w2; end//wash/detergent
							 else if(LID && normalWash) begin LSD = 7'b0010101; RSD = 7'b1111110; LED = 3'b100; nextWashState = w2; end//wash/detergent
							 else if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b100; nextWashState = w2; end//wash/detergent
						
						w2: if(heavyWash && LID) begin LSD = 7'b0110111; RSD = 7'b0111011; LED = 3'b101; nextWashState = w3; end//wash/spin
							 else if(LID && normalWash) begin LSD = 7'b0010101; RSD = 7'b1111110; LED = 3'b101; nextWashState = w6; end//wash/spin
							 else if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b101; nextWashState = w6; end//wash/spin
						
						w3: if(heavyWash && LID) begin LSD = 7'b0110111; RSD = 7'b0111011; LED = 3'b100; nextWashState = w4; end//wash/detergent
						w4: if(heavyWash && LID) begin LSD = 7'b0110111; RSD = 7'b0111011; LED = 3'b101; nextWashState = w5; end//wash/spin	
						w5: if(heavyWash && LID) begin LSD = 7'b0110111; RSD = 7'b0111011; LED = 3'b010; nextWashState = w6; end//rinse/soft
							 else if(LID && normalWash) begin LSD = 7'b0010101; RSD = 7'b1111110; LED = 3'b010; nextWashState = w6; end//rinse
							 else if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b010; nextWashState = w7; end//rinse
						
						w6: if(heavyWash && LID) begin LSD = 7'b0110111; RSD = 7'b0111011; LED = 3'b011; nextWashState = w7; end//rinse/spin
							 else if(LID && normalWash) begin LSD = 7'b0010101; RSD = 7'b1111110; LED = 3'b011; nextWashState = w7; end//rinse/spin
							 else if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b011; nextWashState = w7; end//rinse/spin
						
						w7: if(heavyWash && LID) begin LSD = 7'b0110111; RSD = 7'b0111011; LED = 3'b001; nextWashState = w8; end//spin
							 else if(LID && normalWash) begin LSD = 7'b0010101; RSD = 7'b1111110; LED = 3'b001; nextWashState = w8; end//spin
							 else if(LID && basicWash) begin LSD = 7'b0011111; RSD = 7'b0001101; LED = 3'b001; nextWashState = w8; end//spin
						
						w8: begin LED = 3'b000; coinState = c0; end
						default: begin coinState = c0; end
					endcase
				case (coinIn)  
					1:  coinState = c4; 
					0:  if(nextWashState == w8) begin
							if(heavyWash) coinState = c0; 
							else if (normalWash)coinState = c1; 
							else if (basicWash) coinState = c2;
						 end
				default: begin coinState = c4; LSD = 7'b0110000; RSD = 7'b1111110; LED = 3'b000; end
				endcase
				end
			
			default: begin coinState = c0; LSD = 7'b1111110; RSD = 7'b1111110; LED = 3'b000; end
			endcase
			
	 end

 
endmodule 