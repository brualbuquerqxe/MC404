# Preciso armazenar a entrada em um buffer que estará na seção .bss (dedicada ao armazenamento de dados não inicializados).

	.section .bss

# Buffer da linha 01: aloca 12 bytes, já que é o tamanho máximo da entrada (conta a pulada de linha final).
linha1:
	.skip    12

# Buffer da linha 02: aloca 20 bytes, já que é o tamanho máximo da entrada (conta a pulada de linha final).
linha2:
	.skip    20

# Buffer da saída: aloca 12 bytes, já que é o tamanho máximo da entrada (conta a pulada de linha final).
saida:
	.skip    12

# Prontooo! Agora temos o buffer (área em que vou guardar temporariamente a minha entrada) alocado. Isso signfica que eu posso sair da seção .bss.

# A próxima seção é a .text, onde fica o código do programa e define as funções.

	.section .text

	.globl   _start

	.globl   leitura_linha1

	.globl   leitura_linha2

	.globl   escrita

	.globl   conversao_int

	.globl   raiz_quadrada

	.globl   main

	.globl   int_to_string

# Inicia o programa a partir do rótulo "_start".
_start:
	call     main
	li       a0, 0                         # Código de saída
	li       a7, 93                        # Serviço de saída
	ecall

# Função que vai ler a primeira linha de entrada
leitura_linha1:
	li       a0, 0                         # Entrada padrão
	la       a1, linha1                    # Onde a entrada será armazenada
	li       a2, 12                        # Número de bytes que serão lidos
	li       a7, 63                        # read
	ecall                                  # Chama sistema
	ret                                    # Retorna

# Função que vai ler a primeira linha de entrada
leitura_linha2:
	li       a0, 0                         # Entrada padrão
	la       a1, linha2                    # Onde a entrada será armazenada
	li       a2, 20                        # Número de bytes que serão lidos
	li       a7, 63                        # read
	ecall                                  # Chama sistema
	ret

# Escreve 12 bytes do 'buffer' na saída padrão
escrita:
	li       a0, 1                         # Saída padrão
	la       a1, saida                     # Endereço do buffer de saída
	li       a2, 12                        # 12 bytes será o tamanho da saída
	li       a7, 64                        # write
	ecall
	ret


# A função "conversao_int" extrai o número da string armazenada no buffer e o converte para um valor inteiro.
conversao_int:
	li       t2, 4                         # 4 dígitos
	li       a0, 0                         # Inicializa o registrador a0 com 0
	li       t1, 1000                      # Multiplicador inicial
	li       t4, 10                        # Carrega o valor 10 no registrador t4

repeticao_extracao_numero:
	add      t5, a1, t3                    # Endereço do caractere atual
	lbu      t0, 0(t5)                     # Leitura do primeiro caractere da string
	addi     t0, t0, -'0'                  # Converte o caractere ASCII para um inteiro
	mul      t0, t0, t1                    # Multiplica o valor pelo multiplicador
	add      a0, a0, t0                    # Soma o valor ao registrador a0

	addi     t3, t3, 1                     # Incrementa o índice para o próximo caractere
	addi     t2, t2, -1                    # Decrementa o contador
	div      t1, t1, t4                    # Atualiza o multiplicador (divide por 10 para o próximo dígito)

	bnez     t2, repeticao_extracao_numero # Se o contador for maior que zero, repete o processo

	ret                                    # Retorna da função (a0)

# A função "raiz_quadrada" calcula a raiz quadrada inteira do número armazenado em a0.
raiz_quadrada:

	beqz     a0, rq_zero                   # Exceção quando o número for zero
	li       t1, 1
	beq      a0, t1, rq_one                # Exceção quando o número for um

	li       t6, 2                         # Carrega o valor 2 no registrador t6
	div      a2, a0, t6                    # Divide o número por 2 para obter uma aproximação inicial (k)

	li       t2, 21                        # Número de iterações para melhorar a precisão

# No livro estava falando de uma forma de chegar na raiz usando, no máximo, 10 iterações.
iteracoes_raiz:
	div      t3, a0, a2                    # Divide o número pelo valor atual de k (antes era s2)
	add      a2, a2, t3                    # Soma k com o resultado da divisão
	div      a2, a2, t6                    # Divide a soma por 2 para obter a nova aproximação (novo k)
	addi     t2, t2, -1                    # Decrementa o contador de iterações (antes era s1)
	bnez     t2, iteracoes_raiz            # Se ainda houver iterações restantes, repete o processo

	mv       a0, a2                        # Move o valor final da raiz quadrada para a0

	ret                                    # Retorna da função, sendo a2 o lugar que vai estar armazenado a raiz quadrada final

# Exceção quando o número for zero
rq_zero:
	mv       a0, x0                        # Retorna 0
	ret

# Exceção quando o número for um
rq_one:
	li       a0, 1                         # Retorna 1
	ret

# A função "int_to_string" converte o número inteiro armazenado em a0 para uma string de 4 dígitos, armazenando-a no endereço apontado por a1.
int_to_string:
	li       t5, 1000                      # Divisor inicial (1000 para o primeiro dígito)
	divu     t0, a0, t5                    # Divide o número pelo divisor
	remu     a0, a0, t5                    # Resto da divisão (atualiza a0 para o próximo dígito)
	addi     t0, t0, '0'                   # Converte o dígito para caractere ASCII
	sb       t0, 0(a1)                     # Armazena o caractere na posição correta do buffer

	li       t5, 100                       # Divisor para o segundo dígito
	divu     t0, a0, t5                    # Divide o número pelo divisor
	remu     a0, a0, t5                    # Resto da divisão (atualiza a0 para o próximo dígito)
	addi     t0, t0, '0'                   # Converte o dígito para caractere ASCII
	sb       t0, 1(a1)                     # Armazena o caractere na posição correta do buffer

	li       t5, 10                        # Divisor para o terceiro dígito
	divu     t0, a0, t5                    # Divide o número pelo divisor
	remu     a0, a0, t5                    # Resto da divisão (atualiza a0 para o próximo dígito)
	addi     t0, t0, '0'                   # Converte o dígito para caractere ASCII
	sb       t0, 2(a1)                     # Armazena o caractere na posição correta do buffer

	addi     t0, a0, '0'                   # Converte o dígito para caractere ASCII
	sb       t0, 3(a1)                     # Armazena o caractere na posição correta do buffer

	addi     a1, a1, 4                     # Avança o ponteiro de destino em 4 posições (precisa chegar no próximo bloco de 4 dígitos)
	ret

# A função "main" chama as outras funções e finaliza o programa.
main:
# Função principal do programa
main:
# Constantes
	li       s4, 10                        # Divisor 10
	li       s5, 3                         # Velocidade = 3 (para 0,3)

# Leitura da primeira linha com as coordenadas Y_b e X_c
	jal      leitura_linha1
	la       s0, linha1                    # Carrega o endereço de entrada em s0

# Y_b == s10
	mv       a1, s0                        # Transfere o endereço de entrada para a1
	li       t3, 1                         # Pula o sinal
	jal      conversao_int
	mv       s10, a0                       # Y_b está na posição s10

# X_c == s11
	mv       a1, s0                        # Transfere o endereço de entrada para a1
	li       t3, 7                         # Pula o sinal
	jal      conversao_int_signed
	mv       s11, a0                       # X_c está na posição s11

# Leitura da segunda linha com os tempos
	jal      leitura_linha2
	la       s0, linha2                    # Carrega o endereço de entrada em s0

# TA == s6
	mv       a1, s0                        # Transfere o endereço de entrada para a1
	li       t3, 0                         # Pula o sinal
	jal      conversao_int
	mv       s6, a0                        # TA está na posição s6

# TB == s7
	mv       a1, s0                        # Transfere o endereço de entrada para a1
	li       t3, 5                         # Pula o sinal
	jal      conversao_int
	mv       s7, a0                        # TB está na posição s7

# TC == s8
	mv       a1, s0                        # Transfere o endereço de entrada para a1
	li       t3, 10                        # Pula o sinal
	jal      conversao_int
	mv       s8, a0                        # TC está na posição s8

# TR == s9
	mv       a1, s0                        # Transfere o endereço de entrada para a1
	li       t3, 15                        # Pula o sinal
	jal      conversao_int
	mv       s9, a0                        # TR está na posição s9

# Distâncias medidas a partir da diferença de tempo
# DA = s6
	sub      s6, s9, s6                    # Diferença de tempo
	mul      s6, s6, s5                    # Vezes velocidade
	div      s6, s6, s4                    # Dividido por 10

# DB = s7
	sub      s7, s9, s7
	mul      s7, s7, s5
	div      s7, s7, s4

# DC = s8
	sub      s8, s9, s8
	mul      s8, s8, s5
	div      s8, s8, s4

# Constantes
	li       s4, -1                        # -1 para subtrações
	li       s5, 2                         # 2 para multiplicações

# Y = (DA*DA + Y_b*Y_b - (DB*DB))/(2*Yb)
	mul      s6, s6, s6                    # DA*DA (usa depois)
	mv       s3, s6                        # Move para s3
	mul      s2, s10, s10                  # Y_b*Y_b
	add      s3, s3, s2                    # DA*DA + Y_b*Y_b
	mul      s2, s7, s7                    # DB*DB
	mul      s2, s2, s4                    # -(DB*DB)
	add      s3, s3, s2                    # DA*DA + Y_b*Y_b -(DB*DB)
	mul      s2, s10, s5                   # 2*Y_b
	div      s3, s3, s2                    # Y == s3

# X = +-raiz(DA*DA - (Y*Y))
	mul      s7, s3, s3                    # Y*Y
	mul      s7, s7, s4                    # -(Y*Y)
	add      s10, s7, s6                   # dA^2 - y^2 (em s10)
	mv       a0, s10                       # Move para a0
	call     raiz_quadrada                 # Calcula raiz quadrada
	mv       s10, a0                       # Move devolta para s10

# Imprime
	call     imprime_saida_yx

# Saída
	li       a0, 0                         # Código de saída
	li       a7, 93                        # Serviço de saída
	ecall