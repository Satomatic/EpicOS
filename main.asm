jmp kstart

%include "kernel/syscall.asm"

kstart:

	;;
	;; Check BS:FS headers exist and make sure
	;; current drive is set as a boot drive.
	;;
	call DL_CHECK_BSFS

	cmp al, 1
	jne .bsfs_fail

	cmp ah, 1
	jne .bsfs_noboot

	;;
	;; BS:FS passed print kernel boot msg
	;;
	mov si, k_bootmsg
	mov bx, 0x0F
	call print

	;;
	;; Set up global session with default
	;; user.
	;;
	call G_SESSION_INIT
	call G_GLOBAL_USR

	mov di, si
	mov si, k_dfltusr
	call strcpy

	;;
	;; Run the login command
	;;
	mov di, k_initexe
	mov bx, 1
	mov dx, 0x2000
	call DiskLoad

	;;
	;; Initialise the user shell
	;;
	mov di, k_initshl
	mov bx, 1
	mov dx, 0x1E00
	call DiskLoad

	jmp kstart

.bsfs_fail:
	mov si, k_nobsfs
	call print
	jmp $

.bsfs_noboot:
	mov si, k_noboot
	call print
	jmp $

k_bootmsg db 'EpicOS 4.0 Kernel', 0x0a, 0x0d, 0

k_initexe db 'login', 0
k_initshl db 'shell', 0
k_dfltusr db 'krnsh', 0

k_noboot db '[!] Drive is not a valid BS:FS boot drive', 0x0a, 0x0d, 0
k_nobsfs db '[!] Current drive does not contain BS:FS headers', 0x0a, 0x0d, 0

%include "kernel/api.asm"

%include "kernel/lib/array.asm"
%include "kernel/lib/string.asm"
%include "kernel/lib/shell.asm"
%include "kernel/lib/disk.asm"
%include "kernel/lib/io.asm"
%include "kernel/session.asm"

kernel_end:
