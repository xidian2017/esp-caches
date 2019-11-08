`timescale 1ps / 1ps
`include "cache_consts.svh" 
`include "cache_types.svh"

// l2_core.sv
// Author: Joseph Zuckerman
// top level l2 cache module

module l2_core(clk, rst, l2_cpu_req_valid, l2_cpu_req, l2_cpu_req_ready, l2_fwd_in_valid, l2_fwd_in, l2_fwd_in_ready, l2_rsp_in_valid, l2_rsp_in, l2_rsp_in_ready, l2_req_out_ready, l2_req_out_valid, l2_req_out, l2_rsp_out_ready, l2_rsp_out_valid, l2_rsp_out, l2_rd_rsp_ready, l2_rd_rsp_valid, l2_rd_rsp, l2_flush_valid, l2_flush_data, l2_flush_ready, l2_inval_ready, l2_inval_valid, l2_inval_data
`ifdef STATS_ENABLE
    , l2_stats_ready, l2_stats_valid, l2_stats_data
`endif
);

    input clk, rst; 

    input logic l2_cpu_req_valid; 
    output logic l2_cpu_req_ready;
    l2_cpu_req_t.in l2_cpu_req;

    input logic l2_fwd_in_valid;
    output logic l2_fwd_in_ready; 
    l2_fwd_in_t.in l2_fwd_in; 

    input logic l2_rsp_in_valid;
    output logic l2_rsp_in_ready; 
    l2_rsp_in_t.in l2_rsp_in; 
    
    input logic l2_req_out_ready; 
    output logic l2_req_out_valid;
    l2_req_out.out l2_req_out;

    input logic l2_rsp_out_ready; 
    output logic l2_rsp_out_valid; 
    l2_rsp_out.out l2_rsp_out;

    input logic l2_rd_rsp_ready;
    output logic l2_rd_rsp_valud; 
    l2_rd_rsp.out l2_rd_rsp; 

    input logic l2_flush_valid;
    input logic l2_flush_data;
    output logic l2_flush_ready;

    input logic l2_inval_ready;
    output logic l2_inval_valid;
    output l2_inval_t l2_inval_data;

    output logic flush_done; 

`ifdef STATS_ENABLE
    input logic l2_stats_ready;
    output logic l2_stats_valid;
    output logic l2_stats_data; 
`endif 

endmodule
