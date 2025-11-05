# Seção para dados não incializados.
	.section .bss

bufferComando:
	.skip    3                            # Tamanho do comando

bufferEntrada:
	.skip    100000                       # Tamanho desconhecido

bufferAuxiliar:
	.skip    100000                       # Tamanho desconhecido

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
	ecall                                 # Posso usar a chamada de exit

# Função de leitura
leituraEntrada:

	li       t5, comandoRead              # Extrai o endereço para sinalizar a leitura ( = 1)

	li       t6, enderecoLeitura          # Extrai o endereço do byte que deve ser lido

	li       t1, 0                        # Contador de caracter

	li       t4, '\n'                     # Simboliza a parada da leitura

	la       a0, bufferEntrada

.continuaLeitura:

	li       t2, 1                        # Ativa a configuração
	sb       t2, 0(t5)                    # Leitura ativada

.esperaLeitura:
	lb       t0, 0(t5)                    # lê o registrador de comando
	bnez     t0, .esperaLeitura           # enquanto for diferente de 0, ainda está lendo

	lb       t3, 0(t6)                    # Carrega o byte que é lido

	add      t2, a0, t1                   # Posição que o caracter deve ser gravado

	sb       t3, 0(t2)                    # Armazena o byte lido no buffer

	addi     t1, t1, 1                    # Adiciona uma unidade no endereço do buffer

	bne      t3, t4, .continuaLeitura     # Enquanto o caracter for diferente de '\n', leio

.fimLeitura:
	mv       a1, t1                       # Retorna quantidade de bytes lidos
	la       a0, bufferEntrada            # Retorna endereço base do buffer

	ret                                   # Encerra a leitura


# Função do escrita
escritaSaida:

	li       a6, comandoWrite             # Extrai o endereço para sinalizar a escrita ( = 1)

	li       a2, enderecoEscrita          # Extrai o endereço do byte que deve ser escrito

	li       t1, 0                        # Contador de caracter

.continuaEscrita:

	beq      t1, a1, .fimEscrita          # Se não tiver mais nada para escrever

	add      t2, a0, t1

	lb       a3, 0(t2)                    # Carrega o byte que foi armazenado

	sb       a3, 0(a2)                    # Armazena o byte que deve ser escrito no endereço de Escrita

	li       a5, 1                        # Ativa a configuração
	sb       a5, 0(a6)                    # Escrita ativada

.esperaEscrita:
	lb       t0, 0(a6)                    # lê o registrador de comando
	bnez     t0, .esperaEscrita           # enquanto for diferente de 0, ainda está escrevendo

	addi     t1, t1, 1                    # Adiciona uma unidade no endereço do buffer

	blt      t1, a1, .continuaEscrita     # Enquanto a mesma quantidade de caracters não forem escritas

.fimEscrita:

	ret                                   # Encerra a escrita

# Função do primeiro caso: apenas escreve a entrada
caso01:

	call     escritaSaida                 # Apenas escreve

	ret                                   # Retorna

# Função do segundo caso: escreve a entrada ao contrário
caso02:

	la       a3, bufferAuxiliar           # Carrega o buffer auxiliar

	add      a4, a3, a1                   # Onde estará o '\n'
	addi     a4, a4, -1                   # <<< NOVO: coloca no índice a1-1

	li       t1, '\n'                     # Carrega '\n'
	sb       t1, 0(a4)                    # Posiciona o '\n' no final

	li       t2, 0                        # Contador dos byes registrados

	li       t6, 1                        # Armazena valor subtraído

	sub      t1, a1, t6                   # Posição do "\n"
	sub      t1, t1, t6                   # Último caracter útil

	addi     t5, a1, -1

.escritaInverso:

	add      a4, a3, t1                   # Onde estará armazenado o caracter no novo buffer

	add      t3, a0, t2                   # Endereço do byte que será escrito
	lb       t4, 0(t3)                    # Carrega o byte

	sb       t4, 0(a4)                    # Escreve o byte no buffer

	sub      t1, t1, t6                   # Subtrai uma unidade, posição do próximo byte no buffer auxiliar

	add      t2, t2, t6                   # Adiciona uma unidade no contador de bytes repassados

	blt      t2, t5, .escritaInverso

.fimEscritaInverso:

	mv       a0, a3                       # Move o buffer Auxiliar para o a0, norma ABII

	addi     sp, sp, -4                   # Empilha
	sw       ra, 0(sp)                    # Armazena o endereço de retorno

	call     escritaSaida                 # Escreve a saída inversa

	la       a0, bufferEntrada            # Desloca o endereço da entrada

	lw       ra, 0(sp)                    # Volta com o endereço de retorno
	addi     sp, sp, 4                    # Desempilha

	ret                                   # Retorna

# Função do terceiro caso: converte a entrada da base decimal para hexadecimal
caso03:

	la       a3, bufferAuxiliar           # Carrega o buffer auxiliar

	li       t2, 0                        # Contador dos byes registrados

	li       t6, 1                        # Armazena valor subtraído

	sub      t1, a1, t6                   # Desconsidera o \n
	sub      t1, t1, t6

.escritaInverso2:

	add      a4, a3, t2                   # Onde estará armazenado o caracter no novo buffer

	add      t3, a0, t1                   # Endereço do byte que será escrito
	lb       t4, 0(t3)                    # Carrega o byte

	sb       t4, 0(a4)                    # Escreve o byte no buffer

	addi     t2, t2, 1                    # avança destino
	addi     t1, t1, -1                   # recua origem

	bgez     t1, .escritaInverso2         # continua enquanto t1 for maior ou igual a 0

# coloca '\n' ao final do número espelhado
	la       t5, bufferAuxiliar
	add      t5, t5, t2                   # Posição logo após o último dígito
	li       t1, '\n'
	sb       t1, 0(t5)

.converteDecimal:

	li       t1, '\n'                     # Carrega '\n'

	li       t2, 10                       # Muda de casa
	li       t3, 1                        # Valor multplicado
	li       t4, 0                        # Soma final

	la       t5, bufferAuxiliar           # Carrega a endereço

.somaDecimal:

	lb       t0, 0(t5)                    # Carrega o valor

	beq      t0, t1, .converteHexadecimal # SE for '\n', termina a soma

	addi     t0, t0, -'0'                 # Converte para inteiro
	mul      t0, t0, t3                   # Multiplica pela casa que se encontra

	mul      t3, t3, t2                   # Muda a casa multiplicando por 10
	add      t4, t4, t0                   # Soma

	addi     t5, t5, 1                    # Próximo byte
	j        .somaDecimal

.converteHexadecimal: # Se chegou no final do número, muda para hexadecimal

	li       t1, '\n'                     # Carrega '\n'
	li       t2, 0                        # Contador
	li       t3, 16                       # Valor que divide na conversão

.dividePor16:

	rem      t5, t4, t3                   # Resto da divisão
	div      t4, t4, t3                   # Divide a soma por 16

	li       t6, 10                       # Valor máximo numérico
	blt      t5, t6, .valorNumerico       # Encontrou o valor e coloca no buffer
	j        .valorLetra                  # Número maior do que 9 será convertido em letra

.valorNumerico:
	addi     t5, t5, '0'                  # Converte em ASCII
	j        .continuacao                 # Segue

.valorLetra:
	addi     t5, t5, -10
	addi     t5, t5, 'A'                  # Converte em ASCII

.continuacao:

	la       s6, bufferAuxiliar           # Carrega o endereço onde colocarei os dígitos

	add      s6, s6, t2                   # Posição do caracter

	sb       t5, 0(s6)                    # Armazena o caracter na memória

	addi     t2, t2, 1                    # Aumento o contador

	bnez     t4, .dividePor16             # Se ainda tem como dividir, divido!

.fimConversao:

	la       t3, bufferAuxiliar           # Carrego endereço do buffer novamente

	add      t3, t3, t2                   # Somo a posição do '\n'

	sb       t1, 0(t3)                    # Passo o '\n' para o buffer

	addi     t2, t2, 1                    # Adiciono /n

	mv       a1, t2                       # Move a quantidade de byes

	la       t0, bufferAuxiliar
	la       t1, bufferEntrada
	mv       t2, a1

.copiaHexadecimal:
	beqz     t2, .finalizaCopia
	lb       t4, 0(t0)
	sb       t4, 0(t1)
	addi     t0, t0, 1
	addi     t1, t1, 1
	addi     t2, t2, -1
	j        .copiaHexadecimal

.finalizaCopia:
	la       a0, bufferEntrada            # Move o buffer Entrada para o a0, norma ABII

	addi     sp, sp, -4                   # Empilha
	sw       ra, 0(sp)                    # Armazena o endereço de retorno

	call     caso02                       # Escreve a saída inversa

	la       a0, bufferEntrada            # Desloca o endereço da entrada

	lw       ra, 0(sp)                    # Volta com o endereço de retorno
	addi     sp, sp, 4                    # Desempilha

	ret                                   # Retorna

caso04:
	li       t1, '\n'                     # Indica quebra d elinha
	li       t2, ' '                      # Indica espaço
	li       t3, 0                        # Contador de espaços (devo ter apenas 2)

	la       a3, bufferEntrada            # Carrega o endereço

.converteNumero:

	li       t6, 10                       # Muda de casa
	li       t3, 1                        # Valor multplicado
	li       t4, 0                        # Soma final
	li       s3, 1                        # Se for positivo ou negativo, muda

	lb       t0, 0(a3)                    # Leitura do primeiro byte

	li       s7, '-'                      # Sinal negativo
	li       s8, '+'                      # Sinal positivo

	beq      s7, t0, .sinalNegativo       # Multiplica por -1

	beq      s8, t0, .sinalPositivo       # Multiplica por 1

	j        .somaNumeroDecimal           # Sem sinal explícito: segue normalmente

.sinalNegativo:
	li       s3, -1
	addi     a3, a3, 1                    # Vai para o próximo caracter
	j        .somaNumeroDecimal

.sinalPositivo:
	li       s3, 1
	addi     a3, a3, 1                    # Vai para o próximo caracter
	j        .somaNumeroDecimal

.somaNumeroDecimal:

	lb       t0, 0(a3)                    # Leitura do primeiro byte

	beq      t0, t2, .operacaoMatematica  # Se o valor for de espaço, cheguei na operação matemática

	beq      t0, t1, .fimOperacao         # Se for quebra de linha, cheguei no final da operação

	addi     t0, t0, -'0'                 # Converte para inteiro

	mul      t4, t4, t6                   # Multiplica pela casa que se encontra

	add      t4, t4, t0                   # Soma

	addi     a3, a3, 1                    # Avança para o próximo caracter

	j        .somaNumeroDecimal

.operacaoMatematica:

	addi     a3, a3, 1                    # Avança para o próximo caracter

	mul      a4, t4, s3                   # Já que o primeiro número pode ser negativo

	lb       a5, 0(a3)                    # Operador

	addi     a3, a3, 2                    # Avança para o próximo número, já pulando o espaço

	jal      .converteNumero              # Avança para o segundo número

.fimOperacao:

	mul      a6, t4, s3                   # Já que o segundo número pode ser negativo

	li       t6, '-'                      # Subtração
	beq      a5, t6, .subtracao

	li       t6, '+'                      # Soma
	beq      a5, t6, .soma

	li       t6, '*'                      # Multiplicação
	beq      a5, t6, .multiplicacao

	li       t6, '/'                      # Divisão
	beq      a5, t6, .divisao

	addi     a0, a4, '0'

.imprimeResultado:
	beqz     a4, .imprimeZero             # Se o resultado for zero

	li       s10, 0                        # flag: 0=positivo, 1=negativo
	bltz     a4, .resultadoNegativo
	j        .resultadoNaoNegativo

.resultadoNegativo:
	li       s10, 1
	sub      a4, zero, a4                 # a4 = -a4 (fica positivo para converter dígitos)

.resultadoNaoNegativo:

# Escreve dígitos de trás pra frente no bufferAuxiliar
	la       t0, bufferAuxiliar           # Ponteiro de escrita (aux)
	li       t2, 0                        # Contador de dígitos
	li       t3, 10                       # base 10
	mv       t5, a4                       # Cópia do número

.converteLoop:
	rem      t6, t5, t3
	addi     t6, t6, '0'
	sb       t6, 0(t0)
	addi     t0, t0, 1
	addi     t2, t2, 1
	div      t5, t5, t3
	bnez     t5, .converteLoop

# Copia invertendo para bufferEntrada (ficar em ordem correta)
	la       t0, bufferAuxiliar           # Último dígito gravado -1
	addi     t3, t2, -1
	add      t0, t0, t3

	la       t1, bufferEntrada            # Destino final

# Se for negativo, escreve '-' antes dos dígitos
	beqz     s10, .copiaReverso
	li       t4, '-'
	sb       t4, 0(t1)
	addi     t1, t1, 1

.copiaReverso:
	lb       t4, 0(t0)
	sb       t4, 0(t1)
	addi     t1, t1, 1
	addi     t0, t0, -1
	addi     t2, t2, -1
	bnez     t2, .copiaReverso

	li       t4, '\n'
	sb       t4, 0(t1)                    # Adiciona '\n'
	addi     t1, t1, 1

	la       a0, bufferEntrada
	sub      a1, t1, a0                   # O tamanho da saída, contando a quebra de linha

	j        .chamaPrint

.imprimeZero:
	la       t1, bufferEntrada
	li       t4, '0'
	sb       t4, 0(t1)
	li       t4, '\n'
	sb       t4, 1(t1)
	la       a0, bufferEntrada
	li       a1, 2

.chamaPrint:
	call     escritaSaida
	ret

.subtracao:

	sub      a4, a4, a6                   # Subtrai o segundo valor do primeiro
	call     .imprimeResultado

.soma:

	add      a4, a4, a6                   # Soma o segundo valor ao primeiro
	call     .imprimeResultado

.multiplicacao:

	mul      a4, a4, a6                   # Multiplica o segundo valor com o primeiro
	call     .imprimeResultado

.divisao:

	div      a4, a4, a6                   # Divide o primeiro valor pelo segundo
	call     .imprimeResultado

# Função principal do programa
main:

	call     leituraEntrada               # Leitura da entrada até o '\n'

	la       t0, bufferEntrada            # endereço do buffer onde leituraEntrada escreveu

	lb       s1, 0(t0)

	call     leituraEntrada               # Leitura da entrada até o '\n'

	la       a0, bufferEntrada            # Desloca o endereço da entrada

	li       s2, '1'                      # Caso 01
	beq      s1, s2, .callcaso01          # Chama a função do primeiro caso

	li       s2, '2'                      # Caso 02
	beq      s1, s2, .callcaso02          # Chama a função do segundo caso

	li       s2, '3'                      # Caso 03
	beq      s1, s2, .callcaso03          # Chama a função do terceiro caso

	li       s2, '4'                      # Caso 04
	beq      s1, s2, .callcaso04          # Chama a função do quarto caso

.callcaso01:
	call     caso01
	ret

.callcaso02:
	call     caso02
	ret

.callcaso03:
	call     caso03
	ret

.callcaso04:
	call     caso04
	ret

.final:
	ret                                   # Fim!
