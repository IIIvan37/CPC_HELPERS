; ==============================================================================
; PPI
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc



; ------------------------------------------------------------------------------
;  I/O port address
PPI_A               equ #f400
PPI_B               equ #f500
PPI_C               equ #f600
PPI_CONTROL         equ #f700

; ------------------------------------------------------------------------------
;; Matrix Line 0x00
Key_CursorUp     equ #0100  ;; Bit 0 (01h)
Key_CursorRight  equ #0200  ;; Bit 1 (02h)
Key_CursorDown   equ #0400  ;; Bit 2 (04h)
Key_F9           equ #0800  ;; Bit 3 (08h)
Key_F6           equ #1000  ;; Bit 4 (10h)
Key_F3           equ #2000  ;; Bit 5 (20h)
Key_Enter        equ #4000  ;; Bit 6 (40h)
Key_FDot         equ #8000  ;; Bit 7 (80h)
;; Matrix Line 0x01
Key_CursorLeft   equ #0101
Key_Copy         equ #0201
Key_F7           equ #0401
Key_F8           equ #0801
Key_F5           equ #1001
Key_F1           equ #2001
Key_F2           equ #4001
Key_F0           equ #8001
;; Matrix Line 0x02
Key_Clr          equ #0102
Key_OpenBracket  equ #0202
Key_Return       equ #0402
Key_CloseBracket equ #0802
Key_F4           equ #1002
Key_Shift        equ #2002
Key_BackSlash    equ #4002
Key_Control      equ #8002
;; Matrix Line 0x03
Key_Caret        equ #0103
Key_Hyphen       equ #0203
Key_At           equ #0403
Key_P            equ #0803
Key_SemiColon    equ #1003
Key_Colon        equ #2003
Key_Slash        equ #4003
Key_Dot          equ #8003
;; Matrix Line 0x04
Key_0            equ #0104
Key_9            equ #0204
Key_O            equ #0404
Key_I            equ #0804
Key_L            equ #1004
Key_K            equ #2004
Key_M            equ #4004
Key_Comma        equ #8004
;; Matrix Line 0x05
Key_8            equ #0105
Key_7            equ #0205
Key_U            equ #0405
Key_Y            equ #0805
Key_H            equ #1005
Key_J            equ #2005
Key_N            equ #4005
Key_Space        equ #8005
;; Matrix Line 0x06
Key_6            equ #0106
Joy1_Up          equ #0106
Key_5            equ #0206
Joy1_Down        equ #0206
Key_R            equ #0406
Joy1_Left        equ #0406
Key_T            equ #0806
Joy1_Right       equ #0806
Key_G            equ #1006
Joy1_Fire1       equ #1006
Key_F            equ #2006
Joy1_Fire2       equ #2006
Key_B            equ #4006
Joy1_Fire3       equ #4006
Key_V            equ #8006
;; Matrix Line 0x07
Key_4            equ #0107
Key_3            equ #0207
Key_E            equ #0407
Key_W            equ #0807
Key_S            equ #1007
Key_D            equ #2007
Key_C            equ #4007
Key_X            equ #8007
;; Matrix Line 0x08
Key_1            equ #0108
Key_2            equ #0208
Key_Esc          equ #0408
Key_Q            equ #0808
Key_Tab          equ #1008
Key_A            equ #2008
Key_CapsLock     equ #4008
Key_Z            equ #8008
;; Matrix Line 0x09
Joy0_Up          equ #0109
Joy0_Down        equ #0209
Joy0_Left        equ #0409
Joy0_Right       equ #0809
Joy0_Fire1       equ #1009
Joy0_Fire2       equ #2009
Joy0_Fire3       equ #4009
Key_Del          equ #8009


include '_ppi.macro.asm'

