[ORG 0x2000]

start:
	mov si, help_string
	mov bx, 7
	call print

	ret

help_string db '    [general]', 0x0a, 0x0d
            db '        help      - Help menu', 0x0a, 0x0d
            db '        login     - Login to user', 0x0a, 0x0d
            db '        user      - Show the current user', 0x0a, 0x0d
            db '        shutdown  - Shutdown', 0x0a, 0x0d, 0x0a, 0x0d
            db '    [shell]', 0x0a, 0x0d
            db '        clear     - Clear the command line', 0x0a, 0x0d
            db '        exit      - Exits the shell', 0x0a, 0x0d, 0x0a, 0x0d
            db '    [file system]', 0x0a, 0x0d
            db '        ls        - List files', 0x0a, 0x0d

%include "kernel/api.asm"
