
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

module FsmPuerta(input wire llego, emergencia, necesario,hecho, persona,abrir, piso,clk,rst,output reg [1:0] estado, output wire y );

    wire [1:0] nextEstado;
    //sn1 = s0 H  + s1 Ll A' Pe' Pi' ;
    assign nextEstado[1] = (estado[0] & hecho) | (estado[1] & llego  & ~abrir & ~persona & ~piso );
    //sn0 = s0 H'  + s1 A  + s1 Pe  + s1 Pi  + s1' s0' Ll E' N;
    assign nextEstado[0] = (estado[0] & ~hecho) | (estado[1] & piso) | (estado[1] & abrir) | (estado[1] & persona) | (~estado[1] & ~estado[0] & llego & necesario & ~emergencia );
    assign y =  estado[0] ;
    always @ (posedge clk, posedge rst) begin
        estado <= (rst? 2'b10 : nextEstado);

    end 


endmodule

module OneHotToBinary(input wire [3:0]oneHot , output reg [1:0] binary);
    // segun el diseño del sistema, el resto de opciones nunca han de ser posibles, en funcionamiento normal.
    always @(oneHot) begin
        case(oneHot)
            4'b0001: binary <= 2'b00;
            4'b0010: binary <= 2'b01;
            4'b0100: binary <= 2'b10;
            4'b1000: binary <= 2'b11;
        endcase
    end

endmodule

module OneHotTo7S(input wire [3:0] oneHot, output reg [6:0] segmentos );

    always @(oneHot) begin
    // el resto de combinaciones nunca deberian de suceder
        case(oneHot)
            4'b0001: segmentos <= 7'b0000110;
            4'b0010: segmentos <= 7'b1011011;
            4'b0100: segmentos <= 7'b1001111;
            4'b1000: segmentos <= 7'b1100110;
        endcase
    end

endmodule

module LookNextFloor(input wire [2:0] estado, input wire accion, output wire mantener, output wire [1:0] y );
    /*este modulo es el encargado de que dependiendo del estado en el que se encuentre la FSM piso, y la accion que 
      esta realizando me de el piso al que esta por llegar, la salida va a un mux de 4 entradas, con lo que se selecciona
      la señal que corresponde la entrada de selección de piso y peticion, para ver si es necesario hacer una parada 
      en el siguiente piso la salida de mantener es para indicarle a un latch si deja pasar la señal que se le esta proporcionando
      o si mantiene el valor anterior*/

    //y1 = E1 E0  + E0' A;
    assign y[1] = (estado[1] & estado[0]) | (~estado[0] & accion);
    //y0 = E0 A + E0' A';
    assign y[0] = (estado[0] & accion) | (~estado[0] & ~accion);
    //M = E2 E1  + E2 E0 ;
    assign mantener = (estado[2] & estado[1]) | (estado[2] & estado[0]);

endmodule

module Mux4(input wire [1:0] s, input wire d,c,b,a, output wire y );
    assign y = (s[1] ? ( s[0] ? d : c ) : (s[0] ? b : a)  );
endmodule

module  FlipFlopD(input wire D, clk, preset, rst, output reg Q);
    // flip flop tipo D 
    always @ (posedge clk,posedge rst) Q <= (rst ? preset : D ); 
endmodule

module FlipFlopJK(input j,k,clk,rst, output reg Q);
    //modelo de un flip flop jk
    always @ (posedge clk, posedge rst) begin
        if (rst) Q <= 1'b0;
        else begin
            case( {j,k})
                2'b00: Q<= Q;
                2'b01: Q<= 1'b0;
                2'b10: Q<= 1'b1;
                2'b11: Q<= ~Q;
            endcase
        end
    end
endmodule

module Contador(input clk,rst, output reg [5:0] q);
    //contador de 6 bits
    always @(posedge clk, posedge rst) q<= (rst? 4'b0000 : q+1 );
endmodule


module SistemaElevador(input wire [7:0] piso,
                       input wire [3:0] peticion,
                       input wire [3:0] seleccion,
                       input wire abrir,emergencia,persona,puerta,clk,rst,
                       output wire [6:0] display,
                       output wire [1:0] accion,
                       output wire direccion,accionPuerta);
    
    /* este es el modulo principal en donde se arma todo el sistema del elevador, tal y como fue 
        hecho en circuitverse, las entradas tienen los siguientes significados:
        Piso: Son sensores los cuales detectan el cual piso se encuentra el elevador, siendo que 00000011 la señal
             enviada por los sensores indica que se encuentra en el piso 1, si es 00000110 indica que se encuentra entre
             el piso 1 y el 2, y de igual forma con los demas bits
        peticion: son los botones dentro del elevador en donde las personas seleccionan el piso al que quieren ir, si el bit
                  n-1 esta encendido quiere decir que se desea ir a piso n.
        seleccion: la misma funcion que la entrada de peticion con la diferencia que estos son los botones que se encuentran
                en el exterior del elevador para que las pesonas indiquen que desean usar el elevador, el si el bit n-1 esta 
                encendido significa que hay una persona en el piso n que quiere usar el elevador.
        abrir: boton dentro del elevador para la apertura manual del elevador
        emergencia: boton dentro del elevador para activar los frenos de forma manual
        persona: sensor que detecta si una persona ha pasado por la puerta del elevador para reiniciar el contador
        puerta: sensor que indica si la puerta esta totalmente abierta (1) o totalmente cerrada (0) se obvia los casos en donde
            se encuentre cerrando o abriendo la puerta, se asume que en estos casos la señal mantiene su valor anterior.
        
        las salidas tienen el siguiente significado:

        Display: son los valores que se tienen que colocar en el 7 segmentos para visualizar el piso en el que se encuentra,
                siendo el bit mas significativo el que representa g y el menos significativo representa la terminal a.
        accion: indica que accion tiene que realizar el elevador 00 freno, 01 subir 10 bajar.
        direccion: indica en que direccion se esta moviendo el elevador para referencia de los usuarios 1 subiendo 0 bajando
        accionPuerta: indica que debe hacer la puerta, 1 abrir y 0 cerrar, no indica si esta abierta o cerrada, sino si la puerta
                    debe abrirse o cerrarse.*/
    
    //----- compresion de imformacion del piso--------------------------------------------------
    wire [3:0] pisoComprimido;

    assign pisoComprimido[0] = piso[0] & piso[1];
    assign pisoComprimido[1] = piso[2] & piso[3];
    assign pisoComprimido[2] = piso[4] & piso[5];
    assign pisoComprimido[3] = piso[6] & piso[7];
    //------------------- memoria con FF jk para los botones de peticion y seleccion----------------------------------
    //peticion, todas estas "memorias" se reinician cuando el elevador se encuentra en el piso correspondiente, y la puerta
    //se abre.
    wire [3:0] memPeticion;
    FlipFlopJK  ffJK1(peticion[0],1'b0,clk,(pisoComprimido[0] & accionPuerta) | rst, memPeticion[0] );
    FlipFlopJK  ffJK2(peticion[1],1'b0,clk,(pisoComprimido[1] & accionPuerta) | rst, memPeticion[1] );
    FlipFlopJK  ffJK3(peticion[2],1'b0,clk,(pisoComprimido[2] & accionPuerta) | rst, memPeticion[2] );
    FlipFlopJK  ffJK4(peticion[3],1'b0,clk,(pisoComprimido[3] & accionPuerta) | rst, memPeticion[3] );
    //seleccion
    wire [3:0] memSeleccion;
    FlipFlopJK  ffJK5(seleccion[0],1'b0,clk,(pisoComprimido[0] & accionPuerta) | rst, memSeleccion[0] );
    FlipFlopJK  ffJK6(seleccion[1],1'b0,clk,(pisoComprimido[1] & accionPuerta) | rst, memSeleccion[1] );
    FlipFlopJK  ffJK7(seleccion[2],1'b0,clk,(pisoComprimido[2] & accionPuerta) | rst, memSeleccion[2] );
    FlipFlopJK  ffJK8(seleccion[3],1'b0,clk,(pisoComprimido[3] & accionPuerta) | rst, memSeleccion[3] );
    // uso de la primera FSM piso
    wire accionAnterior; // indica si anteriormente el elevador estaba subiendo o bajando
    wire openDoor;// indica si la puerta esta 
    wire llego; //indica si llego al piso que necesita. esta es la salida igual del comparador
    wire [3:0] floor; //or de memSeleccion y memPeticion bit a bit
    wire [2:0] estadoFSMpiso; //estado de la FSM piso
    wire [3:0] nextFloor;//piso siguente al cual debe ir el elevador
    //------------ operaciones para establecer las entradas de la FSM ----------------------------------------
    assign floor = memPeticion | memSeleccion; 
    assign openDoor = puerta | accionPuerta; 
    // se crea la FSM que maneja los pisos en el que se encuentra 
    FSMpiso decidirPiso(floor,openDoor, direccion, llego, clk,rst,estadoFSMpiso,nextFloor);   
    //valores de piso guardados en memorias con FF tipo D
    wire [3:0] actualFloorFix;
    wire [3:0] nextFloorFix;
    // nodos para permitir el paso de la señal de los FF
    wire senialPisoActual;
    wire senialPisoSiguiente;

    assign senialPisoActual = pisoComprimido[0] | pisoComprimido[1] | pisoComprimido[2] |pisoComprimido[3] ; 
    assign senialPisoSiguiente = nextFloor[0] | nextFloor[1] |nextFloor[2] |nextFloor[3] ;
    //se guardan los datos mientras todos los bits sean 0 si almenos 1 es diferente de 0 entonces se actualiza el valor 
    FlipFlopD   FFD1(pisoComprimido[0], clk & senialPisoActual, 1'b1,rst,actualFloorFix[0]);
    FlipFlopD   FFD2(pisoComprimido[1], clk & senialPisoActual,  1'b0,rst,actualFloorFix[1]);
    FlipFlopD   FFD3(pisoComprimido[2], clk & senialPisoActual,  1'b0,rst,actualFloorFix[2]);
    FlipFlopD   FFD4(pisoComprimido[3], clk & senialPisoActual,  1'b0,rst,actualFloorFix[3]);

    FlipFlopD   FFD5(nextFloor[0], clk & senialPisoSiguiente, 1'b1, rst , nextFloorFix[0]);
    FlipFlopD   FFD6(nextFloor[1], clk & senialPisoSiguiente,  1'b0, rst , nextFloorFix[1]);
    FlipFlopD   FFD7(nextFloor[2], clk & senialPisoSiguiente,  1'b0, rst , nextFloorFix[2]);
    FlipFlopD   FFD8(nextFloor[3], clk & senialPisoSiguiente,  1'b0, rst , nextFloorFix[3]);
    //salida del 7segmentos

    OneHotTo7S  oneTo7s(actualFloorFix,display);
    
    //comparador
    wire menor;// siguiente < actual
    wire mayor; //  sigiente > actual
    Comparador  comp(actualFloorFix,nextFloorFix,llego,menor, mayor);
    
    wire[1:0] estadoFSMelevador;
    //Uso y creacion de la FSM que controla la accion del elevador
    FsmElevador fsmElevador(emergencia,llego,menor,mayor,clk,rst, estadoFSMelevador, accion);
    // valor de la salida direccion
    wire actualizarDireccion;

    assign  actualizarDireccion = accion[1] | accion[0];

    //memoria del estado se actualiza solo si actualizarDireccion es 1
    FlipFlopD FFD9(accion[0],clkSlow & actualizarDireccion ,1'b0,rst,direccion);
    
    //---------- Señales internas necesarias para el funcionamiento de la FSM puerta ----------------------
    wire [1:0] controlMux1; //control del mux que manda la señal necesario a la FSM puerta
    wire mantener; ///senial para mantener o no el dato salido del mux
    wire necesarioPrev;
    wire necesario; //va conectada a la entrada necesario de la FSM puerta

    LookNextFloor   look(estadoFSMpiso,direccion,mantener, controlMux1);

    Mux4 mux1(controlMux1,floor[3],floor[2],floor[1],floor[0],necesarioPrev);
    // senial necesario de la fsm piso
    FlipFlopD   FFD10(necesarioPrev,clk & mantener,1'b0 , rst , necesario);

    // senial piso de la FSM piso
    wire [1:0] controlMux2;
    wire senialPiso;
    OneHotToBinary  oneToBinary(actualFloorFix,controlMux2);
    Mux4    mux2(controlMux2,peticion[3],peticion[2],peticion[1],peticion[0],senialPiso);

    //temporizador para la puerta
    wire [5:0] temporizador;
    wire hecho; //senial hecho de la fsm puerta
    wire resetTem; //senial que reinicia el temporizador
    //senial de renicio para el temporizador
    assign  resetTem = ~puerta | abrir | persona | senialPiso | (temporizador[2] & temporizador[1]  ) | rst; //
    // creacion del contador
    Contador cont(clk,resetTem,temporizador);


    assign hecho = temporizador[2] & temporizador[0]; // cuenta hasta 10, para no hacer tan largo el diagrama de timming 

    wire [1:0] estadoFsmPuerta;
    // creacion de la FSM puerta
    FsmPuerta fsmPuerta(llego, emergencia, necesario,hecho,persona,abrir,senialPiso,clk,rst, estadoFsmPuerta,accionPuerta);

    

endmodule
