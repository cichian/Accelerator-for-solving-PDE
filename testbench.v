module testbench (

);
reg clka;
reg clkb;
reg rst_n;
reg mode;
reg read;
reg left;
reg top;
reg right;
reg down;
wire residue;
wire solution;
reg neighbor_solution;

reg [2:0] counter;

localparam [7:0] r_left = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
localparam [7:0] r_top = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1};
localparam [7:0] r_right = {1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
localparam [7:0] r_down = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0};


pe ins1 (
    .clka (clka),
    .clkb (clkb),
    .rst_n(rst_n),
    .mode(mode),
    .read(read),
    .left(left),
    .top(top),
    .right(right),
    .down(down),
    .residue(residue), // output 
    .solution(solution), // output 
    .neighbor_solution(neighbor_solution)
);

initial begin
    $display("dump start");
    $dumpfile("pe.vcd");
    $dumpvars;
    $display("dump finish");
end

initial begin
    clka <= 0;
    clkb <= 0;
    rst_n <= 1;
    mode <= 0;
    read <= 0;
    neighbor_solution <= 0;
#5 rst_n <= 0;
#5 rst_n <= 0;
#5 rst_n <= 1;
   mode <= 1;
   
   left <= r_left[7];
   top <= r_top[7];
   right <= r_right[7];
   down <= r_down[7];

#5 clka <= 1; // 1
#5 clka <= 0;

   left <= r_left[6];
   top <= r_top[6];
   right <= r_right[6];
   down <= r_down[6];

#5 clka <= 1; // 2
#5 clka <= 0;

   left <= r_left[5];
   top <= r_top[5];
   right <= r_right[5];
   down <= r_down[5];

#5 clka <= 1; // 3 
#5 clka <= 0;

   left <= r_left[4];
   top <= r_top[4];
   right <= r_right[4];
   down <= r_down[4];

#5 clka <= 1;// 4
#5 clka <= 0;

   left <= r_left[3];
   top <= r_top[3];
   right <= r_right[3];
   down <= r_down[3];   

#5 clka <= 1;// 5
#5 clka <= 0;

   left <= r_left[2];
   top <= r_top[2];
   right <= r_right[2];
   down <= r_down[2];

#5 clka <= 1;
#5 clka <= 0; // 6

   left <= r_left[1];
   top <= r_top[1];
   right <= r_right[1];
   down <= r_down[1];

#5 clka <= 1; // 7
#5 clka <= 0;
   left <= r_left[0];
   top <= r_top[0];
   right <= r_right[0];
   down <= r_down[0];

#5 clka <= 1; // 8
#5 clka <= 0;

   left <= 1'bz;
   top <= 1'bz;
   right <= 1'bz;
   down <= 1'bz;

#5 clkb <= 1;
#5 clkb <= 0;
   mode <= 0;
// first cycle end

#10 clka <= 1; // 1
#5 clka <= 0;

#5 clka <= 1; // 2
#5 clka <= 0;

#5 clka <= 1; // 3
#5 clka <= 0;

#5 clka <= 1; // 4
#5 clka <= 0;

#5 clka <= 1; // 5
#5  clka <= 0;

#5 clka <= 1; // 6
#5  clka <= 0;

#5 clka <= 1; // 7
#5 clka <= 0;

#5 clka <= 1; // 8
#5 clka <= 0;

#5 clkb <= 1; // 1
#5 clkb <= 0;

// second cycle end



   mode <= 1;
   left <= r_left[7];
   top <= r_top[7];
   right <= r_right[7];
   down <= r_down[7];

#5 clka <= 1; // 1
#5 clka <= 0;

   left <= r_left[6];
   top <= r_top[6];
   right <= r_right[6];
   down <= r_down[6];

#5 clka <= 1; // 2
#5 clka <= 0;

   left <= r_left[5];
   top <= r_top[5];
   right <= r_right[5];
   down <= r_down[5];

#5 clka <= 1; // 3 
#5 clka <= 0;

   left <= r_left[4];
   top <= r_top[4];
   right <= r_right[4];
   down <= r_down[4];

#5 clka <= 1;// 4
#5 clka <= 0;

   left <= r_left[3];
   top <= r_top[3];
   right <= r_right[3];
   down <= r_down[3];   

#5 clka <= 1;// 5
#5 clka <= 0;

   left <= r_left[2];
   top <= r_top[2];
   right <= r_right[2];
   down <= r_down[2];

#5 clka <= 1;
#5 clka <= 0; // 6

   left <= r_left[1];
   top <= r_top[1];
   right <= r_right[1];
   down <= r_down[1];

#5 clka <= 1; // 7
#5 clka <= 0;
   left <= r_left[0];
   top <= r_top[0];
   right <= r_right[0];
   down <= r_down[0];

#5 clka <= 1; // 8
#5 clka <= 0;

   left <= 1'bz;
   top <= 1'bz;
   right <= 1'bz;
   down <= 1'bz;

#5 clkb <= 1;
#5 clkb <= 0;
   mode <= 0;
// first cycle end

#10 clka <= 1; // 1
#5 clka <= 0;

#5 clka <= 1; // 2
#5 clka <= 0;

#5 clka <= 1; // 3
#5 clka <= 0;

#5 clka <= 1; // 4
#5 clka <= 0;

#5 clka <= 1; // 5
#5  clka <= 0;

#5 clka <= 1; // 6
#5  clka <= 0;

#5 clka <= 1; // 7
#5 clka <= 0;

#5 clka <= 1; // 8
#5 clka <= 0;

read <= 1;

#5 clkb <= 1; // 1
#5 clkb <= 0;

#5 clkb <= 1; // 2
#5 clkb <= 0;

#5 clkb <= 1; // 3
#5 clkb <= 0;

#5 clkb <= 1; // 4
#5 clkb <= 0;

#5 clkb <= 1; // 5
#5 clkb <= 0;

#5 clkb <= 1; // 6
#5 clkb <= 0;

#5 clkb <= 1; // 7
#5 clkb <= 0;

#5 clkb <= 1; // 8
#5 clkb <= 0;

#5 $finish;

end




















endmodule