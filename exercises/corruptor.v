module corruptor(clock, valid, audio_in, audio_out, sw);
  input clock;
  input valid;
  input [23:0] audio_in;
  output [23:0] audio_out;
  reg [23:0] audio_out;
  input [7:0] sw;

  //Registers improve timing performance
  wire [23:0] delayed_a, delayed_b;
  reg signed [23:0] delayed_a_reg, delayed_b_reg;
  wire signed [32:0] mul_a, mul_b;
  wire signed [23:0] result;

  reg [11:0] counter;

  reg  [8:0] gain_a;
  wire [8:0] gain_b;
  wire signed [9:0] signed_gain_a, signed_gain_b;
  reg [12:0] delay_a, delay_b;
  wire [14:0] delay_a_shift, delay_b_shift;


  always @(*) begin
    if (counter[11:10] == 2'b00) begin //A
      gain_a <= 9'd511;
      delay_a <= 13'd255 - {{6{1'b0}}, counter[9:3]};
      delay_b <= 13'd383;
    end else if (counter[11:10] == 2'b01) begin //AB
      gain_a <= 9'd511 - counter[9:1];
      delay_a <= 13'd127 - {{6{1'b0}}, counter[9:3]};
      delay_b <= 13'd383 - {{6{1'b0}}, counter[9:3]};
    end else if (counter[11:10] == 2'b10) begin //B
      gain_a <= 9'd0;
      delay_a <= 13'd383;
      delay_b <= 13'd255 - {{6{1'b0}}, counter[9:3]};
    end else begin //BA
      gain_a <= counter[9:1];
      delay_a <= 13'd383 - {{6{1'b0}}, counter[9:3]};
      delay_b <= 13'd127 - {{6{1'b0}}, counter[9:3]};
    end;
  end

  assign gain_b = 9'd511 - gain_a;

  //Because of the sample rate difference to lab setup we need to shift delays left 2
  assign delay_a_shift = {sw[3] ? (13'd383 - delay_a) : (delay_a), 2'b10};
  assign delay_b_shift = {sw[3] ? (13'd383 - delay_b) : (delay_b), 2'b10};

  assign signed_gain_a = gain_a;
  assign signed_gain_b = gain_b;

  assign mul_a = signed_gain_a * delayed_a_reg;
  assign mul_b = signed_gain_b * delayed_b_reg;
  assign result = mul_a[32:9] + mul_b[32:9];

  always @(posedge clock) begin
    delayed_a_reg <= delayed_a;
    delayed_b_reg <= delayed_b;
    audio_out <= result;

    if(valid == 1'b1)
      counter <= counter + sw[2:0] + 1;
  end;

  variable_delay var_dly_a(
    .clock(clock),
    .valid(valid),
    .audio_in(audio_in),
    .audio_out(delayed_a),
    .delay_amount(delay_a)
  );

  variable_delay var_dly_b(
    .clock(clock),
    .valid(valid),
    .audio_in(audio_in),
    .audio_out(delayed_b),
    .delay_amount(delay_b)
  );
endmodule
