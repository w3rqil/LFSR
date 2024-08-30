`timescale 1ns/1ps

module tb_LFSR_generator;

    // Señales del testbench
    reg     clk                                                                                 ;
    reg     i_valid                                                                             ;
    reg     i_rst                                                                               ;
    reg     i_soft_reset                                                                        ;
    reg     [7:0] i_seed                                                                        ;
    wire    [7:0] o_LFSR                                                                        ;   
    reg     [7:0] seed_reg                                                                      ;
    //! Instancia del módulo a testear
LFSR_generator uut 
(
    .clk(clk)                                                                                   ,
    .i_valid(i_valid)                                                                           ,
    .i_rst(i_rst)                                                                               ,
    .i_soft_reset(i_soft_reset)                                                                 ,
    .i_seed(i_seed)                                                                             ,
    .o_LFSR(o_LFSR)
);
integer i, iPeriod, iRS                                                                         ;
//! Clock de 10MHz
always #50 clk=~clk                                                                             ;

//! Task para cambiar el valor de i_seed
task change_seed(input [7:0] new_seed)                                                          ;
    begin
        i_seed = new_seed                                                                       ;
    end
endtask

//! Task para setear el reset asincrónico (i_rst)
task async_reset                                                                                ;   
    reg [7:0] random_reset_async;                           
    begin
        random_reset_async= urandom_range(1,2000);
        @(posedge clk) i_rst = 1                                                                ;
        # random_reset_async                                                                    ;           // delay aleatorio entre 1us y 250us
        @(posedge clk) i_rst = 0                                                                ;
    end
endtask

//! Task para setear el reset sincrónico (i_soft_reset)
task sync_reset                                                                                 ;
    reg [7:0] random_reset; 
    begin
        random_reset = $urandom_range (1,2000);
        @(posedge clk) i_soft_reset = 1                                                         ;
        # random_reset                                                                          ; // delay aleatorio entre 1us y 250us
        @(posedge clk) i_soft_reset = 0                                                         ;
    end
endtask

/*
************************************************************************************************************************
************************************************************************************************************************
*  Task para verificar la periodicidad del LFSR
*  Se realiza una simulación de 260 ciclos de reloj
*  Si se encuentra un valor igual al inicial, se imprime un mensaje
************************************************************************************************************************
************************************************************************************************************************
*/
    
task check_periodicity                                                                          ;
    // verifica la periodicidad con seed fijo
    reg [7:0] init_value                                                                        ;
    reg [7:0] current_value                                                                     ;
    integer count                                                                               ;
    begin
        $display(" Enters check_periodicity task");
        
        //i_seed = 8'b11111111                                                                    ;
        //async_reset                                                                             ; // registro el valor de i_seed
        init_value = o_LFSR                                                                     ; // guardo valor inicial del LFSR
        count = 0                                                                               ;
        i_valid=0                                                                               ; //reinicio el valid
        @(posedge clk)                                                                          ; // espero un ciclo

        for(iPeriod=0; iPeriod<257; iPeriod=iPeriod+1) 
        begin                                                                                       //comienza el bucle de verificación de periodicidad
            //#100
            i_valid=1                                                                           ;   //activo el valid ( para que se genere un nuevo valor del LFSR)
            @(posedge clk)                                                                      ;
            current_value=o_LFSR                                                                ;
            count=count +1                                                                      ; 
            if (current_value == init_value) 
            begin
                $display("Seed: %b, Periodicity match found at cycle: %d", i_seed, count)       ;
                $display("Init_value: %b", init_value);
                $display("current_value: %b", current_value);                                 
            end
            //@(posedge clk)                                                                      ;
            i_valid=0                                                                           ;   //desactivo el valid ( para que cuando comience el bucle genere un flaco positivo y se genere un nuevo valor del LFSR)
        end

    end
endtask


task check_periodicity_random_seed                                                              ;
// verifica la periodicidad con seed fijo   
reg [7:0] init_value                                                                            ;
reg [7:0] current_value                                                                         ;
integer count                                                                                   ;
begin
   $display(" Enters check_periodicity_random_seed task");
   
   i_seed = $random % 256                                                                       ;
   i_soft_reset = 1                                                                             ; // registro el valor de i_seed

   //async_reset                                                                             ; // registro el valor de i_seed
   @(posedge clk);
   i_soft_reset = 0                                                                             ;
   init_value = o_LFSR                                                                          ; // guardo valor inicial del LFSR
   count = 0                                                                                    ;
   i_valid=0                                                                                    ; //reinicio el valid

   @(posedge clk)                                                                               ; // espero un ciclo

   for(iRS=0; iRS<257; iRS=iRS+1) 
   begin                                                                                       //comienza el bucle de verificación de periodicidad
       //#100
       i_valid=1                                                                                ;   //activo el valid ( para que se genere un nuevo valor del LFSR)
       @(posedge clk)                                                                           ;
       current_value=o_LFSR                                                                     ;
       count=count +1                                                                           ; 
       if (current_value == init_value) 
       begin
           $display("Random seed: %b, Periodicity match found at cycle: %d", i_seed, count)     ;
           $display("Init_value: %b", init_value);
           $display("current_value: %b", current_value);                                 
       end
       //@(posedge clk)                                                                      ;
       i_valid=0                                                                                ;   //desactivo el valid ( para que cuando comience el bucle genere un flaco positivo y se genere un nuevo valor del LFSR)
   end

end
endtask





//! Proceso principal de prueba
initial begin 
    // Inicialización de señales
    $display("Enters initial cycle");
    clk             = 0                                                                         ;
    i_valid         = 0                                                                         ;
    i_rst           = 0                                                                         ;  
    i_soft_reset    = 0                                                                         ;
    i_seed          = 8'b11111111                                                               ; // Valor inicial del seed
    
    /* Actividad 2 */

    // Realizar un reset asincrónico al inicio
    async_reset                                                                                 ;
    //@(posedge clk) i_valid = 1                                                                  ;
    sync_reset                                                                                  ;
    // Generar valid aleatorio y realizar pruebas
        for (i=0; i<256; i=i+1) begin
            @(posedge clk);       //#100; // Espera entre validaciones
            i_valid = $random % 2                                                               ; // Cambia aleatoriamente entre 0 y 1
            #100;
            if (i_valid) begin
                seed_reg = o_LFSR                                                               ; // Guarda el valor del LFSR
                change_seed(seed_reg)                                                           ; // Cambia el seed aleatoriamente
                sync_reset                                                                      ; // Realiza un reset sincrónico
            end
        end
        
    

    /* Actividad 3 */
    
    check_periodicity                                                                          ; // Verifica la periodicidad
    $display(" Out check_periodicity Task!")                                                   ;
    check_periodicity_random_seed                                                              ; // Verifica la periodicidad con seed aleatorio
    $display(" Out check_periodicity_random_seed Task!")                                       ;

    /* Avtividad 5 */


    // Finaliza la simulación
    $finish                                                                                    ;        
end


endmodule
