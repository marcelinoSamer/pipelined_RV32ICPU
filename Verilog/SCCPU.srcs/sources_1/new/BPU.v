`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2025 08:04:57 PM
// Design Name: 
// Module Name: BPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BPU(
input branch1, branch2, jump, result, Reset, clk, output reg prediction, match
    );
    reg [1:0]State;
    localparam Staken = 2'b00;
    localparam Wtaken = 2'b01;
    localparam Wnot = 2'b11;
    localparam Snot = 2'b10;
    reg tReset;
    always @* begin
        tReset <= Reset;
        if(tReset) begin
            State <= Snot;
        end else begin
        case(State)
            Staken: begin
                if(branch2 && result)
                    State <= Staken;
                else
                    State <= Wtaken;
            end
            Wtaken: begin
                if(branch2 && result)
                    State <= Staken;
                else
                    State <= Wnot;
            end
            Wnot: begin
                if(branch2 && result)
                    State <= Wtaken;
                else
                    State <= Snot;
            end
            Snot: begin
                if(branch2 && result)
                    State <= Wnot;
                else
                    State <= Snot;
            end
            default:;
        endcase
        end
    end
    
    always @* begin
        if (jump) prediction = 1;
        else begin
            prediction = ~State[1];
            match = result & prediction;
        end
    end
endmodule
