macro WIN_BRK
                db #ed, #ff
endm

macro WAIT_LINE n
                ld b, {n}
@loop:          ds 60
                djnz @loop
endm




;;
;; BC = BC + A
;;
macro ADD_____BC_A                    ;; 5c

                add             a, c
                ld              c, a
                jr              nc, $ + 3
                inc             b
endm
;;
;; DE = DE + A
;;
macro ADD_____DE_A                    ;; 5c

                add             a, e
                ld              e, a
                jr              nc, $ + 3
                inc             d
endm


macro ADD_____HL_A                    ;; 5c

                add             a, l
                ld              l, a
                jr              nc, $ + 3
                inc             h
endm

macro ADD_____HL_A_SIGNED
                ld e, a       
                add a     
                sbc a     
                ld d, a
                add hl, de
endm

; 7 nops
macro EX_DE:
                ld a, e                         
                exx                            
                ld e, a
                exx
                ld a, d
                exx
                ld d, a
endm

macro NEG_HL
	xor a
	sub l
	ld l, a
	sbc a
	sub h
	ld h, a
endm

macro NEG_DE
	xor a
	sub e
	ld e, a
	sbc a
	sub d
	ld d, a
endm


 
macro INTERLACED draw1, draw2
                ; 0,1,3,2,6,7,5,4
                {draw1}                           ; Ligne 0 0
                set 3, d : {draw2}                ; Ligne 1 4
                set 4, d : {draw1}                ; Ligne 3 8
                res 3, d : {draw2}                ; Ligne 2 12
                set 5, d : {draw1}                ; Ligne 6 16
                set 3, d : {draw2}                ; Ligne 7 20
                res 4, d : {draw1}                ; Ligne 5 24
                res 3, d : {draw2}                ; Ligne 4 28
endm

macro INTERLACED_HL draw1, draw2
                ; 0,1,3,2,6,7,5,4
                {draw1}                           ; Ligne 0 0
                set 3, h : {draw2}                ; Ligne 1 4
                set 4, h : {draw1}                ; Ligne 3 8
                res 3, h : {draw2}                ; Ligne 2 12
                set 5, h : {draw1}                ; Ligne 6 16
                set 3, h : {draw2}                ; Ligne 7 20
                res 4, h : {draw1}                ; Ligne 5 24
                res 3, h : {draw2}                ; Ligne 4 28
endm


macro INTERLACED_HL_R draw1, draw2
                ; 0,1,3,2,6,7,5,4
                {draw1}                           ; Ligne 0 0
                set 3, h : {draw2}                ; Ligne 1 4
                set 4, h : {draw1}                ; Ligne 3 8
                res 3, h : {draw2}                ; Ligne 2 12
                res 5, h : {draw1}                ; Ligne 6 16
                set 3, h : {draw2}                ; Ligne 7 20
                res 4, h : {draw1}                ; Ligne 5 24
                res 3, h : {draw2}                ; Ligne 4 28
endm

macro CREATE_MASK byte

let mask = 0
if {byte} and #aa
mask = mask or #aa
endif
if {byte} and #55
mask = mask or #55
endif
db mask ^ #ff

endm
