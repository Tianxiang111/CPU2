`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/25 16:51:45
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
`define opADD 4'b0001
`define opSUB 4'b0010
`define opMPY 4'b0011
`define opDIV 4'b0100
`define opAND 4'b0101
`define opOR  4'b0110
`define opNOT 4'b0111
`define opSRL 4'b1000
`define opSLL 4'b1001
`define opSR  4'b1010
`define opSL  4'b1011
`define opBR  4'b1111
`define opMBR 4'b1110 
module ALU(clk,rst_n,ctl,oIR,oMBR,oBR,oACC,oALU,MR,DR
    );
    input clk,rst_n;
    input [19:0] ctl;
    input [ 7:0] oIR;
    input [15:0] oMBR;
    input [15:0] oBR;
    input [15:0] oACC;
    output reg [15:0] oALU;
    output reg [15:0] MR;
    output reg [15:0] DR;
    wire is_addr_mode;
    wire [15:0] alu_rhs;
    assign is_addr_mode = (oIR == 8'h13) || (oIR == 8'h14) || (oIR == 8'h15) || (oIR == 8'h16) ||
                          (oIR == 8'h1A) || (oIR == 8'h1B) || (oIR == 8'h1C) || (oIR == 8'h1D) ||
                          (oIR == 8'h1E) || (oIR == 8'h1F) || (oIR == 8'h20);
    assign alu_rhs = is_addr_mode ? oMBR : {8'b0,oMBR[7:0]};
    always @(posedge clk)
    begin
        if (!rst_n)
        begin
            oALU <= 1'b0;
        end
        else
        begin
            case (ctl[15:12])
                `opADD: oALU <= oACC + alu_rhs;
                `opSUB: oALU <= oACC - alu_rhs;
                `opMPY: {MR,oALU} <= oACC * alu_rhs;
                `opDIV: 
                begin
                    oALU <= oACC / alu_rhs;
                    DR <= oACC % alu_rhs;
                end 
                `opAND: oALU <= oACC & alu_rhs;
                `opOR : oALU <= oACC | alu_rhs;
                `opNOT: oALU <= ~oACC;
                `opSRL: oALU <= oACC >> 1;  
                `opSLL: oALU <= oACC << 1;
                `opSR : oALU <= oACC >>> 1;
                `opSL : oALU <= oACC <<< 1;
                `opBR : oALU <= oBR;
                `opMBR: oALU <= oMBR[15:0];
            endcase
        end
    end
endmodule
