
# Seção com as instâncias não inicializadas
	.section .bss

# Imagem
bufferImagem:
	.skip    262144                     # Maior tamanho possível da imagem (512 X 512)

# Informações básicas da imagem
bufferCabecalho:
	.skip    15                         # Serão 15 caracteres

# Seção com o código principal e as funções
	.section .text

	.globl   _start

	.globl   open

	.globl   leituraCabecalho

	.globl   leituraImagem

	.globl   extracaoLarguraCabecalho

	.globl   extracaoAlturaCabecalho

	.globl   extracaoMaxCinzaCabecalho

	.globl   defineCorPixel

	.globl   criacaoImagem

	.globl   close

	.globl   setPixel

	.globl   setCanvasSize

	.globl   setScaling


# Inicia o programa a partir do rótulo "_start".
_start:
	call     main
	li       a0, 0                      # Código de saída
	li       a7, 93                     # Serviço de saída
	ecall

# Abre o arquivo com a imagem
open:
	la       a0, input_file             # address for the file path
	li       a1, 0                      # flags (0: rdonly, 1: wronly, 2: rdwr)
	li       a2, 0                      # mode
	li       a7, 1024                   # syscall open
	ecall
	ret
input_file:
	.asciz   "image.pgm"

# Leitura do cabecalho
leituraCabecalho:
	mv       a0, s0                     # Leitura da imagem
	la       a1, bufferCabecalho        # Onde a entrada será armazenada
	li       a2, 15                     # Número de bytes que serão lidos
	li       a7, 63                     # read
	ecall                               # Chama sistema
	ret

extracaoLarguraCabecalho:
# Largura da imagem
	li       t1, 0                      # Primeiro dígito da largura/ comprimento
	li       s1, 0                      # Armazena largura
	li       t2, 100
	li       t3, 10
	addi     t4, a1, 3                  # Endereço do buffer
	li       t5, 3                      # 3 Dígitos
for1:
	addi     t4, t4, 1                  # Endereço do caractere atual
	lbu      t0, 0(t4)                  # Leitura do primeiro caractere da string
	addi     t0, t0, -'0'               # Converte o caractere ASCII para um inteiro
	mul      t0, t0, t2                 # Multiplica o valor pelo multiplicador
	add      s1, t0, s1                 # Armazena a largura
	div      t2, t2, t3
	addi     t1, t1, 1                  # i++ (adiciona no contador)
	bge      t1, t5, cont1              # Continua se o valor do contador for = 3
	j        for1                       # Continua o loop, caso contrário
cont1:
	mv       s2, s1                     # Largura = s2

extracaoAlturaCabecalho:
# Altura da imagem
	li       t1, 0                      # Primeiro dígito da largura/ comprimento
	li       s1, 0                      # Armazena largura
	li       t2, 100
	li       t3, 10
	addi     t4, a1, 7                  # Endereço do buffer
	li       t5, 3                      # 3 Dígitos
for2:
	addi     t4, t4, 1                  # Endereço do caractere atual
	lbu      t0, 0(t4)                  # Leitura do primeiro caractere da string
	addi     t0, t0, -'0'               # Converte o caractere ASCII para um inteiro
	mul      t0, t0, t2                 # Multiplica o valor pelo multiplicador
	add      s1, t0, s1                 # Armazena a largura
	div      t2, t2, t3
	addi     t1, t1, 1                  # i++ (adiciona no contador)
	bge      t1, t5, cont2              # Continua se o valor do contador for = 3
	j        for2                       # Continua o loop, caso contrário
cont2:
	mv       s3, s1                     # Altura = s3

extracaoMaxCinzaCabecalho:
# Máximo do cinza da imagem
	li       t1, 0                      # Primeiro dígito da largura/ comprimento
	li       s1, 0                      # Armazena largura
	li       t2, 100
	li       t3, 10
	addi     t4, a1, 11                 # Endereço do buffer
	li       t5, 3                      # 3 Dígitos
for3:
	addi     t4, t4, 1                  # Endereço do caractere atual
	lbu      t0, 0(t4)                  # Leitura do primeiro caractere da string
	addi     t0, t0, -'0'               # Converte o caractere ASCII para um inteiro
	mul      t0, t0, t2                 # Multiplica o valor pelo multiplicador
	add      s1, t0, s1                 # Armazena a largura
	div      t2, t2, t3
	addi     t1, t1, 1                  # i++ (adiciona no contador)
	bge      t1, t5, cont3              # Continua se o valor do contador for = 3
	j        for3                       # Continua o loop, caso contrário
cont3:
	mv       s4, s1                     # MaxVal = s4



# Definição da cor
defineCorPixel:
# Para definirmos a cor de um Pixel, precisamos concatear os valores de R G B e A, sendo que R = G = B e A = 255.
# Assim, teremos 32 bits!
# Vamos usar que s5 é a informação armazenada no meu bit.

	slli     s6, s5, 24                 # Left Shift do R
	slli     s7, s5, 16                 # Left Shift do G
	add      s6, s6, s7                 # Soma R com G
	slli     s7, s5, 8                  # Left Shift do B
	add      s6, s6, s7                 # Soma R + G + B
	addi     s6, s6, 255                # Finaliza somando A (Cor do Pixel = s6)

# Possibilita a visualização da imagem
criacaoImagem:
	li       t1, 0                      # Começo com a coordenada X = 0

	li       t2, 0                      # Começo com a coordenada Y = 0

	li       t3, 0                      # Começo com o contador da posição no buffer!

	mul      t4, s2, s3                 # O máximo de bytes da imagem (não é o máximo possível, se não vou ler lixo)!

	mv       t5, s2                     # O tamanho da linha

# Função que passa por todos os bytes que formam a imagem
passagemPelaImagem:
	li       s5, 0                      # Redefino a posição no buffer para 0!

	rem      t6, t3, t5                 # Calcula o resto da posição pelo comprimento da linha!

	beqz     t6, novaLinha              # Se o resto for igual a zero, significa que estamos em uma nova linha!

	j        mesmaLinha                 # Se o resto for diferente de zero, seguimos na mesma linha

	add      s5, a1, t3                 # Uso s5 para armazenar a posição no buffer do caracter que estou lendo (a1 = buffer)

	j        setPixel                   # Define a cor de cada Pixel

	addi     t3, t3, 1                  # Desloco uma pro lado no buffer (próximo Pixel)

	bge      t4, t3, passagemPelaImagem # Se ainda não li todos os bytes, volto para a função.


# Passa para uma nova linha!
novaLinha:

	li       t1, 0                      # Voltamos para a primeira coluna (X = 0)

	addi     t2, t2, 1                  # Descemos mais uma linha (Y = Y + 1)


# Continuo na mesma linha
mesmaLinha:

	addi     t1, t1, 1                  # Avançamos na largura da linha (X = X + 1)

# Leitura da imagem
leituraImagem:
	mv       a0, s0                     # Leitura da imagem
	la       a1, bufferImagem           # Onde a entrada será armazenada
	mv       a2, s5                     # Quantiade de bytes
	li       a7, 63                     # read
	ecall                               # Chama sistema
	ret

# Fecha o arquivo da imagem
close:
	mv       a0, s0                     # Identificador da imagem
	li       a7, 57                     # syscall close
	ecall


# Define a cor de cada Pixel!
setPixel:
	mv       a0, t1                     # Largura (eixo X)
	mv       a1, t2                     # Altura (eixo Y)
	mv       a2, s6                     # Cor do Pixel = s6
	li       a7, 2200                   # syscall setPixel (2200)
	ecall

# Redefine o tamanho da tela
setCanvasSize:
	mv       a0, s2                     # Largura da tela
	mv       a1, s3                     # Altura da tela
	li       a7, 2201                   # syscall setCanvasSize (2201)

# Inspeção da imagem
setScaling:
	li       a0, 1
	li       a1, 1
	li       a7, 2202

# Função principal
main:

# Abertura do arquivo da imagem
	call     open
	mv       s0, a0                     # Movimenta o endereço de abertura para não perder

# Leitura do cabecalho
	call     leituraCabecalho
	la       a1, bufferCabecalho        # Carrega o endereço de entrada em a1
	call     extracaoLarguraCabecalho   # Largura = s2
	call     extracaoAlturaCabecalho    # Altura = s3
	call     extracaoMaxCinzaCabecalho  # Max = s4

# Leitura da imagem
	mul      s5, s2, s3                 # Quantidade de Pixels (preciso fazer isso para não ficar esperando entrada)
	addi     s5, s5, 1                  # Já que temos o último espaço em branco
	call     leituraImagem
	la       a1, bufferImagem           # Carrega o buffer da imagem em a1

# Criação da imagem!
	call     criacaoImagem

# Define o Canvas
	call     setCanvasSize

# Inspeção
	call     close

# Saída
	li       a0, 0                      # Código de saída
	li       a7, 93                     # Serviço de saída
	ecall