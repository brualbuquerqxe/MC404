# Seção para dados não inicializados.
	.section .bss

bufferEntrada:
	.skip    7                      # Pode ter sinal ou não

bufferSaida:
	.skip    5                      # O máximo de nós é 1000

bufferLinha:
	.skip    2                      # Adiciona comando que pula linha

# Seção que está com o código e as funções.
	.section .text

	.globl   _start

	.globl   puts

	.globl   gets

	.globl   atoi

# Inicia o programa a partir do rótulo "_start".
_start:
	call     main
	li       a0, 0                  # Código de saída
	li       a7, 93                 # Serviço de saída
	ecall

# Função que escreve a saída e adicona um caracter a mais de "\n"
puts:
	li       a2, 5                  # Número do bytes lidos
	li       a0, 1                  # Saída (STDOUT)
	la       a1, bufferSaida        # Carrega o endereço do buffer
	li       a7, 64                 # Código do serviço de escrita
	ecall

	la       a1, BufferLinha        # Carrega o endereço do buffer
	li       t0, '\n'               # Armazena o caracter que pula linha
	sb       t0, 0(a1)              # Move para o buffer

	li       a2, 1                  # Número do bytes lidos
	li       a0, 1                  # Saída (STDOUT)
	li       a7, 64                 # Código do serviço de escrita
	ecall

	ret

# Armazena a entrada até a aparição de um caracter de nova linha
gets:
	li       a0, 0                  # Entrada STDIN
	la       a1, bufferEntrada      # Local que armazena a entrada
	li       a2, 7                  # Número de bytes que serão lidos
	li       a7, 63                 # Chamada de leitura
	ecall                           # Chama sistema

	li       t0, 10                 # '\n'
	li       t1, 0                  # '\0'
	li       t2, 0                  # Contador
	mv       t3, a1                 # Move o endereço
	li       t4, 6

# Enquanto o caracter não for '\n'
.for:
	lbu      t5, 0(t3)              # Carrega caracter
	beq      t5, t0, encontraQuebra # Encontrou '\n'
	beq      t5, t1, fim            # Chegou em '\0'
	addi     t2, t2, 1              # Próximo caracter
	addi     t3, t3, 1
	beq      t2, t4, encontraQuebra # Chegou ao fim do buffer
	j        .for
.encontraQuebra:
	sb       t1, 0(t3)              # Muda de '\n' para '\0'
.fim:
	sub      t3, t3, t2             # Volta o ponteiro para o início
	mv       a0, t3                 # Move de volta o endereço
	ret

# Converte string para inteiro
atoi:

# a0 = endereço string

	li       t0, 48                 # Caracter com valor 0
	li       t1, 57                 # Caracter com valor 9
	li       t2, 45                 # Caracter '-'
	li       t3, 1                  # Valor positivo
	li       t4, 0                  # Verifica se leu um número
	li       t5, 0                  # Contador
	li       a1, 0                  # Lugar da soma

.for:
	lbu      t6, 0(a0)              # Caracter em análise
	beq      t2, t6, .numeroSinal   # Número com sinal
	bltu      t6, t0, .naoNumero
	bltu      t1, t6, .naoNumero
	j        .converteNumero        # Converte em inteiro
.continua:
	addi     t5, t5, 1              # Próximo caracter
	addi     a0, a0, 1              # Avança
	j        .for                   # Retorna no loop
.converteNumero:
	li       t4, 10
	addi     t6, t6, -'0'           # Converte em número inteiro
	mul      a1, a1, t4             # Multiplica por 10
	add      a1, a1, t6             # Adiciona na soma
	li       t4, 1                  # Mostra que já leu algum número
	j        .continua

.numeroSinal:
	bnez     t4, .fim               # Está no meio do número
	li       t3, -1                 # Número negativo
	j        .continua
.naoNumero:
	bne      t4, zero, .fim         # Já leu o número inteiro
	j        .continua              # Se não leu um número, volta pra ler
.fim:
	mul      a1, a1, t3             # Caso o número seja negativo
	sub      a0, a0, t5             # Volta para o início do buffer
	ret