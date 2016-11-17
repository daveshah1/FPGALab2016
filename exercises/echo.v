module echo(clock, valid, audio_in, audio_out)
  input clock;
  input valid;
  input [23:0] audio_in;
  output [23:0] audio_out;
  reg [23:0] audio_out;
  wire [23:0] fifo_in, fifo_out;
  wire signed [24:0] xt, xdly, y;
  wire fifo_wren, fifo_rden, fifo_full;

  assign fifo_rden = valid & fifo_full;
  assign fifo_wren = valid;
  assign fifo_in = audio_in;

  always@(posedge clock) begin
    //Registers to improve timing perfomance
    xt <= {audio_in[23], audio_in}; //just sign extend
    xdly <= {2{fifo_out[23]}, fifo_out[22:1]}; //sign extend and divide by 2
  end

  always@(*) begin
    y = xt + xdly;
    //saturate instead of overflowing
    if(y[24] != y[23])
      audio_out = 24{y[24]};
    else
      audio_out = y[23:0];
  end

  audio_delay_fifo fifo (
    .clk(clock),
    .din(fifo_in),
    .wr_en(fifo_wren),
    .rd_en(fifo_rden),
    .dout(fifo_out),
    .full(fifo_full)
  );
endmodule
