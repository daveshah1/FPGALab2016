module variable_tone(clock, valid, audio_out, freq_set, freq_disp);
  input clock;
  input valid;
  output [23:0] audio_out;
  input [9:0] freq_set;
  output [34:0] freq_disp;

  reg [11:0] addr_counter;
  wire [9:0] rom_dout;
  wire [9:0] sample_2comp;

  wire [19:0] freq_disp_mul;
  wire [15:0] freq_disp_val;
  wire [19:0] freq_disp_bcd;
  always@(posedge clock) begin
    if (valid == 1'b1)
      addr_counter <= addr_counter + freq_set;
  end

  //Magic number is different to book as our sample frequency is 12kHz
  assign freq_disp_mul = freq_set * 10'h2EE;
  assign freq_disp_val = {2'b00, freq_disp_mul[19:6]};
  //Convert from offset to two's complement
  assign sample_2comp = rom_dout - 10'd512;
  //Extend to 24 bits
  assign audio_out = {sample_2comp, {14{sample_2comp[0]}}};

  sine_rom sine_rom_1 (
    .clka(clock),
    .addra(addr_counter[11:2]), //reduce sample rate by 4 by discarding 2 LSBs
    .douta(rom_dout)
  );

  bin2bcd_16 dec (
    .B(freq_disp_val),
    .BCD_0(freq_disp_bcd[03:00]),
    .BCD_1(freq_disp_bcd[07:04]),
    .BCD_2(freq_disp_bcd[11:08]),
    .BCD_3(freq_disp_bcd[15:12]),
    .BCD_4(freq_disp_bcd[19:16])
  );

  hex_to_7seg SEG0 (freq_disp[34:28], freq_disp_bcd[03:00]);
  hex_to_7seg SEG1 (freq_disp[27:21], freq_disp_bcd[07:04]);
  hex_to_7seg SEG2 (freq_disp[20:14], freq_disp_bcd[11:08]);
  hex_to_7seg SEG3 (freq_disp[13:07], freq_disp_bcd[15:12]);
  hex_to_7seg SEG4 (freq_disp[06:00], freq_disp_bcd[19:16]);

endmodule
