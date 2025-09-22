# Variáveis globais
	.section .bss

linha1:
	.skip    5

linha2:
	.skip    8

saida1:
	.skip    8

saida2:
	.skip    5

saida3:
	.skip    2

# Código e funções
	.section .text

	.globl   _start

	.globl   leitura_linha1

	.globl   leitura_linha2

	.globl   definicao_p

	.globl   escrita_saida1

	.globl   escrita_saida2

	.globl   escrita_saida3

	.globl   escrita_p

# Inicia o programa
_start:
	call     main
	li       a0, 0
	li       a7, 93
	ecall

# Lê a primeira linha de entrada
leitura_linha1:
	li       a0, 0          # Entrada padrão
	la       a1, linha1     # Onde a entrada será armazenada
	li       a2, 5          # Número de bytes que serão lidos
	li       a7, 63         # Read
	ecall
	ret

# Lê a segunda linha de entrada
leitura_linha2:
	li       a0, 0          # Entrada padrão
	la       a1, linha1     # Onde a entrada será armazenada
	li       a2, 8          # Número de bytes que serão lidos
	li       a7, 63         # Read
	ecall
	ret

# Define o valor do p!
definicao_p:

	lb       t0, 0(s2)      # Carrega o valor da memória
	li       t1, 1          # Constante 1

# Primeiro bit
	li       t2, 0          # Número do bit que será isolado
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2     # t3 = primeiro bit

# Segundo bit
	li       t2, 1
	sll      t1, t1, t2
	and      t4, t0, t1
	srl      t4, t4, t2     # t4 = segundo bit

# Terceiro bit
	li       t2, 2
	sll      t1, t1, t2
	and      t5, t0, t1
	srl      t5, t5, t2     # t5 = terceiro bit

# Quarto bit
	li       t2, 3
	sll      t1, t1, t2
	and      t6, t0, t1
	srl      t6, t6, t2     # t6 = quarto bit

# Analisa o valor do p1
	xor      a1, t3, t4
	xor      a1, a1, t6

# Analisa o valor do p2
	xor      a2, t3, t5
	xor      a2, a2, t6

# Analisa o valor do p2
	xor      a3, t4, t5
	xor      a3, a3, t6


# Função principal do programa
main:

# Leitura da primeira linha
	call     leitura_linha1
	la       s2, linha1     # Carrega o endereço de entrada em s2
	li       t4, '0'        # Carrega "0" no t0
	li       t5, '1'        # Carrega "1" no t1

	call     definicao_p    # Define o valor de p1
	mv       s9, a1         # s9 == p1
	mv       s10, a2        # s10 == p2
	mv       s11, a3        # s11 == p3


# Saída
	li       a0, 0          # Código de saída
	li       a7, 93         # Serviço de saída
	ecall