include "./_gate_array.h.asm"
; input:
; a first ink
; c palette length
; hl palette
; ouput:
; af, bc, hl, destroyed  
setPalette:
                ld b, hi(GATE_ARRAY)
.loop:
                out (c), a
                inc b
                outi
                inc a
                dec c
                jr nz, .loop
                ret

setPaletteToBlack:
                ld c, #10
                ld hl, Color.fm_0
                ld b, hi(GATE_ARRAY)
.loop:         
                out (c), h
                out (c), l
                inc h 
                dec c 
                jr nz, .loop

                ret