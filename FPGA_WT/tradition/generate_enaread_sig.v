module generate_enaread_sig(
						clk,
						rst,
						sta,
						ena_read4,
						ena_read8,
						ena_read12
					  );
 
parameter n = 32'd1;
input  clk;
input  rst;
input  sta;
output ena_read4,ena_read8,ena_read12;
reg  d; 
reg  r;
reg  [2:0] m;
reg  [31:0] count;
reg  [31:0] counta;
wire g;

always@(posedge clk or posedge rst) begin
  if (rst) begin
    d <= 0;
	 count <= 0;
	 counta <= 0;
	 end
  else if((sta==1)) begin
	 count <= count + 1;
	 counta <= counta + 1;
    end
  else if(((count==32'd12)||(count==32'd24)||(count==32'd36)||(count==32'd48)||(count==32'd60)||(count==32'd72)||(count==32'd84)||(count==32'd96)||(count==32'd108)||(count==32'd120)||(count==32'd132)||(count==32'd144)||(count==32'd156)||(count==32'd168)||(count==32'd180)||(count==32'd192)||(count==32'd204)||(count==32'd216)||(count==32'd228)||(count==32'd240)||(count==32'd252)||(count==32'd264)||(count==32'd276)||(count==32'd288)||(count==32'd300)||(count==32'd312))&&(counta <= n)) begin
    d <= 0;
	 count <= count+1;
    end
  else if(((count==32'd11)||(count==32'd23)||(count==32'd35)||(count==32'd47)||(count==32'd59)||(count==32'd71)||(count==32'd83)||(count==32'd95)||(count==32'd107)||(count==32'd119)||(count==32'd131)||(count==32'd143)||(count==32'd155)||(count==32'd167)||(count==32'd179)||(count==32'd191)||(count==32'd203)||(count==32'd215)||(count==32'd227)||(count==32'd239)||(count==32'd251)||(count==32'd263)||(count==32'd275)||(count==32'd287)||(count==32'd299)||(count==32'd311))&&(counta < n)) begin
    d <= 1;
	 counta <= counta + 1;
	 count <= count + 1;
    end
  else if(count!= 0)
	 count <= count + 1;    	
end

assign g = sta || d;
	
always@(posedge clk or posedge rst) begin
  if (rst) begin
    r <= 0;
	 m <= 0;
	 end
  else if((g==1)&&(m==0)) begin
    r <= 1;
    m <= m+1;
	 end
  else if((m!=0)&&(m<3'd4)) begin
    r <= 1;
    m <= m+1;
	 end
  else if(m>=3'd4) begin
    r <= 0;
    m <= 0; 
	 end
end

assign ena_read4 = r;

DELAY_1CLK #(4) DELAY_1(
						.clk(clk),
						.rst(rst),
						.d(ena_read4),
						.q(ena_read8)
					  );
					  
DELAY_1CLK #(4) DELAY_2(
						.clk(clk),
						.rst(rst),
						.d(ena_read8),
						.q(ena_read12)
					  );


endmodule


