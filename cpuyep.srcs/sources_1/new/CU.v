`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/25 18:46:38
// Design Name: 
// Module Name: CU
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

`define op_STORE 'h01
`define op_LOAD 'h02
`define op_ADD 'h03
`define op_SUB 'h04
`define op_JMPGEZ 'h05
`define op_JMP 'h06
`define op_HALT 'h07
`define op_MPY 'h08
`define op_AND 'h0A
`define op_OR 'h0B
`define op_NOT 'h0C
`define op_SRL 'h0D
`define op_SLL 'h0E
module CU(clk,rst_n,ctl,flags,oIR
    );
    input clk,rst_n;
    input flags;
    input [ 7:0] oIR;
    output[19:0] ctl;
    reg [7:0] CAR=0;
    blk_mem_gen_1 ROM(
        .clka(clk),
        .addra(CAR),
        .douta(ctl)
    );    
    always @(posedge clk)
    begin
        if (!rst_n)
        begin
            CAR <=1'b0;
        end
        else
        begin
            if(ctl[17]==1'b1)
            begin
                case(oIR)
                    `op_STORE:  CAR <= 'h09;
                    `op_LOAD:   CAR <= 'h05;
                    `op_ADD:    CAR <= 'h0F;
                    `op_SUB:    CAR <= 'h13;
                    `op_JMPGEZ: // Jump when ACC >= 0 (flags==0 because flags marks negative ACC)
                    begin
                        if (!flags) CAR <= 'h1F;
                        else CAR <= 'h09;
                    end
                    `op_JMP:    CAR <= 'h1F;
                    `op_HALT:   CAR <= 'h2B;
                    `op_MPY:    CAR <= 'h17;
                    `op_AND:    CAR <= 'h36;
                    `op_OR:     CAR <= 'h3A;
                    `op_NOT:    CAR <= 'h3E;
                    `op_SRL:    CAR <= 'h42;
                    `op_SLL:    CAR <= 'h46;
                    default:    CAR <= 'h00;
                endcase
            end
            if(ctl[16]==1'b1) CAR <= CAR + 1;
            if(ctl[18]==1'b1) CAR <= 1'b0;
            //if(CAR=='h26&&flags) CAR<='h09;
            //else if (CAR=='h26) CAR<='h1F;
        end
    end
endmodule
