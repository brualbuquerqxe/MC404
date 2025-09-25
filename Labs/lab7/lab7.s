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

	.globl   leitura_codigo

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
	mv       a4, t3         # a4 = primeiro bit

# Segundo bit
	li       t2, 1
	sll      t1, t1, t2
	and      t4, t0, t1
	srl      t4, t4, t2     # t4 = segundo bit
	mv       a5, t4         # a5 = segundo bit

# Terceiro bit
	li       t2, 2
	sll      t1, t1, t2
	and      t5, t0, t1
	srl      t5, t5, t2     # t5 = terceiro bit
	mv       a6, t5         # a6 = terceiro bit

# Quarto bit
	li       t2, 3
	sll      t1, t1, t2
	and      t6, t0, t1
	srl      t6, t6, t2     # t6 = quarto bit
	mv       a7, t6         # a7 = quarto bit

# Analisa o valor do p1 (XOR = exclusivo) e se for ímpar, armazena 1 (1, 2, 4)
	xor      a1, t3, t4
	xor      a1, a1, t6

# Analisa o valor do p2 (1, 3, 4)
	xor      a2, t3, t5
	xor      a2, a2, t6

# Analisa o valor do p2 (2, 3, 4)
	xor      a3, t4, t5
	xor      a3, a3, t6

# Extrai os valores de d1 (2), d2 (4), d3 (5) e d4 (6)
leitura_codigo:

	lb       t0, 0(s2)      # Carrega o valor da memória
	li       t1, 1          # Constante 1

# Primeiro bit
	li       t2, 2          # Número do bit que será isolado
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2     # t3 = d1
	mv       a1, t3         # a1 = d1

# Segundo bit
	li       t2, 4
	sll      t1, t1, t2
	and      t4, t0, t1
	srl      t4, t4, t2     # t4 = d2
	mv       a2, t3         # a2 = d2


# Terceiro bit
	li       t2, 5
	sll      t1, t1, t2
	and      t5, t0, t1
	srl      t5, t5, t2     # t5 = d3
	mv       a3, t3         # a3 = d3

# Quarto bit
	li       t2, 6
	sll      t1, t1, t2
	and      t6, t0, t1
	srl      t6, t6, t2     # t6 = d4
	mv       a4, t3         # a4 = d4

# Saída do código pronto
escrita_saida1:
	la       t1, saida2
	sb       s9, 0(t1)      # Escreve p1
	sb       s10, 1(t1)     # Escreve p2
	sb       a4, 2(t1)      # Escreve d1
	sb       s11, 3(t1)     # Escreve p3
	sb       a5, 4(t1)      # Escreve d2
	sb       a6, 5(t1)      # Escreve d3
	sb       a7, 6(t1)      # Escreve d4

	li       t0, '\n'
	sb       t0, 7(t1)      # Newline ao final

	li       a0, 8          # Número de bytes a serem escritos (saída completa)

	mv       t0, a0         # Copia o número de bytes lidos para t0
	li       a0, 1          # STDOUT = 1 (saída padrão)
	la       a1, saida1     # Carrega o endereço do buffer para o registrador a1
	mv       a2, t0         # Move o valor de número de bytes lidos para o a2
	li       a7, 64         # Código do serviço de escrita
	ecall                   # Chamada de sistema
	ret                     # Retorna da função

# Escreve o código decodificado
escrita_saida2:
	la       t1, saida2
	sb       a1, 0(t1)      # Escreve d1
	sb       a2, 1(t1)      # Escreve d2
	sb       a3, 2(t1)      # Escreve d3
	sb       a4, 3(t1)      # Escreve d4
	li       t0, '\n'
	sb       t0, 4(t1)      # Newline ao final

	li       a0, 5          # Número de bytes a serem escritos (saída completa)

	mv       t0, a0         # Copia o número de bytes lidos para t0
	li       a0, 1          # STDOUT = 1 (saída padrão)
	la       a1, saida2     # Carrega o endereço do buffer para o registrador a1
	mv       a2, t0         # Move o valor de número de bytes lidos para o a2
	li       a7, 64         # Código do serviço de escrita
	ecall                   # Chamada de sistema
	ret                     # Retorna da função

# Escreve se houve erro ou não
escrita_saida3:
	la       t1, saida3
	sb       a1, 0(t1)      # Escreve d1
	li       t0, '\n'
	sb       t0, 1(t1)      # Newline ao final

	li       a0, 2          # Número de bytes a serem escritos (saída completa)

	mv       t0, a0         # Copia o número de bytes lidos para t0
	li       a0, 1          # STDOUT = 1 (saída padrão)
	la       a1, saida3     # Carrega o endereço do buffer para o registrador a1
	mv       a2, t0         # Move o valor de número de bytes lidos para o a2
	li       a7, 64         # Código do serviço de escrita
	ecall                   # Chamada de sistema
	ret                     # Retorna da função

# Leitura dos valores ps originais
leitura_ps:

	lb       t0, 0(s2)      # Carrega o valor da memória
	li       t1, 1          # Constante 1

# Primeiro bit
	li       t2, 0          # Número do bit que será isolado
	sll      t1, t1, t2
	and      t3, t0, t1
	srl      t3, t3, t2     # t3 = p1
	mv       a1, t3         # a1 = p1

# Segundo bit
	li       t2, 1
	sll      t1, t1, t2
	and      t4, t0, t1
	srl      t4, t4, t2     # t4 = p2
	mv       a2, t3         # a2 = p2


# Terceiro bit
	li       t2, 3
	sll      t1, t1, t2
	and      t5, t0, t1
	srl      t5, t5, t2     # t5 = p3
	mv       a3, t3         # a3 = p3

# Função principal do programa
main:

# ETAPA 01:
# Leitura da primeira linha
	call     leitura_linha1
	la       s2, linha1     # Carrega o endereço de entrada em s2

# Manipulações
	call     definicao_p    # Define o valor de p1
	mv       s9, a1         # s9 == p1
	mv       s10, a2        # s10 == p2
	mv       s11, a3        # s11 == p3

# Escrita linha 1
	call     escrita_saida1 # Escrita da primeira linha

# ETAPA 02:
# Leitura da segunda linha
	call     leitura_linha2
	la       s2, linha2     # Carrega o endereço de entrada em s2

# Manipulações
	call     leitura_codigo # Carrega o código e pega os valores de d1, d2, d3 e d4

# Escrita linha 2
	call     escrita_saida2 # Escreve a saída da segunda linha

# ETAPA 03:
# Verifica erros
	la       s2, saida2     # Está com o código decodificado

# Manipulações
	call     definicao_p

	mv       s9, a1         # s9 == p1
	mv       s10, a2        # s10 == p2
	mv       s11, a3        # s11 == p3

	la       s2, linha2     # Carrega o endereço da linha 2

	call     leitura_ps     # Lê os valores de ps

	mv       s6, a1         # s6 == p1
	mv       s7, a1         # s7 == p1
	mv       s8, a1         # s8 == p1

	xor      a1, s6, s9     # Verifica se são iguais
	xor      a2, s7, s10
	xor      a3, s8, s11

# Verifica se teve algum erro (valor = 1)
	or       a1, a1, a2
	or       a1, a1, a3

# Escrita linha 3
	call     escrita_saida3

# Saída
	li       a0, 0          # Código de saída
	li       a7, 93         # Serviço de saída
	ecall