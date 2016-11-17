module add3_ge5(xin, yout);

  output [3:0] yout;
  input [3:0] xin;
  reg [3:0] yout;

  always @(*)
    if (xin > 12)
      yout = 0;
    else if (xin >= 5)
      yout = xin + 4'h3;
    else
      yout = xin;
endmodule
