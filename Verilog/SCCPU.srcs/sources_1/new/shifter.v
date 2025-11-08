`timescale 1ns / 1ps

module shifter #(
    parameter N = 32
)(
    input  [N-1:0] a,
    input  shamt,               // 0 -> shift by 20, 1 -> shift by 1
    input  [1:0] type,
    output reg [N-1:0] r
);
    always @* begin
        case (type)
            2'b00: begin // Logical left shift
                if (shamt) r = a << 1;
                else       r = a << 20;
            end
            2'b01: begin // Logical right shift
                if (shamt) r = a >> 1;
                else       r = a >> 20;
            end
            2'b10: begin // Arithmetic right shift
                if (shamt) r = $signed(a) >>> 1;
                else       r = $signed(a) >>> 20;
            end
            default: r = a; // Safe default
        endcase
    end
endmodule

