# Seção para dados não incializados.
	.section .bss

bufferComando:
	.skip    3                        # Tamanho do comando

bufferEntrada:
	.skip    100000                   # Tamanho desconhecido

	.section .text

# Indica se será realizada a escrita do byte ( = 1)
	.set     comandoWrite, 0x00

# Indica se será realizada a leitura do byte ( = 1)
	.set     comandoRead, 0x02

# Endereço do byte que deve ser lido
	.set     enderecoLeitura, 0x01

# Função que inicia o programa
	.globl   _start

# Função que lê a entrada
	.globl   leituraEntrada

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
	ecall                             # Posso usar a chamada de exit

# Função de leitura
leituraEntrada:

	li       a0, comandoWrite         # Extrai o endereço para sinalizar a leitura ( = 1)
	li       a1, 1                    # Ativa a configuração
	sb       a1, 0(a0)                # Leitura ativada

	li       a2, enderecoLeitura      # Extrai o endereço do byte que deve ser lido

	li       t1, 0                    # Contador de caracter

	li       a4, '\n'                 # Simboliza a parada da leitura

.continuaLeitura:

	lb       a3, 0(a2)                # Carrega o byte que é lido

	la       a5, bufferEntrada        # Local que armazena a entrada

	add      a6, a5, t1               # Posição que o caracter deve ser gravado

	sb       a3, a6                   # Armazena o byte lido no buffer

	addi     t1, t1, 1                # Adiciona uma unidade no endereço do buffer

	bne      a3, a4, .continuaLeitura # Enquanto o caracter for diferente de '\n', leio

.fimLeitura:
	li       a1, 0                    # Desativa a configuração
	sb       a1, 0(a0)                # Leitura ativada

	ret                               # Encerra a leitura

# Função principal do programa
main:

	la       a5, bufferComando        # Salva o comando

	call     leituraEntrada           # Leitura da entrada até o '\n'
	lb       s1, 0(a5)                # Valor da instrução

	la       a5, bufferEntrada        # Salva a frase/ operação

	call     leituraEntrada           # Leitura da entrada até o '\n'

	mv       a2, t1                   # Quantidades de caracteres lidos

	li       s2, 1                    # Caso 01
	beq      s1, s2, caso01           # Chama a função do primeiro caso

	li       s2, 2                    # Caso 02
	beq      s1, s2, caso02           # Chama a função do segundo caso

	li       s2, 3                    # Caso 03
	beq      s1, s2, caso03           # Chama a função do terceiro caso

	li       s2, 4                    # Caso 04
	beq      s1, s2, caso04           # Chama a função do quarto caso

	ret                               # Fim!
