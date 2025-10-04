# Seção para dados não incializados.
	.section .bss

bufferEntrada:
	.skip    7                       # Pode ter sinal ou não

# Seção que está com o código e as funções.
	.section .text

	.globl   _start

	.globl   leituraEntrada

	.globl   converteEntrada

# Inicia o programa a partir do rótulo "_start".
_start:
	call     main
	li       a0, 0                   # Código de saída
	li       a7, 93                  # Serviço de saída
	ecall

# Leitura do número da entrada.
leituraEntrada:
	li       a0, 0                   # Entrada STDIN
	la       a1, bufferEntrada       # Local que armazena a entrada
	li       a2, 7                   # Número de bytes que serão lidos
	li       a7, 63                  # Chamada de leitura
	ecall                            # Chama sistema
	ret                              # Retorna

# Converte o número para inteiro.
converteEntrada:
# Define os caracteres que são diferentes de números
	li       s1, 32                  # ' '
	li       s2, 9                   # '\t'
	li       s3, 10                  # '\n'
	li       s4, 13                  # '\r'
	li       s5, 45                  # '-'
	li       s6, 1                   # Contador (máximo = 7 = a2)
	li       s8, 1                   # Se o número for negativo, multiplicar por -1
	li       s9, 0                   # Soma do número inteiro
	li       s10, 10                 # Casa decimal
	mv       s11, a1                 # Copia o local que está armazenado o número
# Loop com a leitura do número
for:
	lbu      s7, 0(s11)              # Primeiro caracter da entrada
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
	mul      s9, s9, s10             # Muda a casa da soma
	addi     s7, s7, -'0'            # Converte em número inteiro
	add      s9, s9, s7              # Soma o valor
	addi     s6, s6, 1               # Aumenta o contador
	addi     s11, s11, 1             # Passa para a próxima posição
	call     for

.fimNumero:
	mul      s9, s9, s8              # Multiplica por -1 se o número for negativo
	ecall
	ret

.numeroNegativo:
	li       s8, -1                  # Multiplica por -1
	addi     s6, s6, 1               # Aumenta o contador
	addi     s11, s11, 1             # Passa para a próxima posição
	call     for

# Principal funcionalidade do programa
main:

	call     leituraEntrada          # Lê o valor da entrada
	call     converteEntrada         # Converte o número para inteiro

	mv       a3, s9                  # a3 = entrada

	call 