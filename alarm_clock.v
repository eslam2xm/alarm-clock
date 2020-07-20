`timescale 1ns / 1ps

module alarm_clock(
    input reset,
    input clk, //input clk should be 10 hz for time to be computed correctly
    input stop_alarm,
    input LD_alarm,
    input LD_time,
	 input [5:0] sec_in,
	 input [5:0] min_in,
	 input [5:0] hour_in,
	 output reg [5:0] sec,
    output reg [5:0] min,
    output reg [5:0] hour,
    output reg alarm
    );

reg [5:0] alarm_sec, alarm_min, alarm_hour;
reg [3:0] temp_tclk;

always @(posedge clk)
begin
	if(reset)
		begin
			sec <= 6'b000000;
			min <= 6'b000000;
			hour <= 6'b000000;
			temp_tclk <= 0;
			alarm<= 1'b0;
		end
	else if(LD_alarm)
		begin
			alarm_sec <= sec_in;
			alarm_min <= min_in;
			alarm_hour <= hour_in;
		end
	else if(LD_time)
		begin
			sec <= sec_in;
			min <= min_in;
			hour <= hour_in;
		end
	else if(stop_alarm)
		begin
			alarm <= 1'b0;
		end
	else if(sec == alarm_sec && min == alarm_min && hour == alarm_hour )
		begin
			alarm <= 1'b1;
		end
//-----------------------time calculation----------------------------------------//
		
	else //clock should work normally because no input signals were detected
		begin
			if(hour == 23 && min == 59 && sec==59 && temp_tclk==9 )
				begin
					hour <= 0;
					min <= 0;
					sec <= 0;
					temp_tclk <=0;
				end	
			else if(min == 59 && sec==59 && temp_tclk==9) //forcing time not to be updated before a complete min passes
				begin
					min <= 0;
					sec <= 0;
					temp_tclk <= 0;
					hour <= hour + 1;
				end
			else if(sec == 59 && temp_tclk ==9) //forcing time not to be updated before a complete second passes
				begin
					sec <= 0;
					temp_tclk <= 0;
					min <= min + 1;
				end
			else if(temp_tclk == 9) //each 10 temp_tclk's = 1 sec
				begin
					sec <= sec + 1;
					temp_tclk <= 0;
				end
			else
				temp_tclk <= temp_tclk + 1;	
		end
end

endmodule
