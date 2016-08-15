;#######################################################
;	
;#######################################################


section .data
	
	parte1: db '+-------------------------------------------------+',0xa	;Lineas base para imprimir
	parte1_tamano: equ $-parte1				;Tamaño de la variable techo
	
	parte2: db '|+-----++-----++-----++-----++-----++-----++-----+|',0xa	;Lineas base para imprimir
	parte2_tamano: equ $-parte2				;Tamaño de la variable techo
	
	parte3: db '||     ||     ||     ||     ||     ||     ||     ||',0xa	;Lineas base para imprimir
	parte3_tamano: equ $-parte3				;Tamaño de la variable techo
	
	parte4: db '|                                                 |',0xa	;Lineas base para imprimir
	parte4_tamano: equ $-parte4				;Tamaño de la variable techo
	
	parte5: db '+________________________|________________________+'
	
	modificacion: db '#'
	modificacion_tamano: equ $-modificacion
	
	
	escSeq db 27, "[04;01H"
	escLen equ 8
	
	termios: times 36 db 0 ;Estructura 36 bytes, contiene modo de operaciÃ³n de la consola
	stdin: equ 0 ;Standar Input
	ICANON: equ 1<<1 ;ICANON: valor de control para on/off modo canonico
	ECHO: equ 1<<3 ;ECHO: valor control para on/off eco

	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
	;TERMIOS = TERMinal Input/Output Settings

	clrScreen db 0x1b, "[2J" ;,0x1, "[H"
	clrScreen_length: equ $-clrScreen
	
	arriba db 0x1b, "[8A" ;,0x1, "[H"
	arriba_length: equ $-clrScreen
	
	derecha db 0x1b, "[2C" ;,0x1, "[H"
	derecha_length: equ $-clrScreen
	
	neutroa db 0x1b, "[00;10f" ;,0x1, "[H"
	neutroa_length: equ $-clrScreen
	
	neutrob db 0x1b, "[33C" ;,0x1, "[H"
	neutrob_length: equ $-clrScreen
	
	
	;____________Declaracion de Funciones____________________

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;Se enciende modo canonico de Linux. Linux espera un ENTER
;para procesar la captura del teclado
canonical_on:
	call read_stdin_termios ;Funcion que lee estado actual de TERMIOS en STDIN
	or dword [termios+12], ICANON ;Escribe nuevo valor del modo canonico
	call write_stdin_termios ;Escribe nueva configuracion de TERMIOS
	ret
;Final de la Funcion
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;ECHO = ON
;Linux muestra en la pantalla(stdout) cada tecla que se 
;escribe en el teclado (stdin)
echo_on:
	call read_stdin_termios ;Lee el estado actual del TERMIOS en STDIN
	or dword [termios+12], ECHO ;Escribe nuevo valor de modo echo
	call write_stdin_termios ;Escribe nueva configuracion de TERMIOS
	ret
;Final de la Funcion
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;Lectura de la configuraciÃ³n actual del stdin o teclado
;Valores de stdin se cargan con EAX=36h y llamada a la interrupcion 80h
;Para utilizarlo: call read_stdin_termios
read_stdin_termios:
	push rax
	push rbx
	push rcx
	push rdx

	mov eax, 36h
	mov ebx, stdin
	mov ecx, 5401h
	mov edx, termios
	int 80h

	pop rdx
	pop rcx
	pop rbx
	pop rax
	ret
;Final de la Funcion
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;Escritura de la configuracion actual del stdin o teclado
;Para utilizarlo: call write_stdin_termios
write_stdin_termios:
	push rax
	push rbx
	push rcx
	push rdx

	mov eax, 36h
	mov ebx, stdin
	mov ecx, 5402h
	mov edx, termios
	int 80h

	pop rdx
	pop rcx
	pop rbx
	pop rax
	ret
;Final de la Funcion
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;Funcion encargada de limpiar la pantalla
clear_screen: 
	mov rax,1
	mov rdi,1
	mov rsi,clrScreen
	mov rdx,clrScreen_length
	syscall
	ret
;Fin de la funcion
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&	
	
mover_cursor: 
	mov rax,1
	mov rdi,1
	mov rsi,arriba
	mov rdx,arriba_length
	syscall
	mov rsi,derecha
	mov rdx,derecha_length
	syscall
	ret

imparroba:
	mov rax,1
	mov rdi,1
	mov rsi,modificacion
	mov rdx,modificacion_tamano
	syscall
	ret
	
neutro:
	mov rax,1
	mov rdi,1
	mov rsi,neutroa
	mov rdx,neutroa_length
	syscall
	;mov rsi,neutrob
	;mov rdx,neutrob_length
	;syscall
	ret
	
	
	
	

section .text
	global _start				;Etiqueta para ensamblar usando NASM
	global _etiqueta1			;Etiquetas de comprobacion con gdb (no necesarias)
	global _etiqueta2
	global _etiqueta3
	global _paso1
	global _paso2
	global _paso3

_start:
	call clear_screen
	;Encender modo canonico
	call canonical_on   ;Llamado a funcion que enciende el modo canonico
	call echo_on        ;Llamado a funcion que enciende echo

_paso1:
	mov r8, 32
	mov r9, 1
	
	mov rax, 1					
	mov rdi, 1				
	mov rsi, parte1			
	mov rdx, parte1_tamano	
	syscall	
	
	add r9,1
	
_paso2:

	cmp r9, r8
	je _paso3
	mov rax, 1					
	mov rdi, 1	
	mov rsi, parte4			
	mov rdx, parte4_tamano	
	syscall	
	add r9,1
	jmp _paso2
	
	
_paso3:
	
	mov rax, 1					
	mov rdi, 1	
	mov rsi, parte1			
	mov rdx, parte1_tamano	
	syscall	
	;call clear_screen
	call mover_cursor
	call imparroba
	call mover_cursor
	call imparroba
	call mover_cursor
	call imparroba
	call mover_cursor
	call imparroba
	;call neutro
	;jmp _paso3




;Luego de completar el programa, se deben recargar registros con las
;condiciones para la siguiente operación, en este caso: sys_exit (60)
	mov rax,60				;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0				;en rdi se carga un 0
	syscall					;se llama al sistema.
;fin del programa


;comando de ensamblaje
;nasm -f elf64 -o prueba_2.o prueba_2.asm && ld -o ejecutable2 prueba_2.o && ./ejecutable2

