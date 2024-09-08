`timescale 1ns / 1ps

module tb_TOP_LFSR;

    reg clk;
    reg i_rst;
    reg i_soft_reset;
    reg i_valid;
    reg i_corrupt;
    reg [7:0] i_seed;
    wire o_lock;

    // Instanciación del módulo TOP_LFSR
    top uut (
        .clk(clk),
        .i_rst(i_rst),
        .i_soft_reset(i_soft_reset),
        .i_valid(i_valid),
        .i_seed(i_seed),
        .i_corrupt(i_corrupt),
        .o_lock(o_lock)
    );

    // Generación de clock a 100 MHz
    always #50 clk = ~clk; // 5 ns para 100 MHz
    

    initial begin
        // Inicialización de señales
        clk=0;
        i_rst = 1               ;
        i_soft_reset = 0        ;
        i_valid = 0             ;
        i_seed = 8'b11111111    ;
        i_corrupt = 0           ;

        @(posedge clk)          ;
        i_rst   = 0             ;
        i_soft_reset = 1        ;

        @(posedge clk)          ;
        i_soft_reset = 0        ;

        #2000

        repeat(26) begin
          i_valid = 1;
          @(posedge clk);
        end
        i_valid = 0;
        i_corrupt = 1 ;
        repeat (6) begin
        i_valid = 1;
        @(posedge clk);
        end
        
        i_valid = 0;
        
        // finish 
        #200;
        $finish;
    end

endmodule
