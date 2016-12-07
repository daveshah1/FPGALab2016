module fixed_tone(clock, valid, audio_out);
  input clock;
  input valid;
  output [23:0] audio_out;
  reg [11:0] addr_counter;
  wire [9:0] rom_dout;
  wire [9:0] sample_2comp;

  always@(posedge clock) begin
    if (valid == 1'b1)
      addr_counter <= addr_counter + 1;
  end

  //Convert from offset to two's complement
  assign sample_2comp = rom_dout - 10'd512;
  //Extend to 24 bits
  assign audio_out = {sample_2comp, {14{sample_2comp[0]}}};

  sine_rom sine_rom_1 (
    .clka(clock),
    .addra(addr_counter[11:2]), //reduce sample rate by 4 by discarding 2 LSBs
    .douta(rom_dout)
  );
endmodule
