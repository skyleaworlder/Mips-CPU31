`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/10 14:46:55
// Design Name: 
// Module Name: Controller
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


module Controller(
    input [31:0] IM_instr,
    input ZF,
    output [4:0] ALUC_out,
    output [13:0] MUXC_out,
    output [1:0] DMC_out,
    output [1:0] RFC_out
    );
        
    wire add_, addu_, sub_, subu_, and_, or_, xor_, nor_;
    wire slt_, sltu_, sll_, srl_, sra_, sllv_, srlv_, srav_, jr_;
    assign add_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b100_000);
    assign addu_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b100_001);
    assign sub_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b100_010);
    assign subu_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b100_011);
    assign and_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b100_100);
    assign or_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b100_101);
    assign xor_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b100_110);
    assign nor_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b100_111);
    assign slt_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b101_010);
    assign sltu_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b101_011);
    assign sll_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b000_000);
    assign srl_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b000_010);
    assign sra_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b000_011);
    assign sllv_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b000_100);
    assign srlv_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b000_110);
    assign srav_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b000_111);
    assign jr_ = (IM_instr[31:26] == 6'b000_000 && IM_instr[5:0] == 6'b001_000);
    
    wire addi_, addiu_, andi_, ori_, xori_, lw_, sw_, beq_, bne_;
    wire slti_, sltiu_, lui_;
    assign addi_ = (IM_instr[31:26] == 6'b001_000);
    assign addiu_ = (IM_instr[31:26] == 6'b001_001);
    assign andi_ = (IM_instr[31:26] == 6'b001_100);
    assign ori_ = (IM_instr[31:26] == 6'b001_101);
    assign xori_ = (IM_instr[31:26] == 6'b001_110);
    assign lw_ = (IM_instr[31:26] == 6'b100_011);
    assign sw_ = (IM_instr[31:26] == 6'b101_011);
    assign beq_ = (IM_instr[31:26] == 6'b000_100);
    assign bne_ = (IM_instr[31:26] == 6'b000_101);
    assign slti_ = (IM_instr[31:26] == 6'b001_010);
    assign sltiu_ = (IM_instr[31:26] == 6'b001_011);
    assign lui_ = (IM_instr[31:26] == 6'b001_111);

    wire j_, jal_;
    assign j_ = (IM_instr[31:26] == 6'b000_010);
    assign jal_ = (IM_instr[31:26] == 6'b000_011);
    
    // ALUC
    assign ALUC_out[4] = lui_;
    assign ALUC_out[3] = slt_ || sltu_ || slti_ || sltiu_ || sll_ || srl_ || sra_ || sllv_ || srlv_ || srav_;
    assign ALUC_out[2] = and_ || andi_ || or_ || ori_ || xor_ || xori_ || nor_ || sra_ || sllv_ || srlv_ || srav_;
    assign ALUC_out[1] = sub_ || subu_ || beq_ || bne_ || xor_ || xori_ || nor_ || sll_ || srl_ || srlv_ || srav_;
    assign ALUC_out[0] = addu_ || addiu_ || lw_ || sw_ || subu_ || beq_ || bne_ || or_ || ori_ || nor_ || sltu_ || sltiu_ || srl_ || sllv_ || srav_;
    
    // DMEM
    assign DMC_out[1] = sw_;
    assign DMC_out[0] = lw_;
    
    // RegFile
    assign RFC_out[0] = !(sw_ || jr_ || j_ || beq_ || bne_);

    // pc MUX
    assign MUXC_out[0] = (beq_ && ZF) || (bne_ && !ZF); // 0 is pc+4, 1 is ext18 + npc
    assign MUXC_out[1] = jr_; // 1 is jr, 0 is beq | bne
    assign MUXC_out[2] = (jal_ || j_); // 1 is jal | j, 0 is jr or beq | bne

    // rd MUX
    assign MUXC_out[3] = (slt_ || sltu_) && !(slti_ || sltiu_); // 1 is SF, 0 is CF
    assign MUXC_out[4] = lw_; // 1 is lw, 0 is slt | sltu | slti | sltiu;
    assign MUXC_out[5] = jal_; // 1 is jal, 0 is lw | slt | sltu | slti | sltiu
    assign MUXC_out[6] = !(slt_ || sltu_ || slti_ || sltiu_ || lw_ || jal_);

    // alu a MUX
    assign MUXC_out[7] = (sll_ || srl_ || sra_); // 1 is sll | srl | sra, 0 is others

    // alu b MUX
    assign MUXC_out[8] = sw_ || lw_ || addi_ || addiu_ || slti_ || sltiu_; // sign ext16
    assign MUXC_out[9] = !(addi_ || addiu_ || andi_ || ori_ || xori_ || lw_ || sw_ || slti_ || sltiu_ || lui_);
    
    // rdc MUX
    assign MUXC_out[10] = MUXC_out[5]; // cos jal need change rdc to 31
    assign MUXC_out[11] = !MUXC_out[9]; // muxc[11] == 1 means I type, while 0 means R type instructions

endmodule
