module variable_delay(clock, valid, audio_in, audio_out, delay_amount);
  input clock;
  input valid;
  input [23:0] audio_in;
  output [23:0] audio_out;
  input [14:0] delay_amount;

  reg [14:0] rd_addr;
  wire [14:0] wr_addr;

  wire [17:0] ram_d, ram_q;

  //Convert to/from 18-bit to save memory; quality loss is unlikely to be noticeable
  assign ram_d = audio_in[23:6];
  assign audio_out = {ram_q, {6{ram_q[0]}}};

  always@(posedge clock) begin
    if (valid == 1'b1)
      rd_addr <= rd_addr + 1;
  end

  assign wr_addr = rd_addr + delay_amount;

  delay_ram delay_ram_1 (
    .clka(clock),
    .wea(valid),
    .addra(wr_addr),
    .dina(ram_d),
    .clkb(clock),
    .addrb(rd_addr),
    .doutb(ram_q)
  );

endmodule
