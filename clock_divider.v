module clock_divider(c_in,c_out);

input c_in;
output reg c_out;
   
parameter D = 25000000;
reg[31:0] count = 32'd0;

always @(posedge c_in) begin
    if (count >= D-1) begin
        count <= 32'd0;
        c_out  <= ~c_out;         
    end else begin
        count <= count + 32'd1;
    end
end

endmodule