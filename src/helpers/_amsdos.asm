storeDriveLetter:
                ;;------------------------------------------------------------------------
                ;; store the drive number the loader was run from to InitializeAmsdos
                ld hl,(#be7d)
                ld a,(hl)                 
                ld (_driveLoad + 1),a                 
	ret
   
_initializeAmsdos:
     ;; ** INITIALISE ALTERNATE REGISTER SET FOR FIRMWARE **
     
                exx
                ld bc, #7f88            ;initialise lower rom and select mode 0
                out (c),c               ;this routine must be located above &4000
                exx 
                ex af,af'
                xor a
                ex af,af'
     
    ;; ** INITIALISE FIRMWARE **

                call #0044                ;initialise lower jumpblock (&0000-&0040)
                                          ;and high kernal jumpblock (&b800-&bae4)
              
                call #bb00                ;initialise keyboard manager
                call #b909                ;disable lower rom

      ;;; ** INITIALISE DISK ROM FOR LOADING/SAVING **

            ld de, #40
            ld hl, #a000
            call #bccb

            ld a, #c9
            ld (#bb5a), a           ;prevent printing of text characters
                                    ;don t get error messages corrupting screen
   
    ;; ** INITIALISE ALL ROMS (FOR LOADING/SAVING) **

            ld a, #ff
            ld (#be78), a                ;turn of disc error messages
                
      ;;------------------------------------------------------------------------
      ;; when AMSDOS is enabled, the drive reverts back to drive 0!
      ;; This will restore the drive number to the drive the loader was run from
_driveLoad:               
            ld a, #00
            ld hl,(#be7d)
            ld (hl), a 
   
            ret

initializeAmsdos:
            jp _InitializeAmsdos

loadFile:
      ;; ** LOAD FILE USING FIRMWARE **                           


      ;; B = length of the filename in characters
      ;; HL = address of the start of the filename
      push de
      call #bc77 ; cas_in_open
      pop hl
   
      call #bc83 ;cas_in_direct
      jr nc, ERROR
      call #bc7a ;cas_in_close
     
      ret                                 ;...exit to program!!
ERROR:
      di
      SET_BORDER Color.fm_6
      jr $
  
