module tb();
    reg  [7:0] piso;
    reg  [3:0] peticion;
    reg  [3:0] seleccion;
    reg  abrir,emergencia,persona,puerta,clk,rst;
    wire [6:0] display;
    wire [1:0] accion;
    wire direccion,accionPuerta;
 
    SistemaElevador sistema(piso,peticion, seleccion,abrir,emergencia,persona,puerta,clk,rst,
                            display,accion,direccion,accionPuerta);
    



    initial clk = 1;

    initial begin
	piso=	8'b00000011;	peticion =	4'b0000;	seleccion = 	4'b0000 ;	abrir = 	0;	emergencia = 	0;	persona =	0;	puerta = 	0;	rst =	0;	
#1															rst =	1;	
#1															rst =	0;	
#2			peticion =	4'b0001;													
#2			peticion =	4'b0000;													
#4													puerta= 	1;			//luego de que se envia la senial de abrir se abre la puerta
#14													puerta= 	0;			
#10			peticion =	4'b1000;	seleccion = 	4'b0110;											
#4	piso =	8'b00000110;	peticion =	4'b0000;	seleccion = 	4'b0000 ;											
#4									emergencia = 	1;	//se activan los frenos de emergencia						
#8									emergencia = 	0;	// se desactivan						
#4	piso =	8'b00001100;	// llego al piso 2														
#4													puerta =	1;			
#4							abrir = 	1;	 // alguen presiono el boton de abrir								
#2							abrir = 	0;			persona = 	1;	//paso una persona 				
#2											persona = 	0;					
#14													puerta =	0;			
#10	piso =	8'b00011000;															
#8	piso = 	8'b00110000;	//llego al piso 3														
#4													puerta = 	1;			
#2											persona = 	1;					
#6											persona= 	0;					
#14													puerta = 	0;			
#16	piso = 	8'b01100000;															
#10	piso = 	8'b11000000;															
#4													puerta = 	1;			
#4							abrir = 	1;	 // alguen presiono el boton de abrir								
#2							abrir = 	0;			persona = 	1;	//paso una persona 				
#2											persona = 	0;					
#14													puerta = 	0;			
#4			peticion =	4'b1000;													
#4			peticion =	4'b0000	;puerta = 1;// alguien en el piso 4 quiere entrar 								puerta =	1;			
#4					seleccion =	4'b0001;	// pide ir al piso 1										
#6					seleccion =	4'b0000	;										
#8													puerta =	0;			
#10	piso = 	8'b01100000;															
#10	piso = 	8'b00110000;															
#10	piso =	8'b00011000;															
#10	piso =	8'b00001100;															
#10	piso =	8'b00000110;															
#10	piso = 	8'b00000011;															
#4													puerta =	1;			
#14													puerta =	0;			
			

       #10 $finish;
    end


    always #1 clk = ~clk;

    initial begin
        $dumpfile("elevador_tb.vcd");
        $dumpvars(0,tb);
    end
 

endmodule