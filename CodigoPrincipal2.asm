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



;////////////////////////////////////////////////////////////////////	Definicion de variables	////////////////////////////////////////////////////////////////////

section .data
	;Definicion de las lineas especiales de texto para diujar el area de juego
	linea_techo: 	db '|-------------------------------------------------|', 0xa
	linea_bloques:	db '| ####### ####### ####### ####### ####### ####### |', 0xa
	linea_blanca: 	db '|                                                 |', 0xa
	linea_bola: 	db '|                         @                       |',  0xa
	linea_tabla: 	db '|                      =======                    |',  0xa
	linea_base: 	db '|-------------------------|-----------------------|', 0xa
	pelota:		db '@'
	tabla: 		db '======='
	pelota_borrar:		db ' '
	tabla_borrar: 		db '       '  
	bloques_borrar:	db '       '
	
	
	;Mensajes especiales para el area de juego
	msj_press_x:			db '|          > Presione X para continuar <          |', 0xa
	msj_vida_menos:		db '|              > Ha perdido una vida <            |', 0xa
	msj_game_over:		db '|               > Fin del juego... <              |', 0xa	
	
	;Lineas anteriores son del mismo tamano, entonces se maneja como una constante
	tamano_linea: 		equ 52

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
	posY_bloque: dq 0
	posX_tabla: dq 24	
	posX_bola: dq 23
	posX_bloque: dq 0
	
	deltaY:	dq	0		;Las variables de cantidad de desplazamiento
	deltaX:	dq	0
	
	dir_mov_X: dq '+'		;Las variablesde direccion de movimiento de la pelota
	dir_mov_Y: dq '+'
	
	teclado: dq '-'
	
;segmento de datos no-inicializados, que se pueden usar para capturar variables 
;del usuario, por ejemplo: desde el teclado
section .bss
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
	canonical_on ICANON,termios
		
	;Se imprime la pantalla inicial
	impr_texto saludo,saludo_length
	impr_texto infoCurso,infoCurso_length
	impr_texto semestre,semestre_length
	impr_texto msjUser,msjUser_length
		
	;Se activa la macro para capturar el numbre desde el teclado
	leer_texto userName,20
	
	;Apagar el modo canonico
	canonical_off ICANON,termios
	call echo_off

	;Limpiar la pantalla
	limpiar_pantalla clean,clean_tam
	
	;Imprimir la pantalla de pausa
	call imprimirpantalla_pausa

	;Esperar a leer la tecla X para ingresar al juego
	_leer_press_x:
	leer_texto teclado,1	
	mov r15, [teclado]
	cmp r15, 'x'
	jne _leer_press_x
	
	;Se limpia la pantalla y se imprime la pantalla de juego.
	limpiar_pantalla clean,clean_tam
	call imprimirpantalla_normal
	
	;Se coloca el cursor en la posicion de inicio
	call cursor_inicial
	
		
	
	;Se reinician los valores de posicion 
	call reestablecer_valores
	
	
	
	;///////////////////////////////////////////////////
	;///////////////////////////////////////////////////
	;///////////////////////////////////////////////////
	;EXCLUSIVAMENTE PARA PRUEBAS
	
	mov r14, 1
	mov [deltaY], r14
	mov r14, 5
	mov [deltaX], r14
	
	
	_loopdeprueba:

	call imprime_tabla_pelota	
	
	leer_texto teclado,1	
	mov r15, [teclado]
	
	cmp r15, 'p'
	je _final_ejecucion
	
	cmp r15, 'z'
	je _mov_izquierda	
	
	cmp r15, 'c'
	je _mov_derecha
	
	call borra_tabla_pelota
	jmp _siguiente
	
	_mov_izquierda:
	call borra_tabla_pelota
	call tabla_izquierda	
	jmp _siguiente	
	
	_mov_derecha:
	call borra_tabla_pelota
	call tabla_derecha	
	jmp _siguiente
	
	_siguiente:
	
	call borra_tabla_pelota
	
	call modificar_posicion
	
	mov r8, posX_bloque
	cmp r8, 0
	je _loopdeprueba
	
	call borra_bloque
	cmp r8, 0
	mov [posX_bloque], r8 
	mov [posY_bloque], r8 
	jmp _loopdeprueba
	
	
	_final_ejecucion:
	limpiar_pantalla clean,clean_tam
	;EXCLUSIVAMENTE PARA PRUEBAS
	;///////////////////////////////////////////////////
	;///////////////////////////////////////////////////
	;///////////////////////////////////////////////////
	
	
	
	
	
	
	
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
	mov r8, 0						;Se carga el registro r8 con un cero
	
	_cursorincialloop:					;Etiqueta para realizar el salto
	cmp r8, 4						;Se compara r8 con 4
	je _fincursorinicial					;Si el registro contador es igual a 4, se termina la funcion
	impr_texto arriba, cursor_tamano	;Se imprime el codigo ESC-ANSI para mover el cursor para arriba
	inc r8							;Se incrementa en 1 unidad el registro contador r8
	jmp _cursorincialloop				;Se devuelve a la etiqueta para realizar el dato
	
	_fincursorinicial:					;Etiqueta que indica el fin de la funcion
	
ret


;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que dibuja los movimientos de la pelota y de la tabla segun la posicion en la que se encuentren
imprime_tabla_pelota:
	
	;movimientos de la pelota
	;----------------------------------
	mov r8, 0							;Se inicializa el registro contador r8
	_imprimetablapelotaloop1:
	cmp r8, [posX_bola]					;Se compara el contador con el registro
	je _ciclo1								;Si se completan los movimientos a la derecha, se pasan a los movimientos verticales
	impr_texto derecha, cursor_tamano			;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en una unidad el registro contador
	jmp _imprimetablapelotaloop1				;Retorno a un nuevo ciclo
	
	_ciclo1:
	mov r8, 0							;Se reinicia el registro contador
	_imprimetablapelotaloop2:				
	cmp r8, [posY_bola]					
	je _imprime_pelota						;Si ya se han completado los movimientos hacia arriba, se pasa a imprimir la pelota
	impr_texto arriba, cursor_tamano			;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en una unidad el registro contador
	jmp _imprimetablapelotaloop2				;Retorno a un nuevo ciclo
	
	_imprime_pelota:
	impr_texto pelota, 1						;Impresion de la pelota
	
	mov r8, 0							;Reinicio del registro contador
	mov r9, [posX_bola]					;Se carga la posicion de la pelota 
	add r9, 1								;Se agrega un 1 a la posicion de la pelota, para contrarrestar el offset generado por el codigo ANSI
	_imprimetablapelotaloop3:
	cmp r8, r9							;Si ya se acabaron los movimientos a la izquierda, se pasa a los movimientos hacia abajo
	je _ciclo2
	impr_texto izquierda, cursor_tamano		;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en una unidad el registro contador
	jmp _imprimetablapelotaloop3				;Retorno a un nuevo ciclo
	
	_ciclo2:
	mov r8, 0							;Se reinicia el registro contador
	_imprimetablapelotaloop4:			
	cmp r8, [posY_bola]					;Si ya se realizaron los movimientos hacia abajo, entonces se pasa al proceso de imprimir la tabla
	je _ciclo3
	impr_texto abajo, cursor_tamano			;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en 1 unidad el registro contador
	jmp _imprimetablapelotaloop4				;Retorno a un nuevo ciclo
	
	;movimientos de la tabla
	;----------------------------------
	
	;Nota importante: El procedimiento que se sigue para imprimir la tabla es el mismo que en la pelota, asi que los
	;comentarios para esta seccion no son necesarios.
	
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
	add r9, 7						;Se agregan 7 unidades a la posicion original debido al offset generado por la impresion de la tabla
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
;Funcion que borra la pelota y de la tabla segun la posicion en la que se encuentren
borra_tabla_pelota:
	
	;movimientos de la pelota
	;----------------------------------
	mov r8, 0							;Se inicializa el registro contador r8
	_borratablapelotaloop1:
	cmp r8, [posX_bola]					;Se compara el contador con el registro
	je _ciclo6								;Si se completan los movimientos a la derecha, se pasan a los movimientos verticales
	impr_texto derecha, cursor_tamano			;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en una unidad el registro contador
	jmp _borratablapelotaloop1				;Retorno a un nuevo ciclo
	
	_ciclo6:
	mov r8, 0							;Se reinicia el registro contador
	_borratablapelotaloop2:				
	cmp r8, [posY_bola]					
	je _borra_pelota						;Si ya se han completado los movimientos hacia arriba, se pasa a imprimir la pelota
	impr_texto arriba, cursor_tamano			;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en una unidad el registro contador
	jmp _borratablapelotaloop2				;Retorno a un nuevo ciclo
	
	_borra_pelota:
	impr_texto pelota_borrar, 1						;Impresion de la pelota
	
	mov r8, 0							;Reinicio del registro contador
	mov r9, [posX_bola]					;Se carga la posicion de la pelota 
	add r9, 1								;Se agrega un 1 a la posicion de la pelota, para contrarrestar el offset generado por el codigo ANSI
	_borratablapelotaloop3:
	cmp r8, r9							;Si ya se acabaron los movimientos a la izquierda, se pasa a los movimientos hacia abajo
	je _ciclo7
	impr_texto izquierda, cursor_tamano		;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en una unidad el registro contador
	jmp _borratablapelotaloop3				;Retorno a un nuevo ciclo
	
	_ciclo7:
	mov r8, 0							;Se reinicia el registro contador
	_borratablapelotaloop4:			
	cmp r8, [posY_bola]					;Si ya se realizaron los movimientos hacia abajo, entonces se pasa al proceso de imprimir la tabla
	je _ciclo8
	impr_texto abajo, cursor_tamano			;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en 1 unidad el registro contador
	jmp _borratablapelotaloop4				;Retorno a un nuevo ciclo
	
	;movimientos de la tabla
	;----------------------------------
	
	;Nota importante: El procedimiento que se sigue para imprimir la tabla es el mismo que en la pelota, asi que los
	;comentarios para esta seccion no son necesarios.
	
	_ciclo8:
	mov r8, 0
	_borratablapelotaloop5:
	cmp r8, [posX_tabla]
	je _ciclo9
	impr_texto derecha, cursor_tamano
	inc r8
	jmp _borratablapelotaloop5
	
	_ciclo9:
	mov r8, 0
	_borratablapelotaloop6:
	cmp r8, [posY_tabla]
	je _borra_tabla
	impr_texto arriba, cursor_tamano
	inc r8
	jmp _borratablapelotaloop6
	
	_borra_tabla:
	impr_texto tabla_borrar, 7
	
	mov r8, 0	
	mov r9, [posX_tabla]
	add r9, 7						;Se agregan 7 unidades a la posicion original debido al offset generado por la impresion de la tabla
	_borratablapelotaloop7:
	cmp r8, r9
	je _ciclo10
	impr_texto izquierda, cursor_tamano
	inc r8
	jmp _borratablapelotaloop7
	
	_ciclo10:
	mov r8, 0
	_borratablapelotaloop8:
	cmp r8, [posY_tabla]
	je _finalborratablapelota
	impr_texto abajo, cursor_tamano
	inc r8
	jmp _borratablapelotaloop8
	
	_finalborratablapelota:
	ret
;Fin de la funcion



;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que borra un bloque segun la posicion en la que se encuentre
borra_bloque:
	
	;movimientos del cursor
	;----------------------------------
	mov r8, 0							;Se inicializa el registro contador r8
	_borrabloqueloop1:
	cmp r8, [posX_bloque]					;Se compara el contador con el registro
	je _ciclo11								;Si se completan los movimientos a la derecha, se pasan a los movimientos verticales
	impr_texto derecha, cursor_tamano			;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en una unidad el registro contador
	jmp _borrabloqueloop1				;Retorno a un nuevo ciclo
	
	_ciclo11:
	mov r8, 0							;Se reinicia el registro contador
	_borrabloqueloop2:				
	cmp r8, [posY_bloque]					
	je _borra_bloque						;Si ya se han completado los movimientos hacia arriba, se pasa a imprimir la pelota
	impr_texto arriba, cursor_tamano			;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en una unidad el registro contador
	jmp _borrabloqueloop2				;Retorno a un nuevo ciclo
	
	_borra_bloque:
	impr_texto bloques_borrar, 7						;Impresion de la pelota
	
	mov r8, 0							;Reinicio del registro contador
	mov r9, [posX_bloque]					;Se carga la posicion de la pelota 
	add r9, 7								;Se agrega un 1 a la posicion de la pelota, para contrarrestar el offset generado por el codigo ANSI
	_borrabloqueloop3:
	cmp r8, r9							;Si ya se acabaron los movimientos a la izquierda, se pasa a los movimientos hacia abajo
	je _ciclo12
	impr_texto izquierda, cursor_tamano		;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en una unidad el registro contador
	jmp _borrabloqueloop3				;Retorno a un nuevo ciclo
	
	_ciclo12:
	mov r8, 0							;Se reinicia el registro contador
	_borrabloqueloop4:			
	cmp r8, [posY_bloque]					;Si ya se realizaron los movimientos hacia abajo, entonces se pasa al proceso de imprimir la tabla
	je _final_borra_bloque
	impr_texto abajo, cursor_tamano			;Ejecucion del movimiento mediante la impresion en pantalla del codigo ESC ANSI
	inc r8								;Se incrementa en 1 unidad el registro contador
	jmp _borrabloqueloop4				;Retorno a un nuevo ciclo
	
	_final_borra_bloque:
	ret	
;Fin de la funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que reestablece los valores de las variables de posicion y movimiento
reestablecer_valores:
	mov r8, 3
	mov [posY_tabla], r8	;Reestablecimiento del valor vertical de la pelota
	mov r8, 4
	mov [posY_bola], r8		;Reestablecimiento del valor horizontal de la pelota
	mov r8, 23
	mov [posX_tabla], r8	;Reestablecimiento del valor horizontal de la tabla
	mov r8, 26
	mov [posX_bola], r8	;Reestablecimiento del valor vertical de la tabla
	mov r8,0
	mov r14, '+'
	mov [dir_mov_X], r14	;Reestablecimiento de la direccion de movimiento horizontal
	mov [dir_mov_Y], r14		;Reestablecimiento de la direccion de movimiento vertical
	mov r8, 1
	mov [bloque11], r8		;Reestablecimiento del estado de los bloques
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
;Funcion que modifica la direccion de la pelota cuando la funcion modifica posicion lo requiera
modificar_direccion:
	mov r8, [posX_bola]			;Se carga la posicion X de la bola 
	
	cmp r8, 1					;Se realiza la primera comparacion, si X=1 (pared izquierda del area de juego)
		;if not
		jne _m_p_jmp1			;Si no X no es igual a uno se pasa a la otra comparacion
		
		_m_p_jmp1_2:				;Etiqueta de salto para la segunda comparacion
		;if equal
		mov r10, [dir_mov_X]		
		cmp r10, '+'				;Se compara el string de posicion
			;if not
			jne _m_p_jmp1_1		;Si no es positiva, se salta a la etiqueta _m_p_jmp1_1
			
			;if equal comandos
			mov r10, '-'			;Si la condicion es positiva, se cambia dir_mov_X a negativo
			mov [dir_mov_X], r10
			jmp _m_p_jmp2		;Salto al final de la funcion
			
			;if not comandos
			_m_p_jmp1_1:			
			mov r10, '+'			;Si la condicion es negativa, se cambia dir_mov_X a positivo
			mov [dir_mov_X], r10
			jmp _m_p_jmp2		;Salto al final de la funcion
	
	
	
	_m_p_jmp1:					;Se realiza la segunda comparacion, si X=49 (pared derecha del area de juego)
	cmp r8, 49
		;if not
		jne _m_p_jmp2			;Si no es igual, entonces se salta a la tercera comparacion
		
		;if equal
		jmp _m_p_jmp1_2		;Si es igual, el procedimiento es el mismo que la comparacion 1, por lo tanto se salta hacia ahi.
		
		
		
	_m_p_jmp2:					;Se realiza la tercera comparacion, si Y=29 (Pared superior del area de juego)
	mov r8, [posY_bola]
	
	cmp r8, 28
		;if  not
		jne _m_p_jmp3			;Si Y es distinto a 29, se salta a la cuarta comparacion
		
		;if equal
		_m_p_jmp2_2:			;Etiqueta de salto que la cuarta condicion utilizara
		mov r10, [dir_mov_Y]		;Se carga el signo de la direccion del movimiento Y al registro de 8 bits AL
		cmp r10, '+'				
			;if not
			jne _m_p_jmp2_1		;Si la direccion del moviento no es positiva, se saltara a la etiqueta _m_p_jmp2_1
			
			;if equal comandos
			mov r10, '-'			;Si la direccion del movimiento es positiva, se cambia a negativa
			mov [dir_mov_Y], r10
			jmp _m_p_final		;Salto al final de la funcion
			
			;if not comandos
			_m_p_jmp2_1:		;Si la direccion del movimiento es negativa, se cambia a positiva
			mov r10, '+'
			mov [dir_mov_Y], r10
			jmp _m_p_final		;Salto al final de la funcion
	
	
	_m_p_jmp3:					;Se realiza la comparacion Y=4 (Altura de la plataforma en donde rebotara la pelota)
	cmp r8, 27				
		;if  not
		jne _m_p_jmp4		;Si no se cumple la condicion final, se salta al final de la funcion
		
		;if equal
		jmp _m_p_jmp2_2		;Si se cumple esta condicion, el procedimiento es el mismo que con la tercera condicion
	
	_m_p_jmp4:					;Se realiza la comparacion Y=4 (Altura de la plataforma en donde rebotara la pelota)
	cmp r8, 26				
		;if  not
		jne _m_p_jmp5		;Si no se cumple la condicion final, se salta al final de la funcion
		
		;if equal
		jmp _m_p_jmp2_2		;Si se cumple esta condicion, el procedimiento es el mismo que con la tercera condicion
	
	_m_p_jmp5:					;Se realiza la comparacion Y=4 (Altura de la plataforma en donde rebotara la pelota)
	cmp r8, 25				
		;if  not
		jne _m_p_jmp6		;Si no se cumple la condicion final, se salta al final de la funcion
		
		;if equal
		jmp _m_p_jmp2_2		;Si se cumple esta condicion, el procedimiento es el mismo que con la tercera condicion
		
	_m_p_jmp6:					;Se realiza la comparacion Y=4 (Altura de la plataforma en donde rebotara la pelota)
	cmp r8, 24				
		;if  not
		jne _m_p_jmp7		;Si no se cumple la condicion final, se salta al final de la funcion
		
		;if equal
		jmp _m_p_jmp2_2		;Si se cumple esta condicion, el procedimiento es el mismo que con la tercera condicion
	
	_m_p_jmp7:					;Se realiza la comparacion Y=4 (Altura de la plataforma en donde rebotara la pelota)
	cmp r8, 4				
		;if  not
		jne _m_p_final			;Si no se cumple la condicion final, se salta al final de la funcion
		
		;if equal
		jmp _m_p_jmp2_2		;Si se cumple esta condicion, el procedimiento es el mismo que con la tercera condicion
	
				
	_m_p_final:					;Etiqueta de final de funcion

ret
;Fin de la funcion



;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que mueve una posicion a la derecha el valor horizontal de la tabla, para que se desplace
tabla_derecha:
	
	mov r8, [posX_tabla]	;Se carga la posicion en r8
	
	cmp r8, 43			;Se compara la posicion de r8 con la posicion maxima a la derecha que puede tener la tabla 
						;para no exceder los limites del area de juego
	
	je _final_tabla_derecha	;Si la posicion ha llegado al limite derecho, no se agrega nada y se salta directamente al final de la funcion
	
	inc r8				;Si no se ha llegado al limite derecho, entonces se incrementa una unidad a la posicion
	mov [posX_tabla], r8	;Se guarda en memoria la nueva posicion horizontal
	
		
	_final_tabla_derecha:	;Fin de la funcion
	ret
;Final de la Funcion



;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que mueve una posicion a la izquierda el valor horizontal de la tabla, para que se desplace
tabla_izquierda:
	
	mov r8, [posX_tabla]	;Se carga la posicion en r8
	
	cmp r8, 1			;Se compara la posicion de r8 con la posicion maxima a la izquierda que puede tener la tabla 
						;para no exceder los limites del area de juego
	
	je _final_tabla_izquierda	;Si la posicion ha llegado al limite iaquierdo, no se agrega nada y se salta directamente al final de la funcion
	
	dec r8				;Si no se ha llegado al limite izquierdo, entonces se decrementa una unidad a la posicion
	mov [posX_tabla], r8	;Se guarda en memoria la nueva posicion horizontal
	
		
	_final_tabla_izquierda:	;Fin de la funcion
	ret
;Final de la Funcion



;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que realiza los cambios en los movimientos de la pelota, teniendo en cuenta la cantidad de espacios
;verticales y horizontales por ciclo que se deben hacer
modificar_posicion:

	mov r8, [dir_mov_X]			
	mov r9, [dir_mov_Y]	
	mov r10, [posX_bola]	;Se carga la posicion X de la pelota en el registro general r10
	mov r11, [posY_bola]	;Se carga la posicion Y de la pelota en el registro general r11
	mov r12, [deltaX]		;Se carga la cantidad de movimientos en X por ciclo que realiza la bola
	mov r13, [deltaY]		;Se carga la cantidad de movimientos en Y por ciclo que realiza la bola
	
	
	;MOVIMIENTOS VERTICALES
	_movimientos_verticales:
	
	cmp r13, 0
		jne	_comparaciones
		
		cmp r12, 0
			je _cargadatos2		

			jmp _movimientos_horizontales
			
			_cargadatos2:
			mov  [posX_bola], r10	
			mov [posY_bola], r11 	
			jmp _fin_modificar_posicion			
		
	_comparaciones:
	cmp r11, 28
	je _accioneslinea28	
	
	cmp r11, 27
	je _accioneslinea27	
				
	cmp r11, 26
	je _accioneslinea26
		
	cmp r11, 25
	je _accioneslinea25
	
	cmp r11, 24
	je _accioneslinea24	
		
	cmp r11, 4
	je _intersecciontabla
								
	cmp r11, 1
	je _nomal	
										
			_movimientos_generales:
				cmp r9, '+'
				je _agregar_vertical
															
				dec r13	;Se decrementa en 1 la cantidad de elementos por sumar en Y
				dec r11 	;Se decrementa en 1 unidad la posicion en Y de la pelota
				jmp _movimientos_horizontales	;Una vez decrementado, se salta a los movimientos horizontales
													
			_agregar_vertical:
				dec r13	;Se decrementa en 1 la cantidad de elementos por sumar en Y
				inc r11 	;Se incrementa en 1 unidad la posicion en Y de la pelota
				jmp _movimientos_horizontales	;Una vez incrementado, se salta a los movimientos horizontales
													
													
			_accioneslinea28:
				cmp r9, '+'	
				mov  [posX_bola], r10	
				mov [posY_bola], r11 	
				call modificar_direccion
				je _fin_modificar_posicion	
				
				;si no es positivo el movimiento...
				jmp _interseccionbloquefila3	
				

			_accioneslinea27:
				cmp r9, '+'	
				je _interseccionbloquefila3
				
				;si no es positivo el movimiento...
				jmp _interseccionbloquefila1	
				
				
			_accioneslinea26:
				cmp r9, '+'	
				je _movimientos_generales	
				
				;si no es positivo el movimiento...
				jmp _interseccionbloquefila2
				
				
			_accioneslinea25:
				cmp r9, '+'	
				je _interseccionbloquefila2
				
				;si no es positivo el movimiento...
				jmp _movimientos_generales	
				
			
			_accioneslinea24:
				cmp r9, '+'	
				je _interseccionbloquefila1
				
				;si no es positivo el movimiento...
				jmp _movimientos_generales	
				
				
			_intersecciontabla:
				;mov r14, [posX_tabla]
				;cmp r14, r10 ;Comparacion de las posiciones en X del inicio de la tabla vs la pelota
				;	
				;	jae _anchotabla
				;	
				;	jmp _movimientos_generales
				;	
				;	_anchotabla:
				;		add r14, 7
				;		cmp r14, r10 ;Comparacion de las posiciones en X del final de la tabla vs la pelota
				;		
				;		jbe _final_intersecciontabla
				;	
				;		jmp _movimientos_generales
				;		
				;		_final_intersecciontabla:
				
							;??????????????????
							cmp r9, '+'	
							jne _nomal
							jmp _movimientos_generales
							
							_nomal:
							;???????????????????
							mov  [posX_bola], r10	
							mov [posY_bola], r11 	
							call modificar_direccion
							jmp _fin_modificar_posicion
						
				
						
			;Acciones para el choque con la fila 1 de bloques:
			_interseccionbloquefila1:
			cmp r10, 7
				jae _seccion12
				
				mov r14, [bloque11]
				cmp	 r14, 0
				
					je _bloque11falso
					
					mov r14, 25
					mov [posY_bloque], r14
					mov r14, 2
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque11], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque11falso:
					jmp _movimientos_generales
					
			
				_seccion12:
				cmp r10, 17
				jae _seccion13
				
				mov r14, [bloque12]
				cmp	 r14, 0
				
					je _bloque12falso
					
					mov r14, 25
					mov [posY_bloque], r14
					mov r14, 10
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque12], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque12falso:
					jmp _movimientos_generales
					
				
				_seccion13:
				cmp r10, 25
				jae _seccion14
				
				mov r14, [bloque13]
				cmp	 r14, 0
				
					je _bloque13falso
					
					mov r14, 25
					mov [posY_bloque], r14
					mov r14, 18 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque13], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque13falso:
					jmp _movimientos_generales
					
					
				_seccion14:
				cmp r10, 33
				jae _seccion15
				
				mov r14, [bloque14]
				cmp	 r14, 0
				
					je _bloque14falso
					
					mov r14, 25
					mov [posY_bloque], r14
					mov r14, 26 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque14], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque14falso:
					jmp _movimientos_generales
					
			
				_seccion15:
				cmp r10, 41
				jae _seccion16
				
				mov r14, [bloque15]
				cmp	 r14, 0
				
					je _bloque15falso
					
					mov r14, 25
					mov [posY_bloque], r14
					mov r14, 34 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque15], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque15falso:
					jmp _movimientos_generales
					
					
				_seccion16:
				mov r14, [bloque16]
				cmp	 r14, 0
				
					je _bloque16falso
					
					mov r14, 25
					mov [posY_bloque], r14
					mov r14, 42 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque16], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque16falso:
					jmp _movimientos_generales
					
		
			;Acciones para el choque con la fila 2 de bloques:
			_interseccionbloquefila2:
			cmp r10, 7
				jae _seccion22
				
				mov r14, [bloque21]
				cmp	 r14, 0
				
					je _bloque21falso
					
					mov r14, 26
					mov [posY_bloque], r14
					mov r14, 2
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque21], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque21falso:
					jmp _movimientos_generales
					
			
				_seccion22:
				cmp r10, 17
				jae _seccion23
				
				mov r14, [bloque22]
				cmp	 r14, 0
				
					je _bloque22falso
					
					mov r14, 26
					mov [posY_bloque], r14
					mov r14, 10
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque22], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque22falso:
					jmp _movimientos_generales
					
				
				_seccion23:
				cmp r10, 25
				jae _seccion24
				
				mov r14, [bloque23]
				cmp	 r14, 0
				
					je _bloque23falso
					
					mov r14, 26
					mov [posY_bloque], r14
					mov r14, 18 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque23], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque23falso:
					jmp _movimientos_generales
					
					
				_seccion24:
				cmp r10, 33
				jae _seccion25
				
				mov r14, [bloque24]
				cmp	 r14, 0
				
					je _bloque24falso
					
					mov r14, 26
					mov [posY_bloque], r14
					mov r14, 26 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque24], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque24falso:
					jmp _movimientos_generales
					
			
				_seccion25:
				cmp r10, 41
				jae _seccion26
				
				mov r14, [bloque25]
				cmp	 r14, 0
				
					je _bloque25falso
					
					mov r14, 26
					mov [posY_bloque], r14
					mov r14, 34 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque25], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque25falso:
					jmp _movimientos_generales
					
					
				_seccion26:
				mov r14, [bloque26]
				cmp	 r14, 0
				
					je _bloque26falso
					
					mov r14, 26
					mov [posY_bloque], r14
					mov r14, 42 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque26], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque26falso:
					jmp _movimientos_generales
					
			
			;Acciones para el choque con la fila 3 de bloques:
			_interseccionbloquefila3:
			cmp r10, 7
				jae _seccion32
				
				mov r14, [bloque31]
				cmp	 r14, 0
				
					je _bloque31falso
					
					mov r14, 27
					mov [posY_bloque], r14
					mov r14, 2
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque31], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque31falso:
					jmp _movimientos_generales
					
			
				_seccion32:
				cmp r10, 17
				jae _seccion33
				
				mov r14, [bloque32]
				cmp	 r14, 0
				
					je _bloque32falso
					
					mov r14, 27
					mov [posY_bloque], r14
					mov r14, 10
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque32], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque32falso:
					jmp _movimientos_generales
					
				
				_seccion33:
				cmp r10, 25
				jae _seccion34
				
				mov r14, [bloque33]
				cmp	 r14, 0
				
					je _bloque33falso
					
					mov r14, 27
					mov [posY_bloque], r14
					mov r14, 18 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque33], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque33falso:
					jmp _movimientos_generales
					
					
				_seccion34:
				cmp r10, 33
				jae _seccion35
				
				mov r14, [bloque34]
				cmp	 r14, 0
				
					je _bloque34falso
					
					mov r14, 27
					mov [posY_bloque], r14
					mov r14, 26 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque34], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque34falso:
					jmp _movimientos_generales
					
			
				_seccion35:
				cmp r10, 41
				jae _seccion36
				
				mov r14, [bloque35]
				cmp	 r14, 0
				
					je _bloque35falso
					
					mov r14, 27
					mov [posY_bloque], r14
					mov r14, 34 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque35], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque35falso:
					jmp _movimientos_generales
					
					
				_seccion36:
				mov r14, [bloque36]
				cmp	 r14, 0
				
					je _bloque36falso
					
					mov r14, 27
					mov [posY_bloque], r14
					mov r14, 42 
					mov [posX_bloque], r14
					mov r14, 0
					mov [bloque36], r14
					mov  [posX_bola], r10	
					mov [posY_bola], r11 	
					call modificar_direccion
					jmp _fin_modificar_posicion
					
					_bloque36falso:
					jmp _movimientos_generales
								
								
	;MOVIMIENTOS HORIZONTALES
	_movimientos_horizontales:
	
	cmp r12, 0
		jne	_comparaciones2
		
		cmp r13, 0
			je _fincargadatos1			

			jmp _movimientos_verticales
			
			_fincargadatos1:
			mov  [posX_bola], r10	
			mov [posY_bola], r11 	
			jmp _fin_modificar_posicion			
		
	_comparaciones2:
	cmp r10, 1
	je _accionescolumna1	
	
	cmp r10, 49
	je _accionescolumna50
	
	_movimientos_generales_2:
	cmp r8, '+'
		je _agregar_horizontal
													
		dec r12	;Se decrementa en 1 la cantidad de elementos por sumar en X
		dec r10 	;Se decrementa en 1 unidad la posicion en X de la pelota
		jmp _movimientos_verticales	;Una vez decrementado, se salta a los movimientos horizontales
											
	_agregar_horizontal:
		dec r12	;Se decrementa en 1 la cantidad de elementos por sumar en X
		inc r10 	;Se incrementa en 1 unidad la posicion en X de la pelota
		jmp _movimientos_verticales	;Una vez incrementado, se salta a los movimientos horizontales
	
					
	_accionescolumna1:
		cmp r8, '-'	
		je _acciones1jmp	
		
		jmp _movimientos_generales_2
		
		_acciones1jmp:
		mov  [posX_bola], r10	
		mov [posY_bola], r11 	
		call modificar_direccion
		jmp _fin_modificar_posicion	
		
	_accionescolumna50:
		cmp r8, '+'	
		je _acciones2jmp	
		
		jmp _movimientos_generales_2
		
		_acciones2jmp:
		mov  [posX_bola], r10	
		mov [posY_bola], r11 	
		call modificar_direccion
		jmp _fin_modificar_posicion	
		
		
		
		
		
	;FIN DE LA FUNCION
	_fin_modificar_posicion:
	;mov  [posX_bola], r10	;Se carga la posicion X de la pelota en el registro general r10
	;mov [posY_bola], r11 	;Se carga la posicion Y de la pelota en el registro general r11
	ret
;Final de la funcion
	

;-------------------------------------------------------------------------------------------------------------------------------------
;FIN DEL CODIGO FUENTE	
;-------------------------------------------------------------------------------------------------------------------------------------

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;COMANDO DE EMSAMBLAJE
;nasm -f elf64 -o principal.o CodigoPrincipal2.asm && ld -o mainexe2 principal.o && ./mainexe2
