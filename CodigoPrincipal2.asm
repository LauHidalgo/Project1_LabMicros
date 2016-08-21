;#######################################################
;	Tecnologico de Costa Rica - Escuela de Ingenieria Electronica
;	Curso: Laboratorio de Estructura de Microprocesadores - Grupo 1
;	Fecha: Jueves 18 de Agosto de 2016
;
;	Proyecto #1: Juego estilo Arkanoid (Micronoid)
;
;	Codigo desarrollado por el grupo 3:
;		- Anthony Chaves Vasquez
;		- Laura Hidalgo Soto
;		- Carlos Murillo Soto
;		- Irene Rivera Arrieta
;
;#######################################################




;////////////////////////////////////////////////////////////////////	Declaracion de Macros 	////////////////////////////////////////////////////////////////////

;-------------------------------------------------------------------------------------------------------------------------------------
;Macro encargado de imprimir texto
;Recibe 2 parametros: %1 (direccion del texto), %2 (cantidad de bytes del texto)
%macro impr_texto 2 	;recibe 2 parametros
	mov rax,1	        ;sys_write
	mov rdi,1	        ;std_out
	mov rsi,%1	        ;Texto
	mov rdx,%2	        ;Tamano texto
	syscall
%endmacro
;End Macro


;-------------------------------------------------------------------------------------------------------------------------------------
;Macro encargado de leer  texto de teclado y almacenarlo en variable
;Recibe 2 parametros: %1 (direccion donde se guarda el texto)
;%2 (cantidad de bytes a guardar)
%macro leer_texto 2 	;recibe 2 parametros
	mov rax,0	        ;sys_read
	mov rdi,0	        ;std_input
	mov rsi,%1	        ;primer parametro: Variable
	mov rdx,%2	        ;segundo parametro: Tamano 
	syscall
%endmacro
;End Macro


;-------------------------------------------------------------------------------------------------------------------------------------
;Macro encargado de limpiar la pantalla
;Recibe 2 parametros: %1 (direccion de memoria donde se guarda el texto),
;%2 (cantidad de bytes a guardar)
%macro limpiar_pantalla 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: caracteres especiales para limpiar la pantalla
	mov rdx,%2	;segundo parametro: Tamano 
	syscall
%endmacro



;-------------------------------------------------------------------------------------------------------------------------------------


;////////////////////////////////////////////////////////////////////	Definicion de variables	////////////////////////////////////////////////////////////////////

section .data
	;Definicion de las lineas especiales de texto para diujar el area de juego
	linea_techo: 	db '|------------------------------------------------|', 0xa
	linea_bloques:	db '| ######  ######  ######  ######  ######  ###### |', 0xa
	linea_blanca: 	db '|                                                |', 0xa
	linea_bola: 	db '|                        @                       |',  0xa
	linea_tabla: 	db '|                     =======                    |',  0xa
	linea_base: 	db '|------------------------|-----------------------|', 0xa
	
	;Mensajes especiales para el area de juego
	msj_press_x:			db '|         > Presione X para continuar <          |', 0xa
	msj_vida_menos:		db '|             > Ha perdido una vida <            |', 0xa
	msj_game_over:		db '|              > Fin del juego... <              |', 0xa	
	
	;Lineas anteriores son del mismo tamano, entonces se maneja como una constante
	tamano_linea: 		equ 51

	;Lineas para excribir el nombre de usuairo y las vidas restantes
	msj_encabezado_nombre:	db '>>> Usuario: '
	encabezado_nombre_length: equ $-msj_encabezado_nombre		
	msj_arrow:			db '>>>'
	arrow_length: equ $-msj_arrow
	msj_encabezado_vidas:	db '>>> Vidas Restantes: '
	encabezado_vidas_length: equ $-msj_encabezado_vidas
	nueva_linea:			db ' ',0xa
	nueva_linea_length: equ $-nueva_linea
	
	numero1: db '1'		;Variables char que sirven para escribir los numeros 1 al 3
	numero2: db '2'
	numero3: db '3'
	
	;Mensajes para pantalla de bienvenida
	saludo: db 0xa,'Bienvenido a Micronoid', 0xa 								;Mensaje de bienvenida al juego
	saludo_length: equ $-saludo 											;Tamano de la variable saludo

	infoCurso: db 0xa,'EL 4313 Laboratorio de Estructura de Microprocesadores.', 0xa 	;Informacion del curso
	infoCurso_length: equ $-infoCurso										;Tamano de la variable curso
	
	semestre: db 'II Semestre 2016', 0xa  									;Informacion del semestre
	semestre_length: equ $-semestre 										;Tamano variable semestre

	msjUser: db 0xa, 'Ingrese el nombre del jugador y luego presione Enter: ' 		;Banner para ingreso de nombre de usuario.
	msjUser_length: equ $-msjUser 					
		
	;Variables para limpiar pantalla
	clean    db 0x1b, "[2J", 0x1b, "[H"
	clean_tam equ $ - clean
	
	;Manejo del modo canonico y el echo
	termios:	times 36 db 0	;Estructura de 36bytes que contiene el modo de operacion de la consola
	stdin:		equ 0		;Standard Input (se usa stdin en lugar de escribir manualmente los valores)
	ICANON:		equ 1<<1	;ICANON: Valor de control para encender/apagar el modo canonico
	ECHO:           equ 1<<3	;ECHO: Valor de control para encender/apagar el modo de eco
	
	intentos: dq 3			;Variable que indica el numero de intentos que el usuario tiene en el juego
	
	arriba db 0x1b, "[1A" 			;Codigo ANSI para mover el cursor 1 posicion hacia arriba
	abajo db 0x1b, "[1B" 			;Codigo ANSI para mover el cursor 1 posicion hacia abajo
	derecha db 0x1b, "[1C" 			;Codigo ANSI para mover el cursor 1 posicion hacia la derecha
	izquierda db 0x1b, "[1D" 			;Codigo ANSI para mover el cursor 1 posicion hacia la izquierda
	cursor_tamano: equ $-izquierda	
	
	bloquesY: db 0			;Para uso de la funcion BorraBloque, los indices de los bloques al chocar estan 
	bloquesX: db 0			;regidos por estas dos variables
		
	bloque11: db 1		;Las variabes bloque sirven para tener control de cuales bloques ya han sido eliminados
	bloque12: db 1
	bloque13: db 1
	bloque14: db 1
	bloque15: db 1
	bloque16: db 1
	bloque21: db 1
	bloque22: db 1
	bloque23: db 1
	bloque24: db 1
	bloque25: db 1
	bloque26: db 1
	bloque31: db 1
	bloque32: db 1
	bloque33: db 1
	bloque34: db 1
	bloque35: db 1
	bloque36: db 1
	
	
	posY_tabla: db 5		;Las variables de posicion de la tabla y la pelota
	posY_bola: db 6
	posX_tabla: db 21
	posX_bola: db 25
	
	dir_mov_X: db '+'		;Por cuestion de control, se tienen las variables de en que direccion de movimiento se encuentra la pelota
	dir_mov_Y: db '+'


;segmento de datos no-inicializados, que se pueden usar para capturar variables 
;del usuario, por ejemplo: desde el teclado
section .bss
	temporal: resb 1
	userName: resb 20
	
;-------------------------------------------------------------------------------------------------------------------------------------


;////////////////////////////////////////////////////////////////////	Codigo Principal	////////////////////////////////////////////////////////////////////

section .text
	global _start		;Definicion de la etiqueta inicial


_start:

	;Limpiar la pantalla
	limpiar_pantalla clean,clean_tam
	
	;Imprime primera pantalla de bienvenida

	;Se enciende el modo canonico
	call canonical_on 
	call echo_on
	
	;Se imprime la pantalla inicial
	impr_texto saludo,saludo_length
	impr_texto infoCurso,infoCurso_length
	impr_texto semestre,semestre_length
	impr_texto msjUser,msjUser_length
		
	;Se activa la macro para capturar el numbre desde el teclado
	leer_texto userName,20
	
	;Apagar el modo canonico
	call canonical_off
	call echo_off

	;Limpiar la pantalla
	limpiar_pantalla clean,clean_tam
	
	;Imprimir la pantalla de pausa
	call imprimirpantalla_pausa

	;Esperar a leer la tecla X para ingresar al juego
	_leer_press_x:
	leer_texto temporal,1	
	mov al, [temporal]
	cmp al, 'x'
	jne _leer_press_x
	
	;Se limpia la pantalla y se imprime la pantalla de juego.
	limpiar_pantalla clean,clean_tam
	call imprimirpantalla_normal
	
	;Se coloca el cursor en la posicion de inicio
	call cursor_inicial
	
	;Se inicializan las variables de posicion de la pelota, tabla y los bloques
		
		
	

	;Finalmente, se devuelven los recursos del sistema
	;y se termina el programa
	call echo_on	;se devuelve el modo echo al sistema
	mov rax,60	;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0	;en rdi se carga un 0
	syscall	
		
	


;-------------------------------------------------------------------------------------------------------------------------------------
;FIN DEL PROGRAMA	PRINCIPAL
;-------------------------------------------------------------------------------------------------------------------------------------



;////////////////////////////////////////////////////////////////////	Declaracion de CALL's (metodos o funciones) luego del codigo principal	////////////////////////////////////////////////////////////////////

;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que imprime el area de juego con el mensaje de espera
imprimirpantalla_pausa:
	impr_texto linea_techo,tamano_linea
	impr_texto linea_blanca,tamano_linea
	
	;se hace un loop para imprimir 3 lineas de tipo "linea_bloque"
	mov r8,0
	loop_1:
		impr_texto linea_bloques,tamano_linea
		inc r8
		cmp r8,3
		jne loop_1
	;se hace un loop para imprimir 9 lineas de tipo "linea_blanco"
	mov r8,0
	loop_2:
		impr_texto linea_blanca,tamano_linea
		inc r8
		cmp r8,9
		jne loop_2
		
	;se imprime el mensaje de bienvenida
	impr_texto msj_press_x,tamano_linea
	
	;se hace un loop para imprimir 8 lineas de tipo "linea_blanco"
	mov r8,0
	loop_3:
	impr_texto linea_blanca,tamano_linea
	inc r8
	cmp r8,10
	jne loop_3
			
	
	impr_texto linea_bola,tamano_linea
	;se imprime la linea de la plataforma
	impr_texto linea_tabla,tamano_linea
	;se imprime la linea del piso
	impr_texto linea_blanca,tamano_linea
	impr_texto linea_blanca,tamano_linea
	impr_texto linea_base,tamano_linea
	call usuarioyvidas
	
	ret
;Final de la Funcion

;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que imprime la pantalla de juego en donde se desarrollara el juego
imprimirpantalla_normal:
	impr_texto linea_techo,tamano_linea
	impr_texto linea_blanca,tamano_linea
	;se hace un loop para imprimir 3 lineas de tipo "line_bloque"
	mov r8,0
	loop_4:
		impr_texto linea_bloques,tamano_linea
		inc r8
		cmp r8,3
		jne loop_4
	;se hace un loop para imprimir 20 lineas de tipo "linea_blanco"
	mov r8,0
	loop_5:
		impr_texto linea_blanca,tamano_linea
		inc r8
		cmp r8,20
		jne loop_5
			
	
	impr_texto linea_bola,tamano_linea
	;se imprime la linea de la plataforma
	impr_texto linea_tabla,tamano_linea
	;se imprime la linea del piso
	impr_texto linea_blanca,tamano_linea
	impr_texto linea_blanca,tamano_linea
	impr_texto linea_base,tamano_linea
	call usuarioyvidas
	
	ret
;Final de la Funcion

;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que imprime el nombre de usuario y la cantida de vidas que tiene
usuarioyvidas:	
	impr_texto msj_encabezado_nombre, encabezado_nombre_length
	impr_texto userName, 20
	impr_texto nueva_linea, nueva_linea_length
	impr_texto msj_encabezado_vidas, encabezado_vidas_length
	
	mov r8, [intentos]
	
	cmp r8, 3
	jne _jump1
	impr_texto numero3, 1
	jmp _finusuarioyvidas
	
	_jump1:
	cmp r8, 2
	jne _jump2
	impr_texto numero2, 1
	jmp _finusuarioyvidas
	
	_jump2:
	impr_texto numero1, 1
	
	_finusuarioyvidas:
	impr_texto nueva_linea, nueva_linea_length
	ret
;Final de la funcion	

;-------------------------------------------------------------------------------------------------------------------------------------
;Se enciende modo canonico de Linux. Linux espera un ENTER
;para procesar la captura del teclado
canonical_on:
	call read_stdin_termios 			;Funcion que lee estado actual de TERMIOS en STDIN
	or dword [termios+12], ICANON	;Escribe nuevo valor del modo canonico
	call write_stdin_termios 			;Escribe nueva configuracion de TERMIOS
	ret
;Final de la Funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Se apaga el modo canonico de Linux. 
canonical_off:
	call read_stdin_termios  	;Funcion que lee estado actual de TERMIOS en STDIN
	mov rax, ICANON		;Carga el valor de ICANON al registro RAX
	not rax				;Invierte el valor de los bits de RAX
	and [termios+12], rax 	;Escribe nuevo valor del modo canonico
	call write_stdin_termios	;Escribe nueva configuracion de TERMIOS
	ret
;Final de la Funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Habilitacion del modo ECHO. Linux muestra en la pantalla(stdout) cada tecla que se 
;escribe en el teclado (stdin)
echo_on:
	call read_stdin_termios 			;Lee el estado actual del TERMIOS en STDIN
	or dword [termios+12], ECHO 		;Escribe nuevo valor de modo echo
	call write_stdin_termios 			;Escribe nueva configuracion de TERMIOS
	ret
;Final de la Funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Deshabilitacion del modo ECHO. 
echo_off:
	call read_stdin_termios 		;Lee el estado actual del TERMIOS en STDIN
	mov rax, ECHO			;Se mueve la direccion de memoria ECHO a rax
	not rax					;Se invierte rax
	and [termios+12], rax 		;Escribe nuevo valor de modo echo
	call write_stdin_termios 		;Escribe nueva configuracion de TERMIOS
	ret
;Final de la Funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Lectura de la configuracion actual del stdin o teclado
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


;-------------------------------------------------------------------------------------------------------------------------------------
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


;-------------------------------------------------------------------------------------------------------------------------------------
;
cursor_inicial:
	mov r8, 0
	
	_cursorincialloop:
	cmp r8, 4
	je _fincursorinicial
	impr_texto arriba, cursor_tamano
	inc r8
	jmp _cursorincialloop
	
	_fincursorinicial:
	
ret
	
;-------------------------------------------------------------------------------------------------------------------------------------
;FIN DEL CODIGO FUENTE	
;-------------------------------------------------------------------------------------------------------------------------------------

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;COMANDO DE EMSAMBLAJE
;nasm -f elf64 -o principal.o CodigoPrincipal2.asm && ld -o mainexe2 principal.o && ./mainexe2
