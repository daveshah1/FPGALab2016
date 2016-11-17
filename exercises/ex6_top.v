module ex6_top(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4);
  input CLOCK_50;
  input [3:0] KEY;
  input [7:0] SW;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4;
  wire tick, count_en;
  wire [15:0] count;
  wire [3:0] BCD0, BCD1, BCD2, BCD3, BCD4;
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4;

  div_50000  CLKDIV (CLOCK_50, tick);

  assign count_en = tick & (~KEY[0]);

  counter_16 COUNT15 (CLOCK_50, KEY[1], count_en, count);

  bin2bcd_16 B2BCD (count, BCD0, BCD1, BCD2, BCD3, BCD4);

  hex_to_7seg SEG0 (HEX0, BCD0);
  hex_to_7seg SEG1 (HEX1, BCD1);
  hex_to_7seg SEG2 (HEX2, BCD2);
  hex_to_7seg SEG3 (HEX3, BCD3);
  hex_to_7seg SEG4 (HEX4, BCD4);

endmodule
