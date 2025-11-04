# Seção para dados não incializados.
	.section .bss

bufferComando:
	.skip    3                           # Tamanho do comando

bufferEntrada:
	.skip    100000                      # Tamanho desconhecido

bufferAuxiliar:
	.skip    100000                      # Tamanho desconhecido

	.section .text

# Indica se será realizada a escrita do byte ( = 1)
	.set     comandoWrite, 0xFFFF0100

# Endereço do byte que deve ser escrito
	.set     enderecoEscrita, 0xFFFF0101

# Indica se será realizada a leitura do byte ( = 1)
	.set     comandoRead, 0xFFFF0102

# Endereço do byte que deve ser lido
	.set     enderecoLeitura, 0xFFFF0103

# Função que inicia o programa
	.globl   _start

# Função que lê a entrada
	.globl   leituraEntrada

# Função que escreva a saída
	.globl   escritaSaida

# Função que lida com o primeiro caso
	.globl   caso01

# Função que lida com o segundo caso
	.globl   caso02

# Função que lida com o terceiro caso
	.globl   caso03

# Função que lida com o quarto caso
	.globl   caso04

# Função principal
	.globl   main

# Inicia o programa
_start:

	call     main

	li       a0, 0
	li       a7, 93
	ecall                                # Posso usar a chamada de exit

# Função de leitura
leituraEntrada:

	li       t5, comandoRead             # Extrai o endereço para sinalizar a leitura ( = 1)

	li       t6, enderecoLeitura         # Extrai o endereço do byte que deve ser lido

	li       t1, 0                       # Contador de caracter

	li       t4, '\n'                    # Simboliza a parada da leitura

	la       a0, bufferEntrada

.continuaLeitura:

	li       t2, 1                       # Ativa a configuração
	sb       t2, 0(t5)                   # Leitura ativada

.esperaLeitura:
	lb       t0, 0(t5)                   # lê o registrador de comando
	bnez     t0, .esperaLeitura          # enquanto for diferente de 0, ainda está lendo

	lb       t3, 0(t6)                   # Carrega o byte que é lido

	add      t2, a0, t1                  # Posição que o caracter deve ser gravado

	sb       t3, 0(t2)                   # Armazena o byte lido no buffer

	addi     t1, t1, 1                   # Adiciona uma unidade no endereço do buffer

	bne      t3, t4, .continuaLeitura    # Enquanto o caracter for diferente de '\n', leio

.fimLeitura:
	mv       a1, t1                      # Retorna quantidade de bytes lidos
	la       a0, bufferEntrada           # Retorna endereço base do buffer

	ret                                  # Encerra a leitura


# Função do escrita
escritaSaida:

	li       a6, comandoWrite            # Extrai o endereço para sinalizar a escrita ( = 1)

	li       a2, enderecoEscrita         # Extrai o endereço do byte que deve ser escrito

	li       t1, 0                       # Contador de caracter

.continuaEscrita:

	beq      t1, a1, .fimEscrita         # Se não tiver mais nada para escrever

	add      t2, a0, t1

	lb       a3, 0(t2)                   # Carrega o byte que foi armazenado

	sb       a3, 0(a2)                   # Armazena o byte que deve ser escrito no endereço de Escrita

	li       a5, 1                       # Ativa a configuração
	sb       a5, 0(a6)                   # Escrita ativada

.esperaEscrita:
	lb       t0, 0(a6)                   # lê o registrador de comando
	bnez     t0, .esperaEscrita          # enquanto for diferente de 0, ainda está escrevendo

	addi     t1, t1, 1                   # Adiciona uma unidade no endereço do buffer

	blt      t1, a1, .continuaEscrita    # Enquanto a mesma quantidade de caracters não forem escritas

.fimEscrita:

	ret                                  # Encerra a escrita

# Função do primeiro caso: apenas escreve a entrada
caso01:

	call     escritaSaida                # Apenas escreve

	ret                                  # Retorna

# Função do segundo caso: escreve a entrada ao contrário
caso02:

	la       a3, bufferAuxiliar          # Carrega o buffer auxiliar

	add      a4, a3, a1                  # Onde estará o '\n'
	addi     a4, a4, -1                  # <<< NOVO: coloca no índice a1-1

	li       t1, '\n'                    # Carrega '\n'
	sb       t1, 0(a4)                   # Posiciona o '\n' no final

	li       t2, 0                       # Contador dos byes registrados

	li       t6, 1                       # Armazena valor subtraído

	sub      t1, a1, t6                  # Posição do "\n"
	sub      t1, t1, t6                  # Último caracter útil

	addi     t5, a1, -1

.escritaInverso:

	add      a4, a3, t1                  # Onde estará armazenado o caracter no novo buffer

	add      t3, a0, t2                  # Endereço do byte que será escrito
	lb       t4, 0(t3)                   # Carrega o byte

	sb       t4, 0(a4)                   # Escreve o byte no buffer

	sub      t1, t1, t6                  # Subtrai uma unidade, posição do próximo byte no buffer auxiliar

	add      t2, t2, t6                  # Adiciona uma unidade no contador de bytes repassados

	blt      t2, t5, .escritaInverso

.fimEscritaInverso:

	mv       a0, a3                      # Move o buffer Auxiliar para o a0, norma ABII

	addi     sp, sp, -4                  # Empilha
	sw       ra, 0(sp)                   # Armazena o endereço de retorno

	call     escritaSaida                # Escreve a saída inversa

	la       a0, bufferEntrada           # Desloca o endereço da entrada

	lw       ra, 0(sp)                   # Volta com o endereço de retorno
	addi     sp, sp, 4                   # Desempilha

	ret                                  # Retorna

# Função do terceiro caso: converte a entrada da base decimal para hexadecimal
caso03:

	la       a3, bufferAuxiliar          # Carrega o buffer auxiliar

	add      a4, a3, a1                  # Onde estará o '\n'

	li       t1, '\n'                    # Carrega '\n'
	sb       t1, 0(a4)                   # Posiciona o '\n' no final

	li       t2, 0                       # Contador dos byes registrados

	li       t6, 1                       # Armazena valor subtraído

	sub      t1, a1, t6                  # Desconsidera o \n

.escritaInverso2:

	add      a4, a3, t1                  # Onde estará armazenado o caracter no novo buffer

	add      t3, a0, t2                  # Endereço do byte que será escrito
	lb       t4, 0(t3)                   # Carrega o byte

	sb       t4, 0(a4)                   # Escreve o byte no buffer

	sub      t1, t1, t6                  # Subtrai uma unidade, posição do próximo byte no buffer auxiliar

	add      t2, t2, t6                  # Adiciona uma unidade no contador de bytes repassados

	bge      t1, t2, .escritaInverso2    # Se ainda não passou por todos os bytes, lê mais bytes

.converteDecimal:

	li       t1, '\n'                    # Carrega '\n'

	li       t2, 10                      # Muda de casa
	li       t3, 1                       # Valor multplicado
	li       t4, 0                       # Soma final

	la       t5, bufferAuxiliar          # Carrega a endereço

.somaDecimal:

	lb       t0, 0(t5)                   # Carrega o valor
	addi     t0, t0, -'0'                # Converte para inteiro
	mul      t0, t0, t3                  # Multiplica pela casa que se encontra

	mul      t3, t3, t2                  # Muda a casa multiplicando por 10
	add      t4, t4, t0                  # Soma

	addi     t5, t5, 1                   # Próximo byte
	lb       t0, 0(t5)                   # Carrega o valor do próximo byte

	bne      t0, t1, .somaDecimal        # Se não chegou no '\n', continua convertendo o número

.converteHexadecimal: # Se chegou no final do número, muda para hexadecimal

	li       t1, '\n'                    # Carrega '\n'
	li       t2, 0                       # Contador
	li       t3, 16                      # Valor que divide na conversão

.dividePor16:

	rem      t5, t4, t3                  # Resto da divisão
	div      t4, t4, t3                  # Divide a soma por 16

# AQUI EU COLOCO OS CASOS DE CONVERSÃO PARA ASCII
# PRECISO ARMAZENAR NO BUFFER AUXILIAR


	addi     t2, t2, 1                   # Aumento o contador

	beqz     t4, .fimConversao

	call     .dividePor16                # Se ainda tem como dividir, divido!

.fimConversao:

	addi     t2, t2, 1                   # Adiciono /n

	la       t3, bufferAuxiliar          # Carrego endereço do buffer novamente

	add      t3, t3, t2                  # Somo a posição do '\n'

	sb       t1, 0(t3)                   # Passo o '\n' para o buffer

# .................................

	la       a0, bufferAuxiliar          # Move o buffer Auxiliar para o a0, norma ABII

	mv       a1, t2                      # Move a quantidade de byes

	addi     sp, sp, -4                  # Empilha
	sw       ra, 0(sp)                   # Armazena o endereço de retorno

	call     caso02                      # Escreve a saída inversa

	la       a0, bufferEntrada           # Desloca o endereço da entrada

	lw       ra, 0(sp)                   # Volta com o endereço de retorno
	addi     sp, sp, 4                   # Desempilha

	ret                                  # Retorna

# Função principal do programa
main:

	call     leituraEntrada              # Leitura da entrada até o '\n'

	la       t0, bufferEntrada           # endereço do buffer onde leituraEntrada escreveu

	lb       s1, 0(t0)

	call     leituraEntrada              # Leitura da entrada até o '\n'

	la       a0, bufferEntrada           # Desloca o endereço da entrada

	li       s2, '1'                     # Caso 01
	beq      s1, s2, .callcaso01         # Chama a função do primeiro caso

	li       s2, '2'                     # Caso 02
	beq      s1, s2, .callcaso02         # Chama a função do segundo caso

	li       s2, '3'                     # Caso 03
	beq      s1, s2, .callcaso03         # Chama a função do terceiro caso

.callcaso01:
	call     caso01
	ret

.callcaso02:
	call     caso02
	ret

.callcaso03:
	call     caso03
	ret

.final:
	ret                                  # Fim!
