 
nolist
;
;
; FDC Code reading AMSDOS file
; Without system.
; V1.0
;
; By Targhan/Arkos
;
; AMSDOS limitations still present.
; 9 2-sized sectors per track (c1-c9), one side.
; However, can read sectors up to 41 tracks
; (used by files copied with Disc'o'Magic, for example).
;
; Can't read ASCII files (who cares ?)
;
;
; Filename entered follow the format =
; AAAAAAAABBB
; Use upper case only. Do not put the '.'.
;
;
;
; Proper use =
; call FDCON to turn the drive ON
;
; ld a,drive (0-3)
; ld b,head (0-1)
; call FDCVARS to tell which drive to use, head to read.
;
; ld hl,FILENAME
; ld de,destination
; ld bc,buffer read below about it.
; call LOADFILE to load the file.
; Return =
; A=state. 0=ok  1=disc missing  2=read fail
; 3=file not found
;
; When you've loaded all the files you wanted =
; call FDCOFF
;
; You shouldn't need it, but...
; call RECALIBR
; to recalibrate the current drive (use FDCON
; and FDCVARS first !). AMSDOS does it when you turn
; the CPC on. You can also do it when an error disc
; happened, before trying loading the file again.
;
; That's it !
;
;
; Notes
; - The 'buffer' of LOADFILE CAN be equal to DE. It is used
;   to load one sector of the Directory. In the case you want
;   to load a screen in #c000, you might want to set BC to
;   another address, so that you don't see garbage at the
;   beginning of the loading.
; - By changing the Head, you can read the file on the second
;    side of a 3"5 disc.
; - Automatically skips the AMSDOS header.
; - Even if the file is not found, 512 bytes will be use
; from the 'destination' address.
; - The User of a file is ignored (who cares ?), except for deleted files.
; - No buffer is needed.
; - The interruptions are CUT by the loading code.
; - Interruptions are turned on when turning on the FDC, so
;   put #c9fb in #38 before if you don't want your
;   interruptions code to be run at this moment.
; - Some little tables are defined at the end. You can relocate
;   them where you want if needed.
;
;
;
;Maximum number of direction entry of a file. *16 to get the maximum size
;loadable in KB. 4 should be more than enough (=64k).
NBMAXENT equ 4
;
;Track where the directory is. Some AMSDOS tweakings allow to use another one.
DIRTRACK equ 0
;
;First sector of the directory.
DIRFSECT equ #c1
;
;
;
;
;
;Some testing program
;Removing this when included this code to your own.
;----------------------------
; di
; ld hl,#c9fb
; ld (#38),hl
;
; call FDCON
;
; xor a
; ld b,0
; call FDCVARS
;
; ld hl,MYFILE
; ld de,#c000
; ld bc,#c000
; call LOADFILE
; jr nc,ERROR
;
; call FDCOFF
;
;ENDLESS jr ENDLESS
;MYFILE defb "IMG     SCR"
;
;ERROR ld bc,#7f10  ;error
; out (c),c
; ld c,#4c
; out (c),c
; jr ENDLESS
;----------------------------
;
;
;
;
;Tell which drive to use, head to read.
;A=drive (0-3)
;B=head (0-1)
FDCVARS
 ld (FDCDRIVE),a
 ld c,a
 ld a,b
 ld (FDCHEAD),a
 rla
 rla
 and %100
 or c
 ld (FDCIDDR),a
 ret
;
;
;
;
;Turn FDC on and wait a bit.
FDCON    LD   A,(FDCMOTOR)
         OR   A
         RET  NZ
         INC  A
         LD   (FDCMOTOR),A
         LD   BC,#FA7E
         LD   A,1
         OUT  (C),A
  EI      ;Wait for motor to get full speed
         LD   B,6*30
WAIT     HALT 
         DJNZ WAIT
         DI   
         RET  
;
;
;
;
;Turn FDC off.
FDCOFF   XOR  A
         LD   (FDCMOTOR),A
         LD   BC,#FA7E
         XOR  A
         OUT  (C),A
         RET  
;
;
;
;Recalibrate current drive.
RECALIBR
 call RECALIB2
 call RECALIB2
 ret
RECALIB2
         LD   A,%00000111
         CALL PUTFDC
  ld a,(FDCIDDR)
         CALL PUTFDC
         CALL WAITEND
         RET  
;
;
;
;
;
;Load a file
;HL=Filename
;DE=Where to load it
;BC=#200 buffer
;RET=A=state. 0=ok  1=disc missing  2=read fail
;3=file not found
LOADFILE
 ld (PTFILENM),hl
 LD (LOADWHER),DE
 ld (ADBUFFER),bc
;
;
        CALL BUILDTAB
 ret nc
;
 ld a,128
 ld (SKIPBYTE+1),a
;
;
;Reading the file
 LD IX,TABSECTS
LOADLP LD A,(IX+0)
 cp #ff
 jr z,LOADFOK
 cp #fe
 jr z,LOADNEXT
 LD B,(IX+1)
 push ix
 CALL READSECT
 pop ix
 ret nc
 ld (LOADWHER),hl
;
 ld hl,(TOREAD)
 ld a,l
 or h
 jr z,LOADFOK
;
 xor a
 ld (SKIPBYTE+1),a
;
LOADNEXT inc ix
  inc ix
 jr LOADLP
;
LOADFOK xor a
 scf
 ret
;
;
;
;
;
;
;
;
;
;Wait for the end of the current instruction (using ST0).
WAITEND
         LD   A,%00001000
         CALL PUTFDC
         CALL GETFDC                    ;Get ST0
         LD   (ST0),A
         CALL GETFDC
         XOR  A
         LD   (ST1),A                   ;Reset ST1 and ST2
         LD   (ST2),A
;
         LD   A,(ST0)
         BIT  5,A                       ;Instruction over ?
         JR   Z,WAITEND
         RET  
;
;Send data to FDC
;A=data
PUTFDC
        ex af,af'
 LD   BC,#FB7E
PUTFD2 IN   A,(C)
        JP   P,PUTFD2
        ex af,af'
 inc c
 OUT  (C),A
        RET  
;
;Get data from FDC
;Ret = A=FDC data
GETFDC
 LD   BC,#FB7E
GETFD2 IN   A,(C)
 JP   P,GETFD2
 inc c
        IN   A,(C)
        RET  
;
;
;Track change
;a=nb piste
GOTOPIST
         PUSH AF
         LD   A,%00001111
         CALL PUTFDC
         LD   A,(FDCIDDR)
         CALL PUTFDC
         POP  AF
         CALL PUTFDC
;
         CALL WAITEND
;
         RET  
;
;
;Read sector.
;A=track
;B=ID sector
;RET=A=state.Carry=1=ok A=0=ok  1=disc missing  2=read fail
;3=file not found
;HL=Where new data should be loaded (LOADWHER)
READSECT
         LD   (RSPIST+1),A
         PUSH BC
         CALL GOTOPIST
;
         LD   A,%01000110
         CALL PUTFDC
         LD   A,(FDCIDDR)               ;ID drive
         CALL PUTFDC
RSPIST   LD   A,0                       ;track
         CALL PUTFDC
         XOR  A               ;head
         CALL PUTFDC
         POP  BC                        ;ID sect
         LD   A,B
         PUSH AF
         CALL PUTFDC
         LD   A,2                       ;size
         CALL PUTFDC
         POP  AF                        ;last sect to read
         CALL PUTFDC
         LD   A,#52                     ;GAP
         CALL PUTFDC
         LD   A,#FF
         CALL PUTFDC
;
         LD   BC,#FB7E
;
SKIPBYTE ld a,0   ;If header, skip it
 or a
 jr z,RSAVLOOP
 ld e,a
;
 ld hl,BUFHEAD
;Read bytes to the header buffer.
RSSKIPLP
 IN   A,(C)                     ;FDC ready for transf ?
 JP   P,RSSKIPLP
 AND  %00100000   ;FDC performing ?
 JR   Z,RSFIN
;
 INC C
 IN A,(C)
 ld (hl),a
 inc hl
 DEC  C
 dec e
        jr nz,RSSKIPLP
;
 ld hl,(BUFHEAD+64)  ;get filesize
 ld (TOREAD),hl
;
;Normal reading code.
RSAVLOOP
 LD HL,(LOADWHER)
 ld de,(TOREAD)
RSLOOP
        IN   A,(C)                     ;FDC ready for transf ?
        JP   P,RSLOOP
        AND  %00100000    ;FDC performing ?
        JR   Z,RSFIN
;
        INC  C
        IN   A,(C)
        LD   (HL),A
        INC  HL
;
        DEC  C
 dec de
 ld a,e
 or d
        JR nz,RSLOOP
;
;Reading with saving. Done if end of file but sectors left.
RSWASTE
        IN   A,(C)                     ;FDC ready for transf ?
 JP   P,RSWASTE
        AND  %00100000    ;FDC performing ?
        JR   Z,RSFIN
;
        INC  C
        IN   A,(C)
        DEC  C
        JR RSWASTE
;
;Reading instr result
RSFIN
 ld (TOREAD),de
;
        CALL GETFDC
        LD   (ST0),A
        CALL GETFDC
        LD   (ST1),A
        CALL GETFDC
        LD   (ST2),A
        CALL GETFDC
        CALL GETFDC
        CALL GETFDC
        CALL GETFDC
;
;
;Test errors.
;ret= Carry=1=ok a=0=ok  a=1=disc missing  2=read fail
;ute ST0, ST1, ST2
         LD   A,(ST0)
         BIT  7,A
         JR   NZ,TESTEJEC               ;no disc
         BIT  3,A
         JR   NZ,TESTEJEC               ;no disc
         BIT  4,A
         JR   NZ,TESTFAIL               ;Read fail
;
         LD   A,(ST1)
         AND  %00110111
         JR   NZ,TESTFAIL
;
         LD   A,(ST2)
         AND  %00110000
         JR   NZ,TESTFAIL
;
TESTNOE
 XOR  A
 scf
 ret
TESTEJEC
 LD A,1
 or a
 ret
TESTFAIL
 LD A,2
 or a
 ret
ERRFNF
 LD A,3
 or a
 ret
;
;
;
;
;
;
;Search a file in the AMSDOS directory, and
;build the sector table.
;RET=A=state. 0=ok  1=disc missing  2=read fail
;3=file not found
BUILDTAB
 ld a,DIRFSECT
 ld (BTSECT+1),a
 add a,4
 ld (BTESECT+1),a
 xor a
 ld (FILFOUND),a
 ld (SKIPBYTE+1),a
;
 ld hl,#ffff
 ld (TOREAD),hl
;
;
 ld hl,TABSECTS
 ld de,TABSECTS+1
 ld bc,TABSECTF-TABSECTS-1
 ld (hl),#fe
 ldir
;
;
BTLOOP ld a,DIRTRACK
BTSECT ld b,#c1
 call READSECT
 ret nc
;
 ld hl,(ADBUFFER)
 ld (BTBUFF+1),hl
;
;Search in the loaded sector the right entry(ies)
 ld b,16
BTENTLP push bc
 LD HL,(PTFILENM)
BTBUFF ld de,0
 ld a,(de)
 cp #e5   ;ignore deleted files
 jr z,BTNEXT
 inc de
        CALL CMP
        call C,BTFOUND
;
BTNEXT ld hl,(BTBUFF+1)
 ld de,32
 add hl,de
 ld (BTBUFF+1),hl
;
 pop bc
 djnz BTENTLP
;Next sector
 ld a,(BTSECT+1)
 inc a
 ld (BTSECT+1),a
BTESECT cp #c5
 jr nz,BTLOOP
;
 ld a,(FILFOUND)
 or a
 jr z,BTNOFND
 xor a
 scf
 ret
;
BTNOFND ld a,3  ;File not found
 ret
;
;
;
;Right entry found.
BTFOUND
 ld a,1
 ld (FILFOUND),a
;
 ld ix,(BTBUFF+1)
 ld a,(ix+12)   ;Get block number
 ld l,a    ;Calcule where to code the track+sect
 ld h,0    ;in the tabsects
 add hl,hl
 add hl,hl
 add hl,hl
 add hl,hl
 add hl,hl
 add hl,hl
 ld de,TABSECTS
 add hl,de
 ex de,hl
 defb #fd : ld l,e
 defb #fd : ld h,d
;
 ld de,16
 add ix,de
;
;ix=source
;iy=dest
 call CONV
;
 ret
;
;
;
;
;
;Compare two strings. 7th bit to 0.
;DE=     buffer   HL=filename
;RET=    Carry=OK
CMP
         LD   B,11
;
CM2      LD   A,(DE)
         RES  7,A
         CP   (HL)
         JR   NZ,CMPNOT
         INC  HL
         INC  DE
         DJNZ CM2
         SCF
         RET  
CMPNOT   OR A
         RET  
;
;
;Convert block table to table of tracks+sects
;IX=src  IY=dest
CONV
 ld b,16   ;Reading 16 blocks max
CVNEXT ld a,(ix+0)  ;read block number
 or a
 ret z
 inc ix
;
 push bc
;
         LD   L,A
         LD   H,0
         ADD  HL,HL
         CALL DIV9
         LD   (iy+0),c  ;get track
;
;  sect1
;
         LD   HL,(RESTE)
         LD   A,L
         add a,DIRFSECT
         LD   (iy+1),A
;
; sect2
;
         INC  A
         CP   #CA
         JR   NZ,CVP2
         LD   A,#C1
         INC  C
CVP2     LD   (iy+2),C
         LD   (iy+3),A
 ld de,4
 add iy,de
;
 pop bc
 djnz CVNEXT
 ret
;
;
;
DIV9     LD   DE,9  ;Not optimised. Who cares ?
         LD   C,0
DIV91    OR   A
         SBC  HL,DE
         JR   C,DIV92
         INC  C
         JR   DIV91
DIV92    ADD  HL,DE
         LD   (RESTE),HL
         RET  
;
;
FDCMOTOR defb 0   ;Drive motor (0-1)
FDCDRIVE defb 0   ;Drive used (0-3)
FDCHEAD defb 0   ;Head used (0-1)
FDCIDDR defb 0   ;Drive ID.
ST0 DEFB 0
ST1 DEFB 0
ST2 defb 0
FILFOUND defb 0
RESTE    DEFW 0
;
LOADWHER defw 0  ;Where to load the file
ADBUFFER defw 0  ;#200 buffer
PTFILENM defw 0  ;Point on the filename
TOREAD defw 0  ;Size (decrease)
;
;
;Table where is build the sector table.
;One directory entry can contain 16 blocks, hence '16'
;One block=2 sectors, each one defined by a track+sect ID. Hence the '*4'.
TABSECTS DEFS 16*4*NBMAXENT,#fe
TABSECTF DEFW #FFFF
;
BUFHEAD defs 128,0   ;Header put here
;
 list
;*** End FDC code
 nolist


