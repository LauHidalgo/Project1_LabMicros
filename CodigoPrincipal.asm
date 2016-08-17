;#######################################################
;	Tecnologico de Costa Rica - Escuela de Ingenieria Electronica
;	Curso: Laboratorio de Estructura de Microprocesadores - Grupo 1
;	Fecha: Jueves 18 de Agosto de 2016
;
;	Proyecto #1: Juego estilo Arkanoid (Micronoid)
;
;	Codigo desarrollado por:
;		- Anthony Chaves Vasquez
;		- Laura Hidalgo Soto
;		- Carlos Murillo Soto
;		- Irene Rivera Arrieta
;
;#######################################################


;////////////////////////////////////////////////////////////////////	Definicion de variables	////////////////////////////////////////////////////////////////////
section .data
	
	saludo: db 0xa,'Bienvenido a Micronoid', 0xa 								;Mensaje de bienvenida al juego
	saludo_length: equ $-saludo 											;Tamano de la variable saludo

	infoCurso: db 0xa,'EL 4313 Laboratorio de Estructura de Microprocesadores.', 0xa 	;Informacion del curso
	infoCurso_length: equ $-infoCurso										;Tamano de la variable curso
	
	semestre: db 'II Semestre 2016', 0xa  									;Informacion del semestre
	semestre_length: equ $-semestre 										;Tamano variable semestre

	msjUser: db 0xa, 'Ingrese el nombre del jugador y luego presione Enter: ' 		;Banner para ingreso de nombre de usuario.
	msjUser_length: equ $-msjUser 										;Longitud de msj de nombre del usuario

	nameUser: db'' 													;Almacena nombre del usuario
	
	msjintentos: db 0xa,'Intentos Restantes -----> ',0xa 	 								;Encabezado de mensaje de intentos restantes
	msjintentos_tamano: equ $-msjintentos
	
	encabezadoNombre: db 'Nombre ----> ' ,0xa	 								;Encabezado de mensaje de intentos restantes
	encabezadoNombre_tamano: equ $-encabezadoNombre
	
	numero1:	db '1'													;Variables char que sirven para escribir los numeros 1 al 3
	numero2: db '2'
	numero3: db '3'
	
	
	
	termios: times 36 db 0 												;Estructura de 36 bytes, contiene modo de operacion de la consola
	stdin: equ 0 														;Standard Input
	ICANON: equ 1<<1													;ICANON: valor de control para on/off modo canonico
	ECHO: equ 1<<3 													;ECHO: valor control para on/off eco

																	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
																	;TERMIOS = TERMinal Input/Output Settings

	clrScreen: db  0x1b,"[2J", 0x1 										;Variable que usa combinacion de caracteres ANSI para borrar la pantalla
	clrScreen_length: equ $-clrScreen										;Tamano de la variable clrScreen
	
	
	parte1: db '+-------------------------------------------------+',0xa			;Parte 1 para el area de juego
	parte1_tamano: equ $-parte1								;Tamaño de la variable 
	
	parte2: db '|+-----++-----++-----++-----++-----++-----++-----+|',0xa	;Parte 2 para el area de juego
	parte2_tamano: equ $-parte2								;Tamaño de la variable 
	
	parte3: db '||     ||     ||     ||     ||     ||     ||     ||',0xa				;Parte 3 para el area de juego
	parte3_tamano: equ $-parte3								;Tamaño de la variable 
	
	parte4: db '|                                                 |',0xa				;Parte 4 para el area de juego
	parte4_tamano: equ $-parte4								;Tamaño de la variable 
	
	parte5: db '+________________________|________________________+',0xa	;Parte 5 para el area de juego
	parte5_tamano: equ $-parte5								;Tamaño de la variable 
	
	cambiodelinea: db ' ',0xa										;linea vacia para el area de juego
	cambiodelinea_tamano: equ $-cambiodelinea							;Tamaño de la variable 
	
	lineavacia: db '#',0xa										;linea vacia para el area de juego
	lineavacia_tamano: equ $-lineavacia			
	
	
	
	intentos: db 3			;Variable que indica el numero de intentos que el usuario tiene en el juego
	
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
	
	posY_tabla: db 0		;Las variables de posicion de la tabla y la pelota
	posY_bola: db 0
	posX_tabla: db 0
	posX_bola: db 0
	dir_mov_X: db '+'		;Por cuestion de control, se tienen las variables de en que direccion de movimiento se encuentra la pelota
	dir_mov_Y: db '+'
	
	arriba db 0x1b, "[1A" 			;Codigo ANSI para mover el cursor 1 posicion hacia arriba
	arriba_tamano: equ $-arriba	
	abajo db 0x1b, "[1B" 			;Codigo ANSI para mover el cursor 1 posicion hacia abajo
	abajo_tamano: equ $-abajo		
	derecha db 0x1b, "[1C" 			;Codigo ANSI para mover el cursor 1 posicion hacia la derecha
	derecha_tamano: equ $-derecha	
	izquierda db 0x1b, "[1D" 			;Codigo ANSI para mover el cursor 1 posicion hacia la izquierda
	izquierda_tamano: equ $-izquierda
	
	
	



;////////////////////////////////////////////////////////////////////	Codigo Principal	////////////////////////////////////////////////////////////////////

;Definicion de etiquetas
section .text
	global _start 			
	global _primero
	global _segundo
	global _tercero
	global _finprograma
	
	;globales para el call "imprimir_area_juego"
	global _imprimir_parte1
	global _imprimir_parte2
	global _imprimir_parte3
	global _imprimir_parte4
	global _imprimir_parte5
	global _loop1
	global _intentos1
	global _intentos2
	global _intentos3
	global _terminar
	
	;globales para la funcion "cursor_origen"
	global _loop2
	global _nombreyvidas



_start:
	
	;PRIMERA PARTE:  Se muestran los banner iniciales de la pantalla de inicio
	
	;Limpieza de pantalla
	call limpiar_pantalla
	
	;Imprimir saludo
	mov rax,1				;rax = sys_write
	mov rdi,1				;rdi = pantalla (standar output)
	mov rsi,saludo			;rsi = msj a imprimir
	mov rdx,saludo_length		;rdx = longitud de la variable saludo
	syscall

	;Imprimir banner de con informacion del curso
	mov rax,1           
	mov rdi,1          
	mov rsi,infoCurso   
	mov rdx,infoCurso_length
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

	;Encender modo canonico y el modo echo
	call canonical_on   			;Llamado a funcion que enciende el modo canonico
	call echo_on       			;Llamado a funcion que enciende echo

	;Captura de nombre de usuario
	mov rax,0          			;rax = sys_read
	mov rdi,0          			;rdi = teclado (standar input)
	mov rsi,nameUser   		;direccion de memoria donde se almacena nombre del usuario
	mov rdx,20				;numero de bytes (teclas presionadas antes de enter) a almacenar 
	syscall
	
	;Apagar modo canonico y el modo echo
	call canonical_off   			;Llamado a funcion que apaga el modo canonico
	call echo_off       			;Llamado a funcion que apaga echo
	
	;Inicializar las variables del juego
	;call inicializar

	;Limpieza de pantalla
	call limpiar_pantalla
	
	;Imprimir el area de juego
	call imprimir_area_juego
	
	;Colocar el cursor en la posicion de origen para iniciar el juego
	;call cursor_origen
	
	










_finprograma:
	;Finalizacion del programa
	call echo_on
	mov rax,60  ;rax = sys_exit
	mov rdi,0   ;rdi = 0
	syscall

;-------------------------------------------------------------------------------------------------------------------------------------
;FIN DEL PROGRAMA	PRINCIPAL
;-------------------------------------------------------------------------------------------------------------------------------------








;////////////////////////////////////////////////////////////////////	Declaracion de CALL's (metodos o funciones) luego del codigo principal	////////////////////////////////////////////////////////////////////

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
;Funcion encargada de limpiar la pantalla
limpiar_pantalla: 
	mov rax,1
	mov rdi,1
	mov rsi,clrScreen
	mov rdx,clrScreen_length
	syscall
	ret
;Fin de la funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion encargada de limpiar la pantalla
imprimir_area_juego:
	mov r9, 2					;Se inicializa el registro contador r9 en 2, ya que se imprime la primera linea de forma estatica

	mov rax, 1					
	mov rdi, 1
	mov rsi, lineavacia			;Se imprime en pantalla un caracter vacio debido a un vicio en el sistema que afecta 
	mov rdx, lineavacia_tamano	;la estetica del area de juego.
	syscall	
	mov rax, 1					
	mov rdi, 1
	mov rsi, parte1				;Se imprime la primera linea (techo) del area de juego
	mov rdx, parte1_tamano	
	syscall	
	
_loop1:
	cmp r9, 2
	je _imprimir_parte2			;Se imprime la parte superior de los bloques
	cmp r9, 3
	je _imprimir_parte3			;Se imprime la parte intermedia de los bloques
	cmp r9, 4
	je _imprimir_parte2			;Se imprime la parte inferior de los bloques
	cmp r9, 5
	je _imprimir_parte2			;Se imprime la parte superior de los bloques
	cmp r9, 6
	je _imprimir_parte3			;Se imprime la parte intermedia de los bloques
	cmp r9, 7
	je _imprimir_parte2			;Se imprime la parte inferior de los bloques
	cmp r9, 8
	je _imprimir_parte2			;Se imprime la parte superior de los bloques
	cmp r9, 9
	je _imprimir_parte3			;Se imprime la parte intermedia de los bloques
	cmp r9, 10
	je _imprimir_parte2			;Se imprime la parte inferior de los bloques
	cmp r9, 33
	je _imprimir_parte5			;Si el contador se encuentra en la ultima linea (33), se imprime la base del area de juego
	
	jmp _imprimir_parte4			;Si ninguna de las anteriores se cumple, se imprime el espacio vacio del area de juego
	
	
_imprimir_parte2:	
	mov rax, 1					
	mov rdi, 1	
	mov rsi, parte2			
	mov rdx, parte2_tamano	
	syscall
	inc r9					;Se agrega un 1 al registro contador
	jmp _loop1
	
_imprimir_parte3:	
	mov rax, 1					
	mov rdi, 1	
	mov rsi, parte3			
	mov rdx, parte3_tamano	
	syscall
	inc r9					;Se agrega un 1 al registro contador
	jmp _loop1
	
_imprimir_parte4:	
	mov rax, 1					
	mov rdi, 1	
	mov rsi, parte4			
	mov rdx, parte4_tamano	
	syscall
	inc r9					;Se agrega un 1 al registro contador
	jmp _loop1
	
_imprimir_parte5:	
	mov rax, 1					
	mov rdi, 1	
	mov rsi, parte5			
	mov rdx, parte5_tamano	
	syscall
	
	;--------------------------
	mov rax, 1					;Una vez impresas las partes del area de juego, se procede a imprimir
	mov rdi, 1					;el nombre de usuario en la parte inferior, iniciando por el encabezado.
	mov rsi, encabezadoNombre			
	mov rdx, encabezadoNombre_tamano 	
	syscall
	
	
	mov rax, 1					;Ademas del nombre, se imprime tambien la cantidad de intentos
	mov rdi, 1	
	mov rsi, msjintentos			;El primer mensaje a imprimir en intentos es el encabezado.
	mov rdx, msjintentos_tamano	
	syscall
	
	;mov r9, [intentos]				;Se carga el registro r9 con el valor de intentos	para comparar y asi establecer lque numero imprimir
	;cmp r9, 1
	;je _intentos1
	;cmp r9, 2
	;je _intentos2
	;cmp r9, 3
	;je _intentos3
	
;_intentos1:
;	mov rax, 1					
;	mov rdi, 1	
;	mov rsi, numero1			;Se imprime el numero 1
;	mov rdx, 1
;	syscall
;	jmp _terminar
;
;_intentos2:
;	mov rax, 1					
;	mov rdi, 1	
;	mov rsi, numero2			;Se imprime el numero 2
;	mov rdx, 1
;	syscall
;	jmp _terminar

;_intentos3:
;	mov rax, 1					
;	mov rdi, 1	
;	mov rsi, numero3			;Se imprime el numero 3
;	mov rdx, 1
;	syscall
;	jmp _terminar	
;	
;_terminar
	ret			; Se retorna al ciclo normal del programa principal
;fin de la funcion


;-------------------------------------------------------------------------------------------------------------------------------------
;Funcion encargada de colocar el cursor en el origen de coordenadas cuando se imprime el area de juego.
;Lo realiza mediante el movimiento con codigos de escape ANSI 50 veces hacia la izquierda (50 es el ancho
;total del area de juego.
cursor_origen:
	
	mov r9,0				;Se inicializa el registro contador r9 con un valor entero de 0

_loop2:
	
	cmp r9, 50			;Se compara con el valor total de columnas
	je _nombreyvidas		;Si es igual, se envia a la etiqueta de finalizacion de funcion
	
	mov rax, 1			;Se cargan los registros con los valores correspondientes y variables ANSI
	mov rdi, 1	
	mov rsi, izquierda			
	mov rdx, izquierda_tamano	
	syscall				;Se llama al sistema
	inc r9				;Se incrementa en una unidad el registro contador r9
	jmp _loop2			;Se salta incondicionalmente a loop2 para proceder a una nueva iteracion
	
	
_nombreyvidas:
	
	mov rax,1
	mov rdi,1
	mov rsi,nameUser
	mov rdx,20
	syscall
	
	
	
	
	
	ret		
;Fin de la funcion

	
;-------------------------------------------------------------------------------------------------------------------------------------
;FIN DEL CODIGO FUENTE	
;-------------------------------------------------------------------------------------------------------------------------------------

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;COMANDO DE EMSAMBLAJE
;nasm -f elf64 -o name.o name.asm 
;ld -o ejecutable_name name.o 
;./ejecutable_name

