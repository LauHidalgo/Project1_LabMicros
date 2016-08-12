;#################################################
;	Programa de prueba para imprimir 5 veces las lineas usando cmp, je y jmp
;#################################################


section .data
	
	techo: db '+-------------------------------------------------+',0xa	;Lineas base para imprimir
	techo_tamano: equ $-techo					;Tamaño de la variable techo
	
	num1: dd 5								;Numero de veces a imprimir las lineas
	
	
		
section .text
	global _start				;Etiqueta para ensamblar usando NASM
	global _etiqueta1			;Etiquetas de comprobacion con gdb (no necesarias)
	global _etiqueta2
	global _etiqueta3
		

_start:

	mov r12, 1				;Carga al registro general r12 un numero entero 1
	mov r13, [num1]			;Carga al registro general r13 la variable num1
.top:							
	mov rax, 1				;Argumento 1 de llamada al sistema "sys_write"	
	mov rdi, 1				;Argumento de "sys_write" de salida 1 (por defecto pantalla)
	mov rsi, techo				;Argumento de "sys_write" texto a imprimir
	mov rdx, techo_tamano		;Argumento de "sys_write" tamaño del texto
	syscall					;Llamada al sistema para ejecutar la funcion
	
	cmp r12, r13				;Se comparan los registros contador (r12) y limite de contador (r13)
	je .finalprograma			;Si los registros son identicos, se salta a la etiqueta top
	
	add r12,1				;Si los registros no son  equivalentes, se agrega un uno al valor contenido en el registro contador
		
	jmp .top					;Se salta incondicionalmente a .top luego de comprobar que los registros no son iguales y se haya agregado "una vuelta" al registro contador
	
	

.finalprograma:

;Luego de completar el programa, se deben recargar registros con las
;condiciones para la siguiente operación, en este caso: sys_exit (60)
	mov rax,60				;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0				;en rdi se carga un 0
	syscall					;se llama al sistema.
;fin del programa


;comando de ensamblaje
;nasm -f elf64 -o prueba_2.o prueba_2.asm && ld -o ejecutable2 prueba_2.o && ./ejecutable2

