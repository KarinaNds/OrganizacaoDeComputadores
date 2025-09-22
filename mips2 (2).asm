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
    vazio: .asciiz "Nao há itens cadastrados para imprimir. \n"
    pSemCad: .asciiz "Nao há itens cadastrados para buscar. \n"
    pSemCad2: .asciiz "Nao há itens cadastrados para alterar o estoque. \n"
    pSemCad3: .asciiz "Não há itens cadastrados para deletar \n"
    insFeito: .asciiz "Item cadastrado com sucesso \n"
    delFeito: .asciiz "Item deletado com sucesso \n"
    pCodigo: .asciiz "\nCodigo: "
    pEstoque: .asciiz "\nQuantidade em estoque: "
    pEstoqueAtualizado: .asciiz "Quantidade atualizada: "
    naoEnc: .asciiz "Item não cadastrado\n"
    ap1Enc: .asciiz "Programa encerrado, obrigado! \n"
    lstProd: .asciiz "Lista de produtos: \n"
    pulaLinha: .asciiz "\n"

.text

main:
    li $s0, 0 # Inicializa o head como NULL

    loopMenu:
        jal printMenu  # Chama a função que imprime o menu na tela
        move $t0, $v0 # Move a opção escolhida para $t0 para facilitar a comparação

        beq $t0, 1, InsertC # Se o usuário digitou 1, vai para InsertC (inserir item)
        beq $t0, 2, DeleteC # Se digitou 2, vai para DeleteC (deletar item)
        beq $t0, 3, SearchC # Se digitou 3, vai para SearchC (buscar item)
        beq $t0, 4, UpdateC # Se digitou 4, vai para UpdateC (atualizar item)
        beq $t0, 5, PrintC # Se digitou 5, vai para PrintC (listar itens)
        beq $t0, 6, fimLoopMenu # Se digitou 6, sai do loop (encerra o programa)
        blez $t0, InvalidC # Se a opção for menor ou igual a 0, é inválida e vai para mensagem de erro
        bge $t0, 7, InvalidC # Se for maior ou igual a 7, também inválida

    InsertC:
        jal Insert # Chama a função de inserção de item
        j loopMenu
    DeleteC:
        jal Delete  # Chama a função de remoção de item
        j loopMenu
    SearchC:
        jal Search # Chama a função de busca de item
        j loopMenu
    UpdateC:
        jal Update # Chama a função de atualização de item
        j loopMenu
    PrintC:
        jal Print # Chama a função de impressão/listagem dos itens
        j loopMenu
    InvalidC:
        li $v0, 4
        la $a0, OptInvalid # Mensagem: "Opcao invalida, por favor insira um numero de 1 a 6."
        syscall
        j loopMenu

    fimLoopMenu:
        li $v0, 10  # Código do syscall para encerrar o programa
        syscall

printMenu:
    li $v0, 4
    la $a0, IniMenu0 # Carrega o endereço da string "IniMenu0" que serve para criar uma linha de separação
    syscall

    li $v0, 4 # Prepara novamente para exibir outra string
    la $a0, IniMenu # Carrega o endereço da string "IniMenu", que contém o título do menu
    syscall # Chama a syscall para imprimir o título do menu

    li $v0, 4
    la $a0, Opt1 # Carrega o endereço da string "Opt1" que contém a primeira opção do menu
    syscall # Exibe a primeira opção: "1. Inserir um novo item do estoque"
 
    li $v0, 4
    la $a0, Opt2 # Carrega o endereço da string "Opt2" que contém a segunda opção do menu
    syscall # Exibe a segunda opção: "2. Excluir um item do estoque"

    li $v0, 4
    la $a0, Opt3 # Carrega o endereço da string "Opt3" que contém a terceira opção do menu
    syscall # Exibe a terceira opção: "3. Buscar um item pelo código"

    li $v0, 4
    la $a0, Opt4 # Carrega o endereço da string "Opt4" que contém a quarta opção do menu
    syscall # Exibe a quarta opção: "4. Atualizar a quantidade em estoque"

    li $v0, 4
    la $a0, Opt5 # Carrega o endereço da string "Opt5" que contém a quinta opção do menu
    syscall # Exibe a quinta opção: "5. Imprimir os produtos no estoque"

    li $v0, 4
    la $a0, Opt6 # Carrega o endereço da string "Opt6" que contém a sexta opção do menu
    syscall # Exibe a sexta opção: "6. Sair"

    li $v0, 4
    la $a0, Optxt # Carrega o endereço da string "Optxt", que contém a solicitação "Opcao: "
    syscall # Exibe o texto "Opcao: "

    li $v0, 5 # le o numero digitado pelo usuarrio (entrada)
    syscall

    jr $ra

Insert:
    li $v0, 9
    li $a0, 12 # Aloca 12 bytes: código, quantidade e ponteiro
    syscall
    move $t2, $v0 # $t2 armazena o endereço do novo nó

    # Solicita código
    li $v0, 4
    la $a0, insiraCod
    syscall
    li $v0, 5
    syscall
    sw $v0, 0($t2) # Armazena código no nó

    # Solicita quantidade
    li $v0, 4
    la $a0, insiraQnt
    syscall
    li $v0, 5
    syscall
    sw $v0, 4($t2) # Armazena quantidade no nó

    sw $zero, 8($t2) # Inicializa o ponteiro 'next' como NULL

    # Insere o nó na lista
    beq $s0, $zero, inserirPrimeiroNo # Se a lista estiver vazia
    jal inserirNoFinal # Insere no final da lista
    j fimInsert

inserirPrimeiroNo:
    move $s0, $t2 # O novo nó se torna o head
    j fimInsert

inserirNoFinal:
    move $t1, $s0 # $t1 percorre a lista
    loopInserirFinal:
        lw $t3, 8($t1) # $t3 = next
        beqz $t3, fimLoopInserirFinal
        move $t1, $t3
        j loopInserirFinal
    fimLoopInserirFinal:
        sw $t2, 8($t1) # O último nó aponta para o novo nó
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
    move $t0, $v0 # Código a ser deletado

    move $t1, $s0 # $t1 percorre a lista
    move $t4, $zero # $t4 guarda o nó anterior

    loopDelete:
        lw $t2, 0($t1) # Código do nó atual
        beq $t0, $t2, encontradoDelete

        lw $t3, 8($t1) # Próximo nó
        beqz $t3, naoEncontrado3 # Fim da lista

        move $t4, $t1 # Atualiza nó anterior
        move $t1, $t3 # Próximo nó
        j loopDelete

encontradoDelete:
    beq $t1, $s0, removerHeadDelete # Nó a ser deletado é o head

    # Nó a ser deletado está no meio ou no final
    lw $t3, 8($t1) # Próximo nó
    sw $t3, 8($t4) # Nó anterior aponta para o próximo
    j fimDeleteS

removerHeadDelete:
    lw $t3, 8($s0) # Próximo nó
    move $s0, $t3 # Atualiza o head
    j fimDeleteS

# Imprime a mensagem "Não encontrado"
naoEncontrado3:
    li $v0, 4
    la $a0, naoEnc
    syscall
    # Vai para o final da função
    j fimDelete
    
# Imprime "Lista vazia" (não há produtos cadastrados)
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
    
# Retorna da função
fimDelete:
    jr $ra

Search:
    beqz $s0, semCad # Lista vazia

    li $v0, 4
    la $a0, insiraCod
    syscall
    li $v0, 5
    syscall
    move $t0, $v0 # Código a ser buscado em $t0

    move $t1, $s0 # Inicializa o ponteiro para percorrer a lista (começa do head)

    loopBusca:
        lw $t2, 0($t1) # Código do nó atual
        beq $t0, $t2, encontradoBusca # Se o código for igual ao buscado, pula para exibição

        lw $t3, 8($t1) # Carrega o ponteiro para o próximo nó
        beqz $t3, naoEncontrado # Se for NULL, fim da lista e item não encontrado

        move $t1, $t3 # Avança para o próximo nó
        j loopBusca 

encontradoBusca:
    li $v0, 4
    la $a0, pCodigo # Exibe o texto "Código:"
    syscall
    li $v0, 1
    lw $a0, 0($t1) # Carrega o código do produto no nó encontrado
    syscall

    li $v0, 4
    la $a0, pEstoque # Exibe o texto "Quantidade em estoque:"
    syscall
    li $v0, 1
    lw $a0, 4($t1) # Carrega a quantidade do nó encontrado
    syscall

    li $v0, 4
    la $a0, pulaLinha # Pula linha
    syscall
    j fimBusca # Retorna

naoEncontrado:
    li $v0, 4
    la $a0, naoEnc # Exibe "Item não cadastrado"
    syscall
    j fimBusca

semCad:
    li $v0, 4
    la $a0, pSemCad  # Exibe "Não há itens cadastrados para buscar"
    syscall

fimBusca:
    jr $ra # Retorna

Update:
    beqz $s0, semCad2 # Lista vazia

    li $v0, 4
    la $a0, insiraCod # Solicita ao usuário que insira o código do produto.
    syscall
    li $v0, 5
    syscall
    move $t0, $v0 # # Armazena o código digitado em $t0 (código que será buscado).
    
    move $t1, $s0 # Inicializa $t1 com o ponteiro para o início da lista (head).

    loopAtualiza:
        lw $t2, 0($t1) # Carrega o código do nó atual em $t2.
        beq $t0, $t2, encontradoAtualiza  # Se o código do nó atual for igual ao buscado, pula para a atualização.

        lw $t3, 8($t1) # Carrega o código do nó atual em $t3.
        beqz $t3, naoEncontradoAtualiza # Se o próximo for NULL, chegou ao fim da lista sem encontrar o item.

        move $t1, $t3 # Avança para o próximo nó.
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
    la $a0, naoEnc  # Exibe mensagem "Item não cadastrado"
    syscall
    j fimAtualiza

semCad2:
    li $v0, 4
    la $a0, pSemCad2 # Exibe "Nao há itens cadastrados para alterar o estoque."
    syscall

fimAtualiza:
    jr $ra # Retorna para o menu principal

Print:
    beqz $s0, vazioPrint  # Verifica se a lista está vazia (head == NULL)

    move $t1, $s0 # Inicializa $t1 com o início da lista (head).

    loopPrint:
        li $v0, 4
        la $a0, IniMenu0 # Imprime uma linha de separação entre os itens
        syscall

        li $v0, 4
        la $a0, pCodigo # Imprime o texto "Codigo: "
        syscall
        li $v0, 1
        lw $a0, 0($t1) # Carrega e imprime o código do produto
        syscall

        li $v0, 4
        la $a0, pEstoque # Imprime o texto "Quantidade em estoque: "
        syscall
        li $v0, 1
        lw $a0, 4($t1) # Carrega e imprime a quantidade em estoque 
        syscall

        li $v0, 4
        la $a0, pulaLinha # Imprime uma linha em branco para espaçamento
        syscall

        lw $t1, 8($t1) # Atualiza $t1 com o ponteiro para o próximo nó 
        beqz $t1, fimPrint #Se o próximo nó for NULL, fim da lista - fim da função
        j loopPrint

vazioPrint:
    li $v0, 4
    la $a0, vazio # Exibe: "Nao há itens cadastrados para imprimir."
    syscall

fimPrint:
    jr $ra # Retorna para o menu principal








]












