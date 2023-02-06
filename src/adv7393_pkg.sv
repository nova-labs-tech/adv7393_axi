package adv7393_pkg;

// Параметры блока  
parameter M_AXI_DWIDTH = 128;
parameter S_AXI_DWIDTH = 32 ;
parameter S_AXI_AWIDTH = 4  ;
parameter CSR_ENABLE   = 4  ;
parameter TEST_ENABLE  = 0  ;
parameter VERSION      = 0  ;

parameter REG_WIDTH         = 32;
parameter PIXELS_PER_SYMBOL = 4 ;

typedef logic [REG_WIDTH-1:0] Reg_t;

typedef struct {
  Reg_t LineLength;   // Длина строчки в пикселях
  Reg_t Lines;        // Количество линий в фрейме
} FrameCtrl_t;        // Настройка фрейма

typedef struct {
  Reg_t Base;       // Базовый адрес буфера
  Reg_t LineStep;   // Шаг записи строки
  Reg_t Count;      // Количество кадров в буфере
} BufferCtrl_t;     // Настройка буфера

typedef struct {
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
  int               LineFieldChange;
  LineActInterval_t Odd            ;
  LineActInterval_t Even           ;
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

parameter Reg_t BASE         = 'h10000;
parameter Reg_t LINE_STEP    = 'h1000;
parameter Reg_t COUNT        = 2;

parameter LINE_LEN           = 640;
parameter LINES              = 625;
parameter BUFFER_DEPTH       = LINE_LEN/PIXELS_PER_SYMBOL;
parameter BUFFER_COUNT       = COUNT;
parameter BUFFER_SIZE        = BUFFER_COUNT*BUFFER_DEPTH;
parameter LINES_CNT_W        = $clog2(LINES);

parameter LINE_LEN_ACT_T     = (1536);
parameter LINE_LEN_BLANK_T   = (352);
parameter LINE_LEN_T         = (LINE_LEN_BLANK_T + LINE_LEN_ACT_T);
parameter LINE_LEN_CNT_W     = $clog2(LINE_LEN_T);
parameter HSYNC_W            = 4;

parameter OUT_DWIDTH         = 10;

FrameCtrl_t frame_ctrl0 = '{ 640, 480 };
FrameCtrl_t frame_ctrl1 = '{ 640, 512 };

StandardCfg_t PAL625i = '{
  LINES, 
  768,
  313,
  '{ 23, 310 }, 
  '{ 336, 623 },
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

parameter PIXEL_SIZE         = $size(Pixel_t)/8;
parameter PIXEL_STORED_SIZE  = $size(PixelStored_t)/8;
parameter COMPRESSED_WIDTH   = PIXEL_STORED_SIZE*PIXELS_PER_SYMBOL;

function PixelStored_t pixel_remove_dummy(Pixel_t pixel);
  PixelStored_t ret = '0;
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

endpackage : adv7393_pkg