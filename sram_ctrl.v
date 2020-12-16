
//*******************************************************************************************
//*******************************************************************************************
//
// Module name : SRAM controller
//
// Reset : no reset (memory and combination logic)
//
// Clock : gated main clock
//
// Function Description : interface SRAM with masters (SPI, AFEC, Filter)
//
// Version : 2020.11.27 v0.1 first release
//
//*******************************************************************************************
//*******************************************************************************************

`timescale 1ns/10ps

module sram_ctrl (

   // Input
   i_testen,
   i_test_mem_ck,
   i_test_mem_csb,
   i_test_mem_a,
   i_test_mem_web,
   i_test_mem_di,
   i_test_buf_a_valid,

   i_afec_mem_ck,
   i_afec_mem_csb,
   i_afec_mem_a,
   i_afec_mem_web,
   i_afec_mem_di,
   i_afec_data_access,

   i_rsf_mem_ck,
   i_rsf_mem_csb,
   i_rsf_mem_a,
   i_rsf_mem_web,
   i_rsf_mem_di,
   i_rsf_data_access,

   i_spi_mem_ck,
   i_spi_mem_csb,
   i_spi_mem_a,
   i_spi_mem_web,
   i_spi_mem_di,
   i_spi_data_access,

   i_dbuf_sel,
   i_fbufr_en,
   i_dbufr_en,
   i_dbufw_en,
   i_sbufr_en,

   // Output
   o_test_mem_do,
   o_afec_mem_do,
   o_rsf_mem_do,
   o_spi_mem_do
);

   // MBIST I/F
   input          i_testen;
   input          i_test_mem_ck;
   input          i_test_mem_csb;
   input  [11:0]  i_test_mem_a;
   input          i_test_mem_web;
   input  [13:0]  i_test_mem_di;
   input          i_test_buf_a_valid;

   output [13:0]  o_test_mem_do;


   // AFEC I/F
   input          i_afec_data_access;
   input          i_afec_mem_ck;
   input          i_afec_mem_csb;
   input  [11:0]  i_afec_mem_a;
   input          i_afec_mem_web;
   input  [13:0]  i_afec_mem_di;

   output [13:0]  o_afec_mem_do;

   // RSF I/F
   input          i_rsf_data_access;
   input          i_rsf_mem_ck;
   input          i_rsf_mem_csb;
   input  [11:0]  i_rsf_mem_a;
   input          i_rsf_mem_web;
   input  [13:0]  i_rsf_mem_di;

   output [13:0]  o_rsf_mem_do;

   // SPI I/F
   input          i_spi_data_access;
   input          i_spi_mem_ck;
   input          i_spi_mem_csb;
   input  [11:0]  i_spi_mem_a;
   input          i_spi_mem_web;
   input  [13:0]  i_spi_mem_di;

   output [13:0]  o_spi_mem_do;

   // REGS_ALL I/F
   input  [1:0]   i_dbuf_sel;
   input          i_fbufr_en;
   input          i_sbufr_en;
   input          i_dbufr_en;
   input          i_dbufw_en;

   // Wire declaration
   wire   [13:0]  o_test_mem_do;
   wire   [13:0]  o_afec_mem_do;
   wire   [13:0]  o_rsf_mem_do;
   wire   [13:0]  o_spi_mem_do;

   wire   [13:0]  mem_di;
   wire   [13:0]  mem_do;

   wire   [13:0]  mem_d;
   wire   [11:0]  mem_a;
   wire           mem_wen;
   wire           mem_cen;
   wire           mem_clk;

   // Main code
   assign mem_clk = (i_testen) ? i_test_mem_ck :
                    (i_afec_data_access) ? i_afec_mem_ck :
                    (i_rsf_data_access)  ? i_rsf_mem_ck  :
                    //(i_spi_data_access)  ? i_spi_mem_ck  : 1'b0;
                    (!i_spi_mem_csb)  ? i_spi_mem_ck  : 1'b0;

   assign mem_cen = (i_testen) ? i_test_mem_csb :
                    (i_afec_data_access) ? i_afec_mem_csb :
                    (i_rsf_data_access)  ? i_rsf_mem_csb  :
                    //(i_spi_data_access)  ? i_spi_mem_csb  : 1'b0;
                    (!i_spi_mem_csb)  ? 1'b0  : 1'b1;

   assign mem_a   = (i_testen) ? i_test_mem_a :
                    (i_afec_data_access) ? i_afec_mem_a :
                    (i_rsf_data_access)  ? i_rsf_mem_a  :
                    //(i_spi_data_access)  ? i_spi_mem_a  : 1'b0;
                    ((!i_spi_mem_csb) && i_fbufr_en) ? i_spi_mem_a :
                    ((!i_spi_mem_csb) && (i_dbufr_en || i_dbufw_en) && (i_dbuf_sel==2'b00)) ? i_spi_mem_a + 12'd560  :
                    ((!i_spi_mem_csb) && (i_dbufr_en || i_dbufw_en) && (i_dbuf_sel==2'b01)) ? i_spi_mem_a + 12'd1120 :
                    ((!i_spi_mem_csb) && (i_dbufr_en || i_dbufw_en) && (i_dbuf_sel==2'b10)) ? i_spi_mem_a + 12'd1680 :
                    ((!i_spi_mem_csb) && i_sbufr_en) ? i_spi_mem_a + 12'd2240 : 1'b0;

   assign mem_wen = (i_testen) ? i_test_mem_web :
                    (i_afec_data_access) ? i_afec_mem_web :
                    (i_rsf_data_access)  ? i_rsf_mem_web  :
                    //(i_spi_data_access)  ? i_spi_mem_web  : 1'b1;
                    (!i_spi_mem_csb)  ? i_spi_mem_web  : 1'b1;

   assign mem_di  = (i_testen) ? i_test_mem_di :
                    (i_afec_data_access) ? i_afec_mem_di :
                    (i_rsf_data_access)  ? i_rsf_mem_di  :
                    //(i_spi_data_access)  ? i_spi_mem_di  : 1'b0;
                    (!i_spi_mem_csb)  ? i_spi_mem_di  : 14'b0;

   assign o_test_mem_do = (i_testen) ? mem_do : 14'b0;
   assign o_afec_mem_do = (i_afec_data_access) ? mem_do : 14'b0;
   assign o_rsf_mem_do  = (i_rsf_data_access)  ? mem_do : 14'b0;
   //assign o_spi_mem_do  = (i_spi_data_access)  ? mem_do : 14'b0;
   assign o_spi_mem_do  = (!i_spi_mem_csb)  ? mem_do : 14'b0;

   // SRAM intantiation
 /*
   SRAM2500X14 sram (
                       // Inputs
                       .CLK             (mem_clk),
                       .CEN             (mem_cen),
                       .WEN             (mem_wen),
                       .A               (mem_a[11:0]),
                       .D               (mem_di[13:0]),

                       // Outputs
                       .Q               (mem_do[13:0])
                    );
*/

// To use SRAM in G1M77 for test
   SRAM12288X32 sram (
                       // Inputs
                       .CLK             (mem_clk),
                       .CEN             (mem_cen),
                       .WEN             ({4{mem_wen}}),
                       .A               ({2'b0, mem_a[11:0]}),
                       .D               ({18'b0, mem_di[13:0]}),

                       // Outputs
                       .Q               (mem_do[13:0])
                    );


endmodule
