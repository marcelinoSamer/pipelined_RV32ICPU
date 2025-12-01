`timescale 1ns / 1ps

module shifter #(
    parameter N = 32
)(
    input  [N-1:0] a,
    input  [4:0] shamt,               // 0 -> shift by 20, 1 -> shift by 1
    input  [1:0] type,
    output  [N-1:0] r
);
            assign r = (type == 2'b00) ? a >> shamt :
             (type == 2'b10) ? $signed(a) >>> shamt :
             (type == 2'b01) ? a << shamt :
             32'b0;
  
endmodule

