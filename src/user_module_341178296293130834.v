`default_nettype none

// Keep I/O fixed for TinyTapeout
module user_module_341178296293130834(
  input [7:0] io_in,
  output [7:0] io_out
);
  /* Inputs */
  wire CLK;
  wire RST;
  wire [3:0]IR_IN;
  wire DATAIN;
  assign CLK = io_in[0];
  assign RST = io_in[1];
  assign IR_IN = io_in[5:2];
  assign DATAIN = io_in[6];

  /* Outputs */
  wire FL0;
  wire JMP;
  wire RTN;
  wire FLF;
  reg DATAOUT;
  reg WRT;
  reg RR;
  reg C;

  assign io_out[0] = FL0;
  assign io_out[1] = JMP;
  assign io_out[2] = RTN;
  assign io_out[3] = FLF;
  assign io_out[4] = DATAOUT;
  assign io_out[5] = WRT;
  assign io_out[6] = RR;
  assign io_out[7] = C;

  /* Module body */
  reg IEN;
  reg OEN;
  reg SKZ;
  reg PHASE;

  `define I_NOP0  4'b0000
  `define I_LD    4'b0001
  `define I_ADD   4'b0010
  `define I_SUB   4'b0011
  `define I_ONE   4'b0100
  `define I_NAND  4'b0101
  `define I_OR    4'b0110
  `define I_XOR   4'b0111
  `define I_STO   4'b1000
  `define I_STOC  4'b1001
  `define I_IEN   4'b1010
  `define I_OEN   4'b1011
  `define I_JMP   4'b1100
  `define I_RTN   4'b1101
  `define I_SKZ   4'b1110
  `define I_NOPF  4'b1111

  reg [3:0] IR;
  assign FL0 = IR == `I_NOP0;
  assign JMP = IR == `I_JMP;
  assign RTN = IR == `I_RTN;
  assign FLF = (IR == `I_NOPF) && !SKZ;
  wire DATAIFEN;
  assign DATAIFEN = DATAIN & IEN;

  always@(posedge CLK)
  begin
    if(RST)
    begin
      IEN <= 0;
      OEN <= 0;
      SKZ <= 0;
      RR <= 0;
      C <= 0;
      WRT <= 0;
      PHASE <= 0;
    end
    else
    begin
      if(!PHASE)
      begin
        PHASE <= 1;
        IR <= IR_IN | (SKZ & IR_IN);
        WRT <= 0;
        DATAOUT <= 0;
        case (IR)
          `I_ONE:
            begin
              RR <= 1;
              C <= 0;
            end
          `I_STO:
            begin
              if(OEN)
              begin
                DATAOUT = RR;
              end
            end
          `I_STOC:
            begin
              if(OEN)
              begin
                DATAOUT = !RR;
              end
            end
          `I_RTN:
            begin
              SKZ <= 1;
            end
          `I_SKZ:
            begin
              if(!RR)
                SKZ <= 1;
            end 
        endcase
      end else begin
      PHASE <= 0;
      case (IR)
        `I_LD:
          begin
            RR <= DATAIFEN;
          end
        `I_ADD:
          begin
            RR <= DATAIFEN ^ RR ^ C; 
            C <= DATAIFEN & RR | C & RR | C & DATAIFEN;
          end
        `I_SUB:
          begin
            RR <= !DATAIFEN ^ RR ^ C; 
            C <= DATAIFEN & RR | C & RR | C & DATAIFEN;
          end
        `I_NAND:
          begin
            RR <= !(RR & DATAIFEN);
          end
        `I_OR:
          begin
            RR <= RR | DATAIFEN;
          end
        `I_XOR:
          begin
            RR <= RR ^ DATAIFEN;
          end
        `I_STO:
          begin
            if(OEN)
            begin
              WRT <= 1;
            end
          end
        `I_STOC:
          begin
            if(OEN)
            begin
              WRT <= 1;
            end
          end
        `I_IEN:
          begin
            IEN <= DATAIN;
          end
        `I_OEN:
          begin
            OEN <= DATAIN;
          end
      endcase 
    end
  end
end
endmodule
