`include "../parameter/global_parameter.v"


module System_FIFO_64(
								clk,
								rst,
								rst_user,
								before_enaread,
								before_enawrite,
								cin,
								cout
							  );
							  
input clk;
input rst;
input rst_user;
input before_enawrite;
input before_enaread;
input [63:0] cin;
output [63:0] cout;
reg [63:0] cout;
wire ena_read,ena_write;
wire [63:0] cout1;
wire [3:0] usedw;
wire empty_sig,full_sig;
reg ena;
wire before_enaread1;

generate_ena #(`N_WindTurbine ) generate_ena1  (
						.clk(clk),
						.rst(rst),
						.d(before_enaread),
						.q(ena_read)
					  );
generate_ena_write #(`N_WindTurbine ) generate_ena2  (
						.clk(clk),
						.rst(rst),
						.rst_user(rst_user),
						.d(before_enawrite),
						.q(ena_write)
					  );					  
					  					  
FIFO64	FIFO10 (
	.clock ( clk ),
	.data ( cin ),
	.rdreq ( ena_read ),
	.wrreq ( ena_write ),
	.empty ( empty_sig ),
	.full ( full_sig ),
	.q ( cout1 ),
	.usedw ( usedw )
	);
	
DELAY_1CLK  #(1) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(before_enaread),
											.q(before_enaread1)
										  );
										  
always@ (posedge clk or posedge rst) begin
	if(rst) begin
		ena <= 1'b0;
	end
	else if(before_enaread1) begin
		ena <= 1'b1;
	end
end


always@ (posedge clk or posedge rst) begin
	if(rst) begin
		cout <= 1'b0;
	end
	else if(ena) begin
		cout <= cout1;
	end
end

endmodule
