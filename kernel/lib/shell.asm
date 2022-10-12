SYS_ARGV times 20 db 0

SH_GET_ARGUMENTS:
	mov si, SYS_ARGV
	ret

SH_SET_ARGUMENTS:
	mov di, SYS_ARGV
	call strcpy

	mov si, SYS_ARGV
	mov al, byte ' '
	call arraySplit

	ret