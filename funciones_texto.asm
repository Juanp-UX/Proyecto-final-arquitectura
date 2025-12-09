; ========== FUNCIONES DE TEXTO ==========

; Imprime un texto que termina en cero
imprimir_texto:
    pusha
    mov ecx, eax
    ; calculamos cuántos caracteres tiene
    xor edx, edx
contar_chars:
    cmp byte [ecx + edx], 0
    je imprimir_ahora
    inc edx
    jmp contar_chars
imprimir_ahora:
    mov eax, 4                      ; sys_write
    mov ebx, 1                      ; stdout
    int 0x80
    popa
    ret

; Lee texto del teclado
; eax = donde guardar, ebx = máximo de caracteres
leer_teclado:
    pusha
    mov ecx, eax
    mov edx, ebx
    mov eax, 3                      ; sys_read
    mov ebx, 0                      ; stdin
    int 0x80
    
    ; quitamos el enter al final
    mov edi, ecx
    xor ecx, ecx
buscar_enter:
    cmp byte [edi + ecx], 0xA
    je quitar_enter
    cmp byte [edi + ecx], 0
    je terminar_impresion
    inc ecx
    jmp buscar_enter
quitar_enter:
    mov byte [edi + ecx], 0


; Compara dos textos
; esi = primer texto, edi = segundo texto
; devuelve 0 en eax si son iguales
comparar_textos:
    push esi
    push edi
seguir_comparando:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne son_diferentes
    cmp al, 0
    je son_iguales
    inc esi
    inc edi
    jmp seguir_comparando
son_diferentes:
    pop edi
    pop esi
    mov eax, 1
    ret
son_iguales:
    pop edi
    pop esi
    xor eax, eax
    ret

; Convierte texto a número
; eax = dirección del texto, devuelve el número en eax
texto_a_numero:
    push ebx
    push ecx
    push edx
    push esi

    mov esi, eax
    xor eax, eax                    ; acá iremos guardando el número
    xor ecx, ecx
    xor edx, edx                    ; flag para saber si es negativo

    cmp byte [esi], '-'             ; verificamos si tiene signo menos
    jne convertir_digitos
    mov edx, 1                      ; marcamos que es negativo
    inc esi

convertir_digitos:
    mov cl, [esi]
    cmp cl, 0
    je terminar_conversion
    cmp cl, 0xA
    je terminar_conversion
    
    sub cl, '0'                     ; convertimos de ASCII a número
    imul eax, 10                    ; corremos el resultado actual
    add eax, ecx                    ; agregamos el nuevo dígito
    
    inc esi
    jmp convertir_digitos

terminar_conversion:
    cmp edx, 1
    jne devolver_numero
    neg eax                         ; si era negativo, invertimos el signo

devolver_numero:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; Convierte número a texto y lo imprime
; eax = número a imprimir
numero_a_texto:
    pusha
    mov dword [contador_loop], 0    ; contador de dígitos (ahora manual)
    
    cmp eax, 0
    jge procesar_numero
    ; si es negativo, imprimimos el signo
    push eax
    mov eax, signo_menos
    call imprimir_texto
    pop eax
    neg eax                         ; lo hacemos positivo

procesar_numero:
    mov ebx, 10
separar_digitos:
    xor edx, edx
    div ebx                         ; dividimos entre 10
    add dl, '0'                     ; convertimos el resto a ASCII
    push edx                        ; guardamos en la pila
    inc dword [contador_loop]       ; contamos el dígito
    cmp eax, 0
    jne separar_digitos
    
; Ahora imprimimos los dígitos usando loop manual
imprimir_digitos:
    cmp dword [contador_loop], 0    ; verificamos si quedan dígitos
    je terminar_impresion          ; si no quedan, terminamos
    
    pop eax                         ; sacamos cada dígito
    mov [buffer_resultado], al
    mov byte [buffer_resultado+1], 0
    mov eax, buffer_resultado
    call imprimir_texto
    
    dec dword [contador_loop]       ; restamos 1 al contador
    jmp imprimir_digitos           ; repetimos manualmente

terminar_impresion:
    popa
    ret