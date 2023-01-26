// Posit register file control module.

module dec_pr_ctl (
   input logic active_clk,
   input logic clk,
   input logic rst_l,

   input logic [4:0] raddr0,   // logical read addresses
   input logic [4:0] raddr1,

   input logic rden0,          // read enables
   input logic rden1,

   input logic [4:0] waddr,    // logical write address

   input logic wen,            // write enable

   input logic [31:0] wd,      // write data

   output logic [31:0] rd0,    // read data
   output logic [31:0] rd1,

   input logic scan_mode
);

   logic [31:1] [31:0] pr_out;  // 31 x 32 bit PRs
   logic [31:1] [31:0] pr_in;
   logic [31:1] wv;             // one-hot write enable vector

   // PR Write Enables for power savings
   for ( genvar i=1; i<32; i++ ) begin
      rvdffe #(32) prff (.*, .en(wv[i]), .din(pr_in[i][31:0]), .dout(pr_out[i][31:0]));
   end

   // the read out
   always_comb begin
      rd0[31:0] = 32'b0;
      rd1[31:0] = 32'b0;
      wv[31:1] = 31'b0;
      pr_in[31:1] = '0;

      // PR Read logic
      for (int i=1; i<32; i++ ) begin
         rd0[31:0] |= ({32{rden0 & (raddr0[4:0] == 5'(i))}} & pr_out[i][31:0]);
         rd1[31:0] |= ({32{rden1 & (raddr1[4:0] == 5'(i))}} & pr_out[i][31:0]);
      end

      // PR Write logic
      for (int j=1; j<32; j++ ) begin
         wv[j] = wen & (waddr[4:0] == 5'(j));
         pr_in[j] = ({32{wv[j]}} & wd[31:0]);
      end
   end // always_comb begin

endmodule // dec_pr_ctl