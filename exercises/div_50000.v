module div_50000(clock, ce_out);
  parameter COUNT_MAX = 50000;
  input clock;
  output ce_out;
  reg[15:0] count;
  reg ce_out;

  initial count = 0;

  always @ (posedge clock)
    if (count == COUNT_MAX - 1) begin
      count <= 16'h0000;
      ce_out <= 1;
     end else begin
      count <= count + 1'b1;
      ce_out <= 0;
     end;
endmodule
