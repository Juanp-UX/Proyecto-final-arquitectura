%include 'funciones_texto.asm'
%include 'operaciones.asm'
section .data
    ; Contraseña del sistema
    contrasena_guardada db "1234", 0
    
    ; Mensajes del login
    txt_pedir_pass      db "Ingrese contrasena: ", 0
    txt_bienvenida      db 0xA, "============ BIENVENIDO AL SISTEMA ============ ", 0xA, 0
    txt_pass_incorrecto db "contrasena incorrecto.", 0xA, 0
    txt_bloqueado       db "Sistema bloqueado.", 0xA, 0
    
    ; Texto del menú principal
    texto_menu          db 0xA, "SELECCIONE OPERACION:", 0xA
                        db "1. Suma", 0xA
                        db "2. Resta", 0xA
                        db "3. Multiplicacion", 0xA
                        db "4. Division", 0xA
                        db "5. Salir", 0xA
                        db "Opcion > ", 0
    
    ; Mensajes para las operaciones
    txt_primer_num      db "Ingrese primer numero: ", 0
    txt_segundo_num     db "Ingrese segundo numero: ", 0
    txt_resultado       db "El resultado es: ", 0
    txt_error_division  db "Error: Division por cero", 0xA, 0
    salto_linea         db 0xA, 0
    signo_menos         db "-", 0

    ; Códigos ANSI para ocultar lo que escribe el usuario
    ocultar_texto       db 1Bh, "[8m", 0     ; modo invisible ANSI
    mostrar_texto       db 1Bh, "[0m", 0     ; volver a normal

section .bss
    entrada             resb 30     ; donde se guarda lo que escribe el usuario
    numero1             resd 1      ; primer número de la operación
    numero2             resd 1      ; segundo número de la operación
    buffer_resultado    resb 30     ; para convertir números a texto
    contador_loop       resd 1      ; para loops 

section .text
    global _start

_start:
    xor ecx, ecx                    ; ecx cuenta los intentos fallidos

verificar_password:
    push ecx                        ; guardamos cuántos intentos lleva
    
    ; Pedimos la contraseña
    mov eax, txt_pedir_pass
    call imprimir_texto

    ; Ocultamos lo que va a escribir 
    mov eax, ocultar_texto
    call imprimir_texto

    ; Leemos lo que ingresa el usuario
    mov eax, entrada
    mov ebx, 10
    call leer_teclado
    
    ; Volvemos a mostrar el texto normal
    mov eax, mostrar_texto
    call imprimir_texto
    mov eax, salto_linea
    call imprimir_texto

    ; Comparamos con la contraseña correcta
    mov esi, entrada
    mov edi, contrasena_guardada
    call comparar_textos

    pop ecx                         ; recuperamos el contador de intentos
    cmp eax, 0                      ; si da 0, la contraseña es correcta
    je password_correcto

    ; Si llegamos acá es porque falló
    mov eax, txt_pass_incorrecto
    call imprimir_texto
    
    inc ecx                         ; sumamos un intento fallido
    cmp ecx, 3
    jl verificar_password           ; si aún no llega a 3, dejamos intentar de nuevo

    ; Ya gastó los 3 intentos
    mov eax, txt_bloqueado
    call imprimir_texto
    call terminar_programa

password_correcto:
    mov eax, txt_bienvenida
    call imprimir_texto

mostrar_menu:
    ; Mostramos las opciones
    mov eax, texto_menu
    call imprimir_texto

    ; Leemos qué opción eligió
    mov eax, entrada
    mov ebx, 5
    call leer_teclado

    ; Vemos qué número ingresó
    mov al, [entrada]
    
    cmp al, '1'
    je hacer_suma
    cmp al, '2'
    je hacer_resta
    cmp al, '3'
    je hacer_multiplicacion
    cmp al, '4'
    je hacer_division
    cmp al, '5'
    je terminar_programa
    
    jmp mostrar_menu                ; si puso cualquier otra cosa, volvemos al menú



