;;
;;
;; Global kernel session data
;;
;;
GLOBAL_SESSION_DIRECTORY times 50 db 0  ; Users current directory as a string
GLOBAL_SESSION_DIRNODEID db 0           ; Users current directory tree ID
GLOBAL_SESSION_USERIDINT db 0           ; Current user ID
GLOBAL_SESSION_USERLEVEL db 0           ; Permission level for current user (0 == root)
GLOBAL_SESSION_USERLOGIN times 20 db 0  ; Current user as a string

GLOBAL_SESSION_PREVDIRNM times 50 db 0  ; Previous directory name
GLOBAL_SESSION_PREVDIRID db 0           ; Previous directory ID

;;
;; Initialise the global session
;;
G_SESSION_INIT:
	;; Set current directory to root
	mov [GLOBAL_SESSION_DIRNODEID], byte 0
	mov [GLOBAL_SESSION_DIRECTORY], byte '/'
	ret

G_GLOBAL_DIR:
	mov al, byte [GLOBAL_SESSION_DIRNODEID]
	ret

G_GLOBAL_DIRNAME:
	mov si, GLOBAL_SESSION_DIRECTORY
	ret

G_GLOBAL_USR:
	mov si, GLOBAL_SESSION_USERLOGIN
	mov al, byte [GLOBAL_SESSION_USERLOGIN]
	ret

G_GLOBAL_STO:
	pusha

	mov ah, byte [GLOBAL_SESSION_PREVDIRID]
	mov [GLOBAL_SESSION_DIRNODEID], ah

	mov si, GLOBAL_SESSION_PREVDIRNM
	mov di, GLOBAL_SESSION_DIRECTORY
	call strcpy

	popa

	ret

S_GLOBAL_DIR:
	mov [GLOBAL_SESSION_DIRNODEID], al
	mov di, GLOBAL_SESSION_DIRECTORY
	call strcpy
	ret

S_GLOBAL_STO:
	pusha
	mov ah, byte [GLOBAL_SESSION_DIRNODEID]
	mov [GLOBAL_SESSION_PREVDIRID], ah

	mov si, GLOBAL_SESSION_DIRECTORY
	mov di, GLOBAL_SESSION_PREVDIRNM
	call strcpy

	popa

	ret

S_GLOBAL_USR:
	mov [GLOBAL_SESSION_USERIDINT], al
	mov di, GLOBAL_SESSION_USERLOGIN
	call strcpy
	ret