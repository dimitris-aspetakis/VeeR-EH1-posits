// Posit unit control module.


module exu_posu_ctl
   import veer_types::*;
(
   // Inputs
   input logic scan_mode,           // Scan mode

   input logic  [31:0] a,           // A value
   input logic  [31:0] b,           // B value

   input posu_pkt_t    dp,          // Validity and instruction type (add, sub, mul, div)

   // Outputs
   output logic finish,             // Posit unit instruction finished
   output logic posu_stall,         // Posit unit is occupied

   output logic [31:0] out          // Result
);

   logic posu_free;
   logic zero;
   logic inf;

   assign finish = posu_free;
   assign posu_stall = dp.valid & ~posu_free;

   // Connect adder
   exu_posit_add_ctl posit_add ( .in1     ( a ),                  // I
                                 .in2     ( b ),                  // I
                                 .start   ( dp.add & dp.valid ),  // I
                                 .out     ( out ),                // O
                                 .done    ( posu_free ),          // O
                                 .zero    ( zero ),               // O
                                 .inf     ( inf ));               // O

   // Connect adder after taking the 2's compliment from b
   exu_posit_add_ctl posit_sub ( .in1     ( a ),                  // I
                                 .in2     ( -b ),                 // I
                                 .start   ( dp.sub & dp.valid ),  // I
                                 .out     ( out ),                // O
                                 .done    ( posu_free ),          // O
                                 .zero    ( zero ),               // O
                                 .inf     ( inf ));               // O

   // Connect multiplier
   exu_posit_mul_ctl posit_mul ( .in1     ( a ),                  // I
                                 .in2     ( b ),                  // I
                                 .start   ( dp.mul & dp.valid ),  // I
                                 .out     ( out ),                // O
                                 .done    ( posu_free ),          // O
                                 .zero    ( zero ),               // O
                                 .inf     ( inf ));               // O

   // Connect divider
   // exu_posit_div_ctl posit_div ( .in1     ( a ),                  // I
   //                               .in2     ( b ),                  // I
   //                               .start   ( dp.div & dp.valid ),  // I
   //                               .out     ( out ),                // O
   //                               .done    ( posu_free ),          // O
   //                               .zero    ( zero ),               // O
   //                               .inf     ( inf ));               // O

endmodule // exu_posu_ctl