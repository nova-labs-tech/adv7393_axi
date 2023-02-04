package adv7393_pkg;

// Параметры блока  
parameter M_AXI_DWIDTH = 128;
parameter S_AXI_DWIDTH = 32 ;
parameter S_AXI_AWIDTH = 4  ;
parameter CSR_ENABLE   = 4  ;
parameter TEST_ENABLE  = 0  ;
parameter VERSION      = 0  ;

localparam REG_WIDTH         = 32;
localparam PIXELS_PER_SYMBOL = 4 ;

typedef logic [REG_WIDTH-1:0] Reg_t;

typedef struct {
  Reg_t LineLength;   // Длина строчки в пикселях
  Reg_t Lines;        // Количество линий в фрейме
  Reg_t FramePhases;  // Количество фаз в выходном потоке
} FrameCtrl_t;        // Настройка фрейма

typedef struct {
  Reg_t Base;       // Базовый адрес буфера
  Reg_t LineStep;   // Шаг записи линии
  Reg_t Count;      // Количество кадров в буфере
} BufferCtrl_t;     // Настройка буфера

typedef struct {
  logic [7:0] version;  // Версия прошивки
  logic [23:0] dummy;
} Status_t;

typedef struct packed {
  Status_t      status;
  FrameCtrl_t   frame;
  BufferCtrl_t  buffer;
} ADV7393RegBlock_t;

localparam Reg_t LINES        = 576;
localparam Reg_t LINE_LEN     = 640;
localparam Reg_t FRAME_PHASES = 2;

localparam Reg_t BASE         = 'h10000;
localparam Reg_t LINE_STEP    = 'h1000;
localparam Reg_t COUNT        = 2;

localparam BUFFER_DEPTH       = LINE_LEN/PIXELS_PER_SYMBOL;
localparam BUFFER_COUNT       = 2;
localparam BUFFER_SIZE        = BUFFER_COUNT*BUFFER_DEPTH;
localparam PHASE_W            = $clog2(FRAME_PHASES);
localparam LINES_CNT_W        = $clog2(LINES);

ADV7393RegBlock_t def_config = {
  '{ VERSION, '0 },
  '{ LINE_LEN, LINES, FRAME_PHASES },
  '{ BASE, LINE_STEP, COUNT }
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

localparam PIXEL_SIZE         = $size(Pixel_t)/8;
localparam PIXEL_STORED_SIZE  = $size(PixelStored_t)/8;
localparam COMPRESSED_WIDTH   = PIXEL_STORED_SIZE*PIXELS_PER_SYMBOL;

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