include 'const.asm'

     org ENTRY_ADR
start
    include 'test.asm'

_KEYBOARDSTATUSBUFFE
end:

RUN Test_start
SAVE '-test.bin', start,end-start, DSK, './dist/test.dsk'                              