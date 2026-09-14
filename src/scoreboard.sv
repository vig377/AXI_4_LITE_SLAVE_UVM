class scoreboard extends uvm_scoreboard;

`uvm_component_utils(scoreboard)

bit [`DATA_WIDTH-1:0]mem[bit[`ADDR_WIDTH-1:0]];
  bit [7:0] MATCH,MISMATCH;
uvm_tlm_analysis_fifo#(trans)in_wrt_fifo;
uvm_tlm_analysis_fifo#(trans)in_rd_fifo;
uvm_tlm_analysis_fifo#(trans)out_wrt_fifo;
uvm_tlm_analysis_fifo#(trans)out_rd_fifo;

bit [1:0]BRESP,RRESP;
bit [`DATA_WIDTH-1:0]RDATA;

trans wrt,rd,out_wrt,out_rd;

function new(string name,uvm_component parent);
  super.new(name,parent);
  in_wrt_fifo=new("in_wrt_fifo",this);
  in_rd_fifo=new("in_rd_fifo",this);
  out_wrt_fifo=new("out_wrt_fifo",this);
  out_rd_fifo=new("out_rd_fifo",this);
endfunction
  
  function bit write_valid(bit[`ADDR_WIDTH-1:0]addr);
    if((addr>=0 && addr<=36)||(addr>=52 && addr<=56)||(addr==60))
      return 1;
    else
      return 0;
  endfunction
  
  function bit read_valid(bit[`ADDR_WIDTH-1:0]addr);
    if((addr>=0 && addr<=36) || (addr>=40 && addr<=48) || (addr==60))
      return 1;
   else
     return 0;
  endfunction

task run_phase(uvm_phase phase);
  forever
    begin
      fork
        begin
          in_wrt_fifo.get(wrt);
            write();
        end
        begin
          in_rd_fifo.get(rd);
            read();
        end
      join_any
end
endtask

task write();
  if(wrt.AWADDR >63)
    begin
      BRESP=2'b11;
    end
  else if(wrt.AWADDR %4!=0)
    	begin
          BRESP=2'b10;
        end
  else if(write_valid(wrt.AWADDR))
    begin
      foreach(wrt.WSTRB[i])
        begin
          if(wrt.WSTRB[i])
            mem[wrt.AWADDR][i*8+:8]=wrt.WDATA[i*8+:8];
        end
      BRESP=2'b00;
    end
 else
   BRESP=2'b10;
  out_wrt_fifo.get(out_wrt);
  if(out_wrt.BRESP == BRESP)
    begin
      MATCH++;
      `uvm_info("SCB",$sformatf("WRITE MATCH AWADDR=%0d WDATA=%0d WSTRB=%b EXP_BRESP=%b GOT_BRESP=%b",
               wrt.AWADDR,
               wrt.WDATA,
               wrt.WSTRB,
               BRESP,
                                out_wrt.BRESP),UVM_LOW)
    end
  else
    begin
      MISMATCH++;
      `uvm_error("SCB" ,$sformatf("WRITE MISMATCH  AWADDR=%0d WDATA=%0d WSTRB=%b EXP_BRESP=%b GOT_BRESP=%b",
               wrt.AWADDR,
               wrt.WDATA,
               wrt.WSTRB,
               BRESP,
                                  out_wrt.BRESP))
    end
      
endtask

task read();
  if(rd.ARADDR >63)
    begin
      RRESP=2'b11;
      RDATA=0;
    end
  else if(rd.ARADDR %4!=0)
    begin
      RRESP=2'b10;
      RDATA=0;
    end
  else if(read_valid(rd.ARADDR))
    begin
      RRESP=2'b00;
      if(mem.exists(rd.ARADDR))
        RDATA=mem[rd.ARADDR];
      else
         RDATA=0;
    end
   else
     begin
     	RRESP=2'b10;
        RDATA=0;
     end
      out_rd_fifo.get(out_rd);
      if(RDATA == out_rd.RDATA && RRESP == out_rd.RRESP)
        begin
          MATCH++;
          `uvm_info("SCB" ,$sformatf("READ MATCH ARADDR=%0d EXP_RDATA=%0d EXP_RRESP=%b GOT_RDATA=%0d GOT_RRESP=%b",
   rd.ARADDR,
   RDATA,
   RRESP,
   out_rd.RDATA,
                                     out_rd.RRESP),UVM_LOW)
        end
      else
        begin
          MISMATCH++;
          `uvm_error("SCB" ,$sformatf("READ MISAMTCH ARADDR=%0d EXP_RDATA=%0d EXP_RRESP=%b GOT_RDATA=%0d GOT_RRESP=%b",
   rd.ARADDR,
   RDATA,
   RRESP,
   out_rd.RDATA,
                                      out_rd.RRESP))
        end

                      
endtask

function void report_phase(uvm_phase phase);
  `uvm_info("SCB",$sformatf("TOTAL TRANSACTION = %d MATCH = %d MISMATCH = %d ",MATCH+MISMATCH,MATCH,MISMATCH),UVM_LOW)
endfunction

endclass
