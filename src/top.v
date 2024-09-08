module top
(
    input wire clk                                                                                           // Clock input (100 MHz)
   
);

     wire i_rst                                                                                ;         // Asynchronous reset
     wire i_soft_reset                                                                         ;         // Synchronous reset
     wire i_valid                                                                              ;         // Validation signal
     wire [7:0] i_seed                                                                         ;         // Seed input
     wire i_corrupt                                                                            ;         // Corruption signal
     wire o_lock                                                                               ;        // Lock output
    wire [7:0] o_LFSR_checker;
//
    wire [7:0] LFSR_output                                                                     ;       // Output of LFSR_generator
    wire [7:0] corrupted_LFSR                                                                  ;       // Corrupted LFSR sequence
    //wire       o_valid                                                                              ;
   //wire soft_checker;


    //! Instancia del LFSR_generator
    LFSR_generator U1_LFSR_generator 
    (
        .clk(clk)                                                                                   ,
        .i_valid(i_valid)                                                                           ,
        .i_rst(i_rst)                                                                               ,
        .i_soft_reset(i_soft_reset)                                                                 ,
        .i_seed(i_seed)                                                                             ,
        //.o_valid(o_valid)                                                                           ,
        .o_LFSR(LFSR_output)
    );

    //! Corromper el bit 0 de la secuencia si i_corrupt está activo
    assign corrupted_LFSR = i_corrupt ? {LFSR_output[7:1], ~LFSR_output[0]} : LFSR_output           ;

    //! Instancia del LFSR_checker
    LFSR_checker U2_LFSR_checker 
    (
        .clk(clk)                                                                                   ,
        .i_reset(i_rst)                                                                               ,
        .i_valid(i_valid)                                                                           ,
        .i_LFSR(corrupted_LFSR)                                                                     ,
        .o_LFSR_checker(o_LFSR_checker),
        //.i_soft_reset(soft_checker),
        .o_lock(o_lock)
    );

    vio
    u_vio
    (
        .clk_0   (clk)                                                                              ,
        .probe_in0_0 (corrupted_LFSR)                                                                       ,
        .probe_in1_0 (o_lock)                                                                       ,
        .probe_in2_0 (o_LFSR_checker)                                                               ,
        
        .probe_out0_0(i_seed)                                                                       ,
        .probe_out1_0(i_corrupt)                                                                    ,
        .probe_out2_0(i_rst)                                                                        ,
        .probe_out3_0(i_valid)                                                                      ,
        .probe_out4_0(i_soft_reset)
    );
    
    ila 
    u_ila
    (
        .clk_0(clk)                     ,
        .probe0_0(corrupted_LFSR)       ,
        .probe1_0(o_LFSR_checker)               ,
        .probe2_0(i_valid)              ,
        .probe3_0(i_rst)                ,
        .probe4_0(i_soft_reset)
    );
endmodule
