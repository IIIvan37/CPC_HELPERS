
macro SET_COLOR pen, ink
                ld bc, GATE_ARRAY | PENR | {pen}
                out (c), c
                ld c, {ink}
                out (c), c
endm

macro SET_COLOR_a pen
                ld bc, GATE_ARRAY | PENR | {pen}
                out (c), c
                out (c), a
endm


macro SET_BORDER ink 
                SET_COLOR #10, {ink}
endm

macro SET_MODE mode 
                LD bc, GATE_ARRAY | RMR | ROM_OFF | {mode}
                out (c), c
                print "Mode :", {hex}GATE_ARRAY | RMR | ROM_OFF | {mode}
endm

             
macro SET_PALETTE palette, start, length
                ld a, {start}
                ld c, {length}
                ld hl, {palette}
                ld b, hi(GATE_ARRAY)
@loop:
                out (c), a
                inc b
                outi
                inc a
                dec c
                jr nz, @loop
endm

macro SET_BANK bank
                ld bc, GATE_ARRAY | {bank}
                out (c), c
endm

macro SET_BANK_SAFE bank
	
	di
                ld bc, GATE_ARRAY | {bank}
                out (c), c
	ld (gVars.crtBank), bc
	ei
endm

macro SET_BANK_SAFE_A
	di
	ld c, a
                ld b, hi(GATE_ARRAY)
                out (c), c
	ld (gVars.crtBank), bc
	ei
endm

macro RESTORE_BANK
	
                ld bc, (gVars.crtBank)
                out (c), c
endm