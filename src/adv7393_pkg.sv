package adv7393_pkg;

// Параметры блока  
localparam M_AXI_DWIDTH = 128;
localparam S_AXI_DWIDTH = 32 ;
localparam S_AXI_AWIDTH = 4  ;
localparam CSR_ENABLE   = 4  ;
localparam TEST_ENABLE  = 0  ;
localparam VERSION      = 0  ;

localparam REG_WIDTH         = 32;
localparam PIXELS_PER_SYMBOL = 4 ;
localparam AXIS_DWIDTH = M_AXI_DWIDTH;

typedef logic [REG_WIDTH-1:0] Reg_t;

typedef struct packed {
  Reg_t LineLength;   // Длина строчки в пикселях
  Reg_t Lines;        // Количество линий в фрейме
} FrameCtrl_t;        // Настройка фрейма

typedef struct packed {
  Reg_t Base;       // Базовый адрес буфера
  Reg_t LineStep;   // Шаг записи строки
  Reg_t Count;      // Количество кадров в буфере
} BufferCtrl_t;     // Настройка буфера

typedef struct packed {
  logic [7:0] version;  // Версия прошивки
  logic [23:0] dummy;
} Status_t;

typedef struct packed {
  int start;  
  int stop;
} LineActInterval_t;

typedef struct packed {
  int               Lines          ;
  int               PixelsPerLine  ;
  int               ActiveLines    ;
  int               LineFieldChange;
  int               BlankLineLen   ; // Ticks
  int               ActiveLineLen  ; // Ticks
  int               HSyncLen       ; // Ticks
} StandardCfg_t;

typedef struct packed {
  Status_t      status;
  FrameCtrl_t   frame;
  BufferCtrl_t  buffer;
  StandardCfg_t standard;
} ADV7393RegBlock_t;

localparam Reg_t BASE         = 'h10000;
localparam Reg_t LINE_STEP    = 'h1000;
localparam Reg_t COUNT        = 2;

localparam LINE_LEN           = 640;
localparam LINES              = 625;
localparam BUFFER_DEPTH       = LINE_LEN/PIXELS_PER_SYMBOL;
localparam BUFFER_COUNT       = COUNT;
localparam BUFFER_SIZE        = BUFFER_COUNT*BUFFER_DEPTH;
localparam LINES_CNT_W        = $clog2(LINES);

localparam LINE_LEN_ACT_T     = (1536);
localparam LINE_LEN_BLANK_T   = (352);
localparam LINE_LEN_T         = (LINE_LEN_BLANK_T + LINE_LEN_ACT_T);
localparam LINE_LEN_CNT_W     = $clog2(LINE_LEN_T);
localparam HSYNC_W            = 4;

localparam OUT_DWIDTH         = 10;

FrameCtrl_t frame_ctrl0      = '{ 640, 480 };
FrameCtrl_t frame_ctrl1      = '{ 640, 512 };

StandardCfg_t PAL625i = '{
  LINES, 
  768,
  576,
  313,
  LINE_LEN_BLANK_T, 
  LINE_LEN_ACT_T, 
  1 
};

ADV7393RegBlock_t def_config = {
  '{ VERSION, '0 },
  frame_ctrl0,
  '{ BASE, LINE_STEP, COUNT },
  PAL625i
};

typedef struct packed {
  logic [7:0] Y;
  logic [7:0] CbCr;
  logic [15:0] Dummy;
} Pixel_t;

typedef struct packed {
  logic [7:0] Y;
  logic [7:0] CbCr;
} PixelStored_t;

PixelStored_t blank_val = '{ 0, 0 };

localparam PIXEL_SIZE         = $size(Pixel_t);
localparam PIXEL_STORED_SIZE  = $size(PixelStored_t);
localparam COMPRESSED_WIDTH   = PIXEL_STORED_SIZE*PIXELS_PER_SYMBOL;

function PixelStored_t pixel_remove_dummy(Pixel_t pixel);
  automatic PixelStored_t ret = '0;
  ret.Y = pixel.Y;
  ret.CbCr = pixel.CbCr;
  return ret;
endfunction

function PixelStored_t [PIXELS_PER_SYMBOL-1:0] data2pixel(logic [M_AXI_DWIDTH-1:0] data);
  PixelStored_t [PIXELS_PER_SYMBOL-1:0] res;
  Pixel_t pix;

  for (int i = 0; i < PIXELS_PER_SYMBOL; i++) begin
    pix = data[i*$size(Pixel_t) +: $size(Pixel_t)];
    res[i] = pixel_remove_dummy(pix);
  end

  return res;
endfunction

function logic [COMPRESSED_WIDTH-1:0] pixels2data (PixelStored_t [PIXELS_PER_SYMBOL-1:0] pixels);
  pixels2data = pixels;
endfunction

function logic [COMPRESSED_WIDTH-1:0] compress_data(logic [M_AXI_DWIDTH-1:0] data);
  compress_data = pixels2data(data2pixel(data));
endfunction

function logic [31:0] line_offset(logic [31:0] frame_base, logic [LINES_CNT_W:0] line2read);
  line_offset = frame_base + line2read*LINE_STEP;
endfunction

function logic [31:0] frame_base(ADV7393RegBlock_t regs, logic fb_sel);
  frame_base = fb_sel ? regs.buffer.Base + regs.frame.Lines*LINE_STEP : regs.buffer.Base;
endfunction

function LineActInterval_t frame_align_center(ADV7393RegBlock_t registers);
  frame_align_center.start  = (registers.standard.ActiveLines - registers.frame.Lines)/2;
  frame_align_center.stop   = frame_align_center.start + registers.frame.Lines;
endfunction

function logic blank_line([LINES_CNT_W-1:0] line2read,  LineActInterval_t interval);
  return (((line2read) >= (interval.start)) && ((line2read) <= (interval.stop)));
endfunction

function logic [15:0] reverse_vector_out(input logic [15:0] din);
  automatic logic [15:0] ret = '0;        
  for (int i = 0; i < $size(din); i++) begin
      ret[i] = din[$size(din)-1-i];
  end
  return ret;
endfunction

function logic [15:0] pixel2out(PixelStored_t pixel, logic data_phase);
  logic [15:0] value;
  value = data_phase ? pixel.Y : pixel.CbCr;

  return reverse_vector_out(value);
endfunction

function PixelStored_t data2pixel_stored(logic [PIXEL_STORED_SIZE-1:0] data);
  data2pixel_stored.Y = data[7:0];    //! Need to rewrite
  data2pixel_stored.CbCr = data[15:8];  //! Need to rewrite
endfunction : data2pixel_stored

endpackage : adv7393_pkg