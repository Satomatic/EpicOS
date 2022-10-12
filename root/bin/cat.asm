[ORG 0x2000]

start:
	call getArgv
	mov ax, 1
	call arrayGet

	mov di, si
	mov bx, 0
	mov dx, 0x3000
	call DiskLoad

	mov si, 0x3000
	mov bx, 0x0F
	call print

	mov si, endl
	call print

	ret

%include "kernel/api.asm"