`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/10 20:23:57
// Design Name: 
// Module Name: PcReg
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


module PcReg(
    input clk,
    input rst,
    input ena,
    input [31:0] PR_in,
    output [31:0] PR_out
    );
    reg [31:0] PcRegister;
    always @(negedge clk or posedge rst) begin
        if (ena) begin
            if (rst) begin
                PcRegister <= 32'h00400000;
            end
            else begin
                PcRegister <= PR_in;
            end
        end
    end
    
    assign PR_out = (ena && !rst) ? PcRegister : 32'hz;
endmodule
