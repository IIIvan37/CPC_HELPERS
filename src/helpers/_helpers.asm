; ==============================================================================
; Hardware
; ==============================================================================
helpers_start:
include '_gate_array/_gate_array.asm'
include '_crtc/_crtc.h.asm'
include '_misc.h.asm'
; include '_fdc.asm'
include '_ppi/_ppi.h.asm'
include '_lz49_decrunch.asm'

;
; Multiply 8-bit values
; In:  Multiply H with E
; Out: HL = result
;
Mult8:
    ld d, 0
    ld l, d
    ld b, 8
.loop:
    add hl, hl
    jr nc, .noAdd
    add hl, de
.noAdd:
    djnz .loop
    ret

macro CHECK_ACTION actionkey, action
 
   ifdef {action}
        
        ld a, (_keyboardStatusBuffer+lo({actionkey}))    
        and hi({actionkey})
        call z, {action}
    else
     fail "Error: ", {action}
    endif
mend



KeyBoard_init:
                ld hl, _keyboardStatusBuffer
                ld e, l
                ld d, h
                inc de 
                ld (hl), #ff
                ld bc, 10 - 1
                ldir
                ret

Keyboard_scan:
                ld  bc,  #F782               
                out (c), c                   
                                
                ld  bc,  #F40E               
                ld  e, b                     
                out (c), c                   

                ld  bc,  #F6C0               
                ld  d, b                     
                out (c), c                   
                out (c), 0                   
                                
                ld  bc,  #F792               
                out (c), c                   
                                
                ld   a, #40                 
                ld   hl, _keyboardStatusBuffer 
                                        
repeat 9:
                ld    b, d               
                out (c), a               
                ld    b, e               
                ini                      
                inc   a                  
rend
   

                ;; Read line 49h
                ld    b, d               
                out (c), a               
                ld    b, e               
                ini                      

                ld  bc,  #F782
                out (c), c    

                ret           

callHL:
                jp (hl)


_keyboardStatusBuffer:
	ds 10

