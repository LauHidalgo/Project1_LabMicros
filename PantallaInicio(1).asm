;#######################################################
;	Pantalla de inicio
;#######################################################

;________________Segmento de Datos______________________
section .data
	infoInicial: db 'EL 4313 Laboratorio de Estructura de Microprocesadores.', 0xa ;Informacion del curso
	infoInicial_length: equ $-infoInicial	;Tamaño de la variable curso
	
	semestre: db 'II Semestre 2016', 0xa  ;Información del semestre
	semestre_length: equ $-semestre ;Tamaño variable semestre

	msjUser: db 'Ingrese el nombre del jugador y luego presione Enter: ' ;Banner para ingreso de nombre de usuario.
	msjUser_length: equ $-msjUser ;Longitud de msj de nombre del usuario

	nameUser: db'' ;Almacena nombre del usuario
	;nameUyer_length: equ $-nameUser

	termios: times 36 db 0 ;Estructura 36 bytes, contiene modo de operación de la consola
	stdin: equ 0 ;Standar Input
	ICANON: equ 1<<1 ;ICANON: valor de control para on/off modo canonico
	ECHO: equ 1<<3 ;ECHO: valor control para on/off eco
	
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
	;TERMIOS = TERMinal Input/Output Settings

;____________Declaración de Funciones____________________

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
;Lectura de la configuración actual del stdin o teclado
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


;_____________Segmento de Codigo_________________________
section .text
	global _start ;Definicion de etiqueta inicial
	global _primero
	global _segundo
	global _tercero
	global _finprograma

;Se van a realizar diferentes pasos para mantener el orden

_start:
;Se muestran los banner iniciales de la pantalla de inicio
	;Encender modo canonico
	call canonical_on  ;Llamado a funcion que enciende el modo canonico
	call echo_on        ;Llamado a funcion que enciende echo

	;Imprimir banner de con informacion del curso
	mov rax,1           ;rax = sys_write
	mov rdi,1           ;rdi = pantalla (standar output)
	mov rsi,infoInicial ;rsi = msj a imprimir
	mov rdx,infoInicial_length
	syscall 
	
	;Imprimir informacion del Semestre
	mov rax,1
	mov rdi,1
	mov rsi,semestre
	mov rdx,semestre_length
	syscall

	;Muestra msj de ingreso de nombre de usuario
	mov rax,1
	mov rdi,1
	mov rsi,msjUser
	mov rdx,msjUser_length
	syscall

_primero:
	;Captura de nombre de usuario
	mov rax,0          ;rax = sys_read
	mov rdi,0          ;rdi = teclado (standar input)
	mov rsi,nameUser   ;direccion de memoria donde se almacena nombre del usuario
	mov rdx,1
	syscall

_segundo:
	;Imprimir msj de "salida"
	mov rax,1
	mov rdi,1
	mov rsi,infoInicial
	mov rdx,infoInicial_length
	syscall

_tercero:
	;Imprimir información capturada
	mov rax,1
	mov rdi,1
	mov rsi,nameUser
	mov rdx,1
	syscall

_finprograma:
	;Finalizacion del programa
	mov rax,60  ;rax = sys_exit
	mov rdi,0   ;rdi = 0
	syscall

;________________________________________________________
;FIN DEL PROGRAMA	

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;COMANDO DE EMSAMBLAJE
;nasm -f elf64 -o name.o name.asm 
;ld -o ejecutable_name name.o 
;./ejecutable_name

