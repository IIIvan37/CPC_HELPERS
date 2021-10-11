; ==============================================================================
; Gate Array
; ==============================================================================
; http://www.cpcwiki.eu/index.php/Gate_Array
; http://quasar.cpcscene.net/doku.php?id=assem:gate_array


; ------------------------------------------------------------------------------
;  I/O port address
GATE_ARRAY:     equ #7f00

; ------------------------------------------------------------------------------
; Registers
PENR:           equ %00000000
INKR:           equ %01000000
RMR:            equ %10000000

; ------------------------------------------------------------------------------
; RAM Banking
; -Address-     0      1      2      3      4      5      6      7
; 0000-3FFF   RAM_0  RAM_0  RAM_4  RAM_0  RAM_0  RAM_0  RAM_0  RAM_0
; 4000-7FFF   RAM_1  RAM_1  RAM_5  RAM_3  RAM_4  RAM_5  RAM_6  RAM_7
; 8000-BFFF   RAM_2  RAM_2  RAM_6  RAM_2  RAM_2  RAM_2  RAM_2  RAM_2
; C000-FFFF   RAM_3  RAM_7  RAM_7  RAM_7  RAM_3  RAM_3  RAM_3  RAM_3
RAM_P0          equ #0000
RAM_P1          equ #4000
RAM_P2          equ #8000
RAM_P3          equ #c000

; ------------------------------------------------------------------------------
; ROM
UPPER_OFF       equ %00001000
UPPER_ON        equ %00000000
LOWER_OFF       equ %00000100
LOWER_ON        equ %00000000
ROM_OFF         equ UPPER_OFF | LOWER_OFF

; ------------------------------------------------------------------------------
; Raster 52 divider
CLEAR_RASTER_DIV    equ %00010000

; ------------------------------------------------------------------------------
; Palette sorted by Hardware Colour Numbers
HW_PALETTE:
.WHITE          equ INKR | #00
.SEA_GREEN      equ INKR | #02
.PASTEL_YELLOW  equ INKR | #03
.BLUE           equ INKR | #04
.PURPLE         equ INKR | #05
.CYAN           equ INKR | #06
.PINK           equ INKR | #07
.BRIGHT_YELLOW  equ INKR | #0A
.BRIGHT_WHITE   equ INKR | #0B
.BRIGHT_RED     equ INKR | #0C
.BRIGHT_MAGENTA equ INKR | #0D
.ORANGE         equ INKR | #0E
.PASTEL_MAGENTA equ INKR | #0F
.BRIGHT_GRREN   equ INKR | #12
.BRIGHT_CYAN    equ INKR | #13
.BLACK          equ INKR | #14
.BRIGHT_BLUE    equ INKR | #15
.GREEN          equ INKR | #16
.SKY_BLUE       equ INKR | #17
.MAGENTA        equ INKR | #18
.PASTEL_GREEN   equ INKR | #19
.LIME           equ INKR | #1a
.PASTEL_CYAN    equ INKR | #1b
.RED            equ INKR | #1c
.MAUVE          equ INKR | #1d
.YELLOW         equ INKR | #1e
.PASTEL_BLUE    equ INKR | #1f

; ------------------------------------------------------------------------------
; Palette sorted by Firmware Colour Numbers
FW_PALETTE:
.BLACK           equ INKR |  #00
.BLUE            equ INKR |  #01
.BRIGHT_BLUE     equ INKR |  #02
.RED             equ INKR |  #03
.MAGENTA         equ INKR |  #04
.MAUVE           equ INKR |  #05
.BRIGHT_RED      equ INKR |  #06
.PURPLE          equ INKR |  #07
.BRIGHT_MAGENTA  equ INKR |  #08
.GREEN           equ INKR |  #09
.CYAN            equ INKR |  #0a
.SKY_BLUE        equ INKR |  #0b 
.YELLOW          equ INKR |  #0c 
.WHITE           equ INKR |  #0d
.PASTEL_BLUE     equ INKR |  #0e 
.ORANGE          equ INKR |  #0f
.PINK            equ INKR |  #10
.PASTEL_MAGENTA  equ INKR |  #11
.BRIGHT_GREEN    equ INKR |  #12
.SEA_GREEN       equ INKR |  #13
.BRIGHT_CYAN     equ INKR |  #14
.LIME            equ INKR |  #15
.PASTEL_GREEN    equ INKR |  #16
.PASTEL_CYAN     equ INKR |  #17
.BRIGHT_YELLOW   equ INKR |  #18
.PASTEL_YELLOW   equ INKR |  #19
.BRIGHT_WHITE    equ INKR |  #20

; -------------------------------------------------------------------------------------------
;
Color:
.fm_0:          equ #54
.fm_1:          equ #44
.fm_2:          equ #55
.fm_3:          equ #5C
.fm_4:          equ #58
.fm_5:          equ #5d
.fm_6:          equ #4C
.fm_7:          equ #45
.fm_8:          equ #4d
.fm_9:          equ #56
.fm_10:         equ #46         
.fm_11:         equ #57
.fm_12:         equ #5e
.fm_13:         equ #40
.fm_14:         equ #5f
.fm_15:         equ #4e
.fm_16:         equ #47
.fm_17:         equ #4f
.fm_18:         equ #52
.fm_19:         equ #42
.fm_20:         equ #53
.fm_21:         equ #5A
.fm_22:         equ #59
.fm_23:         equ #5b
.fm_24:         equ #4a
.fm_25:         equ #43
.fm_26:         equ #4B

include '_gate_array.macro.asm'


