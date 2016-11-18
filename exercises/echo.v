module echo(clock, valid, audio_in, audio_out);
  input clock;
  input valid;
  input [23:0] audio_in;
  output [23:0] audio_out;
  reg [23:0] audio_out;
  wire [23:0] fifo_out;
  reg signed [24:0] xt, xdly, y;
  wire fifo_rden, fifo_full;
  reg valid_dly;
  reg [23:0] fifo_in;
  assign fifo_rden = valid & fifo_full;

  always@(posedge clock) begin
    //Registers to improve timing perfomance
    if(valid_dly == 1'b1) begin
      xt <= {audio_in[23], audio_in}; //just sign extend
      xdly <= {{3{fifo_out[23]}}, fifo_out[22:2]}; //sign extend and divide by 4
    end;
    if(valid == 1'b1) begin
      //saturate instead of overflowing
      /*if(y[24] != y[23])
        audio_out = {{y[24]},24'h000000};
      else
        audio_out = y[23:0];*/
      audio_out = y[24:1];
    end;
    //Delay FIFO inputs by 1 for correct behaviour
    valid_dly <= valid;
    fifo_in <= audio_in;
  end

  always@(*) begin
    y = xt + xdly;

  end

  audio_delay_fifo fifo (
    .clk(clock),
    .din(fifo_in),
    .wr_en(valid_dly),
    .rd_en(fifo_rden),
    .dout(fifo_out),
    .full(fifo_full)
  );
endmodule
