[BITS 16]
[ORG 0x7C00]

jmp BootStart

bs_fs_drive_header db 'B_BS_FS_1', 0

BootStart:
MOV DL, 0x0    ;drive 0 = floppy 1
MOV DH, 0x0    ;head (0=base)
MOV CH, 0x0    ;track/cylinder
MOV CL, 0x2    ;sector (1=bootloader, apparently sectors starts counting at 1 instead of 0)
MOV BX, 0x1000 ;place in RAM for kernel - I suppose randomly chosen on examples
MOV ES, BX     ;place BX in pointer ES
MOV BX, 0x0    ;back to zero - also has something to do with RAM position

ReadFloppy:
MOV AH, 0x02
MOV AL, 0x03
INT 0x13
JC ReadFloppy  ;if it went wrong, try again

;pointers to RAM position (0x1000)
MOV AX, 0x1000
MOV DS, AX
MOV ES, AX
MOV FS, AX
MOV GS, AX
MOV SS, AX

JMP 0x1000:0x0

TIMES 510 - ($ - $$) db 0 ;fill resting bytes with zero
DW 0xAA55 ;end of bootloader (2 bytes)
