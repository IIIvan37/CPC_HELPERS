; ---------------------------------------------------------------------------
; WRITE_CRTC
MACRO WRITE_CRTC reg, val
                ld bc, CRTC_SELECT + {reg}
                ld a, {val}
                out (c), c
                inc b
                out (c), a
ENDM

; WRITE_CRTC reg a
MACRO WRITE_CRTC_a, reg
                ld bc, CRTC_SELECT + {reg}
                out (c), c
                inc b
                out (c), a
ENDM