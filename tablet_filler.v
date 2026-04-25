module bcd_to_7seg (
    input [3:0] bcd,
    output reg [6:0] seg 
);
    
    always @(*) begin
        case(bcd)
            4'd0: seg = 7'b1111110; 
            4'd1: seg = 7'b0110000; 
            4'd2: seg = 7'b1101101; 
            4'd3: seg = 7'b1111001; 
            4'd4: seg = 7'b0110011; 
            4'd5: seg = 7'b1011011;
            4'd6: seg = 7'b1011111;
            4'd7: seg = 7'b1110000; 
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1111011; 
            default: seg = 7'b0000000;
        endcase
    end
endmodule


module tablet_filler_system (
    input clk,                  
    input rst_n,               
    input [3:0] keypad_in,     
    input key_pressed,          
    input sensor_pulse,         
    
    output stop_led,            
    output [6:0] seg_tens,      
    output [6:0] seg_units,     
    output [7:0] total_leds     
);

    
    reg [7:0] target_bcd_reg;   
    reg [7:0] bottle_counter;   
    reg [7:0] total_accumulator;
    
    wire [7:0] target_binary;   
    reg prev_sensor_state;      
    reg prev_key_state;         
    
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            target_bcd_reg <= 8'h00;
            prev_key_state <= 0;
        end else begin
            
            if (key_pressed && !prev_key_state) begin
                
                target_bcd_reg[7:4] <= target_bcd_reg[3:0];
                target_bcd_reg[3:0] <= keypad_in;
            end
            prev_key_state <= key_pressed;
        end
    end

    
    assign target_binary = (target_bcd_reg[7:4] * 10) + target_bcd_reg[3:0];

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bottle_counter <= 8'd0;
            prev_sensor_state <= 0;
        end else begin
            
            if (!stop_led) begin
               
                if (sensor_pulse && !prev_sensor_state) begin
                    bottle_counter <= bottle_counter + 1;
                end
            end
            
           
             prev_sensor_state <= sensor_pulse;
        end
    end

    assign stop_led = (bottle_counter == target_binary) && (target_binary != 0);

    
    reg processed_batch; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            total_accumulator <= 8'd0;
            processed_batch <= 0;
        end else begin
            if (stop_led && !processed_batch) begin
                
                total_accumulator <= total_accumulator + bottle_counter;
                processed_batch <= 1; 
            end else if (!stop_led) begin
                
                processed_batch <= 0;
            end
        end
    end

  
    assign total_leds = total_accumulator;

    
    bcd_to_7seg decoder_tens (
        .bcd(target_bcd_reg[7:4]), 
        .seg(seg_tens)
    );
    
    bcd_to_7seg decoder_units (
        .bcd(target_bcd_reg[3:0]), 
        .seg(seg_units)
    );

endmodule
