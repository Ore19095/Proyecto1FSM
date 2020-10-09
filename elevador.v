
module FSMpiso(input wire[3:0] piso,input wire puerta, accion, llego, clk,reset, output reg [2:0] estado,output wire [3:0] next);
    /*  piso: indica a los pisos a los cuales las personas quieren ir, ya sea por peticion para subir, o si se  
              se seleccionaron los pisos internamente en el elevador.
        accion: indica la accion anterior que se estaba realizando, 1 si se estaba subiendo, 0 si se estaba bajando
        Puerta: indica si la puerta esta abierta (1) o cerrada (0)
        llego : indica si ya se llego al siguiente piso*/
    wire [2:0] nextEstado;
    //------------ bit 2 del nuevo estado ---------------------------------
    wire sn21,sn22,sn23, sn24,sn25 , sn26;
    //s1' s0'  + s2 Llegó' + s2 s1 s0 Acción
    assign sn21 = (~estado[1] & ~estado[0]) | (estado[2] & ~llego) | (estado[2] & estado[1] & estado[0] & accion);
    // s2' s0' PE2 PE1' Puerta'  + s2' s1' PE2 PE0' Puerta'
    assign sn22 = (~estado[2] & ~estado[0] & piso[2] & ~piso[1] & ~puerta) | (~estado[2] & ~estado[1] & piso[2] & ~piso[0] & ~puerta);
    //s2' s1 s0 PE2' PE0 Puerta'  
    assign sn23 = ~estado[2] & estado[1]& estado[0]& ~piso[2] & piso[0] & ~puerta;
    //s2' s1 PE2' PE1' PE0 Puerta'
    assign sn24 = ~estado[2] & estado[1] & ~piso[2] & ~piso[1] & piso[0] & ~puerta; 
    // s2' s0 PE2' PE1 PE0' Puerta'  
    assign  sn25 = ~estado[2] & estado[0] & ~piso[2] & piso[1] & ~piso[0] & ~puerta;
    //s2' PE3 PE2' PE1' PE0' Puerta' ;
    assign sn26 = ~estado[2] & piso[3] & ~piso[2] & ~piso[1] & ~piso[0] & ~puerta;

    assign nextEstado[2] = sn21 | sn22 | sn23 | sn24 | sn25 | sn26;

    // ---------------------------- bit 1 del nuevo estado----------------------------
    wire sn11, sn12 , sn13, sn14, sn15,sn16, sn17;
    // s2' s1 s0  + s0' PE3' PE1 Puerta'   
    assign sn11 = (~estado[2] & estado[1] & estado[0]) | (~estado[0] & ~piso[3] & piso[1] & ~puerta) ;
    //s2 s1' s0 Acción Llegó + s1 s0' PE1 
    assign sn12 = (estado[2] & ~estado[1] & estado[0] & accion & llego) | (estado[1] & ~estado[0] & piso[1]);
    // s1 s0' PE0'  + s1 s0' Puerta  + s2 s1 Acción'
    assign sn13 = (estado[1] & ~estado[0] & ~piso[0]) | (estado[1] & ~estado[0] & puerta) | (estado[2] & estado[1]& ~accion);
    //s1 s0 Llegó' + s1 s0' PE3 Acción
    assign sn14 = (estado[1] & estado[0] & ~llego) | (estado[1] & ~estado[0] & piso[3] & accion );
    //s1' s0' PE3' PE2 Puerta'
    assign sn15 = ~estado[1] & ~estado[0] & ~piso[3] & piso[2] & ~puerta ;
    //s2 s0' PE3' PE0 Puerta'
    assign  sn16 = estado[2] & ~estado[0] & ~piso[3] & piso[0] & ~puerta;
    // s0' PE3' PE2 Puerta' Acción ;
    assign sn17 = ~estado[0] & ~piso[3] & piso[2] & ~puerta & accion;


    assign nextEstado[1] = sn11 | sn12 | sn13 | sn14 | sn15 | sn16 |sn17 ;

    //-------------------------- bit 0 del nuevo estado ------------------------------
    wire sn01, sn02, sn03, sn04, sn05,sn06, sn07, sn08,sn09;
    //s2' s1'  + s2' s0 PE2  + s2' s0 Puerta
    assign sn01 = (~estado[2] & ~estado[1]) | (~estado[2] & estado[0] & piso[2]) | (~estado[2] & estado[0] & puerta);
    // s2 s0 Acción'  + s2 s0 Llegó'
    assign sn02 = (estado[2] & estado[0] & ~accion) | (estado[2] & estado[0] & ~llego);
    //  s2' s0 PE1' PE0'  + s2' s0 PE3 Acción
    assign sn03 = (~estado[2] & estado[0] & ~piso[1] & ~piso[0]) | (~estado[2] & estado[0] & piso[3] & accion);
    // s2 s1 s0' Acción Llegó
    assign sn04 = estado[2] & estado[1] & ~estado[0] & accion & llego;
    // s2' s0' PE1' PE0 Puerta' Acción'
    assign sn05 = ~estado[2] & ~estado[0] & ~piso[1] & piso[0] & ~puerta  & ~accion;
    // s2' s0' PE3' PE2' PE1' PE0 Puerta'
    assign sn06 = ~estado[2] & ~estado[0] & ~piso[3] & ~piso[2] & ~piso[1] & piso[0] & ~puerta;
    // s1' s0' PE3' PE2 Puerta'
    assign  sn07 = ~estado[1] & ~estado[0] & ~piso[3] & piso[2] & ~puerta;
    // s1' s0' PE3' PE1 Puerta'  
    assign sn08 = ~estado[1] & ~estado[0] & ~piso[3] & piso[1] & ~puerta;
    //s1' s0' PE3' PE0 Puerta' ;
    assign sn09 = ~estado[1] & ~estado[0] & ~piso[3] & piso[0] & ~puerta;

    assign nextEstado[0] = sn01 | sn02 | sn03 | sn04 | sn05 | sn06 | sn07 | sn08 | sn09;
    // -------- bit 3 de la salida ------------
    wire y31, y32;
    //s2' s1 s0 PE3 PE2' Puerta' Acción
    assign y31 = ~estado[2] & estado[1] & estado[0] & piso[3] & ~piso[2] & ~puerta & accion;
    //s2' s1 s0 PE3 PE2' PE1' PE0' Puerta' ;
    assign y32 = ~estado[2] & estado[1] & estado[0] & piso[3] & ~piso[2] & ~piso[1] & ~piso[0] & ~puerta;

    assign next[3] = y31 | y32;
    // --------- bit 2 de la salida ------------
    wire y21,y22,y23,y24,y25,y26,y27; 
    //s1' s0' PE3' PE2 Puerta'
    assign y21 = ~estado[1] & ~estado[0] & ~piso[3] & piso[2] & ~puerta;
    //s1' s0' PE3' PE1 Puerta'
    assign y22 = ~estado[1] & ~estado[0] & ~piso[3] & piso[1] & ~puerta;
    //s1' s0' PE3' PE0 Puerta'
    assign y23 = ~estado[1] & ~estado[0] & ~piso[3] & piso[0] & ~puerta;
    //s2' s0' PE3 PE1' PE0' Puerta' 
    assign y24 = ~estado[2] & ~estado[0] & piso[3] & ~piso[1] & ~piso[0] & ~puerta;
    // s2' s0' PE2 PE1' PE0' Puerta'
    assign y25 = ~estado[2] & ~estado[0] & piso[2] & ~piso[1] & ~piso[0] & ~puerta;
    // s2' s0' PE3 PE1' Puerta' Acción
    assign y26= ~estado[2] & ~estado[0] & piso[3] & ~piso[1] & ~puerta &accion;
    // s2' s0' PE2 PE1' Puerta' Acción
    assign y27 = ~estado[2] &  ~estado[0] & piso[2] & ~piso[1] & ~puerta & accion;

    assign next[2] = y21 | y22 | y23| y24 | y25| y26| y27 ; 
    // --------- bit 1 de la salida ------------------------
    wire y11,y12,y13,y14,y15,y16;
    //s2' s1' PE3 PE0' Puerta'
    assign y11 = ~estado[2] & ~estado[1] & piso[3] & ~piso[0] & ~puerta;
    //s2' s1' PE2 PE0' Puerta'
    assign y12 = ~estado[2] & ~estado[1] & piso[2] & ~piso[0] & ~puerta;
    //s2' s1 s0 PE3' PE2' PE0 Puerta'
    assign y13 = ~estado[2] & estado[1] & estado[0] & ~piso[3] & ~piso[2] & piso[0] & ~puerta;
    //s2' s1 s0 PE2' PE0 Puerta' Acción'  
    assign y14 = ~estado[2] & estado[1] & estado[0] & ~piso[2] & piso[0] & ~puerta & ~accion; 
    //s2' s0 PE3' PE2' PE1 PE0' Puerta'
    assign y15 = ~estado[2] & estado[0] & ~piso[3] & ~piso[2] & piso[1] & ~piso[0] & ~puerta;
    //s2' s0 PE2' PE1 PE0' Puerta' Acción' 
    assign y16 = ~estado[2] & estado[0] & ~piso[2] & piso[1] & ~piso[0] & ~puerta & ~accion;


     assign next[1] = y11 |y12 | y13|y14|y15|y16;
    //------ bit 0 de la salida ---------------------------------------
    wire y01,y02;
    //y0 = s2' s0' PE1' PE0 Puerta' Acción'  + s2' s0' PE3' PE2' PE1' PE0 Puerta' ;
    assign y01 = ~estado[2] & ~estado[0] & ~piso[1] & piso[0] & ~puerta & ~accion;
    assign y02 = ~estado[2] & ~estado[0] & ~piso[3] & ~piso[2] & ~piso[1] & piso[0] & ~puerta;

     assign next[0] = y01 | y02;
    
    
    always @(posedge clk,posedge reset ) estado <=  (reset ? 3'b001 : nextEstado) ; //se asigna a estado el siguiente estado

endmodule

module Comparador(input wire[3:0] A, B, output wire igual, mayor, menor); //compara si 2 numeos de 4 bis son iguales mayores o menores
    assign igual = (A == B);
    assign  mayor = (A>B);
    assign  menor = (A<B);

endmodule

module FsmElevador(input wire emergencia, igual, menor, mayor,clk, rst ,output reg [1:0] estado, accion  );

    wire [1:0] nextEstado;
    //S1 = SN0' E' I' Ma' Me + SN1 E' I' Me;
    assign  nextEstado[1] = (~estado[0] & ~emergencia & ~igual & ~mayor & menor ) | (estado[1] & ~emergencia & ~igual & menor) ;
    //S0 = SN1' E' I' Ma ;
    assign  nextEstado[0] = ~estado[1] & ~emergencia & ~igual & mayor;

     

    always @ (posedge clk, posedge rst) begin
        estado = (rst ? 2'b00  : nextEstado );
        accion <= estado; 
    end 

endmodule

module FsmPuerta(input wire llego, emergencia, necesario,hecho, persona,abrir, piso,output [1:0] estado, output y );


endmodule