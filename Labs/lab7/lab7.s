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

	.globl   definicao_p1

	.globl   definicao_p2

	.globl   definicao_p3

	.globl   escrita_saida1

	.globl   escrita_saida2

	.globl   escrita_saida3

# Inicia o programa
_start:
	call     main
	li       a0, 0
	li       a7, 93
	ecall

# Lê a primeira linha de entrada
leitura_linha1:
	li       a0, 0               # Entrada padrão
	la       a1, linha1          # Onde a entrada será armazenada
	li       a2, 5               # Número de bytes que serão lidos
	li       a7, 63              # Read
	ecall
	ret

# Lê a segunda linha de entrada
leitura_linha2:
	li       a0, 0               # Entrada padrão
	la       a1, linha1          # Onde a entrada será armazenada
	li       a2, 8               # Número de bytes que serão lidos
	li       a7, 63              # Read
	ecall
	ret

# Define o valor de p1
definicao_p1:
	li       t6, 0               # Contabilizador inicia com 0
	li       s3 1                # Valor 1 que será adicionado

	lb       t0, 0(s2)           # Carrega o valor da memória
	li       t1, 1               # Constante 1
	li       t2, 0               # Número do bit que será isolado
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2

# Se o caracter for 1, contabiliza
	beq      t3, t5, contabiliza

	lb       t0, 0(s2)
	li       t1, 1
	li       t2, 1
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2

	beq      t3, t5, contabiliza

	lb       t0, 0(s2)
	li       t1, 1
	li       t2, 3
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2

	beq      t3, t5, contabiliza

	call     define_p1

# Adiciona a quantidade de aparições de "1"
contabiliza:
	add      t6, s3 t6

define_p1:
	li       t0, 3               # Número ímpar
	li       t1, 1               # Número ímpar
	beq      t0, t6, valor_p1
	beq      t1, t6, valor_p1
	li       a0, '0'             # Se não for ímpar, define p1 como "0"
	ret                          # Fim

valor_p1:
	li       a0, '1'             # Se for ímpar, define p1 como "1"
	ret

# Define o valor de p2
definicao_p2:
	li       t6, 0               # Contabilizador inicia com 0
	li       s3 1                # Valor 1 que será adicionado

	lb       t0, 0(s2)           # Carrega o valor da memória
	li       t1, 1               # Constante 1
	li       t2, 0               # Número do bit que será isolado
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2

# Se o caracter for 1, contabiliza
	beq      t3, t5, contabiliza

	lb       t0, 0(s2)
	li       t1, 1
	li       t2, 2
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2

	beq      t3, t5, contabiliza

	lb       t0, 0(s2)
	li       t1, 1
	li       t2, 3
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2

	beq      t3, t5, contabiliza

	call     define_p2

# Adiciona a quantidade de aparições de "1"
contabiliza:
	add      t6, s3 t6

define_p2:
	li       t0, 3               # Número ímpar
	li       t1, 1               # Número ímpar
	beq      t0, t6, valor_p2
	beq      t1, t6, valor_p2
	li       a0, '0'             # Se não for ímpar, define p1 como "0"
	ret                          # Fim

valor_p2:
	li       a0, '1'             # Se for ímpar, define p1 como "1"
	ret

# Define o valor de p3
definicao_p3:
	li       t6, 0               # Contabilizador inicia com 0
	li       s3 1                # Valor 1 que será adicionado

	lb       t0, 0(s2)           # Carrega o valor da memória
	li       t1, 1               # Constante 1
	li       t2, 1               # Número do bit que será isolado
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2

# Se o caracter for 1, contabiliza
	beq      t3, t5, contabiliza

	lb       t0, 0(s2)
	li       t1, 1
	li       t2, 2
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2

	beq      t3, t5, contabiliza

	lb       t0, 0(s2)
	li       t1, 1
	li       t2, 3
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2

	beq      t3, t5, contabiliza

	call     define_p3

# Adiciona a quantidade de aparições de "1"
contabiliza:
	add      t6, s3 t6

define_p3:
	li       t0, 3               # Número ímpar
	li       t1, 1               # Número ímpar
	beq      t0, t6, valor_p3
	beq      t1, t6, valor_p3
	li       a0, '0'             # Se não for ímpar, define p1 como "0"
	ret                          # Fim

valor_p3:
	li       a0, '1'             # Se for ímpar, define p1 como "1"
	ret

# Função principal do programa
main:

# Leitura da primeira linha
	call     leitura_linha1
	la       s2, linha1          # Carrega o endereço de entrada em s2
	li       t4, '0'             # Carrega "0" no t0
	li       t5, '1'             # Carrega "1" no t1

	call     definicao_p1        # Define o valor de p1
	mv       s9, a0              # s9 == p1

	call     definicao_p2        # Define o valor de p2
	mv       s10, a0             # s10 == p2

	call     definicao_p3        # Define o valor de p3
	mv       s11, a0             # s11 == p3




# Saída
	li       a0, 0               # Código de saída
	li       a7, 93              # Serviço de saída
	ecall