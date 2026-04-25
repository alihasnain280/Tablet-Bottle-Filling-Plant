`timescale 1ns / 1ps

module tb_tablet_filler;

    
    reg clk;
    reg rst_n;
    reg [3:0] keypad_in;
    reg key_pressed;
    reg sensor_pulse;

    
    wire stop_led;
    wire [6:0] seg_tens;
    wire [6:0] seg_units;
    wire [7:0] total_leds;

    
    tablet_filler_system uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .keypad_in(keypad_in), 
        .key_pressed(key_pressed), 
        .sensor_pulse(sensor_pulse), 
        .stop_led(stop_led), 
        .seg_tens(seg_tens), 
        .seg_units(seg_units), 
        .total_leds(total_leds)
    );

    
    always #5 clk = ~clk; 

    
    task press_key(input [3:0] digit);
        begin
            keypad_in = digit;
            key_pressed = 1;
            #20;
            key_pressed = 0;
            #20;
        end
    endtask

    initial begin
       
        clk = 0;
        rst_n = 0;
        keypad_in = 0;
        key_pressed = 0;
        sensor_pulse = 0;

        
        #20 rst_n = 1;
        $display("System Reset.");

        
        press_key(4'd1);
      
        press_key(4'd2);
        
        $display("Target Set to 12. Tens Display Segs: %b, Units: %b", seg_tens, seg_units);
        
        
        repeat (12) begin
            #10 sensor_pulse = 1;
            #10 sensor_pulse = 0;
            #10; 
        end
        
       
        #10;
        if (stop_led) 
            $display("SUCCESS: Bottle Full! Stop LED is ON.");
        else
            $display("ERROR: Bottle should be full but Stop LED is OFF.");
            
        $display("Total Accumulator LEDs: %d (Expected 12)", total_leds);

               $finish;
    end
      
endmodule
