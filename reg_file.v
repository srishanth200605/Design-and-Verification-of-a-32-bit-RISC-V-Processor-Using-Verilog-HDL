// reg_file.v - Updated with Debug Outputs
module reg_file (
    input         clk,
    input         rst,
    input         reg_write,
    input  [4:0]  rs1, rs2, rd,
    input  [31:0] wd,
    output [31:0] rd1, rd2,
    // Debug outputs
    output [31:0] debug_x5,
    output [31:0] debug_x7
);

    reg [31:0] registers [0:31];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) 
                registers[i] <= 32'b0;
        end else if (reg_write && rd != 5'b0) begin
            registers[rd] <= wd;
        end
    end

    assign rd1 = (rs1 == 0) ? 32'b0 : registers[rs1];
    assign rd2 = (rs2 == 0) ? 32'b0 : registers[rs2];

    // Debug ports
    assign debug_x5 = registers[5];   // x5 = t0
    assign debug_x7 = registers[7];   // x7 = t2

endmodule
