`timescale 1ns / 1ps
`include "function.v"
`include "crc8.v"
`include "debounce.v"
`include "lfsr2.v"
`include "lfsr.v"

module bist(input CLK100MHZ,
            input BTNU,
            input BTNL,
            input BTNC,
            input BTND,
            input [15:0] SW,
            output LED16_B,
            output LED16_G,
            output LED17_B,
            output LED17_G,
            output [15:0] LED
            );

            wire rst_button_deb;
            wire start_button_deb;
            wire test_button_deb;
            wire show_amount_deb;

            reg test_mode = 0;

            wire[7:0] a, b;

            wire [15:0] out;
            wire busy_f;

            wire [7:0] lfsr_left_value;
            wire [7:0] lfsr_right_value;

            wire [7:0] crc_out;

            integer counter_swaps = 0;
            reg is_show = 0;
            reg tmp = 0;
            wire checker;

            assign LED17_G = tmp;

            assign a = (test_mode == 1) ? lfsr_left_value : SW[7:0];
            assign b = (test_mode == 1) ? lfsr_right_value : SW[15:8];
            assign LED = (test_mode == 1) ? crc_out : is_show == 1 ? counter_swaps : out;
            assign LED16_B = busy_f;
            assign LED16_G = test_mode;
            assign checker = (data_ready_test) | (start_button_deb); //| bobat;

            assign func_reseter = (rst_button_deb) | (test_reseter);

            functions func_tester(.clk(CLK100MHZ),
                             .rst(func_reseter),
                             .a(a),
                             .b(b),
                             .start(checker),
                             .out(out),
                             .busy(busy_f)
                             );


            debounce reseter(CLK100MHZ, BTNU, rst_button_deb);
            debounce starter(CLK100MHZ, BTNC, start_button_deb);
            debounce tester(CLK100MHZ, BTNL, test_button_deb);
            debounce counter(CLK100MHZ, BTND, show_amount_deb);

            reg bobat = 0;
            reg bobatcrc = 0;
            reg partition = 0;

            reg test_reseter = 0;

            lfsr lfsr_left(bobat, test_reseter, lfsr_left_value);
            lfsr2 lfsr_right(bobat, test_reseter, lfsr_right_value);

            crc8 mycrc(CLK100MHZ, test_reseter, bobatcrc, out, partition, crc_out);


            integer full_iter = 0;
            reg data_ready_test = 0;
            localparam CHECK_FUNC = 3'b000;
            localparam WAIT = 3'b001;
            localparam DONE = 3'b010;
            localparam FILL_FUNC = 3'b011;
            localparam DO_CRC = 3'b100;
            localparam DO_CRC_SECOND = 3'b101;
            localparam WAIT_CRC = 3'b110;
            reg[2:0] STATE = CHECK_FUNC;


            always @(posedge test_button_deb) begin
                if(~test_mode) begin
                        counter_swaps <= counter_swaps + 1;
                        STATE <= CHECK_FUNC;
                        test_reseter <= 0;
                end else begin
                        test_reseter <= 1;
                end

                test_mode <= ~test_mode;
            end
            always @(posedge CLK100MHZ) begin
                if(test_mode) begin
                    case(STATE)
                        CHECK_FUNC : begin
                            bobatcrc <= 0;
                            partition <= 0;
                            tmp <= 0;
                            if(full_iter == 255) begin
                                STATE <= DONE;
                            end
                            if(~busy_f) begin
                                STATE <= FILL_FUNC;
                                bobat <= 1;
                            end

                        end

                        FILL_FUNC : begin
                            bobat <= 0;
                            full_iter <= full_iter + 1;
                            data_ready_test <= 1;
                            STATE <= WAIT;
                            
                        end


                        WAIT : begin
                            if(~busy_f) begin
                                data_ready_test <= 0;
                                STATE <= DO_CRC;
                            end
                        end

                        DO_CRC: begin
                            bobatcrc <= 1;
                            STATE <= WAIT_CRC;
                        end

                        WAIT_CRC: begin
                            bobatcrc <= 0;
                            partition <= 1;
                            STATE <= DO_CRC_SECOND;
                        end

                        DO_CRC_SECOND: begin
                            bobatcrc <= 1;
                            STATE <= CHECK_FUNC;
                        end


                        DONE : begin
                            bobat <= 0;
                            tmp<=1;
                        end
                    endcase
                end
                else begin
                    full_iter <= 0;
                end
            end

            always @(posedge show_amount_deb) begin
                is_show <= ~is_show;
            end

endmodule