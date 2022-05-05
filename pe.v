module pe(
    input wire clka,
    input wire clkb,
    input wire rst_n,
    input wire mode,
    input wire read,
    input wire left,
    input wire top,
    input wire right,
    input wire down,
    output wire residue,
    output wire solution,
    input wire neighbor_solution
);

wire clk_a = clka & mode;

// left 

wire sum_left_1;
wire co_left_1;
reg co_reg_left;
half_adder left_1(
    .a(left),
    .b(co_reg_left),
    .sum(sum_left_1),
    .co(co_left_1)
);

wire sum_left_2;
wire co_left_2;
half_adder left_2(
    .a(left),
    .b(co_left_1),
    .sum(sum_left_2),
    .co(co_left_2)
);

wire sum_left_3;
half_adder left_3(
    .a(left),
    .b(co_left_2),
    .sum(sum_left_3),
    .co()
);

always@(posedge clk_a or negedge rst_n) begin
    if (!rst_n) co_reg_left <= 0;
    else co_reg_left <= co_left_1;
end



// top

wire sum_top_1;
wire co_top_1;
reg co_reg_top;

full_adder top_1(
    .a(top),
    .b(co_reg_top),
    .c(sum_left_1),
    .sum(sum_top_1),
    .co(co_top_1)
);

wire sum_top_2;
wire co_top_2;

full_adder top_2(
    .a(top),
    .b(co_top_1),
    .c(sum_left_2),
    .sum(sum_top_2),
    .co(co_top_2)
);

wire sum_top_3;

full_adder top_3(
    .a(top),
    .b(co_top_2),
    .c(sum_left_3),
    .sum(sum_top_3),
    .co()
);

always@(posedge clk_a or negedge rst_n) begin
    if (!rst_n) co_reg_top <= 0;
    else co_reg_top <= co_top_1;
end

//right

wire sum_right_1;
wire co_right_1;
reg co_reg_right;

full_adder right_1(
    .a(right),
    .b(co_reg_right),
    .c(sum_top_1),
    .sum(sum_right_1),
    .co(co_right_1)
);

wire sum_right_2;
wire co_right_2;

full_adder right_2(
    .a(right),
    .b(co_right_1),
    .c(sum_top_2),
    .sum(sum_right_2),
    .co(co_right_2)
);

wire sum_right_3;

full_adder right_3(
    .a(right),
    .b(co_right_2),
    .c(sum_top_3),
    .sum(sum_right_3),
    .co()
);

always@(posedge clk_a or negedge rst_n) begin
    if (!rst_n) co_reg_right <= 0;
    else co_reg_right <= co_right_1;
end


//down

wire sum_down_1;
wire co_down_1;
reg co_reg_down;

full_adder down_1(
    .a(down),
    .b(co_reg_down),
    .c(sum_right_1),
    .sum(sum_down_1),
    .co(co_down_1)
);

wire sum_down_2;
wire co_down_2;

full_adder down_2(
    .a(down),
    .b(co_down_1),
    .c(sum_right_2),
    .sum(sum_down_2),
    .co(co_down_2)
);

wire sum_down_3;

full_adder down_3(
    .a(down),
    .b(co_down_2),
    .c(sum_right_3),
    .sum(sum_down_3),
    .co()
);

always@(posedge clk_a or negedge rst_n) begin
    if (!rst_n) co_reg_down <= 0;
    else co_reg_down <= co_down_1;
end
// three mux control by mode 
reg [8:0] shift_reg;
reg [8:0] r; // parrallel output of shift register
wire mux1_out;
wire mux2_out;
wire mux3_out;

assign mux1_out = mode ? sum_down_1 : r[7];
assign mux2_out = mode ? sum_down_2 : r[8];
assign mux3_out = mode ? sum_down_3 : r[8];

// serializer and div-4 fip flop 

always@ (*) begin
    r[0] = shift_reg[0];
    r[1] = shift_reg[1];
    r[2] = shift_reg[2];
    r[3] = shift_reg[3];
    r[4] = shift_reg[4];
    r[5] = shift_reg[5];
    r[6] = shift_reg[6];
    r[7] = shift_reg[7];
    r[8] = shift_reg[8];
end

assign residue = r[0];

always@ (posedge clka or negedge rst_n) begin
    if (!rst_n)
        shift_reg <= 9'b0;
    else begin
        //shift_reg[9] <= mux3_out;
        shift_reg[8] <= mux3_out;
        shift_reg[7] <= mux2_out;
        shift_reg[6] <= mux1_out;
        shift_reg[5] <= shift_reg[6];
        shift_reg[4] <= shift_reg[5];
        shift_reg[3] <= shift_reg[4];
        shift_reg[2] <= shift_reg[3];
        shift_reg[1] <= shift_reg[2];
        shift_reg[0] <= shift_reg[1];
    end 
end
// mux before accumulator 
reg [7:0] acc_reg;
wire [7:0] read_or_acc_result;
wire [7:0] acc_co;
wire [7:0] acc_sum;
integer j;

half_adder acc_1(
    .a(acc_reg[0]),
    .b(r[0]),
    .sum(acc_sum[0]),
    .co(acc_co[0])
);
genvar k;
generate 
    for (k = 1; k < 8; k = k + 1) begin
        full_adder acc_2(
            .a(acc_reg[k]),
            .b(r[k]),
            .c(acc_co[k-1]),
            .sum(acc_sum[k]),
            .co(acc_co[k])
        );
    end
endgenerate


genvar i;
generate 
    for (i = 0; i < 7; i = i + 1) begin
        assign read_or_acc_result[i] = read ? (acc_reg[i + 1]): (acc_sum[i]);
    end
endgenerate
assign read_or_acc_result[7] = read ? (neighbor_solution) : (acc_sum[7]);

// accumulator fip flop 
assign clk_b = clkb & (read | mode);

always@ (posedge clk_b or negedge rst_n) begin
    if (!rst_n) acc_reg <= 8'b0;
    else 
        for (j = 0; j < 8; j = j + 1) 
            acc_reg[j] <= read_or_acc_result[j];
end

assign solution = acc_reg[0];

endmodule 


module full_adder(
    input wire c,
    input wire a,
    input wire b,
    output wire sum,
    output wire co
);

assign {co, sum} = a + b + c;

endmodule


module half_adder(
    input wire a,
    input wire b,
    output wire sum,
    output wire co
);

assign {co, sum} = a + b;

endmodule 