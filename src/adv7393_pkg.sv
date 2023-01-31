package adv7393_pkg;

// Параметры блока  
parameter M_AXI_DWIDTH        = 128;  
parameter S_AXI_DWIDTH        = 32;
parameter S_AXI_AWIDTH        = 4;
parameter CSR_ENABLE          = 4;
parameter TEST_ENABLE         = 0;

localparam REG_WIDTH          = 32;

typedef logic [REG_WIDTH-1:0] Reg_t;

typedef struct {
  Reg_t LineLength;   // Длина строчки в пикселях
  Reg_t Lines;        // Количество линий в фрейме
  Reg_t FramePhases;  // Количество фаз в выходном потоке
} FrameCtrl_t;      // Настройка фрейма

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

localparam PIXELS_IN_SYMBOL   = 4;

ADV7393RegBlock_t def_config = {
  '{ '0, '0 },
  '{ LINE_LEN, LINES, FRAME_PHASES },
  '{ BASE, LINE_STEP, COUNT }
};

endpackage : adv7393_pkg