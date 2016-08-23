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
	pelota:		db '@'
	tabla: 		db '=======',  
	pelota_borrar:		db ' '
	tabla_borrar: 		db '       ',  
	
	
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
	
	arriba: db 0x1b, "[1A" 			;Codigo ANSI para mover el cursor 1 posicion hacia arriba
	abajo: db 0x1b, "[1B" 			;Codigo ANSI para mover el cursor 1 posicion hacia abajo
	derecha: db 0x1b, "[1C" 			;Codigo ANSI para mover el cursor 1 posicion hacia la derecha
	izquierda: db 0x1b, "[1D" 			;Codigo ANSI para mover el cursor 1 posicion hacia la izquierda
	cursor_tamano: equ $-izquierda	
	

	bloque11: dq 1		;Las variabes bloque sirven para tener control de cuales bloques ya han sido eliminados
	bloque12: dq 1
	bloque13: dq 1
	bloque14: dq 1
	bloque15: dq 1
	bloque16: dq 1
	bloque21: dq 1
	bloque22: dq 1
	bloque23: dq 1
	bloque24: dq 1
	bloque25: dq 1
	bloque26: dq 1
	bloque31: dq 1
	bloque32: dq 1
	bloque33: dq 1
	bloque34: dq 1
	bloque35: dq 1
	bloque36: dq 1
	
	
	posY_tabla: dq 3		;Las variables de posicion de la tabla y la pelota
	posY_bola: dq 4
	posX_tabla: dq 22
	posX_bola: dq 25
	
	deltaY:	dq	0		;Las variables de cantidad de desplazamiento
	deltaX:	dq	0
	
	dir_mov_X: db '+'		;Las variablesde direccion de movimiento de la pelota
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
	
	;Se llama a la funcion para dibujar la tabla y la pelota 
	call imprime_tabla_pelota
	
	;Se reinician los valores de posicion 
	call reestablecer_valores
	
	
	
	
	
	
	
	
	
	
	
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
		cmp r8,24
		jne loop_5
			
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
;Funcion que realiza 4 movimientos hacia arriba para colocar el cursor en el origen de coordenadas
;del area de juego.
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
;Funcion que dibuja los movimientos de la pelota y de la tabla segun la posicion en la que se encuentren
imprime_tabla_pelota:
	
	;movimientos de la pelota
	;----------------------------------
	mov r8, 0
	_imprimetablapelotaloop1:
	cmp r8, [posX_bola]
	je _ciclo1
	impr_texto derecha, cursor_tamano
	inc r8
	jmp _imprimetablapelotaloop1
	
	_ciclo1:
	mov r8, 0
	_imprimetablapelotaloop2:
	cmp r8, [posY_bola]
	je _imprime_pelota
	impr_texto arriba, cursor_tamano
	inc r8
	jmp _imprimetablapelotaloop2
	
	_imprime_pelota:
	impr_texto pelota, 1
	
	mov r8, 0
	mov r9, [posX_bola]
	add r9, 1
	_imprimetablapelotaloop3:
	cmp r8, r9
	je _ciclo2
	impr_texto izquierda, cursor_tamano
	inc r8
	jmp _imprimetablapelotaloop3
	
	_ciclo2:
	mov r8, 0
	_imprimetablapelotaloop4:
	cmp r8, [posY_bola]
	je _ciclo3
	impr_texto abajo, cursor_tamano
	inc r8
	jmp _imprimetablapelotaloop4
	
	;movimientos de la tabla
	;----------------------------------
	_ciclo3:
	mov r8, 0
	_imprimetablapelotaloop5:
	cmp r8, [posX_tabla]
	je _ciclo4
	impr_texto derecha, cursor_tamano
	inc r8
	jmp _imprimetablapelotaloop5
	
	_ciclo4:
	mov r8, 0
	_imprimetablapelotaloop6:
	cmp r8, [posY_tabla]
	je _imprime_tabla
	impr_texto arriba, cursor_tamano
	inc r8
	jmp _imprimetablapelotaloop6
	
	_imprime_tabla:
	impr_texto tabla, 7
	
	mov r8, 0	
	mov r9, [posX_tabla]
	add r9, 7
	_imprimetablapelotaloop7:
	cmp r8, r9
	je _ciclo5
	impr_texto izquierda, cursor_tamano
	inc r8
	jmp _imprimetablapelotaloop7
	
	_ciclo5:
	mov r8, 0
	_imprimetablapelotaloop8:
	cmp r8, [posY_tabla]
	je _finalimprimetablapelota
	impr_texto abajo, cursor_tamano
	inc r8
	jmp _imprimetablapelotaloop8
	
	_finalimprimetablapelota:
	ret
;Fin de la funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que reestablece los valores de las variables de posicion y movimiento
reestablecer_valores:
	mov r8, 3
	mov [posY_tabla], r8
	mov r8, 4
	mov [posY_bola], r8
	mov r8, 22
	mov [posX_tabla], r8
	mov r8, 25
	mov [posX_bola], r8
	mov r8,0
	mov al, '+'
	mov [dir_mov_X], al
	mov [dir_mov_Y], al
	mov r8, 1
	mov [bloque11], r8
	mov [bloque12], r8
	mov [bloque13], r8
	mov [bloque14], r8
	mov [bloque15], r8
	mov [bloque16], r8
	mov [bloque21], r8
	mov [bloque22], r8
	mov [bloque23], r8
	mov [bloque24], r8
	mov [bloque25], r8
	mov [bloque26], r8
	mov [bloque31], r8
	mov [bloque32], r8
	mov [bloque33], r8
	mov [bloque34], r8
	mov [bloque35], r8
	mov [bloque36], r8
		
ret	
;Fin de la funcion



;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que modifica la direccion de la pelota cuando 
modificar_direccion:
	mov r8, [posX_bola]			;Se carga la posicion X de la bola 
	
	cmp r8, 1					;Se realiza la primera comparacion, si X=1 (pared izquierda del area de juego)
		;if not
		jne _m_p_jmp1			;Si no X no es igual a uno se pasa a la otra comparacion
		
		_m_p_jmp1_2:				;Etiqueta de salto para la segunda comparacion
		;if equal
		mov al, [dir_mov_X]		
		cmp al, '+'				;Se compara el string de posicion
			;if not
			jne _m_p_jmp1_1		;Si no es positiva, se salta a la etiqueta _m_p_jmp1_1
			
			;if equal comandos
			mov al, '-'			;Si la condicion es positiva, se cambia dir_mov_X a negativo
			mov [dir_mov_X], al
			jmp _m_p_final
			
			;if not comandos
			_m_p_jmp1_1:			
			mov al, '+'			;Si la condicion es negativa, se cambia dir_mov_X a positivo
			mov [dir_mov_X], al
			jmp _m_p_final
	
	
	
	_m_p_jmp1:					;Se realiza la segunda comparacion, si X=49 (pared derecha del area de juego)
	cmp r8, 49
		;if not
		jne _m_p_jmp2			;Si no es igual, entonces se salta a la tercera comparacion
		
		;if equal
		jmp _m_p_jmp1_2			;Si es igual, el procedimiento es el mismo que la comparacion 1, por lo tanto se salta hacia ahi.
		
		
	_m_p_jmp2
	mov r8, [posY_bola]
	
	cmp r8, 29
		;if  not
		jne _m_p_final
		
		;if equal
		mov al, [dir_mov_Y]
		cmp al, '+'
			;if not
			jne _m_p_jmp2_1
			
			;if equal comandos
			mov al, '-'
			mov [dir_mov_Y], al
			jmp _m_p_final
			
			;if not comandos
			_m_p_jmp2_1:
			mov al, '+'
			mov [dir_mov_Y], al
			jmp _m_p_final
			
	_m_p_final:

ret
;Fin de la funcion



;-------------------------------------------------------------------------------------------------------------------------------------
;FIN DEL CODIGO FUENTE	
;-------------------------------------------------------------------------------------------------------------------------------------

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;COMANDO DE EMSAMBLAJE
;nasm -f elf64 -o principal.o CodigoPrincipal2.asm && ld -o mainexe2 principal.o && ./mainexe2
