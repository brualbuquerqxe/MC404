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
	la       a1, linha2     # Onde a entrada será armazenada
	li       a2, 8          # Número de bytes que serão lidos
	li       a7, 63         # Read
	ecall
	ret

# Define o valor do p!
leitura_ds:
# prólogo: reserva stack e salva ra
	addi     sp, sp, -16
	sw       ra, 12(sp)

# Leitura do primeiro bit (d1)
	lbu      t3, 0(s0)      # t3 = d1
	addi     t3, t3, -'0'   #Converte para ASCII
	andi     t3, t3, 1

# Leitura do segundo bit (d2)
	lbu      t4, 1(s0)      # t4 = d2
	addi     t4, t4, -'0'   #Converte para ASCII
	andi     t4, t4, 1

# Leitura do terceiro bit (d3)
	lbu      t5, 2(s0)      # t5 = d3
	addi     t5, t5, -'0'   #Converte para ASCII
	andi     t5, t5, 1

# Leitura do quarto bit (d4)
	lbu      t6, 3(s0)      # t6 = d4
	addi     t6, t6, -'0'   #Converte para ASCII
	andi     t6, t6, 1

# Chama a função que define os valores dos ps
	call     definicao_p
# epílogo: restaura ra e desfaz stack
	lw       ra, 12(sp)
	addi     sp, sp, 16
	ret

definicao_p:
# Analisa o valor do p1 (XOR = exclusivo) e se for ímpar, armazena 1 (1, 2, 4)
	xor      a1, t3, t4     # Analisa d1 e d2
	xor      a1, a1, t6     # Compara com d4

# Analisa o valor do p2 (1, 3, 4)
	xor      a2, t3, t5     # Analisa d1 e d3
	xor      a2, a2, t6     # Compara com d4

# Analisa o valor do p2 (2, 3, 4)
	xor      a3, t4, t5     # Analisa d2 e d3
	xor      a3, a3, t6     # Compara com d4

# Retorna
	ret

# Extrai os valores de d1 (2), d2 (4), d3 (5) e d4 (6)
leitura_codigo:

# Leitura do primeiro bit (d1)
	lbu      t3, 2(s0)      # t3 = d1
	addi     t3, t3, -'0'   #Converte para ASCII
	andi     t3, t3, 1

# Leitura do segundo bit (d2)
	lbu      t4, 4(s0)      # t4 = d2
	addi     t4, t4, -'0'   #Converte para ASCII
	andi     t4, t4, 1

# Leitura do terceiro bit (d3)
	lbu      t5, 5(s0)      # t5 = d3
	addi     t5, t5, -'0'   #Converte para ASCII
	andi     t5, t5, 1

# Leitura do quarto bit (d4)
	lbu      t6, 6(s0)      # t6 = d4
	addi     t6, t6, -'0'   #Converte para ASCII
	andi     t6, t6, 1

# Leitura de p1
	lbu      s9, 0(s0)      # s9 = p1
	addi     s9, s9, -'0'   #Converte para ASCII
	andi     s9, s9, 1

# Leitura de p2
	lbu      s10, 1(s0)     # s10 = p2
	addi     s10, s10, -'0' #Desconverte de ASCII
	andi     s10, s10, 1

# Leitura de p3
	lbu      s11, 3(s0)     # s11 = p3
	addi     s11, s11, -'0' #Converte para ASCII
	andi     s11, s11, 1

# Retorna (fim da função)
	ret

# Saída do código pronto
escrita_saida1:
# Converte para ASCII
	addi     t3, t3, '0'
	addi     t4, t4, '0'
	addi     t5, t5, '0'
	addi     t6, t6, '0'
	addi     s9, s9, '0'
	addi     s10, s10, '0'
	addi     s11, s11, '0'
# Escreve saída
	la       t1, saida1
	sb       s9, 0(t1)      # Escreve p1
	sb       s10, 1(t1)     # Escreve p2
	sb       t3, 2(t1)      # Escreve d1
	sb       s11, 3(t1)     # Escreve p3
	sb       t4, 4(t1)      # Escreve d2
	sb       t5, 5(t1)      # Escreve d3
	sb       t6, 6(t1)      # Escreve d4

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
# Converte para ASCII
	addi     t3, t3, '0'
	addi     t4, t4, '0'
	addi     t5, t5, '0'
	addi     t6, t6, '0'
# Escreve saída
	la       t1, saida2
	sb       t3, 0(t1)      # Escreve d1
	sb       t4, 1(t1)      # Escreve d2
	sb       t5, 2(t1)      # Escreve d3
	sb       t6, 3(t1)      # Escreve d4
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

	andi     t0, a0, 1      # Garante que será 0 ou 1
	addi     t0, t0, '0'    # Converte para ASCII
	sb       t0, 0(t1)

	li       t2, '\n'
	sb       t2, 1(t1)

	li       a0, 1          # STDOUT = 1 (saída padrão)
	la       a1, saida3     # Carrega o endereço do buffer para o registrador a1
	li       a2, 2          # Move o valor de número de bytes lidos para o a2
	li       a7, 64         # Código do serviço de escrita
	ecall                   # Chamada de sistema
	ret                     # Retorna da função

# Função principal do programa
main:

# ETAPA 01:
# Leitura da primeira linha
	call     leitura_linha1
	la       s0, linha1     # Carrega o endereço de entrada em s2

# Manipulações
	call     leitura_ds     # Define o valor de p1
	mv       s9, a1         # s9 == p1
	mv       s10, a2        # s10 == p2
	mv       s11, a3        # s11 == p3

# Escrita linha 1
	call     escrita_saida1 # Escrita da primeira linha

# ETAPA 02:
# Leitura da segunda linha
	call     leitura_linha2
	la       s0, linha2     # Carrega o endereço de entrada em s2

# Manipulações
	call     leitura_codigo # Carrega o código e pega os valores de d1, d2, d3 e d4

# ETAPA 03:
# Verifica erros

# Manipulações
	call     definicao_p    # Novos ps recalculados

	mv       s6, a1         # s6 == p1
	mv       s7, a2         # s7 == p2
	mv       s8, a3         # s8 == p3

# Verifica se são iguais aos originais
	xor      t0, s6, s9
	xor      t1, s7, s10
	xor      t2, s8, s11

	or       t0, t0, t1     # Vai "somando as diferencas"
	or       t0, t0, t2
	andi     t0, t0, 1      # Garante que é 0 ou 1

	mv       s5, t0         # Move pra outro lugar

# Segunda saída (valor original)
	call     escrita_saida2

# Terceira saída (verifica erro)
	mv       a0, s5         # 0 ou 1
	call     escrita_saida3

# Saída
	li       a0, 0          # Código de saída
	li       a7, 93         # Serviço de saída
	ecall