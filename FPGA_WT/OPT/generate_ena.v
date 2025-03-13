module generate_ena(
						clk,
						rst,
						d,
						q
					  );
 
parameter n = 32'd1;
 
input  clk;
input  rst;
input  d;
output q;
 
reg  r;
reg  [31:0] m;
assign q = r;
 
always@(posedge clk or posedge rst) begin
  if (rst) begin
    r <= 0;
	 m <= 0;
	 end
  else if((d==1)&&(m==0)) begin
    r <= 1;
    m <= m+1;
	 end
  else if((m!=0)&&(m<n)) begin
    r <= 1;
    m <= m+1;
	 end
  else if(m>=n) begin
    r <= 0;
    m <= 0; 
	 end
end
 
endmodule


