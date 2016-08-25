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
	msj_press_enter:			db '|        > Presione enter para continuar<         |', 0xa
	msj_vida_menos:		db '|              > Ha perdido una vida <            |', 0xa
	msj_game_over:		db '|> Fin del juego...  Mejor suerte para la proxima<|', 0xa	
	msj_gana:		db '|          >FELICIDADES! Juego terminado<         |', 0xa	
	
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
	
	grupo: 	db 'Grupo: 3', 0xa
	grupo_length: equ $-grupo
	
	anthony: 	db 'Anthony Chaves Vasquez - 201048654', 0xa
	anthony_length: equ $-anthony
	
	carlos:	db 'Carlos Murillo Soto - 20338697', 0xa
	carlos_length: equ $-carlos
	
	irene:	db 'Irene Rivera Arrieta - 201121803', 0xa
	irene_length: equ $-irene
	
	laura:	db 'Laura Hidalgo Soto - 200956890', 0xa
	laura_length: equ $-laura
	
	msj_final: db 'Gracias por jugar Micronoid', 0xa
	msj_final_length: equ $-msj_final
	
	prompt: db 'Presione Enter para continuar...', 0xa
	prompt_length: equ $-prompt
	
	intentos: dq 3			;Variable que indica el numero de intentos que el usuario tiene en el juego
	
	arriba: db 0x1b, "[1A" 			;Codigo ANSI para mover el cursor 1 posicion hacia arriba
	abajo: db 0x1b, "[1B" 			;Codigo ANSI para mover el cursor 1 posicion hacia abajo
	derecha: db 0x1b, "[1C" 			;Codigo ANSI para mover el cursor 1 posicion hacia la derecha
	izquierda: db 0x1b, "[1D" 			;Codigo ANSI para mover el cursor 1 posicion hacia la izquierda	
	cursor_tamano: equ $-izquierda	
	
	
	
		
	;Variables para limpiar pantalla
	clean    db 0x1b, "[2J", 0x1b, "[H"
	clean_tam equ $ - clean

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
	
	;Manejo del modo canonico y el echo	
	ICANON:		equ	2      	;Para la bandera canonical
	ECHO:		equ 1<<3      	;Para la bandera de echo
	VTIME:		equ	4       	;Posición de VTIME en CC_C
	VMIN:		equ	5       	;Posición de VMIN en CC_C
	CC_C:		equ	18      	;Offset para localizar CC_C
	STDIN:		equ	0
	STDOUT:		equ	1
	TCGETA: 		equ	0x5401
	TCSETA: 		equ	0x5402
	SYS_READ:	equ	0
	SYS_WRITE:	equ	1
	SYS_EXIT:		equ	0x3c
	IOCTL:		equ	16
	
;segmento de datos no-inicializados, que se pueden usar para capturar variables 
;del usuario, por ejemplo: desde el teclado
section .bss
	userName: resb 20
	termios:    resb    46
	familia:	resb 48
	
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


	;Etiqueta de reinicio
	_loopdeproceso:
	
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
	
	
	;Se cargan los movimientos de pelota y la direccion horizontal, segun el numero de intento
	mov r9, [intentos]
	
	cmp r9, 3
	je _primerintento
	
	cmp r9, 2
	je _segundointento
	
		mov r8, 2
		mov [deltaX], r8
		mov r8, 1
		mov [deltaY], r8
		mov r8, '+'
		mov [dir_mov_X], r8
		jmp _loopdejuego
		
	_primerintento:
		
		mov r8, 1
		mov [deltaX], r8
		mov r8, 3
		mov [deltaY], r8
		mov r8, '-'
		mov [dir_mov_X], r8
		jmp _loopdejuego
		
	_segundointento:
	
		mov r8, 1
		mov [deltaX], r8
		mov r8, 1
		mov [deltaY], r8
		mov r8, '+'
		mov [dir_mov_X], r8
		jmp _loopdejuego
		
	
	;Etiqueta para encerrar los ciclos en donde el juego se desarrollara hasta que la pelota llege
	; a tocar el suelo o se hayan eliminado todos los bloques
	_loopdejuego:	
	
		;Se reinicia el valor de la variable teclado
		mov r15, 0
		mov [teclado], r15

		;Se llama a imprimir la tabla y la pelota
		call imprime_tabla_pelota	
		
		;Se compara si la pelota ha caido al suelo
		mov r15, [posY_bola]
		cmp r15, 1
			jne _nohacaido		
			
			mov r15, [intentos]
			dec	r15
			mov [intentos], r15
			call imprimir_pierdevida			
			je _loopdeproceso
		
		;Se compara si la cantidad de intentos es igual a cero
		_nohacaido:
		mov r15, [intentos]
		cmp r15, 0
			jne _nohaterminado		
			
			call imprimir_pierdejuego			
			je _final_ejecucion
			
		;Se compara ahora si todos los bloques han sido eliminados
		_nohaterminado:
		mov r8, 0	;inicializacion del registro contador
		
		mov r15, [bloque11]
		cmp r15, 0
			jne _irabloque12
			
			inc r8
			jmp _irabloque12
		
		_irabloque12:
		mov r15, [bloque12]
		cmp r15, 0
			jne _irabloque13
			
			inc r8
			jmp _irabloque13
		
		_irabloque13:
		mov r15, [bloque13]
		cmp r15, 0
			jne _irabloque14
			
			inc r8
			jmp _irabloque14
		
		_irabloque14:
		mov r15, [bloque14]
		cmp r15, 0
			jne _irabloque15
			
			inc r8
			jmp _irabloque15
		
		_irabloque15:
		mov r15, [bloque15]
		cmp r15, 0
			jne _irabloque16
			
			inc r8
			jmp _irabloque16
		
		_irabloque16:
		mov r15, [bloque16]
		cmp r15, 0
			jne _irabloque21
			
			inc r8
			jmp _irabloque21
		
		_irabloque21:
		mov r15, [bloque21]
		cmp r15, 0
			jne _irabloque22
			
			inc r8
			jmp _irabloque22
		
		_irabloque22:
		mov r15, [bloque22]
		cmp r15, 0
			jne _irabloque23
			
			inc r8
			jmp _irabloque23
		
		_irabloque23:
		mov r15, [bloque23]
		cmp r15, 0
			jne _irabloque24
			
			inc r8
			jmp _irabloque24
		
		_irabloque24:
		mov r15, [bloque24]
		cmp r15, 0
			jne _irabloque25
			
			inc r8
			jmp _irabloque25
		
		_irabloque25:
		mov r15, [bloque25]
		cmp r15, 0
			jne _irabloque26
			
			inc r8
			jmp _irabloque26
		
		_irabloque26:
		mov r15, [bloque26]
		cmp r15, 0
			jne _irabloque31
			
			inc r8
			jmp _irabloque31
			
		_irabloque31:
		mov r15, [bloque31]
		cmp r15, 0
			jne _irabloque32
			
			inc r8
			jmp _irabloque32
		
		_irabloque32:
		mov r15, [bloque32]
		cmp r15, 0
			jne _irabloque33
			
			inc r8
			jmp _irabloque33
		
		_irabloque33:
		mov r15, [bloque33]
		cmp r15, 0
			jne _irabloque34
			
			inc r8
			jmp _irabloque34
		
		_irabloque34:
		mov r15, [bloque34]
		cmp r15, 0
			jne _irabloque35
			
			inc r8
			jmp _irabloque35
		
		_irabloque35:
		mov r15, [bloque35]
		cmp r15, 0
			jne _irabloque36
			
			inc r8
			jmp _irabloque36
		
		_irabloque36:
		mov r15, [bloque36]
		cmp r15, 0
			jne _compararganador
			
			inc r8
			jmp _compararganador
			
		_compararganador:
		cmp r8, 18
			jne _continuar
			
			call imprimir_ganajuego
			jmp _final_ejecucion
		
		
		;Se recibe la tecla presionada desde el teclado, y se mueve a la variable temporal teclado
		_continuar:
		leer_texto teclado,1	
		mov r15, [teclado]
		
		;Se compara lo obtenido del teclado para saber que accion corresponde
		cmp r15, 'q'			;la tecla q fue seleccionada para que finalice el juego abruptamente
		je _final_ejecucion
		
		cmp r15, 'z'			;la tecla z fue seleccionada para mover la tabla a la izquierda
		je _mov_izquierda	
		
		cmp r15, 'c'			;la tecla c fue seleccionada para mover la tabla a la derecha
		je _mov_derecha
		
		call borra_tabla_pelota	;si ninguna tecla fue seleccionada, entonces se procede a borrar la tabla y la pelota y a pasar a la siguiente fase
		jmp _siguiente
		
		_mov_izquierda:		;acciones si fue presionada la tecla z
		call borra_tabla_pelota	;borrar la tabla y la pelota
		call tabla_izquierda		;llamar a la funcion que agrega una posicion a la izquierda
		jmp _siguiente			;saltar al siguiente paso
		
		_mov_derecha:			;acciones si fue presionada la tecla c
		call borra_tabla_pelota	;borrar la tabla y la pelota
		call tabla_derecha		;llamar a la funcion que agrega una posicion a la izquierda
		jmp _siguiente			;saltar al siguiente paso
		
		
		;Etiqueta de la segunda parte del proceso del ciclo de juego
		_siguiente:
		
		call modificar_posicion	;Se llama a la funcion mas importante, que es la que modifica la posicion y admite cambios de direccion segun las condiciones
		
		mov r8, [posX_bloque]	;Se revisa si hay alguna posicion de bloque cargada en memoria luego de ejecutar la funcion modificar_posicion
		cmp r8, 0
			je _loopdejuego		;Si no la hay, entonces se lanza a otro ciclo de juego
			
			call borra_bloque		;Si la hay, entonces se llama a borrar el bloque cargado en memoria, y luego se inicializan las variables de bloque
			mov r8, 0
			mov [posX_bloque], r8 
			mov [posY_bloque], r8 
			jmp _loopdejuego
			
			
		
	
	_final_ejecucion:
	limpiar_pantalla clean,clean_tam
	
	call pantalla_final
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
;Funcion que apaga el modo canonico (que no necesita del enter para ingresar una tecla)
;Se agrega ademas el modo vtime que -junto con el vmin- espera un tiempo prudencial para que el usuario ingrese una tecla
canonical_off:
    call read_stdin_termios
    ; Limpiamos la bandera de ICANON
    push rax
    mov rax, ICANON
    not rax
    and [termios+12], rax
    mov byte[termios+CC_C+VTIME], 3     ; Ponemos el tiempo de espera a 0
    mov byte[termios+CC_C+VMIN], 0      ; Ponemos la cantidad mínima a 0
    pop rax
    call write_stdin_termios
    ret

;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que apaga el modo echo, es decir, las teclas ingresadas no aparecen en la pantalla
echo_off:
    call read_stdin_termios
    ; Limpiamos la bandera de ECHO
    ;push rax
    mov rax, ECHO
    not rax
    and [termios+12], rax
    ;pop rax
    call write_stdin_termios
    ret

;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que enciende el modo canonico
canonical_on:
    call read_stdin_termios
    ; Restauramos la bandera de CANONICAL
    or dword [termios+12], ICANON
    mov byte[termios+CC_C+VTIME], 0     ; Tiempo espera = 0
    mov byte[termios+CC_C+VMIN], 1      ; Bytes mínimos = 1(default)
    call write_stdin_termios
    ret

;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que enciende el modo echo
echo_on:
    call read_stdin_termios
    ; Restauramos la bandera de ECHO
    or dword [termios+12], ECHO
    call write_stdin_termios
    ret

;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que carga el estatus de ingreso del sistema
read_stdin_termios:
    push rax
    push rbx
    push rcx
    push rdx
    mov rax, IOCTL
    mov rdi, STDIN
    mov rsi, TCGETA
    mov rdx, termios
    syscall
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que sobreescribe la configuracion del ingreso de los perifericos al sistema
write_stdin_termios:
    push rax
    push rbx
    push rcx
    push rdx
    mov rax, IOCTL
    mov rdi, STDIN
    mov rsi, TCSETA
    mov rdx, termios
    syscall
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret


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
				je _mod_direccion_28
				
				jmp _interseccionbloquefila3	
				
				_mod_direccion_28:				
				
				mov  [posX_bola], r10	
				mov [posY_bola], r11 	
				call modificar_direccion
				je _fin_modificar_posicion	
				
								

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
				mov r14, [posX_tabla]
				cmp r14, r10 ;Comparacion de las posiciones en X del inicio de la tabla vs la pelota
				
				je _final_intersecciontabla
				
				inc r14	;se le suma 1 unidad
			
				cmp r14, r10 ;Comparacion de las posiciones en X del inicio de la tabla vs la pelota			
				je _final_intersecciontabla
				
				inc r14	;se le suma 2 unidades
				
				cmp r14, r10 ;Comparacion de las posiciones en X del inicio de la tabla vs la pelota			
				je _final_intersecciontabla
				
				inc r14	;se le suma 3 unidades
				
				cmp r14, r10 ;Comparacion de las posiciones en X del inicio de la tabla vs la pelota			
				je _final_intersecciontabla
				
				inc r14	;se le suma 4 unidades
				
				cmp r14, r10 ;Comparacion de las posiciones en X del inicio de la tabla vs la pelota			
				je _final_intersecciontabla
				
				inc r14	;se le suma 5 unidades
				
				cmp r14, r10 ;Comparacion de las posiciones en X del inicio de la tabla vs la pelota			
				je _final_intersecciontabla
				
				inc r14	;se le suma 6 unidades
				
				cmp r14, r10 ;Comparacion de las posiciones en X del inicio de la tabla vs la pelota			
				je _final_intersecciontabla
				
				inc r14	;se le suma 7 unidades
				
				cmp r14, r10 ;Comparacion de las posiciones en X del inicio de la tabla vs la pelota			
				je _final_intersecciontabla
				
					jmp _movimientos_generales ;Si ninguna coincide, entonces se sigue con la trayectoria normal
				
										
				_final_intersecciontabla:
					cmp r9, '+'	
					jne _nomal
					jmp _movimientos_generales
					
					_nomal:
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
;Funcion que imprime la pantalla de salida del juego
pantalla_final:

	call canonical_on

	limpiar_pantalla clean,clean_tam
	
	impr_texto nueva_linea,nueva_linea_length
	impr_texto nueva_linea,nueva_linea_length
	impr_texto nueva_linea,nueva_linea_length
	
	impr_texto msj_final,msj_final_length
	
	impr_texto nueva_linea,nueva_linea_length
	
	impr_texto grupo,grupo_length
	impr_texto laura,laura_length
	impr_texto irene,irene_length
	impr_texto carlos,carlos_length
	impr_texto anthony,anthony_length
	
	impr_texto nueva_linea,nueva_linea_length
	
	mov eax,80000002h
	cpuid
	mov [familia], eax
	mov [familia+4], ebx
	mov [familia+8], ecx
	mov [familia+12], edx
	
	mov eax,80000003h
	cpuid
	mov [familia+16], eax
	mov [familia+20], ebx
	mov [familia+24], ecx
	mov [familia+28], edx
	
	mov eax,80000004h
	cpuid
	mov [familia+32], eax
	mov [familia+36], ebx
	mov [familia+40], ecx
	mov [familia+44], edx
	
	impr_texto familia, 48
	
	impr_texto nueva_linea,nueva_linea_length
	impr_texto nueva_linea,nueva_linea_length
	impr_texto nueva_linea,nueva_linea_length
	
	
	impr_texto prompt,prompt_length
	
	_leer_press_enter:
	leer_texto teclado,1	
	mov r15, [teclado]
	cmp r15, 0xa
	jne _leer_press_x

	limpiar_pantalla clean,clean_tam
	
	ret
;final de la funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que imprime en el area de juego la perdida de una vida
imprimir_pierdevida:

	;movimientos del cursor
	;----------------------------------
	mov r8, 0				;Se inicializa el registro contador r8	
	_vuelta:
	cmp r8, 16
		jne _movimientoarriba
		
		jmp _imprimir_pierdeintento		
		
		_movimientoarriba:		
		impr_texto arriba, cursor_tamano
		inc r8
		jmp _vuelta
		
	_imprimir_pierdeintento:
		impr_texto msj_vida_menos, tamano_linea
		impr_texto msj_press_enter, tamano_linea
	
	mov r8, 0
	_vuelta2:
	cmp r8, 15
		jne _movimientoabajo
		
		jmp _final_imprimir_pierdevida	
		
		_movimientoabajo:		
		impr_texto abajo, cursor_tamano
		inc r8
		jmp _vuelta2
	
	
	_final_imprimir_pierdevida:
	
	_leer_press_enter_2:
	leer_texto teclado,1	
	mov r15, [teclado]
	cmp r15, 0xa
	jne _leer_press_enter_2

	ret
	
;Fin de la funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que imprime en el area de juego la perdida del juego
imprimir_pierdejuego:

	;movimientos del cursor
	;----------------------------------
	mov r8, 0				;Se inicializa el registro contador r8	
	_vuelta3:
	cmp r8, 16
		jne _movimientoarriba2
		
		jmp _imprimir_pierdearkanoid	
		
		_movimientoarriba2:		
		impr_texto arriba, cursor_tamano
		inc r8
		jmp _vuelta3
		
	_imprimir_pierdearkanoid:
		impr_texto msj_game_over, tamano_linea
		impr_texto msj_press_enter, tamano_linea
	
	mov r8, 0
	_vuelta4:
	cmp r8, 15
		jne _movimientoabajo2
		
		jmp _final_imprimir_pierdejuego
		
		_movimientoabajo2:		
		impr_texto abajo, cursor_tamano
		inc r8
		jmp _vuelta4
	
	
	_final_imprimir_pierdejuego:
	
	_leer_press_enter_3:
	leer_texto teclado,1	
	mov r15, [teclado]
	cmp r15, 0xa
	jne _leer_press_enter_3

	
	ret	
;Fin de la funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion que imprime en el area de juego la perdida del juego
imprimir_ganajuego:

	;movimientos del cursor
	;----------------------------------
	mov r8, 0				;Se inicializa el registro contador r8	
	_vuelta5:
	cmp r8, 16
		jne _movimientoarriba3
		
		jmp _imprimir_ganaarkanoid	
		
		_movimientoarriba3:		
		impr_texto arriba, cursor_tamano
		inc r8
		jmp _vuelta5
		
	_imprimir_ganaarkanoid:
		impr_texto msj_gana, tamano_linea
		impr_texto msj_press_enter, tamano_linea
	
	mov r8, 0
	_vuelta6:
	cmp r8, 15
		jne _movimientoabajo3
		
		jmp _final_imprimir_ganajuego
		
		_movimientoabajo3:		
		impr_texto abajo, cursor_tamano
		inc r8
		jmp _vuelta6
	
	
	_final_imprimir_ganajuego:
	
	_leer_press_enter_4:
	leer_texto teclado,1	
	mov r15, [teclado]
	cmp r15, 0xa
	jne _leer_press_enter_4
	
	
	ret	
;Fin de la funcion


	

;-------------------------------------------------------------------------------------------------------------------------------------
;FIN DEL CODIGO FUENTE	
;-------------------------------------------------------------------------------------------------------------------------------------

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;COMANDO DE EMSAMBLAJE
;nasm -f elf64 -o principal.o CodigoPrincipal2.asm && ld -o mainexe2 principal.o && ./mainexe2
