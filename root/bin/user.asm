[ORG 0X2000]

;;
;; @~> user
;; Show the current logged in user
;;

start:
	mov si, message
	mov bx, 0x0F
	call print

	call getUserLogin

	mov bx, 0x0B
	call print

	mov si, endl
	call print

	ret

message db 'Logged in as @', 0

%include "kernel/api.asm"