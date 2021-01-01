`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/10 11:39:40
// Design Name: 
// Module Name: CPU31
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

`define AKL  1
module CPU31(
    input clk,
    input ena,
    input rst,
    output DM_ena,
    output DM_W,
    output DM_R,
    input [31:0] IM_inst,
    input [31:0] DM_rdata,
    output [31:0] DM_wdata,
    output [31:0] PC_out,
    output [31:0] ALU_out
    );
    
    wire ZF, SF, CF, OF;
    wire [4:0] ALUC;
    wire [13:0] MUXC;
    wire RF_R, RF_W;
    wire [31:0] PC, NPC;
    wire [4:0] Rdc, Rsc, Rtc;
    wire [31:0] Rd, Rs, Rt, A, B, Res;
    
    wire [31:0] MUX_out[11:0];
    wire [31:0] EXT_18_out;
    assign EXT_18_out = { IM_inst[15:0], 2'b0 };
    assign NPC = PC + 4;
    assign DM_ena = 1'b1;
    assign DM_wdata = Rt;
    assign PC_out = PC;
    assign ALU_out = Res;
    assign MUX_out[0] = MUXC[0] ? EXT_18_out + NPC : PC + 4;
    assign MUX_out[1] = MUXC[1] ? Rs : MUX_out[0];
    assign MUX_out[2] = MUXC[2] ? { PC[31:28], IM_inst[25:0], 2'b00 } : MUX_out[1];
    
    assign MUX_out[3] = MUXC[3] ? { 31'b0 , SF } : { 31'b0, OF }; // extend 1 to 32 unsigned by the way
    assign MUX_out[4] = MUXC[4] ? DM_rdata : MUX_out[3];
    assign MUX_out[5] = MUXC[5] ? PC + 8 : MUX_out[4];
    assign MUX_out[6] = MUXC[6] ? Res : MUX_out[5];
    
    assign MUX_out[7] = MUXC[7] ? { 27'b0, IM_inst[10:6] } : Rs; // extend 1 to 32 unsigned btw
    
    assign MUX_out[8] = MUXC[8] ? { {16{IM_inst[15]}}, IM_inst[15:0] } : { 16'b0, IM_inst[15:0] };
    assign MUX_out[9] = MUXC[9] ? Rt : MUX_out[8];
    
    assign MUX_out[10] = MUXC[5] ? 5'b11111 : IM_inst[15:11]; // 1 is jal, 0 is add-...-srav
    assign MUX_out[11] = MUXC[9] ? MUX_out[10] : IM_inst[20:16]; // 1 is lw, sw, addi..., 0 is muxc10
    
    assign Rd = MUX_out[6];
    assign Rsc = IM_inst[25:21];
    assign Rtc = IM_inst[20:16];
    assign Rdc = MUX_out[11];
    
    RegFile Rf(
        .RF_ena(ena),
        .RF_rst(rst),
        .RF_clk(clk),
        .Rdc(Rdc),
        .Rsc(Rsc),
        .Rtc(Rtc),
        .Rd(Rd),
        .Rs(Rs),
        .Rt(Rt),
        .RF_W(RF_W)
    );
    
    PcReg pcreg(
        .clk(clk),
        .rst(rst),
        .ena(ena),
        .PR_in(MUX_out[2]),
        .PR_out(PC)
    );
    
    ALU alu(
        .A(MUX_out[7]),
        .B(MUX_out[9]),
        .Res(Res),
        .ALUC(ALUC),
        .zero(ZF),  // 0 is true, others are false
        .carry(CF), // unsigned cf
        .sign(SF), // 1 is false, 0 is true
        .overflow(OF) // signed of
    );
    
    Controller ctrl(
        .IM_instr(IM_inst),
        .ZF(ZF),
        .ALUC_out(ALUC),
        .MUXC_out(MUXC),
        .DMC_out({ DM_W, DM_R }),
        .RFC_out({ RF_R, RF_W })
    );
endmodule
