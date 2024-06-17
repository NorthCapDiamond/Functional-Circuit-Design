`timescale 1ns / 1ps
module test(
            input CLK100MHZ,
            input BTNU,
            input [15:0] SW,
            input BTNC,
            output LED16_B,
            output [15:0] LED        
            );
            
            reg rst_button;
            reg start_button;
            
            functions tester(.clk(CLK100MHZ),
                             .rst(rst_button),
                             .a(SW[7:0]),
                             .b(SW[15:8]),
                             .start(start_button),
                             .out(LED),
                             .busy(LED16_B)
                             );


            integer rst_n = 0;
            integer start_n = 0;

            integer prob_limit = 100;

            localparam DO_NOTHING = 2'b00;
            localparam ITERATOR_START = 2'b10;
            localparam ITERATOR_RST = 2'b11;

            reg [2:0] STATE = DO_NOTHING;

            always @(posedge CLK100MHZ) begin
                case(STATE)
                    DO_NOTHING : begin
                        rst_n <= 0;
                        start_n <= 0;
                        rst_button <= 0;
                        start_button <= 0;

                        if(BTNU) begin
                            rst_n <= rst_n + 1;
                            STATE <= ITERATOR_RST;
                        end

                        if(BTNC) begin
                            start_n <= start_n + 1;
                            STATE <= ITERATOR_START;
                        end
                    end

                    ITERATOR_RST : begin
                        if(rst_n >= prob_limit) begin
                            rst_button <= 1;
                            STATE <= DO_NOTHING;
                        end

                        if(rst_button < 0) begin
                            rst_button <= 0;
                            STATE <= DO_NOTHING;
                        end

                        if(BTNU) begin
                            rst_n <= rst_n + 1;
                        end
                        else begin
                            rst_n <= rst_n - 1;
                        end
                    end

                    ITERATOR_START : begin
                        if(start_n >= prob_limit) begin
                            start_button <= 1;
                            STATE <= DO_NOTHING;
                        end

                        if(start_n < 0) begin
                            start_button <= 0;
                            STATE <= DO_NOTHING;
                        end


                        if(BTNC) begin
                            start_n <= start_n + 1;
                        end
                        else begin
                            start_n <= start_n - 1;
                        end
                    end
                endcase
            end
endmodule