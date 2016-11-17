module counter_16(clock,
                  reset_n,
                  enable,
                  count);
  parameter BIT_SZ = 16;
  input clock;
  input reset_n;
  input enable;
  output [BIT_SZ-1:0] count;

  reg[BIT_SZ-1:0] count;

  initial count = 0;

  always @ (posedge clock)
    if (reset_n == 1'b0)
      count <= 0;
    else if(enable == 1'b1)
      count <= count + 1'b1;
endmodule
