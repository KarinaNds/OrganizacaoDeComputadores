.data
msg_pedir_raio:       .asciiz "Digite o valor do raio da órbita (em km): "
msg_resultado:        .asciiz "\n*********** Informações sobre o Satélite ************\n"
msg_velocidade:       .asciiz "    Velocidade da Orbital: "
msg_raio_orbita:      .asciiz "\n    Raio da órbita: "
sufixo_km_s:          .asciiz " km/s"
sufixo_km:            .asciiz " km"
sufixo_segundos:      .asciiz " segundos"
msg_periodo_orbita:   .asciiz "\n    Período da órbita do satélite: "
decoracao:            .asciiz "\n**\n"
msg_invalido:         .asciiz "\n Número inválido. Por favor, insira números positivos.\n"

constante_g:          .float 6.674e-11   # Constante gravitacional
massa_terra:          .float 5.972e24    # Massa da Terra
valor_pi:             .float 3.14159     # Valor de pi
constante_mil:        .float 1000.0      # Constante 1000
valor_zero:           .float 0.0         # Carrega zero para comparação

.text
j main

calcular_parametros:
    # Velocidade orbital: v = sqrt(G * M / r)
    la $t7, constante_g        # Carrega constante_g para $t7
    l.s $f2, ($t7)             # G vai para $f2
    la $t1, massa_terra        # Carrega massa da Terra
    l.s $f3, ($t1)             # M vai para $f3
    mul.s $f4, $f2, $f3        # Calcula f4 = G * M
    
    # Converte raio para metros (r = r * 1000)
    la $t0, constante_mil
    l.s $f1, ($t0)             # Carrega 1000 para $f1
    mul.s $f18, $f18, $f1      # r *= 1000 (metros)

    div.s $f5, $f4, $f18       # Calcula f5 = f4 / r
    sqrt.s $f6, $f5            # Velocidade orbital vai para $f6

    div.s $f6, $f6, $f1        # Converte a velocidade para km/s

    # Período orbital: T = sqrt((4 * pi^2 * r^3) / (G * M))
    la $t7, valor_pi           # Carrega pi para $t3
    l.s $f8, ($t7)             # Pi vai para $f8
    li $t4, 4                  # t4 = 4
    mtc1 $t4, $f7              # Move para registrador de ponto flutuante       
    cvt.s.w $f7, $f7           # Converte inteiro para float

    mul.s $f9, $f8, $f8        # $f9 = pi^2
    mul.s $f10, $f7, $f9       # f10 = 4 * pi^2
    mul.s $f11, $f18, $f18     # f11 = r^2
    mul.s $f18, $f11, $f18     # f18 = r^3
    mul.s $f13, $f10, $f18     # 4 * pi^2 * r^3
    div.s $f14, $f13, $f4      # (4 * pi^2 * r^3) / (G * M)
    sqrt.s $f15, $f14          # Período (T em segundos)

    jr $ra

imprimir_resultados:  
    # Exibe os resultados
    li $v0, 4
    la $a0, msg_resultado      # Texto com asteriscos
    syscall

    # Velocidade
    li $v0, 4
    la $a0, msg_velocidade     # Texto da velocidade
    syscall
    mov.s $f12, $f6            # Move a velocidade para $f12 para exibição
    li $v0, 2                  # Código para imprimir float
    syscall
    li $v0, 4
    la $a0, sufixo_km_s        # Texto km/s
    syscall

    # Raio original em km
    li $v0, 4
    la $a0, msg_raio_orbita
    syscall
    mov.s $f12, $f17           # Move o raio para $f12 para exibição
    li $v0, 2                  # Imprime o raio
    syscall
    li $v0, 4
    la $a0, sufixo_km          # Texto km
    syscall

    # Período
    li $v0, 4
    la $a0, msg_periodo_orbita
    syscall
    mov.s $f12, $f15           # Move o período para $f12
    li $v0, 2                  # Imprime o período
    syscall
    li $v0, 4
    la $a0, sufixo_segundos    # Texto segundos
    syscall

    # Encerramento
    li $v0, 4
    la $a0, decoracao
    syscall
    jr $ra

valor_invalido:
    li $v0, 4
    la $a0, msg_invalido       # Aviso de invalidez
    syscall

main:
    # Pede a entrada do raio
    li $v0, 4                  
    la $a0, msg_pedir_raio
    syscall

    li $v0, 6                  # Lê ponto flutuante
    syscall
    mov.s $f18, $f0            # Guarda o valor de r (em km) 

    # Verifica se o número é negativo (f18 < 0)
    la $t7, valor_zero         # Carrega 0 para $t7
    l.s $f19, ($t7)            # Carrega 0.0 para comparação
    c.lt.s $f18, $f19          # Compara f18 < 0
    bc1t valor_invalido        # Se for negativo, volta para a função de invalidação
    
    mov.s $f17, $f18           # Copia raio para exibição
    jal calcular_parametros    # Chama a função de cálculo
    jal imprimir_resultados    # Chama a função de impressão

    li $v0, 10                 # Encerra o programa
    syscall