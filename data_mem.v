module data_mem (
    input clk, mem_read, mem_write,
    input [31:0] addr, wd,
    output [31:0] rd
);
    reg [31:0] mem [0:255]; // 1KB for simulation

    always @(posedge clk) begin
        if (mem_write) mem[addr[9:2]] <= wd; // Word aligned
    end

    assign rd = mem_read ? mem[addr[9:2]] : 32'b0;
endmodule
