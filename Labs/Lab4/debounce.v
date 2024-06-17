module debounce(input clk,
				input button,
				output button_out
				);

	localparam START = 1'b0;
	localparam PRESSED = 1'b1;
	reg STATE = START;
	reg button_out_reg;
	integer counter = 0;
	assign button_out = button_out_reg;

	always @(clk) begin
		case(STATE)
			START : begin
				button_out_reg <= button;
				counter <= 0;
				if(button) begin
					counter <= counter + 1;
					STATE <= PRESSED;
				end
			end

			PRESSED : begin
				button_out_reg <= button;
				if(button) begin
					if(counter < 100) begin
						counter = counter + 1;
					end
					else begin
						button_out_reg <= 1;
						STATE <= PRESSED;
						counter <= 0;
					end
				end

				else begin
					if(counter > 0) begin
						counter = counter - 1;
					end
					else begin
						button_out_reg <= 0;
						STATE <= PRESSED;
						counter <= 0;
					end
				end
			end

		endcase
	end
endmodule