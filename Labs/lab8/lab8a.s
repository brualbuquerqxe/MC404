
# Seção com as instâncias não inicializadas
	.section .bss

# Imagem
bufferImagem:
	.skip    262159                    # Maior tamanho possível da imagem (512 X 512)

# Informações básicas da imagem
bufferCabecalho:
	.skip    15                        # Serão 15 caracteres

# Seção com o código principal e as funções
	.section .text

	.globl   _start

	.globl   open

	.globl   leituraCabecalho

	.globl   leituraImagem

	.globl   extracaoLarguraCabecalho

	.globl   extracaoAlturaCabecalho

	.globl   extracaoMaxCinzaCabecalho

	.globl   close

	.globl   setPixel


# Inicia o programa a partir do rótulo "_start".
_start:
	call     main
	li       a0, 0                     # Código de saída
	li       a7, 93                    # Serviço de saída
	ecall

# Abre o arquivo com a imagem
open:
	la       a0, input_file            # address for the file path
	li       a1, 0                     # flags (0: rdonly, 1: wronly, 2: rdwr)
	li       a2, 0                     # mode
	li       a7, 1024                  # syscall open
	ecall
input_file:
	.asciz   "image.pgm"

# Leitura do cabecalho
leituraCabecalho:
	li       a0, 0                     # Entrada padrão
	la       a1, bufferCabecalho       # Onde a entrada será armazenada
	li       a2, 15                    # Número de bytes que serão lidos
	li       a7, 63                    # read
	ecall                              # Chama sistema
	ret

# Extração das informações importantes do cabeçalho:

extracaoLarguraCabecalho:
# Largura da imagem
	li       t1, 0                     # Primeiro dígito da largura/ comprimento
	li       s1, 0                     # Armazena largura
	li       t2, 100
	li       t3, 10
	lw       t4, 3(a1)                 # Endereço do buffer
for:
	li       t5, 3                     # 3 Dígitos
	add      t4, t4, t1                # Endereço do caractere atual
	lbu      t0, 0(t4)                 # Leitura do primeiro caractere da string
	addi     t0, t0, -'0'              # Converte o caractere ASCII para um inteiro
	mul      t0, t0, t2                # Multiplica o valor pelo multiplicador
	add      s1, t0, s1                # Armazena a largura
	div      t2, t2, t3
	addi     t1, t1, 1                 # i++ (adiciona no contador)
	bge      t1, t5, cont              # Continua se o valor do contador for = 3
	j        for                       # Continua o loop, caso contrário
cont:
	mv       s2, s1                    # Largura = s2

extracaoAlturaCabecalho:
# Altura da imagem
	li       t1, 0                     # Primeiro dígito da largura/ comprimento
	li       s1, 0                     # Armazena largura
	li       t2, 100
	li       t3, 10
	lw       t4, 7(a1)                 # Endereço do buffer
for:
	li       t5, 3                     # 3 Dígitos
	add      t4, t4, t1                # Endereço do caractere atual
	lbu      t0, 0(t4)                 # Leitura do primeiro caractere da string
	addi     t0, t0, -'0'              # Converte o caractere ASCII para um inteiro
	mul      t0, t0, t2                # Multiplica o valor pelo multiplicador
	add      s1, t0, s1                # Armazena a largura
	div      t2, t2, t3
	addi     t1, t1, 1                 # i++ (adiciona no contador)
	bge      t1, t5, cont              # Continua se o valor do contador for = 3
	j        for                       # Continua o loop, caso contrário
cont:
	mv       s3, s1                    # Largura = s2

extracaoMaxCinzaCabecalho:
# Máximo do cinza da imagem
	li       t1, 0                     # Primeiro dígito da largura/ comprimento
	li       s1, 0                     # Armazena largura
	li       t2, 100
	li       t3, 10
	lw       t4, 11(a1)                # Endereço do buffer
for:
	li       t5, 3                     # 3 Dígitos
	add      t4, t4, t1                # Endereço do caractere atual
	lbu      t0, 0(t4)                 # Leitura do primeiro caractere da string
	addi     t0, t0, -'0'              # Converte o caractere ASCII para um inteiro
	mul      t0, t0, t2                # Multiplica o valor pelo multiplicador
	add      s1, t0, s1                # Armazena a largura
	div      t2, t2, t3
	addi     t1, t1, 1                 # i++ (adiciona no contador)
	bge      t1, t5, cont              # Continua se o valor do contador for = 3
	j        for                       # Continua o loop, caso contrário
cont:
	mv       s4, s1                    # Largura = s2



# Leitura da imagem
leituraImagem:
	li       a0, 0                     # Entrada padrão
	la       a1, bufferImagem          # Onde a entrada será armazenada
	li       a2, 20                    # Número de bytes que serão lidos
	li       a7, 63                    # read
	ecall                              # Chama sistema
	ret

# Fecha o arquivo da imagem
close:
	li       a0, 3                     # file descriptor (fd) 3
	li       a7, 57                    # syscall close
	ecall

input_file:
	.asciz   "image.pgm"

# Define a cor de cada Pixel!
setPixel:
	li       a0, 100                   # x coordinate = 100
	li       a1, 200                   # y coordinate = 200
	li       a2, 0xFFFFFFFF            # white pixel
	li       a7, 2200                  # syscall setPixel (2200)
	ecall

# Redefine o tamanho da tela
setCanvasSize:
	mv       a0, t1                    # Largura da tela
	mv       a1, t2                    # Altura da tela
	li       a7, 2201                  # syscall setCanvasSize (2201)

# Função principal
main:

# Leitura do cabecalho
	call     leituraCabecalho
	la       s0, bufferCabecalho       # Carrega o endereço de entrada em s0

