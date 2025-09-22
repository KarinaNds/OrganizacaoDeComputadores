# Autenticacao por Senha em MIPS
.data                            # Início da seção de dados (strings, constantes)
ConfSenha:      .asciiz "Digite a senha numerica: "   
                                   # Mensagem pedida ao usuario (sem newline final
                                   # para que o usuário digite na mesma linha)
SenhaCorreta:   .asciiz "\nAcesso permitido! Senha correta.\n"
                                   # Mensagem exibida quando a senha estiver correta
SenhaIncorreta: .asciiz "\nAcesso negado! Tente novamente.\n"
                                   # Mensagem exibida quando a senha estiver incorreta

.text                            # Início da seção de código
.globl main                      # Define o ponto de entrada "main" para o linker

main:                            # Label principal do programa
    # Define a senha correta no registrador $s1
    li   $s1, 1234               # Carrega o valor 1234 no registrador $s1
                                 # (senha correta explicitamente armazenada em um registrador)
    # Exibe a mensagem pedindo a senha ao usuário
    li   $v0, 4                  # Syscall 4 = print_string
    la   $a0, ConfSenha          # Carrega em $a0 o endereço da string "ConfSenha"
    syscall                      # Executa syscall: imprime "Digite a senha numerica: "

    # Lê a senha digitada pelo usuário (inteiro)

    li   $v0, 5                  # Syscall 5 = read_int
    syscall                      # Executa syscall: lê um inteiro do teclado
    move $t0, $v0                # Move o inteiro lido ($v0) para $t0
                                 # ($t0 agora contém a senha digitada pelo usuário)

    # Comparação bit a bit usando XOR
    # Observação: XOR retorna 0 se e somente se todos os bits forem iguais
    xor  $t1, $t0, $s1           # $t1 = $t0 XOR $s1
                                 # Se $t0 == $s1 então $t1 = 0; caso contrário $t1 != 0
    beq  $t1, $zero, igual       # Se $t1 == 0 (igualdade) salta para o rótulo "igual"
    j    errado                  # Caso contrário, salta para o rótulo "errado"

# Rotina para senha incorreta
errado:
    li   $v0, 4                  # Syscall 4 = print_string
    la   $a0, SenhaIncorreta     # Carrega endereço da string de senha incorreta
    syscall                      # Imprime "Acesso negado! Tente novamente."
    j    main                    # Volta para o início (permite nova tentativa)

# Rotina para senha correta
igual:
    li   $v0, 4                  # Syscall 4 = print_string
    la   $a0, SenhaCorreta       # Carrega endereço da string de senha correta
    syscall                      # Imprime "Acesso permitido! Senha correta."

    # Encerra o programa
    li   $v0, 10                 # Syscall 10 = exit
    syscall                      # Encerra a execução do programa
