; ==============================================================================
; CRTC
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc



; ------------------------------------------------------------------------------
;  I/O port address
CRTC_SELECT         equ #BC00
CRTC_WRITE          equ #BD00
CRTC_STATUS         equ #BE00
CRTC_READ           equ #BF00

; ------------------------------------------------------------------------------
; REG_12 %xxDD MMxx xxxx xxxx
VRAM16              equ #00     ; 16 KBs de VRAM
VRAM32              equ #0C     ; 32 KBs de VRAM
VRAM_P0             equ #00     ; VRAM en #0000 ... #3FFF
VRAM_P1             equ #10     ; VRAM en #4000 ... #7FFF
VRAM_P2             equ #20     ; VRAM en #8000 ... #BFFF
VRAM_P3             equ #30     ; VRAM en #C000 ... #FFFF

VRAM_BLOCK_SIZE     equ #0800   ; 2 KBs

include '_crtc.macro.asm'


