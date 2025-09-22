.data
msg_n:         .asciiz "Digite o numero de leituras (1 a 8): "
erro:          .asciiz "ERRO: N_INVALIDO\n"
msg_leitura:   .asciiz "Digite a leitura de intensidade: "
msg_tot:       .asciiz "TOT_RAD: "
msg_avg:       .asciiz "AVG_RAD: "
msg_max:       .asciiz "MAX_RAD: "
msg_min:       .asciiz "MIN_RAD: "
msg_dyn:       .asciiz "DYN_RNG: "
newline:       .asciiz "\n"

zero_float:    .float 0.0     # constante para inicialização

buffer:        .space 32      # espaço para 8 floats (4 bytes cada)

.text
.globl main
main:

# Solicita N 
li $v0, 4
la $a0, msg_n
syscall

li $v0, 5          # leitura de N
syscall
move $t0, $v0      # $t0 = N

# Verifica se N está entre 1 e 8 
blt $t0, 1, erro_n
bgt $t0, 8, erro_n

# Inicializa variáveis
la $t1, buffer     # $t1 = endereço base do buffer
move $t2, $zero    # contador = 0

# Leitura das N intensidades
leitura_loop:
    bge $t2, $t0, processamento

    # Solicita leitura
    li $v0, 4
    la $a0, msg_leitura
    syscall

    # Lê float
    li $v0, 6
    syscall
    s.s $f0, 0($t1)    # armazena no buffer

    addi $t1, $t1, 4   # próximo espaço no buffer
    addi $t2, $t2, 1   # contador++

    j leitura_loop

# ERRO: N_INVALIDO 
erro_n:
    li $v0, 4
    la $a0, erro
    syscall
    li $v0, 10
    syscall

# Processamento
processamento:
    la $t1, buffer     # reinicia ponteiro do buffer
    move $t2, $zero    # índice = 0

    # Inicializa soma em $f20
    la $t3, zero_float
    l.s $f20, 0($t3)   # $f20 = 0.0

    # Carrega primeira leitura para inicializar max/min
    l.s $f22, 0($t1)   # $f22 = pico
    l.s $f24, 0($t1)   # $f24 = min

process_loop:
    bge $t2, $t0, fim_processamento

    l.s $f2, 0($t1)    # $f2 = leitura atual

    # soma += leitura
    add.s $f20, $f20, $f2

    # verifica max
    c.le.s $f22, $f2
    bc1t atualiza_max

    # verifica min
    c.lt.s $f2, $f24
    bc1t atualiza_min

proximo:
    addi $t1, $t1, 4
    addi $t2, $t2, 1
    j process_loop

atualiza_max:
    mov.s $f22, $f2
    j proximo

atualiza_min:
    mov.s $f24, $f2
    j proximo

fim_processamento:

# Converte N para float 
mtc1 $t0, $f26
cvt.s.w $f26, $f26   # $f26 = N(float)

# Calcula média: soma / N 
div.s $f28, $f20, $f26   # $f28 = média

# Calcula variação dinâmica: pico - min 
sub.s $f30, $f22, $f24   # $f30 = variação

# Relatório
# TOT_RAD
li $v0, 4
la $a0, msg_tot
syscall

mov.s $f12, $f20
li $v0, 2
syscall

li $v0, 4
la $a0, newline
syscall

# AVG_RAD
li $v0, 4
la $a0, msg_avg
syscall

mov.s $f12, $f28
li $v0, 2
syscall

li $v0, 4
la $a0, newline
syscall

# MAX_RAD
li $v0, 4
la $a0, msg_max
syscall

mov.s $f12, $f22
li $v0, 2
syscall

li $v0, 4
la $a0, newline
syscall

# MIN_RAD
li $v0, 4
la $a0, msg_min
syscall

mov.s $f12, $f24
li $v0, 2
syscall

li $v0, 4
la $a0, newline
syscall

# DYN_RNG
li $v0, 4
la $a0, msg_dyn
syscall

mov.s $f12, $f30
li $v0, 2
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 10
syscall
