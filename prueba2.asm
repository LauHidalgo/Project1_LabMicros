;#################################################
;	Programa de prueba para imprimir 5 lineas con cambios en los caracteres
;#################################################


section .data
	
	techo: db '123456789',0xa	;Lineas base para imprimir
	techo_tamano: equ $-techo					;Tamaño de la variable techo

			
section .text
	global _start				;Etiqueta para ensamblar usando NASM
	global _etiqueta1			;Etiquetas de comprobacion con gdb (no necesarias)
			

_start:
	
	mov rsi, techo				;Mueve la direccion de memoria de la variable techo al registro rsi
	mov    byte [rsi +4], '@'	;Cambia el bit que se encuentra en la direccion rsi+4 ('5') con el simbolo '@'
	
_etiqueta1:	
	
	mov rax, 1				;Argumento 1 de llamada al sistema "sys_write"	
	mov rdi, 1				;Argumento de "sys_write" de salida 1 (por defecto pantalla)
	mov rsi, techo			;Argumento de "sys_write" texto a imprimir
	mov rdx, techo_tamano	;Argumento de "sys_write" tamaño del texto
	syscall					;Llamada al sistema para ejecutar la funcion
	






;Luego de completar el programa, se deben recargar registros con las
;condiciones para la siguiente operación, en este caso: sys_exit (60)
	mov rax,60				;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0				;en rdi se carga un 0
	syscall					;se llama al sistema.
;fin del programa


;comando de ensamblaje
;nasm -f elf64 -o prueba_2.o prueba_2.asm && ld -o ejecutable2 prueba_2.o && ./ejecutable2

