class virtual_seq extends uvm_sequence;
  `uvm_object_utils(virtual_seq)
  
  first_addr_then_data sq1;
  read_normal sq2;
  strobe_all_zero sq3;
  first_data_then_addr sq4;
  strobe_all_random sq5;
  strobe_all_one sq6;
  unaligned_write sq7;
  read_only_write sq8;
  dec_write sq9;
  read_unaligned sq10;
  write_only_read sq11;
  dec_read sq12;
 
  `uvm_declare_p_sequencer(virtual_sqr)
  
  function new(string name="virtual_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    sq1=first_addr_then_data::type_id::create("sq1");
    sq2=read_normal::type_id::create("sq2");
    sq3=strobe_all_zero::type_id::create("sq3");
    sq4=first_data_then_addr::type_id::create("sq4");
    sq5=strobe_all_random::type_id::create("sq5");
    sq6=strobe_all_one::type_id::create("sq6");
    sq7=unaligned_write::type_id::create("sq7");
    sq8=read_only_write::type_id::create("sq8");
    sq9=dec_write::type_id::create("sq9");
    sq10= read_unaligned::type_id::create("sq10");
    sq11=write_only_read::type_id::create("sq11");
    sq12=dec_read::type_id::create("sq12");
    $display("FIRST ADDR THEN DATA TEST\n");
    sq1.start(p_sequencer.sqr1);
//     sq2.start(p_sequencer.sqr2);
    $display("STRB ALL 0 \n");
    sq3.start(p_sequencer.sqr1);
    //sq2.start(p_sequencer.sqr2);
    $display("FIRST DATA THEN ADDR TEST\n");
    sq4.start(p_sequencer.sqr1);
//     sq2.start(p_sequencer.sqr2);
    $display("STRB ALL RANDOM TEST\n");
    sq5.start(p_sequencer.sqr1);
//     sq2.start(p_sequencer.sqr2);
    $display("STRB ALL ONE TEST\n");
    sq6.start(p_sequencer.sqr1);
//     sq2.start(p_sequencer.sqr2);
    $display("UNALIGNED WRITE TEST\n");
    sq7.start(p_sequencer.sqr1);
//     sq2.start(p_sequencer.sqr2);
    $display("READ ONLY WRITE TEST\n");
    sq8.start(p_sequencer.sqr1);
    // sq2.start(p_sequencer.sqr2);
    $display("DEC ERR WRITE TEST\n");
    sq9.start(p_sequencer.sqr1);
//    sq2.start(p_sequencer.sqr2);
    $display("READ UNALIGNED TEST\n");
    sq10.start(p_sequencer.sqr2);
    $display("WRITE ONLY READ TEST\n");
    sq11.start(p_sequencer.sqr2);
    $display("DEC ERR READ TEST\n");
    sq12.start(p_sequencer.sqr2);
   
    
  endtask
endclass
  
  
