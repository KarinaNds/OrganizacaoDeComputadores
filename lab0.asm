# Programa para ilustrar E/S e algumas operações

.data 
# .data eh o segmento onde declaramos as "Variaveis"

N1: .asciiz "Digite o 1o numero: "
N2: .asciiz "Digite o 2o numero: "
MsgSoma: .asciiz "\nSoma = "
MsgSub: .asciiz "znSubtracao = "
MsgMul: .asciiz "\nMultiplicacao = "

.text
# .text eh o segmento que contem as instrucoes/programa
# em assembly, a syscall eh utilizada para varias acoes: ler dados do teclado, imprimir algo na tela, finalizar o programa, etc

#imprimir a mensagem N1 na tela 
li $v0,4 # atribuindo o valor 4 para o reg $v0 (cod 4: indica print de string p/ syscall)
la $a0,N1 # carregando o end. da var N1 para dentro do registrador a0
syscall # syscall chama o so para executar a cao relativa oa codigo que esta no $v0

# lwe um inteiro digitado pelo usuario
li $v0, 5 # atribuindo o valor 5 para o reg $v0 (cod 5: indica input de int p/syscall)
syscall

#fazer uma copia do dado lido 
move $t0, $v0 # copiando o conteudo de $v0 para $t0

# imprimir a mensagem N2 na tela
li $v0,4 # atribuindo o conteudo do $v0 para 4 (print)
la $a0,N2
syscall

# ler um inteiro digitado pelo usuario
li $v0,5 # atribuindo o valor 5 para o reg $v0 (cod 5: indica input de int p/ syscall)
syscall

# fazer copia do dado lido
move $t1, $v0 # copiando o conteudo de $v0 para $t1

# soma $t0 com $t1 e armazena o resultado em $t2
add $t2, $t0, $t1
# add eh a operacao de adicao
# $t2 eh o registrador de destino
# $t0 e o $t1 sao os registradores das variaveis N1 e N2

# imprimir a mensagem de soma = na tela 
li $v0, 4
la $a0, MsgSoma
syscall

# imprimir o resultado na tela
li $v0,1
move $a0, $t2
syscall

# subtracao $t0 com $t1 e armazena o resultado em $t2
sub $t2, $t0, $t1
# sub eh a operacao de subtracao
# $t2 eh o registrador de destino 
# $t0 e $t1 sao os registradores das variaveis N1 e N2

# imprimir a mensagem de resposta na tela 
li $v0,4
la $a0,MsgSub
syscall

# imprimr o resultado na tela 
li $v0,1
move $a0, $t2
syscall

# multiplicacao $t0 com $t1 e armazena o resultado em $t2
mul $t2, $t0, $t1
# mul eh a operacao de multiplicacao
# $t2 eh o registrador de destino
# $t0 e $t1 sao os registradores das variaves N1 e N2

# imprimir a mensagem de resposta na tela 
li $v0,4
la $a0,MsgMul
syscall

# imprimir o resultado na tela
li $v0,1
move $a0, $t2
syscall

li $v0,10 # 10 eh o cod que a syscall usa para encerrar o programa
syscall # syscall chama o so para executar a acao relativa ao codigo que esta no $v0 
