`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/09 16:13:47
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] A,
    input [31:0] B,
    output [31:0] Res,
    input [4:0] ALUC,
    output zero,  // 0 is true, others are false
    output carry, // unsigned cf
    output sign, // 1 is false, 0 is true
    output overflow // signed of
    );
    
    parameter ADD = 5'b00000;
    parameter ADDU = 5'b00001;
    parameter SUB = 5'b00010;
    parameter SUBU = 5'b00011;
    parameter AND = 5'b00100;
    parameter OR = 5'b00101;
    parameter XOR = 5'b00110;
    parameter NOR = 5'b00111;
    
    parameter SLT = 5'b01000;
    parameter SLTU = 5'b01001;
    
    parameter SLL = 5'b01010;
    parameter SRL = 5'b01011;
    parameter SRA = 5'b01100;
    parameter SLLV = 5'b01101;
    parameter SRLV = 5'b01110;
    parameter SRAV = 5'b01111;
    
    parameter LUI = 5'b10000;
    
    wire signed [31:0] signA, signB;
    reg [32:0] R;
    reg CF_open, OF_open, ZF_open, SF_open;
    assign signA = A;
    assign signB = B;
    always @(*) begin
        case(ALUC)
            ADD:    R <= signA + signB;
            ADDU:   R <= A + B;
            SUB:    R <= signA - signB;
            SUBU:   R <= A - B;
            AND:    R <= A & B;
            OR:     R <= A | B;
            XOR:    R <= A ^ B;
            NOR:    R <= ~(A | B);
            
            SLT:    R <= (signA - signB);
            SLTU:   R <= (A - B);
            
            SLL:    R <= B << A;
            SRL:    R <= B >> A;
            SRA:    R <= signB >>> signA;
            SLLV:   R <= B << A[4:0];
            SRLV:   R <= B >> A[4:0];
            SRAV:   R <= signB >>> signA[4:0];
            
            LUI:    R <= {B[15:0], 16'b0};
                
        endcase
    end
    assign Res = R[31:0];
    assign zero = (R == 32'b0) ? 1'b1 : 1'b0;
    assign carry = R[32];
    assign overflow = R[32];
    assign sign = (ALUC == SLT ? (signA < signB) : ((ALUC == SLTU) ? (A < B) : 1'b0));
endmodule
