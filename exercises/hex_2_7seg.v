//Hex to 7-segment from the lab book

module hex_to_7seg(seg_out,hex_in);

  output [6:0] seg_out;
  input [3:0] hex_in;

  reg [6:0] seg_out;
  always @(*)
    case(hex_in)
      4'h0: seg_out = 7'b1000000;
      4'h1: seg_out = 7'b1111001;
      4'h2: seg_out = 7'b0100100;
      4'h3: seg_out = 7'b0110000;
      4'h4: seg_out = 7'b0011001;
      4'h5: seg_out = 7'b0010010;
      4'h6: seg_out = 7'b0000010;
      4'h7: seg_out = 7'b1111000;
      4'h8: seg_out = 7'b0000000;
      4'h9: seg_out = 7'b0011000;
      4'ha: seg_out = 7'b00001000;
      4'hb: seg_out = 7'b0000011;
      4'hc: seg_out = 7'b1000110;
      4'hd: seg_out = 7'b0100001;
      4'he: seg_out = 7'b0000110;
      4'hf: seg_out = 7'b0001110;
    endcase
endmodule
