module FinalProject(
    input clock,
    input [3:0] switches,  // 4 switches for binary input (value 0-9)
    input action,           // action button (open / lock safe)
    input save,            // Save button
    output [6:0] light1,   // 7-segment display 1
    output [6:0] light2,   // 7-segment display 2
    output [6:0] light3,   // 7-segment display 3
    output [6:0] light4,   // 7-segment display 4
	output [3:0] leds 	// 4 LEDs to indicate number of invalid pin entries
);

    // 1Hz clock using a clock divider
    wire c_out;
    clock_divider(clock,c_out);
	reg p;
	reg b = 1 ;
	
    // Registers to store the values for each 7-segment display
    reg [4:0] digit1 = 0;
    reg [4:0] digit2 = 0;
    reg [4:0] digit3 = 0;
    reg [4:0] digit4 = 0;
    reg [3:0] current_display = 0; // To track which display to store the value for
	reg save_state_prev = 1;  // Previous state of the save button (assumes default '1' means not pressed)
	reg save_state_curr;
	reg locked = 1;
	reg [3:0] invalidpin = 0;
	reg save_state_prev_action = 1;
	reg save_state_curr_action;
	reg blink_toggle1 = 0;
	reg blink_toggle2 = 0;
	reg blink_toggle3 = 0;
	reg blink_toggle4 = 0;
	reg [3:0] led_control;
	reg [3:0] countdown = 9;
	 
	 // Pincode : Default is 1234 (right to left)
	reg [4:0] pin1 = 1;
	reg [4:0] pin2 = 2;
	reg [4:0] pin3 = 3;
	reg [4:0] pin4 = 4;
	 
always @(posedge c_out) begin
if(invalidpin <= 4) begin
		save_state_curr_action = action;
		if (save_state_prev_action == 1 && save_state_curr_action == 0) begin
			// stop all displays from blinking
			blink_toggle1 <= 0;
			blink_toggle2 <= 0;
			blink_toggle3 <= 0;
			blink_toggle4 <= 0;

			// if the safe is locked
			if(locked == 1) begin
				// Check if pin is correct
				if(digit1 == pin1 && digit2 == pin2 && digit3 == pin3 && digit4 == pin4) begin
					digit1 <= 2;
					digit2 <= 3;
					digit3 <= 16;
					digit4 <= 0;
					locked <= 0;
					invalidpin<=0;
				end
				// if pin is incorrect, show dashes and increment failed attempts count
				else begin
					digit1 <= 15;
					digit2 <= 15;
					digit3 <= 15;
					digit4 <= 15;
					invalidpin<= invalidpin+1;
					current_display<=0;
				end
			end
		end
		// if action button is pressed while unlocked, reset and lock
		else if (save_state_prev_action == 0 && save_state_curr_action == 0 && locked == 0) begin
			digit1 <= 0;
			digit2 <= 0;
			digit3 <= 0;
			digit4 <= 0;
			locked <= 1;
			current_display<=0;
		end
		else begin
			if (locked == 1) begin
		case (current_display)
            0: begin
                blink_toggle1 <= ~blink_toggle1;  // Toggle blink for display 1
                digit1 <= switches;               // Update digit1 value
					blink_toggle2 <= 0;
					blink_toggle3 <= 0;
					blink_toggle4 <= 0;
            end
            1: begin
                blink_toggle2 <= ~blink_toggle2;  // Toggle blink for display 2
                digit2 <= switches;               // Update digit2 value
					blink_toggle1 <= 0;
					blink_toggle3 <= 0;
					blink_toggle4 <= 0;
            end
            2: begin
                blink_toggle3 <= ~blink_toggle3;  // Toggle blink for display 3
                digit3 <= switches;               // Update digit3 value
					blink_toggle1 <= 0;
					blink_toggle2 <= 0;
					blink_toggle4 <= 0;
            end
            3: begin
                blink_toggle4 <= ~blink_toggle4;  // Toggle blink for display 4
                digit4 <= switches;               // Update digit4 value
					blink_toggle1 <= 0;
					blink_toggle2 <= 0;
					blink_toggle3 <= 0;
            end
        endcase

        // Check if save button was just pressed (detect rising edge)
        save_state_curr = save;

        if (save_state_prev == 1 && save_state_curr == 0) begin
            // Only increment display pointer if the button was just pressed
            current_display <= (current_display == 3) ? 0 : current_display + 1;
        end
		  
        // Store the current save button state for the next clock cycle
        save_state_prev <= save_state_curr;
		  
		end
	end
	
		case (invalidpin)
        4'b0000: led_control <= 4'b0000;  // 0 invalid attempts: All LEDs off
        4'b0001: led_control <= 4'b0001;  // 1 invalid attempt: Light 1 LED
        4'b0010: led_control <= 4'b0011;  // 2 invalid attempts: Light 2 LEDs
        4'b0011: led_control <= 4'b0111;  // 3 invalid attempts: Light 3 LEDs
        4'b0100: led_control <= 4'b1111;  // 4 or more invalid attempts: All LEDs on
        default: led_control <= 4'b1111;  // Default: All LEDs on
    endcase
end
else begin
	digit2 <= 0;
	digit3 <= 0;
	digit4 <= 0;
	digit1 <= countdown;
	countdown <= countdown-1;
	if(countdown == 0) begin
		invalidpin <= 0;
		countdown <= 9;
	end
end

		save_state_prev_action <= save_state_curr_action;
end
	 
	assign leds = led_control;
	 
    // Connect digit values to decimal decoders
    decimal_decoder d1(digit1, light1, blink_toggle1);  // First display
    decimal_decoder d2(digit2, light2, blink_toggle2);  // Second display
    decimal_decoder d3(digit3, light3, blink_toggle3);  // Third display
    decimal_decoder d4(digit4, light4, blink_toggle4);  // Fourth display
endmodule
