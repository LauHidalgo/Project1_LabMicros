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

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
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
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;Macro encargado de leer  texto de teclado y almacenarlo en variable
;Recibe 2 parametros: %1 (direccion donde se guarda el texto)
;%2 (cantidad de bytes a guardar)
;-----------------------------------------------------------------------
%macro leer_texto 2 	;recibe 2 parametros
	mov rax,0	        ;sys_read
	mov rdi,0	        ;std_input
	mov rsi,%1	        ;primer parametro: Variable
	mov rdx,%2	        ;segundo parametro: Tamano 
	syscall
%endmacro
;End Macro
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
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
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;Macro que lee stdin_termios
;Recibe 2: %1 (valor de stdin), %2 (valor de termios)
%macro read_stdin_termios 2
        push rax
        push rbx
        push rcx
        push rdx

        mov eax, 36h
        mov ebx, %1
        mov ecx, 5401h
        mov edx, %2
        int 80h

        pop rdx
        pop rcx
        pop rbx
        pop rax
%endmacro
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;Macro que escribe stdin_termios
;Recibe 2 : %1 (valor de stdin), %2 (valor de termios)
;-----------------------------------------------------------------------
%macro write_stdin_termios 2
        push rax
        push rbx
        push rcx
        push rdx

        mov eax, 36h
        mov ebx, %1
        mov ecx, 5402h
        mov edx, %2
        int 80h

        pop rdx
        pop rcx
        pop rbx
        pop rax
%endmacro
;End macro
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;Macro apagar modo canonico del Kernel
;parametros: %1 (valor de ICANON), %2 (valor de termios)
%macro canonical_off 2
	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
        read_stdin_termios stdin,termios

	;Se escribe el nuevo valor de ICANON en EAX, para apagar el modo canonico
        push rax
        mov eax, %1
        not eax
        and [%2 + 12], eax
        pop rax

	;Se escribe la nueva configuracion de TERMIOS
        write_stdin_termios stdin,termios
%endmacro
;End Macro
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
        
	
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;Macro que enciende el modo canonico del Kernel
;Parametros: %1 (valor de ICANON);	%2 (valor de termios)
%macro canonical_on 2

	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
	read_stdin_termios stdin,termios

        ;Se escribe el nuevo valor de modo Canonico
        or dword [%2 + 12], %1

	;Se escribe la nueva configuracion de TERMIOS
        write_stdin_termios stdin,termios
%endmacro
;End macro
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


;################ Definición de variables #########################

section .data
	;Definicion de las lineas especiales de texto para diujar el area de juego
	line_techo: 		db '===============================================================', 0xa
	line_blanco: 		db '|                                                             |', 0xa
	line_bloque: 		db '|  ########  ########  ########  ########  ########  ######## |', 0xa
	line_cubo: 		db '|                             ###                             |', 0xa
	line_plataforma:	db '|                          =========                          |', 0xa
	line_piso:		        db '|^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^|', 0xa
	
	;Mensajes especiales para el area de juego
	msj_press_x:	db '|                    Presione X para iniciar                  |', 0xa
	vida_menos:	db '|         Perdio una vida - Presione X para continuar         |', 0xa
	game_over:	db '|         Fin del Juego   - Presione X para continuar         |', 0xa
	
	;Lineas anteriores son del mismo tamano, entonces se maneja como una constante
	tamano_linea: 		equ 64
	
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


;segmento de datos no-inicializados, que se pueden usar para capturar variables 
;del usuario, por ejemplo: desde el teclado
section .bss
	press_x: resb 1
	userName: resb 20
;#######################################################################


;######################## SEGMENTO DE CODIGO ###########################

;---------- Ejecucion del programa principal -----------------------
section .text
	global _start		;Definicion de la etiqueta inicial

_start:
	;Limpiar la pantalla
	limpiar_pantalla clean,clean_tam
	
	;Imprime primera pantalla de bienvenida
	_bienvenida1:
		;Se enciende el modo canonico
		canonical_on ICANON,termios
		
		impr_texto saludo,saludo_length
		impr_texto infoCurso,infoCurso_length
		impr_texto semestre,semestre_length
		impr_texto msjUser,msjUser_length
		
	_leer_user_name:
		leer_texto userName,20
	
	;Apagar el modo canonico
	canonical_off ICANON,termios
	
	;Imprime la segunda pantalla de bienvenida 
	_bienvenida2:
		;Limpiar la pantalla
		limpiar_pantalla clean,clean_tam
		
		impr_texto line_techo,tamano_linea
		impr_texto line_blanco,tamano_linea
		;se hace un loop para imprimir 3 lineas de tipo "line_bloque"
		mov r8,0
		loop_1:
			impr_texto line_bloque,tamano_linea
			inc r8
			cmp r8,0x3
			jne loop_1
		;se hace un loop para imprimir 5 lineas de tipo "line_blanco"
		mov r8,0
		loop_2:
			impr_texto line_blanco,tamano_linea
			inc r8
			cmp r8,0x5
			jne loop_2
			
		;se imprime el mensaje de bienvenida
		impr_texto msj_press_x,tamano_linea
		;se hace un loop para imprimir 5 lineas de tipo "linea_blanco"
		mov r8,0
		loop_3:
			impr_texto line_blanco,tamano_linea
			inc r8
			cmp r8,0x5
			jne loop_3
				
		;se imprimen 2 lineas de tipo line_cubo
		impr_texto line_cubo,tamano_linea
		impr_texto line_cubo,tamano_linea
		;se imprime la linea de la plataforma
		impr_texto line_plataforma,tamano_linea
		;se imprime la linea del piso
		impr_texto line_blanco,tamano_linea
		impr_texto line_piso,tamano_linea
	
	
	_leer_press_x:
		leer_texto press_x,1
	
	
	;Se limpia la pantalla y se imprime la pantalla de juego.
	_pantalla_juego:
		limpiar_pantalla clean,clean_tam
		
		impr_texto line_techo,tamano_linea
		impr_texto line_blanco,tamano_linea
		;se hace un loop para imprimir 3 lineas de tipo "line_bloque"
		mov r8,0
		loop_4:
			impr_texto line_bloque,tamano_linea
			inc r8
			cmp r8,0x3
			jne loop_4
		;se hace un loop para imprimir 11 lineas de tipo "linea_blanco"
		mov r8,0
		loop_5:
			impr_texto line_blanco,tamano_linea
			inc r8
			cmp r8,0x0B
			jne loop_5
			
		;se imprimen 2 lineas de tipo linea_cubo
		impr_texto line_cubo,tamano_linea
		impr_texto line_cubo,tamano_linea
		;se imprime la linea de la plataforma
		impr_texto line_plataforma,tamano_linea
		;se imprime la linea del piso
		impr_texto line_blanco,tamano_linea
		impr_texto line_piso,tamano_linea
	
	;Se enciende el modo canonico
	canonical_on ICANON,termios

	;Finalmente, se devuelven los recursos del sistema
	;y se termina el programa
		mov rax,60	;se carga la llamada 60d (sys_exit) en rax
		mov rdi,0	;en rdi se carga un 0
		syscall	
;-------------------------------------------------------------------------------------------------------------------------------------
;FIN DEL CODIGO FUENTE	
;-------------------------------------------------------------------------------------------------------------------------------------

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;COMANDO DE EMSAMBLAJE
;nasm -f elf64 -o principal.o CodigoPrincipal.asm && ld -o mainexe principal.o && ./mainexe
