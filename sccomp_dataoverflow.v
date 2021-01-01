`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/17 14:30:45
// Design Name: 
// Module Name: sccomp
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


module sccomp(
    input clk,
    input rst,
    output [31:0] inst,
    output [31:0] pc, // to test
    output [10:0] dm_addr,
    output [10:0] im_addr
    );
    
    wire dw, dr, dena;
    wire [31:0] w_data, r_data;
    wire [31:0] instr, pc, res;
    wire [10:0] dm_addr;
    wire [31:0] im_addr;
    assign inst = instr;
    assign dm_addr = (res - 32'h10010000) / 4;
    
    IMEM imemory(
        .addr(im_addr[12:2]),
        .instr(instr) // output
    );
    assign im_addr = pc - 32'h0040_0000;
    DMEM dmemory(
        .clk(clk), .ena(1'b1), .DM_W(dw), .DM_R(dr), .DM_addr(dm_addr[10:0]), .DM_wdata(w_data),
        .DM_rdata(r_data)
    );
    CPU31 cpu(
        .clk(clk), .ena(1'b1),.rst(rst), .IM_inst(instr), .DM_rdata(r_data),
        .DM_ena(dena), .DM_W(dw), .DM_R(dr), .DM_wdata(w_data), .PC_out(pc), .ALU_out(res)
    );
endmodule
