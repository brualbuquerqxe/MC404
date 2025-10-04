# Seção para dados não incializados.
	.section .bss

bufferEntrada:
	.skip    7                        # Pode ter sinal ou não

bufferSaida:
	.skip    5                        # O máximo de nós é 1000

# Seção que está com o código e as funções.
	.section .text

	.globl   _start

	.globl   leituraEntrada

	.globl   converteEntrada

	.globl   exploraLista

	.globl   converteSaida

	.extern  head_node

# Inicia o programa a partir do rótulo "_start".
_start:
	call     main
	li       a0, 0                    # Código de saída
	li       a7, 93                   # Serviço de saída
	ecall

# Leitura do número da entrada.
leituraEntrada:
	li       a0, 0                    # Entrada STDIN
	la       a1, bufferEntrada        # Local que armazena a entrada
	li       a2, 7                    # Número de bytes que serão lidos
	li       a7, 63                   # Chamada de leitura
	ecall                             # Chama sistema
	ret                               # Retorna

# Converte o número para inteiro.
converteEntrada:
# Define os caracteres que são diferentes de números
	li       s1, 32                   # ' '
	li       s2, 9                    # '\t'
	li       s3, 10                   # '\n'
	li       s4, 13                   # '\r'
	li       s5, 45                   # '-'
	li       s6, 1                    # Contador (máximo = 7 = a2)
	li       s8, 1                    # Se o número for negativo, multiplicar por -1
	li       s9, 0                    # Soma do número inteiro
	li       s10, 10                  # Casa decimal
	mv       s11, a1                  # Copia o local que está armazenado o número
# Loop com a leitura do número
for:
	lbu      s7, 0(s11)               # Primeiro caracter da entrada
# Já leu o máximo de caracteres
	beq      s6, a2, .fimNumero
# Se o caracter não for número, acabou o número
	beq      s7, s1, .fimNumero
	beq      s7, s2, .fimNumero
	beq      s7, s3, .fimNumero
	beq      s7, s4, .fimNumero
	beq      s7, s5, .fimNumero
# Se o caracter for "-", o número será negativo
	beq      s7, s6, .numeroNegativo

continua:
	mul      s9, s9, s10              # Muda a casa da soma
	addi     s7, s7, -'0'             # Converte em número inteiro
	add      s9, s9, s7               # Soma o valor
	addi     s6, s6, 1                # Aumenta o contador
	addi     s11, s11, 1              # Passa para a próxima posição
	call     for

.fimNumero:
	mul      s9, s9, s8               # Multiplica por -1 se o número for negativo
	ecall
	ret

.numeroNegativo:
	li       s8, -1                   # Multiplica por -1
	addi     s6, s6, 1                # Aumenta o contador
	addi     s11, s11, 1              # Passa para a próxima posição
	call     for

# Função que percorre a lista ligada até encontrar o nó correto
exploraLista:
	lw       t1, 0(s1)                # Posição do primeiro número inteiro
	lw       t2, 4(s1)                # Como word ocupa 4 posições, pula 4 e encontra o outro número≥

	add      t3, t2, t1               # Soma dos números

	beq      t3, a2, .somaEncontrada  # Se a soma foi encontrada, para de percorrer a lista

	addi     s1, s1, 8                # Move para o próximo nó
	lw       t4, 0(s2)
	beqz     t4, .fimLista            # Se o próximo nó for zero, chegou no fim da lista

	addi     a4, a4, 1                # Caso contrário, vai para o nó seguinte
	la       s1, t4                   # Vai para o endereço do próximo nó
	call     exploraLista

.somaEncontrada:
	ecall
	ret                               # Encerra a procura

.fimLista:
	li       a4, -1                   # A lista não possui nós que atender a soma
	ecall
	ret

# Função que converte de número para string
converteSaida:

	blt      a4, zero, .saidaNegativa # Se o nó não foi encontrado

	li       s1, 10
	blt      a4, s1, .numero1D        # Se o nó é de 1 dígito

	li       s1, 100
	blt      a4, s1, .numero2D        # Se o nó é de 2 dígitos

	li       s1, 1000
	blt      a4, s1, .numero3D        # Se o nó é de 3 dígitos

	li       s1, 1000
	beq      a4, s1, .numero4D        # Se o nó é o 1000

	li       a0, 5                    # Número de bytes
	mv       t0, a0                   # Copia o número de bytes lidos para t0
	li       a0, 1                    # Saída (STDOUT)
	la       a1, bufferSaida          # Carrega o endereço do buffer
	mv       a2, t0
	li       a7, 64                   # Código do serviço de escrita
	ecall
	ret

.saidaNegativa:
	li       s1, '-'
	li       s2, '1'
	li       s3, '\n'                 # Fim do número

	la       s4, bufferSaida          # Carrega o endereço da saída
	sb       s1, 0(s4)
	sb       s2, 1(s4)
	sb       s3, 2(s4)

	ecall
	ret

.numero1D:
	addi     s1, a4, '0'
	li       s2, '\n'                 # Fim do número

	la       s4, bufferSaida          # Carrega o endereço da saída
	sb       s1, 0(s4)
	sb       s2, 1(s4)

	ecall
	ret

.numero2D:
	li       s5, 10
	div      s1, a4, s5               # Casa decimal
	addi     s1, s1, '0'

	rem      s2, a4, s5               # Unidade
	addi     s2, s2, '0'

	li       s3, '\n'                 # Fim do número

	la       s4, bufferSaida          # Carrega o endereço da saída
	sb       s1, 0(s4)
	sb       s2, 1(s4)
	sb       s3, 1(s4)

.numero3D:
	li       s5, 100
	div      s1, a4, s5               # Casa das centenas
	addi     s1, s1, '0'

	rem      s2, a4, s5
	li       s5, 10

	div      s3, s2, s5               # Casa decimal
	addi     s3, s3, '0'

	rem      s2, s2, s5               # Unidade
	addi     s2, s2, '0'

	li       s5, '\n'                 # Fim do número

	la       s4, bufferSaida          # Carrega o endereço da saída
	sb       s1, 0(s4)
	sb       s3, 1(s4)
	sb       s2, 1(s4)
	sb       s5, 1(s4)

	ecall
	ret

.numero4D:
	li       s1, '1'
	li       s2, '0'
	li       s3, '\n'                 # Fim do número

	la       s4, bufferSaida          # Carrega o endereço da saída
	sb       s1, 0(s4)
	sb       s2, 1(s4)
	sb       s2, 2(s4)
	sb       s2, 3(s4)
	sb       s3, 4(s4)

	ecall
	ret





# Principal funcionalidade do programa
main:

	call     leituraEntrada           # Lê o valor da entrada
	call     converteEntrada          # Converte o número para inteiro

	mv       a2, s9                   # a2 = soma procurada

	la       a3, head_node            # Define o endereço do nó principal
	mv       s1, a3                   # Move o endereço para outro registrador

	li       a4, 0                    # Índice do nó (resposta)

	call     exploraLista             # Percorre a lista ligada até conseguir

	call     converteSaida            # Converte o número inteiro para texto

