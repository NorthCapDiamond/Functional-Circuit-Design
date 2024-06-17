`include "bist.v"
module bist_tb;
 reg clk, up, center, left, down = 0;
 reg [15:0] x = 0;
 reg start = 0;
 reg test = 0;
 wire [15:0] answer;
 wire ledik1, ledik2, ledik3, ledik4;

 bist bistik(clk, up, left, center, down, x, ledik1, ledik2, ledik3, ledik4, answer);

 initial begin
        $dumpfile("bist.vcd");
        $timeformat(-9, 1, "ns", 8);
        $dumpvars(0, bist_tb);
        clk = 0;
        forever
            #5
            clk = ~clk;
    end


    initial begin
     usermode(16'b1);
     testmode(16'b0000000001111111);
     test_to_start(16'b0000000001111111);
     $finish;
    end


    task usermode;
     input [15:0] inner;
     begin
      $display("usermode check");
      up = 1;
      left = 0;
      down = 0;
      center = 0;      
      #100
      $display("Pressed RST : %d", answer);
      up = 0;
      $display("Pressed RST : %d", answer);
      x = inner;
      center = 1;
      #100
      $display("Pressed START : %d", answer);
      center = 0;
      #1000000
      $display("Answer is %d\n", answer);
     end
    endtask

    task testmode;
     input [15:0] inner;
     begin
      $display("test check");
      up = 1;
      left = 0;
      down = 0;
      center = 0;
      #5000000
      $display("Pressed RST : %d", answer);
      up = 0;
      $display("Unressed RST : %d", answer);
      #5000000
      x = inner;
      left = 1;
      #5000000
      $display("Pressed TEST : %d", answer);
      left = 0;
      #5000000
      $display("Unpressed TEST : %d", answer);
      left = 1;
      #5000000
      $display("Pressed TEST : %d", answer);
      left = 0;
      #5000000
      $display("Unpressed TEST : %d", answer);
      left = 1;
      #5000000
      $display("Pressed TEST : %d", answer);
      left = 0;
      #5000000
      $display("Unpressed TEST : %d", answer);
      left = 1;
      #5000000
      $display("Pressed TEST : %d", answer);
      left = 0;
      #5000000
      $display("Unpressed TEST : %d", answer);
      left = 1;
      #5000000
      $display("Pressed TEST : %d", answer);
      left = 0;
      #5000000
      $display("Unpressed TEST : %d", answer);
      $display("Answer is %d\n", answer);
     end
    endtask


    task test_to_start;
    input [15:0] inner;
     begin
      $display("test to start check");
      up = 1;
      left = 0;
      down = 0;
      center = 0;
      #5000000
      $display("Pressed RST : %d", answer);
      up = 0;
      x = inner;
      #5000000
      $display("Unpressed RST : %d", answer);
      left = 1;
      #5000000
      $display("Pressed TEST : %d", answer);
      center = 1;
      #5000000
      $display("Pressed START : %d", answer);
      center = 0;
      #5000000
      $display("Unpressed START : %d", answer);
      left = 0;
      #5000000
      $display("Unpressed TEST : %d", answer);
      left = 1;
      #5000000
      $display("Pressed TEST : %d", answer);
      left = 0;
      #5000000
      $display("Unpressed TEST : %d", answer);
      center = 1;
      #5000000
      $display("Pressed START : %d", answer);
      center = 0;
      #5000000
      $display("Unpressed START : %d", answer);
      left = 1;
      #5000000
      $display("Pressed TEST : %d", answer);
      left = 0;
      #5000000
      $display("Unpressed TEST : %d", answer);
      $display("Answer is %d", answer);
     end
    endtask
endmodule
