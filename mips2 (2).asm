.data
    IniMenu0: .asciiz ".........................................\n"
    IniMenu: .asciiz "-------SISTEMA DE CONTROLE DE ESTOQUE COM LISTAS---------\n"
    Opt1: .asciiz "1. Inserir um novo item do estoque\n"
    Opt2: .asciiz "2. Excluir um item do estoque\n"
    Opt3: .asciiz "3. Buscar um item pelo codigo\n"
    Opt4: .asciiz "4. Atualizar a quantidade em estoque\n"
    Opt5: .asciiz "5. Imprimir os produtos no estoque\n"
    Opt6: .asciiz "6.Sair\n"
    Optxt: .asciiz "Opcao: "
    OptInvalid: .asciiz "Opcao invalida, por favor insira um numero de 1 a 6. \n"
    insiraCod: .asciiz "Insira o codigo do produto: \n"
    insiraQnt: .asciiz "Insira a quantidade de produtos: \n"
    vazio: .asciiz "Nao h� itens cadastrados para imprimir. \n"
    pSemCad: .asciiz "Nao h� itens cadastrados para buscar. \n"
    pSemCad2: .asciiz "Nao h� itens cadastrados para alterar o estoque. \n"
    pSemCad3: .asciiz "N�o h� itens cadastrados para deletar \n"
    insFeito: .asciiz "Item cadastrado com sucesso \n"
    delFeito: .asciiz "Item deletado com sucesso \n"
    pCodigo: .asciiz "\nCodigo: "
    pEstoque: .asciiz "\nQuantidade em estoque: "
    pEstoqueAtualizado: .asciiz "Quantidade atualizada: "
    naoEnc: .asciiz "Item n�o cadastrado\n"
    ap1Enc: .asciiz "Programa encerrado, obrigado! \n"
    lstProd: .asciiz "Lista de produtos: \n"
    pulaLinha: .asciiz "\n"

.text

main:
    li $s0, 0 # Inicializa o head como NULL

    loopMenu:
        jal printMenu  # Chama a fun��o que imprime o menu na tela
        move $t0, $v0 # Move a op��o escolhida para $t0 para facilitar a compara��o

        beq $t0, 1, InsertC # Se o usu�rio digitou 1, vai para InsertC (inserir item)
        beq $t0, 2, DeleteC # Se digitou 2, vai para DeleteC (deletar item)
        beq $t0, 3, SearchC # Se digitou 3, vai para SearchC (buscar item)
        beq $t0, 4, UpdateC # Se digitou 4, vai para UpdateC (atualizar item)
        beq $t0, 5, PrintC # Se digitou 5, vai para PrintC (listar itens)
        beq $t0, 6, fimLoopMenu # Se digitou 6, sai do loop (encerra o programa)
        blez $t0, InvalidC # Se a op��o for menor ou igual a 0, � inv�lida e vai para mensagem de erro
        bge $t0, 7, InvalidC # Se for maior ou igual a 7, tamb�m inv�lida

    InsertC:
        jal Insert # Chama a fun��o de inser��o de item
        j loopMenu
    DeleteC:
        jal Delete  # Chama a fun��o de remo��o de item
        j loopMenu
    SearchC:
        jal Search # Chama a fun��o de busca de item
        j loopMenu
    UpdateC:
        jal Update # Chama a fun��o de atualiza��o de item
        j loopMenu
    PrintC:
        jal Print # Chama a fun��o de impress�o/listagem dos itens
        j loopMenu
    InvalidC:
        li $v0, 4
        la $a0, OptInvalid # Mensagem: "Opcao invalida, por favor insira um numero de 1 a 6."
        syscall
        j loopMenu

    fimLoopMenu:
        li $v0, 10  # C�digo do syscall para encerrar o programa
        syscall

printMenu:
    li $v0, 4
    la $a0, IniMenu0 # Carrega o endere�o da string "IniMenu0" que serve para criar uma linha de separa��o
    syscall

    li $v0, 4 # Prepara novamente para exibir outra string
    la $a0, IniMenu # Carrega o endere�o da string "IniMenu", que cont�m o t�tulo do menu
    syscall # Chama a syscall para imprimir o t�tulo do menu

    li $v0, 4
    la $a0, Opt1 # Carrega o endere�o da string "Opt1" que cont�m a primeira op��o do menu
    syscall # Exibe a primeira op��o: "1. Inserir um novo item do estoque"
 
    li $v0, 4
    la $a0, Opt2 # Carrega o endere�o da string "Opt2" que cont�m a segunda op��o do menu
    syscall # Exibe a segunda op��o: "2. Excluir um item do estoque"

    li $v0, 4
    la $a0, Opt3 # Carrega o endere�o da string "Opt3" que cont�m a terceira op��o do menu
    syscall # Exibe a terceira op��o: "3. Buscar um item pelo c�digo"

    li $v0, 4
    la $a0, Opt4 # Carrega o endere�o da string "Opt4" que cont�m a quarta op��o do menu
    syscall # Exibe a quarta op��o: "4. Atualizar a quantidade em estoque"

    li $v0, 4
    la $a0, Opt5 # Carrega o endere�o da string "Opt5" que cont�m a quinta op��o do menu
    syscall # Exibe a quinta op��o: "5. Imprimir os produtos no estoque"

    li $v0, 4
    la $a0, Opt6 # Carrega o endere�o da string "Opt6" que cont�m a sexta op��o do menu
    syscall # Exibe a sexta op��o: "6. Sair"

    li $v0, 4
    la $a0, Optxt # Carrega o endere�o da string "Optxt", que cont�m a solicita��o "Opcao: "
    syscall # Exibe o texto "Opcao: "

    li $v0, 5 # le o numero digitado pelo usuarrio (entrada)
    syscall

    jr $ra

Insert:
    li $v0, 9
    li $a0, 12 # Aloca 12 bytes: c�digo, quantidade e ponteiro
    syscall
    move $t2, $v0 # $t2 armazena o endere�o do novo n�

    # Solicita c�digo
    li $v0, 4
    la $a0, insiraCod
    syscall
    li $v0, 5
    syscall
    sw $v0, 0($t2) # Armazena c�digo no n�

    # Solicita quantidade
    li $v0, 4
    la $a0, insiraQnt
    syscall
    li $v0, 5
    syscall
    sw $v0, 4($t2) # Armazena quantidade no n�

    sw $zero, 8($t2) # Inicializa o ponteiro 'next' como NULL

    # Insere o n� na lista
    beq $s0, $zero, inserirPrimeiroNo # Se a lista estiver vazia
    jal inserirNoFinal # Insere no final da lista
    j fimInsert

inserirPrimeiroNo:
    move $s0, $t2 # O novo n� se torna o head
    j fimInsert

inserirNoFinal:
    move $t1, $s0 # $t1 percorre a lista
    loopInserirFinal:
        lw $t3, 8($t1) # $t3 = next
        beqz $t3, fimLoopInserirFinal
        move $t1, $t3
        j loopInserirFinal
    fimLoopInserirFinal:
        sw $t2, 8($t1) # O �ltimo n� aponta para o novo n�
    jr $ra

fimInsert:
    li $v0, 4
    la $a0, insFeito
    syscall
    jr $ra

Delete:
    beqz $s0, semCad3 # Lista vazia

    li $v0, 4
    la $a0, insiraCod
    syscall
    li $v0, 5
    syscall
    move $t0, $v0 # C�digo a ser deletado

    move $t1, $s0 # $t1 percorre a lista
    move $t4, $zero # $t4 guarda o n� anterior

    loopDelete:
        lw $t2, 0($t1) # C�digo do n� atual
        beq $t0, $t2, encontradoDelete

        lw $t3, 8($t1) # Pr�ximo n�
        beqz $t3, naoEncontrado3 # Fim da lista

        move $t4, $t1 # Atualiza n� anterior
        move $t1, $t3 # Pr�ximo n�
        j loopDelete

encontradoDelete:
    beq $t1, $s0, removerHeadDelete # N� a ser deletado � o head

    # N� a ser deletado est� no meio ou no final
    lw $t3, 8($t1) # Pr�ximo n�
    sw $t3, 8($t4) # N� anterior aponta para o pr�ximo
    j fimDeleteS

removerHeadDelete:
    lw $t3, 8($s0) # Pr�ximo n�
    move $s0, $t3 # Atualiza o head
    j fimDeleteS

# Imprime a mensagem "N�o encontrado"
naoEncontrado3:
    li $v0, 4
    la $a0, naoEnc
    syscall
    # Vai para o final da fun��o
    j fimDelete
    
# Imprime "Lista vazia" (n�o h� produtos cadastrados)
semCad3:
    li $v0, 4
    la $a0, pSemCad3
    syscall
    j fimDelete
    
# Mensagem de sucesso: "Produto deletado com sucesso"
fimDeleteS:
    li $v0, 4
    la $a0, delFeito
    syscall
    
# Retorna da fun��o
fimDelete:
    jr $ra

Search:
    beqz $s0, semCad # Lista vazia

    li $v0, 4
    la $a0, insiraCod
    syscall
    li $v0, 5
    syscall
    move $t0, $v0 # C�digo a ser buscado em $t0

    move $t1, $s0 # Inicializa o ponteiro para percorrer a lista (come�a do head)

    loopBusca:
        lw $t2, 0($t1) # C�digo do n� atual
        beq $t0, $t2, encontradoBusca # Se o c�digo for igual ao buscado, pula para exibi��o

        lw $t3, 8($t1) # Carrega o ponteiro para o pr�ximo n�
        beqz $t3, naoEncontrado # Se for NULL, fim da lista e item n�o encontrado

        move $t1, $t3 # Avan�a para o pr�ximo n�
        j loopBusca 

encontradoBusca:
    li $v0, 4
    la $a0, pCodigo # Exibe o texto "C�digo:"
    syscall
    li $v0, 1
    lw $a0, 0($t1) # Carrega o c�digo do produto no n� encontrado
    syscall

    li $v0, 4
    la $a0, pEstoque # Exibe o texto "Quantidade em estoque:"
    syscall
    li $v0, 1
    lw $a0, 4($t1) # Carrega a quantidade do n� encontrado
    syscall

    li $v0, 4
    la $a0, pulaLinha # Pula linha
    syscall
    j fimBusca # Retorna

naoEncontrado:
    li $v0, 4
    la $a0, naoEnc # Exibe "Item n�o cadastrado"
    syscall
    j fimBusca

semCad:
    li $v0, 4
    la $a0, pSemCad  # Exibe "N�o h� itens cadastrados para buscar"
    syscall

fimBusca:
    jr $ra # Retorna

Update:
    beqz $s0, semCad2 # Lista vazia

    li $v0, 4
    la $a0, insiraCod # Solicita ao usu�rio que insira o c�digo do produto.
    syscall
    li $v0, 5
    syscall
    move $t0, $v0 # # Armazena o c�digo digitado em $t0 (c�digo que ser� buscado).
    
    move $t1, $s0 # Inicializa $t1 com o ponteiro para o in�cio da lista (head).

    loopAtualiza:
        lw $t2, 0($t1) # Carrega o c�digo do n� atual em $t2.
        beq $t0, $t2, encontradoAtualiza  # Se o c�digo do n� atual for igual ao buscado, pula para a atualiza��o.

        lw $t3, 8($t1) # Carrega o c�digo do n� atual em $t3.
        beqz $t3, naoEncontradoAtualiza # Se o pr�ximo for NULL, chegou ao fim da lista sem encontrar o item.

        move $t1, $t3 # Avan�a para o pr�ximo n�.
        j loopAtualiza

encontradoAtualiza:
    li $v0, 4
    la $a0, insiraQnt # Solicita nova quantidade para o produto.
    syscall
    li $v0, 5
    syscall
    sw $v0, 4($t1) # Atualiza a quantidade

    li $v0, 4
    la $a0, pEstoqueAtualizado # Exibe mensagem "Quantidade atualizada:"
    syscall 
    li $v0, 1
    move $a0, $v0  # Prepara valor digitado para exibir
    syscall
    j fimAtualiza

naoEncontradoAtualiza:
    li $v0, 4
    la $a0, naoEnc  # Exibe mensagem "Item n�o cadastrado"
    syscall
    j fimAtualiza

semCad2:
    li $v0, 4
    la $a0, pSemCad2 # Exibe "Nao h� itens cadastrados para alterar o estoque."
    syscall

fimAtualiza:
    jr $ra # Retorna para o menu principal

Print:
    beqz $s0, vazioPrint  # Verifica se a lista est� vazia (head == NULL)

    move $t1, $s0 # Inicializa $t1 com o in�cio da lista (head).

    loopPrint:
        li $v0, 4
        la $a0, IniMenu0 # Imprime uma linha de separa��o entre os itens
        syscall

        li $v0, 4
        la $a0, pCodigo # Imprime o texto "Codigo: "
        syscall
        li $v0, 1
        lw $a0, 0($t1) # Carrega e imprime o c�digo do produto
        syscall

        li $v0, 4
        la $a0, pEstoque # Imprime o texto "Quantidade em estoque: "
        syscall
        li $v0, 1
        lw $a0, 4($t1) # Carrega e imprime a quantidade em estoque 
        syscall

        li $v0, 4
        la $a0, pulaLinha # Imprime uma linha em branco para espa�amento
        syscall

        lw $t1, 8($t1) # Atualiza $t1 com o ponteiro para o pr�ximo n� 
        beqz $t1, fimPrint #Se o pr�ximo n� for NULL, fim da lista - fim da fun��o
        j loopPrint

vazioPrint:
    li $v0, 4
    la $a0, vazio # Exibe: "Nao h� itens cadastrados para imprimir."
    syscall

fimPrint:
    jr $ra # Retorna para o menu principal








]












