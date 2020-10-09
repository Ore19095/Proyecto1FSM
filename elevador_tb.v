
module tb();
    reg[3:0] piso;
    reg puerta, accion, llego, clk, rst;
    wire [2:0] estado;
    wire [3:0] siguiente;

    FSMpiso fsm(piso,puerta,accion, llego, clk, rst,estado,siguiente);

    initial clk = 0;

    initial begin
        #1 rst= 0; accion = 0; llego = 0; puerta = 0; piso = 4'b000;
        #1 rst =1; 
        #1 rst = 0;
        #4 puerta = 1;
        #4 piso = 4'b0100;
        #4 puerta=0 ;piso = 4'b1100;accion = 1;
        #4 piso = 4'b0110;
        #4 llego = 1;
        #4 puerta = 1; piso=4'b0110; 
        #4 puerta = 0;
        #4 piso = 4'b0100; llego =0;
        #8 llego = 0;
        #4 llego =1; 
        #4 puerta = 1;
        #4 piso = 4'b1000;
        #4 puerta = 0; llego = 0;
        #8 llego = 1;

        #5 $finish;
    end


    always #2 clk = ~clk;

    initial begin
        $dumpfile("elevador_tb.vcd");
        $dumpvars(0,tb);
    end
 

endmodule