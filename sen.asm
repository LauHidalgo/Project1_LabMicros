

	;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	;&&&&&&&&&& DESCRIPCION DE PROGRAMA CALCULO  SEN Y COS &&&&&&&&&&&&&&&&&&&&
	;Este modulo de programa debe de ejecutar la siguiente evaluacion en donde 
	;se ingresa un Angulo de Entrada (VAR) y se compara con 10 bloques los cuales determinan
	;en que rango de se encuentra el angulo con el fin de generar dos Varialbles de salidas
	;que representa el moviento en coordenada (X,Y).
	;		Tabla de Rango: Angulo de entrada=VAR
	;	1. 35<VAR<=54 --> (1,1)
	;	2. 54<VAR<=67 --> (1,2)
	;	2. 67<VAR<=70 --> (1,3)
	;	2. 70<VAR<=80 --> (1,5)
	;	2. 80<VAR     --> (1,8)
	;	2. 22<VAR<=35 --> (8,1)
	;	2. 16<VAR<=22 --> (5,1)
	;	2. 9<VAR<=16  --> (3,1)
	;	2. 0<VAR<=9   --> (2,1)


section .data
	
	;############################################################################
	;########### VARIABLES NUMERICOS DE GRADOS Y POSICION #######################

	num1: equ 35	;angulo de 35 grados								
	num2: equ 54	;angulo de 54 grados							
	num3: equ 67	;angulo de 67 grados
	num4: equ 70	;angulo de 70 grados
	num5: equ 80	;angulo de 80 grados
	num6: equ 9	;angulo de 9 grados
	num7: equ 16	;angulo de 16 grados
	num8: equ 22	;angulo de 22 grados
	angulo: equ 8	;ANGULO_DE_ENTRADA
	pos1: equ 1	;Movimiento de 1 Step
	pos2: equ 2	;Movimiento de 2 Step
	pos3: equ 3	;Movimiento de 3 Step
	pos5: equ 5	;Movimiento de 5 Step
	pos8: equ 8	;Movimiento de 8 Step
	
	;#############################################################################
	;############  Mensaje para Determina el Movimiento de bola ##################
	msj_1: db 'X=1 Y=1. ',0xa	; Mensaje de direccion  X= 1 step y Y= 1 Step
	tamano_msj_1: equ $-msj_1	; Longitud del mensaje 1

	msj_2: db 'X=1 Y=2 ',0xa	; Mensaje de direccion  X= 1 step y Y= 2 Step	
	tamano_msj_2: equ $-msj_2	; Longitud del mensaje 2							

	msj_3: db 'X=1 Y=3',0xa		; Mensaje de direccion  X= 1 step y Y= 3 Step
	tamano_msj_3: equ $-msj_3	; Longitud del mensaje 3

	msj_4: db 'X=1 Y=5',0xa		; Mensaje de direccion  X= 1 step y Y= 5 Step
	tamano_msj_4: equ $-msj_4	; Longitued del mensaje 4
	
	msj_5: db 'X=1 Y=8',0xa	 	; Mensaje de direccion  X= 1 step y Y= 8 Step
	tamano_msj_5: equ $-msj_5	; Longitued del mensaje 5

	msj_6: db 'X=2 Y=1',0xa		; Mensaje de direccion  X= 2 step y Y= 1 Step
	tamano_msj_6: equ $-msj_6	; Longitud del mensaje 6
	
	msj_7: db 'X=3 Y=1',0xa		; Mensaje de direccion  X= 3 step y Y= 1 Step
	tamano_msj_7: equ $-msj_7	; Longitud de mensaje 7
	
	msj_8: db 'X=5 Y=1',0xa		; Mensaje de direccion  X= 5 step y Y= 1 Step
	tamano_msj_8: equ $-msj_8	; Longitud de mensaje 8
	
	msj_9: db 'X=8 Y=1',0xa	;	; Mensaje de direccion  X= 8 step y Y= 1 Step
	tamano_msj_9: equ $-msj_9	; Longitud mensaje 9
	
	;############################################################################
										
section .text
	;############################################################################
	;############### DEFINICION DE ETIQUETAS DE DEBBUG ##########################
	
	global _start		; Definicion del punto de partida
	global _segunda;	; Definicion de segunda 
	
	;############################################################################
_start:

.primer_bloque:

	mov rax,angulo			;ingresa variable angulo a RAX
	mov rbx,num1			;ingresa variales de 35 grados a RBX	
	cmp rax,rbx 			;compara angulo con 35 grados
	jg .segundo_bloque		;salto a segundo bloque si VAR>35
        jle .sexto_bloque		;salto a sexto bloque si VAR<=35

.segundo_bloque	:
	
	mov rax,angulo			;ingresa variable angulo a RAX
	mov rbx,num2			;ingresa variable de 54 grados a RBX
	cmp rax,rbx 			;compara angulo con 54 grados
	jg .tercer_bloque		;salto al tercer bloque si VAR>54 

	;$$Codigo entre simbolos de $ solamente para expresar los mensajes en pantallas$$$$
	;$$$$$$$$$$ Deberias eliminar para codigo final $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	mov rax,1			;rax = "sys_write"
	mov rdi,1			;rdi = 1 (standard output = pantalla)
	mov rsi,msj_1			;rsi = mensaje a imprimir
	mov rdx,tamano_msj_1		;rdx=tamano del mensaje
	syscall				;Llamar al sistema
       	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
	;@@@@@ LAS SIGUIENTES LINEAS SE DEBEN ACTIVAR PARA CODIGO FINAL @@@@@@@@@@@@@@
	;mov r8,pos1			;Asigna Registro R8 el posicion la variable $pos1 que significa X=1 
	;mov r9,pos1			;Asigna Registro R9 el posicion la variable $pos8 que significa Y=1


	 jle .final			;salto al bloque final

.tercer_bloque:

	mov rax,angulo 			;ingresa variable angulo a RAX
	mov rbx,num3			;ingresa variable de 67 grados a RBX
	cmp rax,rbx 			;compara angulo con 67 grados
	jg .cuarto_bloque		;salto al cuarto bloque si VAR>67

	;$$Codigo entre simbolos de $ solamente para expresar los mensajes en pantallas$$$$
	;$$$$$$$$$$ Deberias eliminar para codigo final $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	mov rax,1			;rax = "sys_write"
	mov rdi,1			;rdi = 1 (standard output = pantalla)
	mov rsi,msj_2			;rsi = mensaje a imprimir
	mov rdx,tamano_msj_2		;rdx=tamano del mensaje
	syscall				;Llamar al sistema
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
	;@@@@@ LAS SIGUIENTES LINEAS SE DEBEN ACTIVAR PARA CODIGO FINAL @@@@@@@@@@@@@@
	;mov r8,pos1			;Asigna Registro R8 el posicion la variable $pos1 que significa X=1 
	;mov r9,pos2			;Asigna Registro R9 el posicion la variable $pos8 que significa Y=2


        jle .final			;salta al boque final

.cuarto_bloque:

	mov rax,angulo			;ingresa variable angulo a RAX
	mov rbx,num4			;ingresa variable 70 grados RBX
	cmp rax,rbx 			;compara angulo con 70 grados
	jg .quinto_bloque		;salta al quinto bloque VAR>70

	;$$Codigo entre simbolos de $ solamente para expresar los mensajes en pantallas$$$$
	;$$$$$$$$$$ Deberias eliminar para codigo final $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	mov rax,1			;rax = "sys_write"
	mov rdi,1			;rdi = 1 (standard output = pantalla)
	mov rsi,msj_3			;rsi = mensaje a imprimir
	mov rdx,tamano_msj_3		;rdx=tamano del mensaje
	syscall				;Llamar al sistema
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
	;@@@@@ LAS SIGUIENTES LINEAS SE DEBEN ACTIVAR PARA CODIGO FINAL @@@@@@@@@@@@@@
	;mov r8,pos1			;Asigna Registro R8 el posicion la variable $pos1 que significa X=1 
	;mov r9,pos3			;Asigna Registro R9 el posicion la variable $pos8 que significa Y=3
        jle .final			;salta al bloque final


.quinto_bloque:

	mov rax,angulo			;ingresa variable de angulo RAX
	mov rbx,num5			;ingresa Variable de 80 grados RBX
	cmp rax,rbx 			;compara angulo con 80 grados
	jg .noveno_bloque		;salta noveno bloque VAR>90

	;$$Codigo entre simbolos de $ solamente para expresar los mensajes en pantallas$$$$
	;$$$$$$$$$$ Deberias eliminar para codigo final $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	mov rax,1			;rax = "sys_write"
	mov rdi,1			;rdi = 1 (standard output = pantalla)
	mov rsi,msj_4			;rsi = mensaje a imprimir
	mov rdx,tamano_msj_4		;rdx=tamano del mensaje
	syscall				;Llamar al sistema
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
	;@@@@@ LAS SIGUIENTES LINEAS SE DEBEN ACTIVAR PARA CODIGO FINAL @@@@@@@@@@@@@@
	;mov r8,pos1			;Asigna Registro R8 el posicion la variable $pos1 que significa X=1 
	;mov r9,pos5			;Asigna Registro R9 el posicion la variable $pos8 que significa Y=5
	jle .final			;salta al bloque final
       

.sexto_bloque:
	
	mov rax,angulo			;ingresa variable de angulo a RAX
	mov rbx,num6			;ingresa variale de 9 grados a RBX
	cmp rax,rbx 			;compara angulo con 9 grados
	jg .setimo_bloque		;brinca setimo bloque VAR>9

	;$$Codigo entre simbolos de $ solamente para expresar los mensajes en pantallas$$$$
	;$$$$$$$$$$ Deberias eliminar para codigo final $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	mov rax,1			;rax = "sys_write"
	mov rdi,1			;rdi = 1 (standard output = pantalla)
	mov rsi,msj_6			;rsi = mensaje a imprimir
	mov rdx,tamano_msj_6		;rdx=tamano del mensaje
	syscall				;Llamar al sistema
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
	;@@@@@ LAS SIGUIENTES LINEAS SE DEBEN ACTIVAR PARA CODIGO FINAL @@@@@@@@@@@@@@
	;mov r8,pos2			;Asigna Registro R8 el posicion la variable $pos1 que significa X=2 
	;mov r9,pos1			;Asigna Registro R9 el posicion la variable $pos8 que significa Y=1
        jle .final			;salta bloque final

.setimo_bloque:
	
	mov rax,angulo			;ingresa variable de angulo a RAX
	mov rbx,num7			;ingresa variable de 16 grados a RBX	
	cmp rax,rbx 			;compara angulo con 16 grados
	jg .octavo_bloque		;salta bloque bloque VAR>26

	;$$Codigo entre simbolos de $ solamente para expresar los mensajes en pantallas$$$$
	;$$$$$$$$$$ Deberias eliminar para codigo final $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	mov rax,1			;rax = "sys_write"
	mov rdi,1			;rdi = 1 (standard output = pantalla)
	mov rsi,msj_7			;rsi = mensaje a imprimir
	mov rdx,tamano_msj_7		;rdx=tamano del mensaje
	syscall				;Llamar al sistema
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
	;@@@@@ LAS SIGUIENTES LINEAS SE DEBEN ACTIVAR PARA CODIGO FINAL @@@@@@@@@@@@@@
	;mov r8,pos3			;Asigna Registro R8 el posicion la variable $pos1 que significa X=3 
	;mov r9,pos1			;Asigna Registro R9 el posicion la variable $pos8 que significa Y=1
        jle .final			;salta bloque final

.octavo_bloque:

	mov rax,angulo			;ingresa variable de angulo a RAX
	mov rbx,num8			;ingresa variable de 22 a RBX
	cmp rax,rbx 			;compara angulo con 22 grados
	jg .decimo_bloque		;salta a bloque decimo
	
	;$$Codigo entre simbolos de $ solamente para expresar los mensajes en pantallas$$$$
	;$$$$$$$$$$ Deberias eliminar para codigo final $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	mov rax,1			;rax = "sys_write"
	mov rdi,1			;rdi = 1 (standard output = pantalla)
	mov rsi,msj_8			;rsi = mensaje a imprimir
	mov rdx,tamano_msj_8		;rdx=tamano del mensaje
	syscall				;Llamar al sistema
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
	;@@@@@ LAS SIGUIENTES LINEAS SE DEBEN ACTIVAR PARA CODIGO FINAL @@@@@@@@@@@@@@
	;mov r8,pos5			;Asigna Registro R8 el posicion la variable $pos1 que significa X=5 
	;mov r9,pos1			;Asigna Registro R9 el posicion la variable $pos8 que significa Y=1
        jle .final			;salta al bloque final

.noveno_bloque:

	;$$Codigo entre simbolos de $ solamente para expresar los mensajes en pantallas$$$$
	;$$$$$$$$$$ Deberias eliminar para codigo final $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	mov rax,1			;rax = "sys_write"
	mov rdi,1			;rdi = 1 (standard output = pantalla)
	mov rsi,msj_5			;rsi = mensaje a imprimir
	mov rdx,tamano_msj_5		;rdx=tamano del mensaje
	syscall				;Llamar al sistema
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
	;@@@@@ LAS SIGUIENTES LINEAS SE DEBEN ACTIVAR PARA CODIGO FINAL @@@@@@@@@@@@@@
	;mov r8,pos1			;Asigna Registro R8 el posicion la variable $pos1 que significa X=1 
	;mov r9,pos8			;Asigna Registro R9 el posicion la variable $pos8 que significa Y=8
        jmp .final			;salta al boloque final

.decimo_bloque:
	
	;$$Codigo entre simbolos de $ solamente para expresar los mensajes en pantallas$$$$
	;$$$$$$$$$$ Deberias eliminar para codigo final $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	mov rax,1			;rax = "sys_write"
	mov rdi,1			;rdi = 1 (standard output = pantalla)
	mov rsi,msj_9			;rsi = mensaje a imprimir
	mov rdx,tamano_msj_9		;rdx=tamano del mensaje
	syscall				;Llamar al sistemi
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
	;@@@@@ LAS SIGUIENTES LINEAS SE DEBEN ACTIVAR PARA CODIGO FINAL @@@@@@@@@@@@@@
	;mov r8,pos8			;Asigna Registro R8 el posicion la variable $pos8 que significa X=8 
	;mov r9,pos1			;Asigna Registro R9 el posicion la variable $pos1 que significa Y=1
	jmp .final			;salta al boloque final


.final:

	;Salida del programa
	mov rax,60						;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0							;en rdi se carga un 0
	syscall								;se llama al sistema.


;fin del programa
;###############################################################################################	
