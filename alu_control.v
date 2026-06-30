module alu_control (
    input [1:0] alu_op,
    input [6:0] funct7,
    input [2:0] funct3,
    output reg [3:0] alu_ctrl
);
    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = 4'b0000; // ADD (LW/SW)
            2'b01: alu_ctrl = 4'b0001; // SUB (Branch)
            2'b10: begin // R-type
                case (funct3)
                    3'b000: alu_ctrl = (funct7[5]) ? 4'b0001 : 4'b0000; // ADD/SUB
                    3'b111: alu_ctrl = 4'b0010; // AND
                    3'b110: alu_ctrl = 4'b0011; // OR
                    3'b010: alu_ctrl = 4'b0111; // SLT
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            default: alu_ctrl = 4'b0000;
        endcase
    end
endmodule
