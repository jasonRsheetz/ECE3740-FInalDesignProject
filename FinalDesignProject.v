// David Carlson - %40
// Jason Sheetz - %60
//	group #1
// Team Design Project: Traffic Signal
// This system simulates a traffic light, governed by 2 timers for green and yellow lights respectively. The red 
//light is timed by the sumation of the green and yellow light times
// This is our own work.





// module toplevel container (output is R1Y1G1 and R2Y2G2, and input(s) is clock, (t1 and t2?))
module FinalDesignProject(output LEDG1, LEDG2, LEDY1, LEDY2, LEDR1, LEDR2, input CLOCK);
reg CLK = 1'b0;
integer counter = 0;

//at the rising edge of the clock incriment a counter
always @(posedge CLOCK)begin
counter <= counter +1;

//toggle the clock at 1Hz intervals for the internal modules
if(counter == 50000000 && CLK == 1'b0)begin
CLK <= 1'b1;
counter <= 0;
end else if(counter == 50000 && CLK == 1'b1)begin
CLK <= 1'b0;
counter <= 0;
end

end//always

// controlmodule(pass in stuff)
controlModule controller(START_GREEN_TIMER, START_YELLOW_TIMER, G1, Y1, R1, G2, Y2, R2, T1_END, T2_END, CLK);

//	datapathmodule(pass in stuff)
dataPathModule dataPath(T1_END, T2_END, LEDG1, LEDG2, LEDY1, LEDY2, LEDR1, LEDR2, START_GREEN_TIMER, START_YELLOW_TIMER, G1, Y1, R1, G2, Y2, R2, CLK);

// endmodule
endmodule


// module Control Unit (input is clock, (and T1_END, T2_END))
module controlModule(
output reg START_GREEN_TIMER, START_YELLOW_TIMER, G1, Y1, R1, G2, Y2, R2,
input T1_END, T2_END, CLK
);

//starting values;
integer CYCLE = 0;

//lights cycle like this: r2->g1->y1->r1->g2->y2->r2->g1->..4 differnet phases
always @(posedge CLK)begin
	//set lights based on  status of other lightsif both timers are 0
	if(T1_END == 1'b0 && T2_END == 1'b0)begin
		case(CYCLE)
			0:		begin G1 <= 1'b1; Y1 <= 1'b0; R1 <= 1'b0; R2 <= 1'b1; Y2 <=1'b0; START_GREEN_TIMER <= 1'b1; START_YELLOW_TIMER <= 1'b0; end
			1:		begin Y1 <= 1'b1; G1 <= 1'b0; START_GREEN_TIMER <= 1'b0; START_YELLOW_TIMER <= 1'b1; end
			2:		begin R1 <= 1'b1; Y1 <= 1'b0; G2 <= 1'b1; Y2 <= 1'b0; R2 <= 1'b0; START_GREEN_TIMER <= 1'b1; START_YELLOW_TIMER <= 1'b0;end
			3:		begin Y2 <= 1'b1; G2 <= 1'b0; START_GREEN_TIMER <= 1'b0; START_YELLOW_TIMER <= 1'b1; end
		endcase
		
	CYCLE <= CYCLE +1;
	if(CYCLE == 3) CYCLE <= 0;

	end//if
	
end//always


//
// endmodule
endmodule


// module Datapath (outputs light states, input(s) controls from control unit)
module dataPathModule(
output reg T1_END, T2_END, LEDG1, LEDG2, LEDY1, LEDY2, LEDR1, LEDR2,
input START_GREEN_TIMER, START_YELLOW_TIMER, G1, Y1, R1, G2, Y2, R2, CLK
);

//timing delays
parameter green_time = 5;
parameter yellow_time = 3;

integer green_timer = 5;
integer yellow_timer = 3;


always @(negedge CLK)begin

//green timer
if(START_GREEN_TIMER == 1'b1)begin
	T1_END <= 1'b1;
	green_timer  <= green_timer -1;
end

if(green_timer == 0)begin
	T1_END <=1'b0;
	green_timer <= green_time;
end

//yellow timer
if(START_YELLOW_TIMER == 1'b1)begin
	T2_END <= 1'b1;
	yellow_timer  <= yellow_timer -1;
end

if(yellow_timer == 0)begin
	T2_END <=1'b0;
	yellow_timer <= yellow_time;
end

//set the light values
if(G1 == 1'b1) LEDG1 <= 1'b1; else LEDG1 <= 1'b0;
if(Y1 == 1'b1) LEDY1 <= 1'b1; else LEDY1 <= 1'b0;
if(R1 == 1'b1) LEDR1 <= 1'b1; else LEDR1 <= 1'b0;
if(G2 == 1'b1) LEDG2 <= 1'b1; else LEDG2 <= 1'b0;
if(Y2 == 1'b1) LEDY2 <= 1'b1; else LEDY2 <= 1'b0;
if(R2 == 1'b1) LEDR2 <= 1'b1; else LEDR2 <= 1'b0;





end//always
// endmodule
endmodule














