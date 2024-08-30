`timescale 1ns / 1ps

module tb_LFSR_checker;
    
    `define TEST3
    reg clk                                                                 ;
    reg reset                                                               ;
    reg i_valid                                                             ;
    reg i_soft_reset                                                        ;
    reg [7:0] i_seed                                                        ;
    reg [7:0] i_LFSR                                                        ;
    reg [4:0] max_valid                                                     ;
    reg [4:0] max_invalid                                                   ;
    wire o_lock                                                             ;
    
    wire feedback = LFSR_reg[7] ^ (LFSR_reg[6:0]==7'b0000000)               ;
    reg [7:0] LFSR_reg                                                      ;

    // Instanciación del módulo LFSR_checker
    LFSR_checker uut (
        .clk(clk)                                                           ,
        .reset(reset)                                                       ,
        .i_valid(i_valid)                                                   ,
        //.i_soft_reset(i_soft_reset)                                         ,
        //.i_seed(i_seed)                                                     ,
        .i_LFSR(i_LFSR)                                                     ,
        .o_lock(o_lock)
    );

    // Generación de clock a 10 MHz
    always #50 clk = ~clk                                                   ; // 50 ns para 10 MHz

    initial begin
        // Inicialización
        max_valid =8'h00;
        max_invalid=8'h00;
        reset = 1                                                           ;
        i_valid = 0                                                         ;
        i_soft_reset = 0                                                    ;
        i_seed = 8'b11111111                                                ;

        @(posedge clk) reset = 0                                            ;
        
        `ifdef  TEST1
            begin
                max_valid   = 6;
                max_invalid = 3;
            end
        `elsif TEST2//2 datos inválidos y 1 valido
            begin
                max_valid = 3;
                max_invalid = 2;
            end
        `elsif TEST3 //5 ciclos válidos y 3 ciclos inválidos
            
            begin
                max_valid=26;
                max_invalid=10;
            end
        `endif
        // Configurar seed y aplicar soft reset
        i_soft_reset = 1                                                    ;
        @(posedge clk)                                                      ;
        i_soft_reset = 0                                                    ;
        LFSR_reg= 8'b00000001;
        
       

        #2000 //! delay
        // 
       // i_valid = 1                                     ;
      //  4 datos válidos y 1 inválido    
        repeat (max_valid) begin
            i_valid=1;
            LFSR_reg[0] <= feedback                                         ;
            LFSR_reg[1] <= LFSR_reg[0]                                      ;
            LFSR_reg[2] <= LFSR_reg[1] ^ feedback                           ;
            LFSR_reg[3] <= LFSR_reg[2] ^ feedback                           ;
            LFSR_reg[4] <= LFSR_reg[3]                                      ;
            LFSR_reg[5] <= LFSR_reg[4]                                      ;
            LFSR_reg[6] <= LFSR_reg[5]                                      ;
            LFSR_reg[7] <= LFSR_reg[6] ^ feedback                           ;
            
           @(posedge clk) i_LFSR <= LFSR_reg                                ;
        end
        @(posedge clk)i_valid=0                                             ;

        @(posedge clk) i_valid=0;        
        repeat (max_invalid) begin
            i_valid=1;
            LFSR_reg[0] <= feedback                                         ;
            LFSR_reg[1] <= LFSR_reg[0]                                      ;
            LFSR_reg[2] <= LFSR_reg[1] ^ feedback                           ;
            LFSR_reg[3] <= LFSR_reg[2] ^ feedback                           ;
            LFSR_reg[4] <= LFSR_reg[3]                                      ;
            LFSR_reg[5] <= LFSR_reg[4]                                      ;
            LFSR_reg[6] <= LFSR_reg[5]                                      ;
            LFSR_reg[7] <= LFSR_reg[6] ^ feedback                           ;
            
            @(posedge clk) i_LFSR <= {LFSR_reg[7:1], ~LFSR_reg[0]}          ;
        end
            
        // Finalizar simulación
        #200
        $finish;
    end
/*
************************************************************************************************************************
************************************************************************************************************************
*       A C T I V I D A D           5
************************************************************************************************************************
************************************************************************************************************************
*/

endmodule
