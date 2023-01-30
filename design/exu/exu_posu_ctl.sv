// Posit unit control module.


module exu_posu_ctl
   import veer_types::*;
(
   // Inputs
   input logic clk,                 // Top level clock
   input logic active_clk,          // Level 1 free clock
   input logic rst_l,               // Reset
   input logic scan_mode,           // Scan control

   input logic valid,

   input logic  [31:0] a,           // A value
   input logic  [31:0] b,           // B value

   input posu_pkt_t    dp,          // Validity and instruction type (add, sub, mul, div)

   // Outputs
   output logic finish,             // Posit unit instruction finished
   output logic posu_stall,         // Posit unit is occupied

   output logic [31:0] out          // Result
);

   logic [31:0] a_ff;
   logic [31:0] b_ff;

   rvdffe #(32) aff (.*, .en(valid), .din(a[31:0]), .dout(a_ff[31:0]));
   rvdffe #(32) bff (.*, .en(valid), .din(b[31:0]), .dout(b_ff[31:0]));

   // Ignore for now
   logic zero;
   logic inf;

   assign posu_stall = valid & ~finish;

   // Connect adder
   exu_posit_add_ctl posit_add ( .in1     ( a_ff ),               // I
                                 .in2     ( b_ff ),               // I
                                 .start   ( dp.add & valid ),     // I
                                 .out     ( out ),                // O
                                 .done    ( finish ),             // O
                                 .zero    ( zero ),               // O
                                 .inf     ( inf ));               // O

   // Connect adder after taking the 2's compliment from b
   // exu_posit_add_ctl posit_sub ( .in1     ( a_ff ),               // I
   //                               .in2     ( -b_ff ),              // I
   //                               .start   ( dp.sub & dp.valid ),  // I
   //                               .out     ( out ),                // O
   //                               .done    ( finish ),             // O
   //                               .zero    ( zero ),               // O
   //                               .inf     ( inf ));               // O

   // Connect multiplier
   // exu_posit_mul_ctl posit_mul ( .in1     ( a_ff ),               // I
   //                               .in2     ( b_ff ),               // I
   //                               .start   ( dp.mul & dp.valid ),  // I
   //                               .out     ( out ),                // O
   //                               .done    ( finish ),             // O
   //                               .zero    ( zero ),               // O
   //                               .inf     ( inf ));               // O

   // Connect divider
   // exu_posit_div_ctl posit_div ( .in1     ( a_ff ),               // I
   //                               .in2     ( b_ff ),               // I
   //                               .start   ( dp.div & dp.valid ),  // I
   //                               .out     ( out ),                // O
   //                               .done    ( finish ),             // O
   //                               .zero    ( zero ),               // O
   //                               .inf     ( inf ));               // O

endmodule // exu_posu_ctl