`timescale 1ps / 1ps
`include "cache_consts.svh"
`include "cache_types.svh"

// regs.sv
// Author: Joseph Zuckerman
// llc registers 

module regs(clk, rst, rst_state, decode_en, update_en, rd_set_en, clr_rst_stall, rst_stall, clr_flush_stall, set_flush_stall, flush_stall, clr_req_stall, set_req_stall, req_stall, clr_req_in_stalled_valid, set_req_in_stalled_valid, req_in_stalled_valid, clr_rst_flush_stalled_set, incr_rst_flush_stalled_set, rst_flush_stalled_set, update_dma_addr_from_req, incr_dma_addr, dma_addr, clr_recall_pending, set_recall_pending, recall_pending, clr_dma_read_pending, set_dma_read_pending, dma_read_pending, clr_dma_write_pending, set_dma_write_pending, dma_write_pending, clr_recall_valid, set_recall_valid, recall_valid, clr_is_dma_read_to_resume, set_is_dma_read_to_resume_decoder, set_is_dma_read_to_resume_process, is_dma_read_to_resume, clr_is_dma_write_to_resume, set_is_dma_write_to_resume_decoder, set_is_dma_write_to_resume_process, is_dma_write_to_resume, update_req_in_stalled, req_in_stalled_set, req_in_stalled_tag, set_update_evict_way, update_evict_way, line_br );    
    
    input logic clk, rst, rst_state; 
    input logic decode_en, update_en, rd_set_en; 

    input logic clr_rst_stall;
    output logic rst_stall;
    
    input logic clr_flush_stall, set_flush_stall; 
    output logic flush_stall;

    input logic clr_req_stall, set_req_stall; 
    output logic req_stall;

    input logic clr_req_in_stalled_valid, set_req_in_stalled_valid;  
    output logic req_in_stalled_valid;      

    input logic clr_rst_flush_stalled_set, incr_rst_flush_stalled_set;
    output llc_set_t rst_flush_stalled_set;
  
    input logic update_dma_addr_from_req, incr_dma_addr; 
    output addr_t dma_addr;  
  
    input logic clr_recall_pending, set_recall_pending;    
    output logic recall_pending;   
    
    input logic clr_dma_read_pending, set_dma_read_pending;    
    output logic dma_read_pending;
   
    input logic clr_dma_write_pending, set_dma_write_pending;    
    output logic dma_write_pending; 
   
    input logic clr_recall_valid, set_recall_valid;    
    output logic recall_valid; 
    
    input logic clr_is_dma_read_to_resume, set_is_dma_read_to_resume_decoder, set_is_dma_read_to_resume_process; 
    output logic is_dma_read_to_resume;
    
    input logic clr_is_dma_write_to_resume, set_is_dma_write_to_resume_decoder, set_is_dma_write_to_resume_process; 
    output logic is_dma_write_to_resume; 
    
    input logic update_req_in_stalled; 
    output llc_set_t req_in_stalled_set; 
    output llc_tag_t req_in_stalled_tag;

    input logic set_update_evict_way;
    output logic update_evict_way;

    line_breakdown_llc_t line_br; 

    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state) begin 
            rst_stall <= 1'b1;
        end else if (clr_rst_stall) begin 
            rst_stall <= 1'b0;
        end
    end

    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state || clr_flush_stall) begin 
            flush_stall <= 1'b0; 
        end else if (set_flush_stall) begin 
            flush_stall <= 1'b1; 
        end
    end

    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state ||clr_req_stall) begin 
            req_stall <= 1'b0; 
        end else if (set_req_stall) begin 
            req_stall <= 1'b1; 
        end
    end

    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state || clr_req_in_stalled_valid) begin 
            req_in_stalled_valid <= 1'b0; 
        end else if (set_req_in_stalled_valid) begin 
            req_in_stalled_valid <= 1'b1; 
        end
    end
    
    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state || clr_rst_flush_stalled_set) begin 
            rst_flush_stalled_set <= 0; 
        end else if (incr_rst_flush_stalled_set && update_en) begin 
            rst_flush_stalled_set <= rst_flush_stalled_set + 1; 
        end
    end
   
    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state) begin 
            dma_addr <= 0; 
        end else if (update_dma_addr_from_req && rd_set_en) begin 
            dma_addr <= llc_dma_req_in.addr;
        end else if (incr_dma_addr) begin 
            dma_addr <= dma_addr + 1; 
        end 
    end
    
    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state || clr_recall_pending) begin 
            recall_pending <= 1'b0;
        end else if (set_recall_pending) begin 
            recall_pending <= 1'b1;
        end
    end
    
    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state || clr_dma_read_pending) begin 
            dma_read_pending <= 1'b0;
        end else if (set_dma_read_pending) begin 
            dma_read_pending <= 1'b1;
        end
    end
    
    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state ||clr_dma_write_pending) begin 
            dma_write_pending <= 1'b0;
        end else if (set_dma_write_pending) begin 
            dma_write_pending <= 1'b1;
        end
    end
    
    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state || clr_recall_valid) begin 
            recall_valid <= 1'b0;
        end else if (set_recall_valid) begin 
            recall_valid <= 1'b1;
        end
    end
    
    logic set_is_dma_read_to_resume;
    assign set_is_dma_read_to_resume = set_is_dma_read_to_resume_decoder | set_is_dma_read_to_resume_process;
    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state) begin 
            is_dma_read_to_resume = 1'b0;
        end else if (set_is_dma_read_to_resume) begin
            is_dma_read_to_resume = 1'b1;
        end else if (clr_is_dma_read_to_resume) begin 
            is_dma_read_to_resume = 1'b0; 
        end
    end 

    logic set_is_dma_write_to_resume;
    assign set_is_dma_write_to_resume = set_is_dma_write_to_resume_decoder | set_is_dma_write_to_resume_process;
    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state || clr_is_dma_write_to_resume) begin 
            is_dma_write_to_resume = 1'b0;
        end else if (set_is_dma_write_to_resume) begin
            is_dma_write_to_resume = 1'b1;
        end else if (clr_is_dma_write_to_resume) begin 
            is_dma_write_to_resume = 1'b0; 
        end
    end 

    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state) begin 
            req_in_stalled_set <= 0; 
            req_in_stalled_tag <= 0; 
        end else if (update_req_in_stalled) begin 
            req_in_stalled_set <= line_br.set; 
            req_in_stalled_tag <= line_br.tag;
        end
    end
    
    always_ff @(posedge clk or negedge rst) begin 
        if (!rst || rst_state || decode_en) begin 
            update_evict_way <= 1'b0;
        end else if (set_update_evict_way) begin 
            update_evict_way <= 1'b1; 
        end
    end
endmodule
