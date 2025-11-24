`timescale 1ns / 1ps

module shifter #(
    parameter N = 32
)(
    input  [N-1:0] a,
    input  [4:0] shamt,               // 0 -> shift by 20, 1 -> shift by 1
    input  [1:0] type,
    output reg [N-1:0] r
);
    always @* begin
        case (type)
            2'b00: begin // Logical left shift
                r = a << shamt;
            end
            2'b01: begin // Logical right shift
                r = a >> shamt;
            end
            2'b10: begin // Arithmetic right shift
                r = $signed(a) >>> shamt;
            end
            default: r = a; // Safe default
        endcase
    end
endmodule

