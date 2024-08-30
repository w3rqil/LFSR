
module LFSR_checker
(
    input wire          clk                                     , //!clock de la máquina de estados
    input wire          reset                                   , //!reset de la máquina de estados
    input wire          i_valid                                 , //! booleano para empezar la comparación
    input wire [7:0]    i_LFSR                                  , //!LFSR que se va a comparar con el generado
    output wire          o_lock                                   //!lock que se activa cuando se detecta la secuencia    

);



reg [2:0] valid_counter                                         ;
reg [2:0] invalid_counter                                       ;
reg [7:0] LFSR                                                  ;
wire feedback = LFSR[7] ^ (LFSR[6:0]==7'b0000000)               ;
reg [7:0] next_LFSR                                             ;

reg aux_lock                                                    ;
reg first_flag                                                  ;



always @(posedge clk or posedge reset) 
begin
    if(reset)
    begin /*    preguntar a Facu si está bien que en el reset se seteen a 0 o solo en la condición de desbloqueo*/
        #100                                                    ;
        
        valid_counter <= 0                                      ;
        invalid_counter <= 0                                    ;
        LFSR <= 8'b00000001                                     ;
        aux_lock <=0                                            ;          //! Desbloquear en reset 
        first_flag <= 1                                         ; 

    end else
    begin
        
        if(first_flag) begin
            LFSR <= i_LFSR ;
            LFSR[0] <= feedback                                 ;
            LFSR[1] <= LFSR[0]                                  ;
            LFSR[2] <= LFSR[1] ^ feedback                       ;
            LFSR[3] <= LFSR[2] ^ feedback                       ;
            LFSR[4] <= LFSR[3]                                  ;
            LFSR[5] <= LFSR[4]                                  ;
            LFSR[6] <= LFSR[5]                                  ;
            LFSR[7] <= LFSR[6] ^ feedback                       ;
            first_flag <= 0;
        end else if(i_valid) begin
            //! generates LFSR sequence. 1 step behind LFSR_generator module
            
            LFSR[0] <= feedback                                 ;
            LFSR[1] <= LFSR[0]                                  ;
            LFSR[2] <= LFSR[1] ^ feedback                       ;
            LFSR[3] <= LFSR[2] ^ feedback                       ;
            LFSR[4] <= LFSR[3]                                  ;
            LFSR[5] <= LFSR[4]                                  ;
            LFSR[6] <= LFSR[5]                                  ;
            LFSR[7] <= LFSR[6] ^ feedback                       ;
    
            next_LFSR <= LFSR                                   ;  

            if(i_LFSR == next_LFSR) 
            begin //valid
                $display(" Valid value detected")               ;
                $display(" input LFSR value: %b", i_LFSR)       ;
                $display(" LFSR value: %b", LFSR)               ;
                $display(" NEXT LFSR value: %b", next_LFSR)     ;
                valid_counter = valid_counter + 1               ;
                $display(" valid_counter: %d", valid_counter)   ;
                invalid_counter <= 0                            ;
                if(valid_counter>= 5) begin
                    aux_lock <= 1                               ;
                    $display("--------------------")            ;
                    $display("Output LOCK: %b", aux_lock)       ;
                    $display("--------------------")            ;
                    valid_counter <= 0                          ;
                end

            end else if (i_LFSR != next_LFSR) 
            begin //invalid
                $display("NOT valid value detected");
                $display(" input LFSR value: %b", i_LFSR)      ;
                $display(" LFSR value: %b", LFSR)              ;
                $display(" NEXT LFSR value: %b", next_LFSR)    ;
                invalid_counter = invalid_counter + 1           ;
                $display(" invalid_counter: %d", invalid_counter);
                valid_counter <= 0                              ;
                if(invalid_counter>=3) begin
                    aux_lock=0                                  ;
                    $display("--------------------")            ;
                    $display("Output LOCK: %b", aux_lock)       ;
                    $display("--------------------")            ;
                    invalid_counter <= 0                        ;    
                end
            end
        end

    end
    
end

assign o_lock =aux_lock                                         ;


endmodule
