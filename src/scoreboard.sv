class scoreboard extends uvm_scoreboard;

`uvm_component_utils(scoreboard)

bit [`DATA_WIDTH-1:0]mem[bit[`ADDR_WIDTH-1:0]];
bit MATCH,MISMATCH;
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

task run_phase(uvm_phase phase);
  forever 
    begin
      fork
        begin
          if( in_wrt_fifo.try_get(wrt))
            write();
        end
        begin
           if(in_rd_fifo.try_get(rd))
            read();
        end
      join
end
endtask

task write();
  if(wrt.AWADDR % 4==0 && wrt.AWADDR <=63)
    begin
    foreach(wrt.WSTRB[i])
      if(wrt.WSTRB[i])
        mem[wrt.AWADDR][i*8+:8]=wrt.WDATA[i*8+:8];
    BRESP=2'b00;
    out_wrt_fifo.get(out_wrt);
    if(out_wrt.BRESP==BRESP)
      begin
      MATCH++;
      $display("write trans matched  input  AWADDR = %d WDATA = %d WSTRB = %b exp BRESP = %b got BRESP = %b",wrt.AWADDR,wrt.WDATA,wrt.WSTRB,BRESP,out_wrt.BRESP);
      end
    else
      begin
      MISMATCH++;
      $display("write transaction mismatch input AWADDR = %d WDATA = %d WSTRB = %d exp BRESP = %b got BRESP =%b",wrt.AWADDR,wrt.WDATA,wrt.WSTRB,BRESP,out_wrt.BRESP);
      end
    end
  else if(wrt.AWADDR %4!=0 && wrt.AWADDR<=63)
    begin
        BRESP=2'b10;
        out_wrt_fifo.get(out_wrt);
      if(out_wrt.BRESP==BRESP)
      begin
        MATCH++;
        $display("write transction matched input AWADDR = %d WDATA = %d WSTRB = %d exp BRESP = %b got BRESP = %b ",wrt.AWADDR,wrt.WDATA,wrt.WSTRB,BRESP,out_wrt.BRESP);
      end
      else
        begin
        MISMATCH++;
        $display("write transaction mismatch input AWADDR = %d WDATA = %d WSTRB = %d exp BRESP = %b got BRESP =%b",wrt.AWADDR,wrt.WDATA,wrt.WSTRB,BRESP,out_wrt.BRESP);
      end
    end
  else 
    begin
    BRESP=2'b11;
    out_wrt_fifo.get(out_wrt);
    if(out_wrt.BRESP == BRESP)
      begin
        MATCH++;
        $display("write transaction match input AWADDR = %d WDATA = %d WSTRB = %d exp BRESP = %b got BRESP =%b",wrt.AWADDR,wrt.WDATA,wrt.WSTRB,BRESP,out_wrt.BRESP);
      end
    else
      begin
      MISMATCH++;
      $display("write transaction mismatch input AWADDR = %d WDATA = %d WSTRB = %d exp BRESP = %b got BRESP =%b",wrt.AWADDR,wrt.WDATA,wrt.WSTRB,BRESP,out_wrt.BRESP);
      end
    end
endtask

task read();
  if(mem.exists(rd.ARADDR))
    begin
    RDATA=mem[rd.ARADDR];
    RRESP=2'b00;
    out_rd_fifo.get(out_rd);
    if(RDATA == out_rd.RDATA && RRESP == out_rd.RRESP)
      begin
      MATCH++;
      $display("rd transction match ARADDR = %d exp RDATA = %d RRESP = %b got RDATA =%d RRESP = %b",rd.ARADDR,RDATA,RRESP,out_rd.RDATA,out_rd.RRESP);
      end
    else
      begin
      MISMATCH++;
      $display("rd transction mismatch ARADDR = %d exp RDATA = %d RRESP = %b got RDATA =%d RRESP = %b",rd.ARADDR,RDATA,RRESP,out_rd.RDATA,out_rd.RRESP);
      end
    end
  else if(rd.ARADDR %4 ==0 && rd.ARADDR <=63)
      begin
      RRESP=2'b00;
      out_rd_fifo.get(out_rd);
      if(RDATA == out_rd.RDATA && RRESP == out_rd.RRESP)
        begin
        MATCH++;
        $display("rd transction match ARADDR = %d exp RDATA = %d RRESP = %b got RDATA =%d RRESP = %b",rd.ARADDR,RDATA,RRESP,out_rd.RDATA,out_rd.RRESP);
        end
      else
        begin
        MISMATCH++;
        $display("rd transction mismatch ARADDR = %d exp RDATA = %d RRESP = %b got RDATA =%d RRESP = %b",rd.ARADDR,RDATA,RRESP,out_rd.RDATA,out_rd.RRESP);
        end
      end
  else if(rd.ARADDR %4!=0 && rd.ARADDR<=63)
    begin
    RRESP=2'b10;
    out_rd_fifo.get(out_rd);
    if(RDATA == out_rd.RDATA && RRESP == out_rd.RRESP)
      begin
      MATCH++;
      $display("rd transction match ARADDR = %d exp RDATA = %d RRESP = %b got RDATA =%d RRESP = %b",rd.ARADDR,RDATA,RRESP,out_rd.RDATA,out_rd.RRESP);
      end
    else
      begin
      MISMATCH++;
      $display("rd transction mismatch ARADDR = %d exp RDATA = %d RRESP = %b got RDATA =%d RRESP = %b",rd.ARADDR,RDATA,RRESP,out_rd.RDATA,out_rd.RRESP);
      end
    end
  else
    begin
    RRESP=2'b11;
    out_rd_fifo.get(out_rd);
    if(RDATA == out_rd.RDATA && RRESP == out_rd.RRESP)
      begin
      MATCH++;
      $display("rd transction match ARADDR = %d exp RDATA = %d RRESP = %b got RDATA =%d RRESP = %b",rd.ARADDR,RDATA,RRESP,out_rd.RDATA,out_rd.RRESP);
      end
    else
      begin
      MISMATCH++;
      $display("rd transction mismatch ARADDR = %d exp RDATA = %d RRESP = %b got RDATA =%d RRESP = %b",rd.ARADDR,RDATA,RRESP,out_rd.RDATA,out_rd.RRESP);
      end
    end
endtask

function void report_phase(uvm_phase phase);
  `uvm_info("SCB",$sformatf("TOTAL TRANSACTION = %d MATCH = %d MISMATCH = %d ",MATCH+MISMATCH,MATCH,MISMATCH),UVM_LOW)
endfunction

endclass
