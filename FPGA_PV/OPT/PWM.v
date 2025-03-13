`include "../parameter/Global_parameter.v"

module PWM(
				clk,
				rst,
				rst_user,
				sta,
				sta_user,

				triangle_out,
				done_sig
			  );
			  
parameter INI_STATE = 3'b001;
parameter count_max = 26;
parameter count_min = 1;
parameter INI_COUNT = 32'd0;
parameter count_max_inv = 32'h3d1d89d9;//0.008,Amplitude of trangle

parameter IDLE        = 3'b000;
parameter STATE_I     = 3'b001;
parameter STATE_II    = 3'b010;
parameter STATE_III   = 3'b011;
parameter STATE_IV    = 3'b100;
			  
input clk;
input rst;
input rst_user;
input sta;
input sta_user;

reg[2:0] curr_state;
reg[2:0] next_state;

reg [31:0] count_integer;
wire [31:0] count_float;

output [31:0] triangle_out;
reg [31:0] triangle_out_Amplitude;

reg end_STATE_I;
reg end_STATE_II;
reg end_STATE_III;
reg end_STATE_IV;

output done_sig;

DELAY_1CLK  #(11) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );

always@(posedge clk or posedge rst_user) begin
	if (rst_user) curr_state <= IDLE;
	else     curr_state <= next_state;
end

always@(*) begin
	case (curr_state)	
		IDLE         : if(sta_user)		          		next_state = INI_STATE;
					      else				      				next_state = IDLE;
		STATE_I      : if(end_STATE_I)  	   				next_state = STATE_II;
						   else 										next_state = STATE_I;
		STATE_II     : if(end_STATE_II)						next_state = STATE_III;
						   else          							next_state = STATE_II;
		STATE_III    : if(end_STATE_III)						next_state = STATE_IV;
						   else				   					next_state = STATE_III;
		STATE_IV     : if(end_STATE_IV)						next_state = STATE_I;
						   else				   					next_state = STATE_IV;
		default      :               							next_state = IDLE;
	endcase
end

always @(posedge clk or posedge rst_user) begin
	if(rst_user) begin
	   count_integer <= 32'b0;
		end_STATE_I <= 1'b0;
		end_STATE_II <= 1'b0;
		end_STATE_III <= 1'b0;
		end_STATE_IV <= 1'b0;
	end
	else if(sta_user) begin
		count_integer <= INI_COUNT;
		end_STATE_I <= 1'b0;
		end_STATE_II <= 1'b0;
		end_STATE_III <= 1'b0;
		end_STATE_IV <= 1'b0;
	end
	else if(sta) begin
	   case (curr_state)
		
		   3'b001 : begin
			   if(count_integer == count_max) begin
					count_integer <= count_integer + 1'b1;
				   end_STATE_I <= 1'b1;
				end
			   else begin
				   count_integer <= count_integer + 1'b1;
					end_STATE_I <= 1'b0;
					end_STATE_IV <= 1'b0;
				end
			end
			
		   3'b010 : begin
			   if(count_integer == count_min) begin
					count_integer <= count_integer - 1'b1;
				   end_STATE_II <= 1'b1;
				end
			   else begin
				   count_integer <= count_integer - 1'b1;
					end_STATE_II <= 1'b0;
					end_STATE_I <= 1'b0;
				end
			end
			
			3'b011 : begin
			   if(count_integer == count_max) begin
					count_integer <= count_integer + 1'b1;
				   end_STATE_III <= 1'b1;
				end
			   else begin
				   count_integer <= count_integer + 1'b1;
					end_STATE_III <= 1'b0;
					end_STATE_II <= 1'b0;
				end
			end
			
			3'b100 : begin
			   if(count_integer == count_min) begin
					count_integer <= count_integer - 1'b1;
				   end_STATE_IV <= 1'b1;
				end
			   else begin
				   count_integer <= count_integer - 1'b1;
					end_STATE_IV <= 1'b0;
					end_STATE_III <= 1'b0;
				end
			end
			
			3'b000 : begin
					count_integer <= 1'b0;
					end_STATE_I <= 1'b0;
					end_STATE_II <= 1'b0;
					end_STATE_III <= 1'b0;
					end_STATE_IV <= 1'b0;
				end
			
	   endcase
   end	
end

always @(posedge clk or posedge rst) begin
   if(rst) begin
	   triangle_out_Amplitude <= 1'b0;
	end
	else if(curr_state == STATE_I || curr_state == STATE_II) begin
		triangle_out_Amplitude <= count_max_inv;
	end
	else if(curr_state == STATE_III || curr_state == STATE_IV) begin
	   triangle_out_Amplitude <= {~count_max_inv[31],count_max_inv[30:23],count_max_inv[22:0]};
	end
	else begin
		triangle_out_Amplitude <= 1'b0;
	end
end

INTEGER2FLOAT	INTEGER2FLOAT(
	                          .aclr(rst),
	                          .clk_en(`ena_math),
	                          .clock(clk),
	                          .dataa(count_integer),
	                          .result(count_float)
	                         );

Multiplier_nodsp	Multiplier_triangle_out(
													   .aclr(rst),
													   .clk_en(`ena_math),
													   .clock(clk),
													   .dataa(triangle_out_Amplitude),
													   .datab(count_float),
													   .result(triangle_out)
													  );

endmodule


