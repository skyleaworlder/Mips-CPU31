`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/09 23:04:24
// Design Name: 
// Module Name: DMEM
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


module DMEM(
    input clk,
    input ena,
    input DM_W,
    input DM_R,
    input [10:0] DM_addr,
    input [31:0] DM_wdata,
    output [31:0] DM_rdata
    );
    
    reg [31:0] D_mem[0:31];
    always @(posedge clk) begin
        if (DM_W && ena) begin
            D_mem[DM_addr] <= DM_wdata;
        end
    end
    
    assign DM_rdata = (DM_R && ena) ? D_mem[DM_addr] : 32'bz;
endmodule
