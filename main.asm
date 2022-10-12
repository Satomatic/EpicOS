jmp kstart

%include "kernel/syscall.asm"

kstart:
	mov si, k_bootmsg
	mov bx, 0x0F
	call print

	call G_SESSION_INIT
	call G_GLOBAL_USR

	mov di, si
	mov si, k_dfltusr
	call strcpy

	mov di, k_initexe
	mov bx, 1
	mov dx, 0x2000
	call DiskLoad

	mov di, k_initshl
	mov bx, 1
	mov dx, 0x1E00
	call DiskLoad

	jmp kstart

k_bootmsg db 'EpicOS 4.0 Kernel', 0x0a, 0x0d, 0

k_initexe db 'login', 0
k_initshl db 'shell', 0
k_dfltusr db 'krnsh', 0

%include "kernel/api.asm"

%include "kernel/lib/array.asm"
%include "kernel/lib/string.asm"
%include "kernel/lib/shell.asm"
%include "kernel/lib/disk.asm"
%include "kernel/lib/io.asm"
%include "kernel/session.asm"

kernel_end: