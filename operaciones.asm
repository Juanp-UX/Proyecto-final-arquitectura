; ========== OPERACIONES MATEMÁTICAS ==========

pedir_dos_numeros:
    ; Pedimos el primer número
    mov eax, txt_primer_num
    call imprimir_texto
    
    mov eax, entrada
    mov ebx, 20
    call leer_teclado
    
    mov eax, entrada
    call texto_a_numero
    mov [numero1], eax

    ; Pedimos el segundo número
    mov eax, txt_segundo_num
    call imprimir_texto
    
    mov eax, entrada
    mov ebx, 20
    call leer_teclado
    
    mov eax, entrada
    call texto_a_numero
    mov [numero2], eax
    ret

hacer_suma:
    call pedir_dos_numeros
    mov eax, [numero1]
    add eax, [numero2]
    call mostrar_resultado
    jmp mostrar_menu

hacer_resta:
    call pedir_dos_numeros
    mov eax, [numero1]
    sub eax, [numero2]
    call mostrar_resultado
    jmp mostrar_menu

hacer_multiplicacion:
    call pedir_dos_numeros
    mov eax, [numero1]
    mov ebx, [numero2]
    imul eax, ebx                   ; multiplicamos con signo
    call mostrar_resultado
    jmp mostrar_menu

hacer_division:
    call pedir_dos_numeros
    mov ebx, [numero2]
    cmp ebx, 0
    je error_division_cero          ; verificamos que no divida por cero

    mov eax, [numero1]
    cdq                             ; preparamos para división con signo
    idiv ebx                        ; dividimos, el resultado queda en eax
    call mostrar_resultado
    jmp mostrar_menu

error_division_cero:
    mov eax, txt_error_division
    call imprimir_texto
    jmp mostrar_menu

mostrar_resultado:
    push eax
    mov eax, txt_resultado
    call imprimir_texto
    pop eax
    call numero_a_texto
    mov eax, salto_linea
    call imprimir_texto
    ret

terminar_programa:
    mov eax, 1                      ; syscall para salir
    xor ebx, ebx
    int 0x80