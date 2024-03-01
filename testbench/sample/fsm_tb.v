`timescale 10ns / 1ns
/*
	Describes a simple finite state machine where:
	States {IDLE,INIT,STARTED}

	IDLE => INIT => STARTED (risign CLOCK + enable)
	STARTED => IDLE , INIT => IDLE  (risign CLOCK + reset)
*/

module fsm_tb(output out);

//	PORTS
//input  clock_i, reset_i, enable_i;
//output out_o;

// TYPE
reg clock_i, reset_i, enable_i;


assign out = clock_i;
// FSM
parameter SIZE = 3;
parameter IDLE = 3'b001;
parameter INIT = 3'b010;
parameter STRT = 3'b100;
parameter HIGH = 1'b1;

reg [SIZE-1:0] state;

initial begin
   state = 3'b001;
end 

// DESIGN
always @ (posedge clock_i)

begin
   if (reset_i == 1'b1) 
   begin
      state <= IDLE;
   end
   else
   begin
      if (enable_i == 1'b1) 
      begin
        case (state)
		   IDLE: state <= INIT;
		   INIT: state <= STRT;
		   STRT: state <= STRT;
           default : state <= INIT;
        endcase
	  end
   end
end
	

// TEST
  initial 
  begin
    $dumpfile("vcd/fsm_tb.vcd");
    
    $dumpvars(0, fsm_tb);
    #0 clock_i=1'b0; reset_i = 1'b0; enable_i=1'b1;

    $display("<begin>");
	 $monitor("%b %b",clock_i,state);
    #1 clock_i=1'b1;
    $monitor("%b %b",clock_i,state);
	 #1 clock_i=1'b0;
    $monitor("%b %b",clock_i,state);
	 #1 clock_i=1'b1;
    $monitor("%b %b",clock_i,state);
	 #1 clock_i=1'b0;
    $monitor("%b %b",clock_i,state);
    #1
    $display("<end>");
  end

endmodule
