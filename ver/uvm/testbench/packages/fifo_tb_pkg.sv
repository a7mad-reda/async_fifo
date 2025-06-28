package fifo_tb_pkg;

  typedef struct packed {
    logic [`DATA_WD -1:0] data;
    logic                 overflow;
    logic                 underflow;
  } pkt_mon_pkt_s;

  typedef enum logic [3:0] {
    EMPTY      = 4'b0001,
    NEAR_EMPTY = 4'b0010,
    NEAR_FULL  = 4'b0100,
    FULL       = 4'b1000
  } fifo_state_t;

endpackage
