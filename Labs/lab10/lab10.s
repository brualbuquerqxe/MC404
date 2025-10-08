# Seção para dados não inicializados.
	.section .bss

bufferEntrada:
	.skip    7                 # Pode ter sinal ou não

bufferSaida:
	.skip    5                 # O máximo de nós é 1000

bufferLinha:
	.skip    2                 # Adiciona comando que pula linha

# Seção que está com o código e as funções.
	.section .text

	.globl   _start

	.globl   leituraEntrada

	.globl   escreveSaida

# Inicia o programa a partir do rótulo "_start".
_start:
	call     main
	li       a0, 0             # Código de saída
	li       a7, 93            # Serviço de saída
	ecall

# Leitura do número da entrada.
leituraEntrada:
	li       a0, 0             # Entrada STDIN
	la       a1, bufferEntrada # Local que armazena a entrada
	li       a2, 7             # Número de bytes que serão lidos
	li       a7, 63            # Chamada de leitura
	ecall                      # Chama sistema
	ret                        # Retorna

# Escrita da saída
escreveSaida:
	li       a0, 5             # Número de bytes
	mv       t0, a0            # Copia o número de bytes lidos para t0
	li       a0, 1             # Saída (STDOUT)
	la       a1, bufferSaida   # Carrega o endereço do buffer
	mv       a2, t0
	li       a7, 64            # Código do serviço de escrita
	ecall
	ret

# Função que escreve a saída e adicona um caracter a mais de "\n"
puts:
	li       a2, 5             # Número do bytes lidos
	li       a0, 1             # Saída (STDOUT)
	la       a1, bufferSaida   # Carrega o endereço do buffer
	li       a7, 64            # Código do serviço de escrita
	ecall

	la       a1, BufferLinha   # Carrega o endereço do buffer
	li       t0, '\n'          # Armazena o caracter que pula linha
	sb       t0, 0(a1)         # Move para o buffer

	li       a2, 1             # Número do bytes lidos
	li       a0, 1             # Saída (STDOUT)
	li       a7, 64            # Código do serviço de escrita
	ecall

	ret

