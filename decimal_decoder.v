module decimal_decoder(hex, seg, blink_toggle);
    input [4:0] hex;
    input blink_toggle; // Input for blink control
    output reg [6:0] seg;

    always @(*) begin
        if (blink_toggle) begin
            // If blink_toggle is 1, set the display to blank
            seg = 7'b1111111; // Blank display (all segments off)
        end else begin
            // Decode hex to 7-segment values as usual
            case (hex)
                0: seg = 7'b1000000; // 0
                1: seg = 7'b1111001; // 1
                2: seg = 7'b0100100; // 2
                3: seg = 7'b0110000; // 3
                4: seg = 7'b0011001; // 4
                5: seg = 7'b0010010; // 5
                6: seg = 7'b0000010; // 6
                7: seg = 7'b1111000; // 7
                8: seg = 7'b0000000; // 8
                9: seg = 7'b0010000; // 9
                15: seg = 7'b1111110; // dash (-)
                16: seg = 7'b0001100; // "P"
                default: seg = 7'b1000000; // Default to 0
            endcase
        end
    end
endmodule
