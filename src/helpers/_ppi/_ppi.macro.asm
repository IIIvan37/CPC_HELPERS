; ---------------------------------------------------------------------------
; WAIT_VBL
 macro WAIT_VBL
                ld b, hi(PPI_B)
@wait
                in a, (c)
                rra
                jr nc, @wait
 endm

