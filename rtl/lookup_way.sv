`timescale 1ps / 1ps 
`include "cache_consts.svh"
`include "cache_types.svh"

//lookup_way.sv 
//Author: Joseph Zuckerman
//looks up way for eviction/replacement 

module lookup_way (clk, rst, tag, tags_buf, states_buf, evict_way_buf, lookup_en, way, evict); 
    
    input logic clk, rst; 
    input llc_tag_t tag; 
    input llc_tag_t tags_buf[`LLC_WAYS];
    input llc_state_t states_buf[`LLC_WAYS];
    input llc_way_t evict_way_buf;
    input logic lookup_en; 

    output llc_way_t way;
    output logic evict;  

    
    //LOOKUP
    logic [`LLC_WAYS - 1:0] tag_hits_tmp, empty_ways_tmp, evict_valid_tmp, evict_not_sd_tmp; 
    llc_way_t way_tmp;
    always_comb begin 
        for (int i = 0; i < `LLC_WAYS; i++) begin
            tag_hits_tmp[i] = (tags_buf[i] == tag && states_buf[i] != `INVALID);
            empty_ways_tmp[i] = (states_buf[i] == `INVALID); 
            
            way_tmp = i + evict_way_buf;
            evict_valid_tmp[way_tmp] = (states_buf[way_tmp] == `VALID);
            evict_not_sd_tmp = (states_buf[way_tmp] != `SD); 
        end
    end 

    //way priority encoder
    llc_way_t hit_way, empty_way, evict_way_valid, evict_way_not_sd;
    always_comb begin 
        hit_way = 0;
        empty_way = 0; 
        evict_way_valid = 0;
        evict_way_not_sd = 0; 
        for (int j = `LLC_WAYS-1; j >= 0; j--) begin 
            if (tag_hits_tmp[j]) begin 
                hit_way = j; 
            end 

            if (empty_ways_tmp[j]) begin 
                empty_way = j; 
            end 
        
            if (evict_valid_tmp[j]) begin 
                evict_way_valid = j; 
            end 
        
            if (evict_not_sd_tmp[j]) begin 
                evict_way_not_sd = j; 
            end 
        end
    end

    //handle case for 0 bit
    logic tag_hit, empty_way_found, evict_valid, evict_not_sd; 
    assign tag_hit = |tag_hits_tmp; 
    assign empty_way_found = |empty_ways_tmp;
    assign evict_valid = |evict_valid_tmp; 
    assign evict_not_sd = |evict_not_sd_tmp;

    llc_way_t way_next;
    logic evict_next; 
    always_comb begin 
        if (tag_hit) begin 
            way_next = hit_way;
            evict_next = 1'b0;
        end else if (empty_way_found) begin 
            way_next = empty_way;
            evict_next = 1'b0; 
        end else if (evict_valid) begin 
            way_next = evict_way_valid;
            evict_next = 1'b1;
        end else if (evict_not_sd) begin 
            way_next = evict_way_not_sd;
            evict_next = 1'b1;
        end else begin 
            way_next = evict_way_buf;
            evict_next = 1'b1; 
        end 
    end

    //flop outputs
    always_ff @(posedge clk or negedge rst) begin 
        if (!rst) begin 
            way <= 0; 
            evict <= 1'b0; 
        end else if (lookup_en) begin
            way <= way_next;
            evict <= evict_next;
        end 
    end
endmodule
