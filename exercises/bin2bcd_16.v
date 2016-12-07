//------------------------------
// Module name: bin2bcd_16
// Function: Converts a 16-bit binary number to 5 digits BCD
//            .... it uses a shift-and-add3 algorithm
// Creator:  Peter Cheung
// Version:  2.0  (Correct mistake - problem with numbers 0x5000 or larger)
// Date:     24 Nov 2016
//------------------------------
//   For more explanation of how this work, see 
//     ... instructions on wwww.ee.ic.ac.uk/pcheung/teaching/E2_experiment

module bin2bcd_16 (B, BCD_0, BCD_1, BCD_2, BCD_3, BCD_4);

	input [15:0]	B;		// binary input number
	output [3:0]	BCD_0, BCD_1, BCD_2, BCD_3, BCD_4;   // BCD digit LSD to MSD
	
	wire [3:0]	w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13;
	wire [3:0]	w14,w15,w16,w17,w18,w19,w20,w21,w22,w23,w24,w25;
	wire [3:0]	w26,w27,w28,w29,w30,w31,w32,w33,w34,w35;
	wire [3:0]	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13;
	wire [3:0]	a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25;
	wire [3:0]	a26,a27,a28,a29,a30,a31,a32,a33,a34,a35;

	// Instantiate a tree of add3-if-greater than or equal to 5 cells
	//  ... input is w_n, and output is a_n
	add3_ge5 A1 (w1,a1);
	add3_ge5 A2 (w2,a2);
	add3_ge5 A3 (w3,a3);
	add3_ge5 A4 (w4,a4);
	add3_ge5 A5 (w5,a5);
	add3_ge5 A6 (w6,a6);
	add3_ge5 A7 (w7,a7);
	add3_ge5 A8 (w8,a8);
	add3_ge5 A9 (w9,a9);
	add3_ge5 A10 (w10,a10);
	add3_ge5 A11 (w11,a11);
	add3_ge5 A12 (w12,a12);
	add3_ge5 A13 (w13,a13);
	add3_ge5 A14 (w14,a14);
	add3_ge5 A15 (w15,a15);
	add3_ge5 A16 (w16,a16);
	add3_ge5 A17 (w17,a17);
	add3_ge5 A18 (w18,a18);
	add3_ge5 A19 (w19,a19);
	add3_ge5 A20 (w20,a20);
	add3_ge5 A21 (w21,a21);
	add3_ge5 A22 (w22,a22);
	add3_ge5 A23 (w23,a23);
	add3_ge5 A24 (w24,a24);
	add3_ge5 A25 (w25,a25);
	add3_ge5 A26 (w26,a26);
	add3_ge5 A27 (w27,a27);
	add3_ge5 A28 (w28,a28);
	add3_ge5 A29 (w29,a29);
	add3_ge5 A30 (w30,a30);
	add3_ge5 A31 (w31,a31);
	add3_ge5 A32 (w32,a32);
	add3_ge5 A33 (w33,a33);
	add3_ge5 A34 (w34,a34);
	add3_ge5 A35 (w35,a35);
		
	// wire the tree of add3 modules together
	assign  w1 = {1'b0,B[15:13]};		// w_n is the input port to module a_n
	assign  w2 = {a1[2:0], B[12]};		
	assign  w3 = {a2[2:0], B[11]};		
	assign  w4 = {1'b0,a1[3],a2[3],a3[3]};
	assign  w5 = {a3[2:0], B[10]};
	assign  w6 = {a4[2:0], a5[3]};
	assign  w7 = {a5[2:0], B[9]};
	assign  w8 = {a6[2:0], a7[3]};
	assign  w9 = {a7[2:0], B[8]};
	assign  w10 = {1'b0, a4[3], a6[3], a8[3]};
	assign  w11 = {a8[2:0], a9[3]};
	assign  w12 = {a9[2:0], B[7]};
	assign  w13 = {a10[2:0], a11[3]};
	assign  w14 = {a11[2:0], a12[3]};
	assign  w15 = {a12[2:0], B[6]};
	assign  w16 = {a13[2:0], a14[3]};
	assign  w17 = {a14[2:0], a15[3]};
	assign  w18 = {a15[2:0], B[5]};
	assign  w19 = {1'b0, a10[3], a13[3], a16[3]};
	assign  w20 = {a16[2:0], a17[3]};
	assign  w21 = {a17[2:0], a18[3]};
	assign  w22 = {a18[2:0], B[4]};
	assign  w23 = {a19[2:0], a20[3]};
	assign  w24 = {a20[2:0], a21[3]};
	assign  w25 = {a21[2:0], a22[3]};
	assign  w26 = {a22[2:0], B[3]};
	assign  w27 = {a23[2:0], a24[3]};
	assign  w28 = {a24[2:0], a25[3]};
	assign  w29 = {a25[2:0], a26[3]};
	assign  w30 = {a26[2:0], B[2]};
	assign  w31 = {1'b0,a19[3], a23[3], a27[3]};
	assign  w32 = {a27[2:0], a28[3]};
	assign  w33 = {a28[2:0], a29[3]};
	assign  w34 = {a29[2:0], a30[3]};
	assign  w35 = {a30[2:0], B[1]};
	
	// connect up to four BCD digit outputs	
	assign BCD_0 = {a35[2:0],B[0]};
	assign BCD_1 = {a34[2:0],a35[3]};
	assign BCD_2 = {a33[2:0],a34[3]};
	assign BCD_3 = {a32[2:0],a33[3]};
	assign BCD_4 = {a31[2:0],a32[3]};	
endmodule

	
	

