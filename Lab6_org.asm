.data
	raioInput: .asciiz "Informe o valor do raio em km. (Distancia entre o satelite e o centro da terra): "
	velOutput: .asciiz "\nVelocidade: "
	raioOutput: .asciiz "\nRaio: "
	periodoOutput: .asciiz "\nPeriodo: "
	kmseg: .asciiz " km/seg"
	kmpuro: .asciiz " km"
	segpuro: .asciiz " seg"
	piQuadrado: .double 9.869603661609599 # pi quadrado
	massa: .double 5.972e24  # Massa da Terra em kg
	G: .double 6.67408E-11  # Constante gravitacional
	quatro: .double 4.0 # quatro!!
	mil: .double 1000.0  # Fator de conversão de km para metros
	distMax: .double 140000000000.0
	zd: .double 0.0
	sedna: .asciiz "140 bilhões é a distancia entre entre o Sol e o afelio de Sedna, o corpo celeste, do sistema solar, mais distante do sol.\nPor favor, insira uma distancia menor que 140 bilhoes de KM.\n"
	menorquezero: .asciiz "A distancia nao pode ser menor ou igual a 0.\nPor favor, insira outro valor.\n"
.text
ini:

	# Solicita o valor do raio em km
	li $v0, 4
	la $a0, raioInput
	syscall
	
	li $v0, 7          # Leitura do valor do raio
	syscall
	mov.d $f30, $f0    # Armazenando o raio em KM em $f30
	
	# Comparação: Se o raio é maior que 140 bilhões, salta para 'invalido'	
	ldc1 $f2, distMax
	c.le.d $f30, $f2         # Se $f0 <= $f2, então o branch será tomado
	bc1f invalido           # Se a comparação for falsa (raio maior que distMax), salta para 'invalido'
	
	# Comparação: Se o raio for menor ou igual a 0, salta para 'invalido0'
	ldc1 $f2, zd
	c.le.d $f30, $f2        # Compara $f0 com 0 (valor de ponto flutuante)
	bc1t invalido0          # Se $f0 <= 0, então salta para 'invalido0'
	
	ldc1 $f10, mil
	mul.d $f20, $f30, $f10 #armazena o raio em metros em $f28
	mul.d $f6, $f20, $f20
	mul.d $f28, $f6, $f20 #armazena o raio³ em metros em $f28
	# velocidade v² = GM/r
	# peridogo t² = (4 pi² / GM) * r³
	ldc1 $f2, massa        # Carrega massa da Terra
	ldc1 $f4, G            # Carrega constante gravitacional
	mul.d $f26, $f2, $f4   # Calcula GM e armazena em $f26
	
	# Divisão de GM por raio
	div.d $f2, $f26, $f20  # Divide GM por raio (em metros)
	
	sqrt.d $f4, $f2        # Calcula raiz quadrada de GM/r
	div.d $f24, $f4, $f10   # Converte para km/s
	
	ldc1 $f2, piQuadrado #carregando pi ao quadrado
	ldc1 $f4, quatro # carregando a constante 4
	mul.d $f6, $f2, $f4 #guarda 4 pi² em $f6
	div.d $f2, $f6, $f26 #guarda 4pi² / GM em $f2
	mul.d $f4, $f28, $f2 # guarda (4 pi² / GM) * r³ em $f4
	sqrt.d $f22, $f4 #guarda t em s em  $f22
	
	# imprime a velocidade em quilometros por segundo
	li $v0, 4
	la $a0, velOutput
	syscall
	li $v0, 3
	mov.d $f12, $f24
	syscall
	li $v0, 4
	la $a0, kmseg
	syscall
	
	#imprime o raio em quilometros
	li $v0, 4
	la $a0, raioOutput
	syscall
	li $v0, 3
	mov.d $f12, $f30
	syscall
	li $v0, 4
	la $a0, kmpuro
	syscall

	#imprime o periodo em segundos
	li $v0, 4
	la $a0, periodoOutput
	syscall
	li $v0, 3
	mov.d $f12, $f22
	syscall
	li $v0, 4
	la $a0, segpuro
	syscall
				
	li $v0, 10 #encerra o prog
	syscall
invalido0: #informa que o raio nao pode ser 0 ou negativo
	li $v0, 4
	la $a0, menorquezero
	syscall
	j ini	

invalido: #informa que o raio nao pode ser maior que a distancia entre o sol e o ponto mais distante (em Sedna)
	li $v0, 4
	la $a0, sedna
	syscall	
	j ini
