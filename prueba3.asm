;#################################################
;	Programa de prueba para dos lineas con cambios en los caracteres entre ellas
;#################################################


section .data
	
	techo: db '123456789',0xa			;Lineas base para imprimir
	techo_tamano: equ $-techo			;Tama�o de la variable techo
	
	numero: equ 3


section .text
	global _start						;Etiqueta para ensamblar usando NASM
	global _etiqueta1					;Etiquetas de comprobacion con gdb (no necesarias)
	global _etiqueta2
	global _etiqueta3
			

_start:
	
	mov 	rsi, techo					;Mueve la direccion de memoria de la variable techo al registro rsi
	mov    	byte [rsi +numero], '@'		;Cambia el bit que se encuentra en la direccion rsi+4 ('5') con el simbolo '@'
	
;_etiqueta1:	
	
	mov 	rax, 1					;Argumento 1 de llamada al sistema "sys_write"	
	mov 	rdi, 1					;Argumento de "sys_write" de salida 1 (por defecto pantalla)
	mov 	rsi, techo					;Argumento de "sys_write" texto a imprimir
	mov 	rdx, techo_tamano			;Argumento de "sys_write" tama�o del texto
	syscall							;Llamada al sistema para ejecutar la funcion
	
	
	
	
	mov 	r8, numero				;Mueve el contenido de numero a R8
	add 	r8, 2					;Se agrega 2 unidades enteras a r8
	
	mov 	rsi, techo		
	mov 	byte [rsi +r8], '@'			;Cambia el bit que se encuentra en la direccion rsi+r8 ('7') con el simbolo '@'
	
	mov 	rax, 1					;Argumento 1 de llamada al sistema "sys_write"	
	mov 	rdi, 1					;Argumento de "sys_write" de salida 1 (por defecto pantalla)
	mov 	rsi, techo					;Argumento de "sys_write" texto a imprimir
	mov 	rdx, techo_tamano			;Argumento de "sys_write" tama�o del texto
	syscall		
	






;Luego de completar el programa, se deben recargar registros con las
;condiciones para la siguiente operaci�n, en este caso: sys_exit (60)
	mov rax,60					;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0					;en rdi se carga un 0
	syscall						;se llama al sistema.
;fin del programa


;comando de ensamblaje
;nasm -f elf64 -o prueba_2.o prueba_2.asm && ld -o ejecutable2 prueba_2.o && ./ejecutable2

