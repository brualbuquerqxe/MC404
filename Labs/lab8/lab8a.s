
# Seção com as instâncias não inicializadas
	.section .bss

# Buffer com todas as informações da imagem
buffer:
	.skip    262159

# Seção com o código principal e as funções
	.section .text

	.globl   _start

	.globl   open

	.globl   leituraBuffer

	.globl   extracaoInformacoes

	.globl   defineCorPixel

	.globl   criacaoImagem

	.globl   pulaEspacos

	.globl   setCanvasSize

	.globl   close

# Inicia o programa a partir do rótulo _start.
_start:
	call     main
	li       a0, 0                   # Código de saída
	li       a7, 93                  # Serviço de saída
	ecall

# Abre o arquivo com a imagem
open:
	la       a0, input_file          # address for the file path
	li       a1, 0                   # flags (0: rdonly, 1: wronly, 2: rdwr)
	li       a2, 0                   # mode
	li       a7, 1024                # syscall open
	ecall
	ret

# Definição do arquivo
input_file:
	.asciz   "image.pgm"

# Definição da cor
defineCorPixel:
# s5: nível de cinza (0..255)
	slli     t0, s5, 24              # R << 24
	slli     t4, s5, 16              # G << 16
	or       t0, t0, t4              # R|G
	slli     t4, s5, 8               # B << 8
	or       t0, t0, t4              # R|G|B
	ori      s6, t0, 255             # A = 255 no byte menos significativo
	ret

# Possibilita a visualização da imagem
criacaoImagem:
	addi     sp, sp, -16
	sw       ra, 12(sp)
	sw       s7, 8(sp)

	mv       s7, a2
	li       t2, 0                   # Valor inicial do Y
# Faço um Loop de Y por fora (ou seja, mudança de linha)
.loopY:
	bge      t2, a6, .fim            # Se o valor da altura for igual altura = 0 (fim)

	li       t1, 0                   # Valor inicial do X
# Faço um Loop de X (ou seja, muda coluna)
.loopX:
# Se for igual a largura, singifica que tem que ir pra próxima linha
	bge      t1, a5, .proximaLinha

	add      t0, s7, t1
	add      t0, t0, t2
	mul      t4, t2, a5
	add      t0, s7, t4
	add      t0, t0, t1
	lbu      s5, 0(t0)

# Defina a cor do Pixel
	call     defineCorPixel

# Função de SetPixel (apaguei e estou usando direto)
	mv       a0, t1
	mv       a1, t2
	mv       a2, s6
	li       a7, 2200
	ecall

# Aumenta uma unidade (segue pra próxima coluna)
	addi     t1, t1, 1
	j        .loopX

.proximaLinha:
	addi     t2, t2, 1               # Aumenta o valor de Y
	j        .loopY

# Termina!
.fim:
	lw       s7, 8(sp)
	lw       ra, 12(sp)
	addi     sp, sp, 16
	ret

# Leitura do buffer com o cabeçalho e a imagem
leituraBuffer:
	mv       a0, s0                  # Leitura da imagem
	la       a1, buffer              # Onde a entrada será armazenada
	li       a2, 262159              # Número de bytes que serão lidos
	li       a7, 63                  # read
	ecall                            # Chama sistema
	ret

# Fecha o arquivo da imagem
close:
	mv       a0, s0                  # Identificador da imagem
	li       a7, 57                  # syscall close
	ecall
	ret

# Redefine o tamanho da tela
setCanvasSize:
	mv       a0, a5                  # Largura da tela
	mv       a1, a6                  # Altura da tela
	li       a7, 2201                # syscall setCanvasSize (2201)
	ecall
	ret

# Pula o que não é número
pulaEspacos:
	li       t2, 32                  # ' '
	li       t3, 9                   # '\t'
	li       t4, 10                  # '\n'
	li       t5, 13                  # '\r'
.pesq:
	add      a2, a1, t1
	lbu      t6, 0(a2)
	beq      t6, t2, .avanca
	beq      t6, t3, .avanca
	beq      t6, t4, .avanca
	beq      t6, t5, .avanca
	ret
.avanca:
	addi     t1, t1, 1
	j        .pesq

# Extrai as informações do cabeçalho da imagem
extracaoInformacoes:
	li       t2, 32                  # ' '
	li       t3, 9                   # '\t'
	li       t4, 10                  # '\n'
	li       t5, 13                  # '\r'

# PRIMEIRO CARACTERE (d1)
	add      a2, a1, t1
	lbu      s1, 0(a2)
	addi     t1, t1, 1               # Segue

# SEGUNDO CARACTERE (d2 ou whitespace)
	add      a2, a1, t1
	lbu      s2, 0(a2)
	addi     t1, t1, 1
	beq      s2, t2, fimInformacao1D
	beq      s2, t3, fimInformacao1D
	beq      s2, t4, fimInformacao1D
	beq      s2, t5, fimInformacao1D

# TERCEIRO CARACTERE (d3 ou whitespace)
	add      a2, a1, t1
	lbu      s3, 0(a2)
	addi     t1, t1, 1
	beq      s3, t2, fimInformacao2D
	beq      s3, t3, fimInformacao2D
	beq      s3, t4, fimInformacao2D
	beq      s3, t5, fimInformacao2D

# QUARTO CARACTERE (consome o whitespace após o 3º dígito)
	addi     t1, t1, 1
	call     fimInformacao3D

# Não é número
fimInformacao:
	ret

# 1 dígito
fimInformacao1D:
	addi     s1, s1, -'0'
	ret

# 2 dígitos
fimInformacao2D:
	li       t6, 10
	addi     s1, s1, -'0'
	addi     s2, s2, -'0'
	mul      s1, s1, t6
	add      s1, s1, s2
	ret

# 3 dígitos
fimInformacao3D:
	li       t6, 10
	addi     s1, s1, -'0'
	addi     s2, s2, -'0'
	addi     s3, s3, -'0'
	mul      s1, s1, t6              # (d1*10)
	add      s1, s1, s2              # (d1*10 + d2)
	mul      s1, s1, t6              # ((d1*10 + d2)*10)
	add      s1, s1, s3              # + d3
	ret

# Função principal
main:

# Abertura do arquivo da imagem
	call     open
	mv       s0, a0                  # Movimenta o endereço de abertura para não perder

# Leitura do cabecalho
	call     leituraBuffer
	la       a1, buffer              # Carrega o endereço de entrada em a1
	li       t1, 3                   # Percorre todo o buffer (pula o P5)
	call     pulaEspacos
	call     extracaoInformacoes     # Extrai a Largura
	mv       a5, s1                  # Largura = a5
	call     pulaEspacos
	call     extracaoInformacoes     # Extrai a Altura
	mv       a6, s1                  # Altura = a6
	call     pulaEspacos
	addi     t1, t1, 4

# Define o endereço da imagem
	add      a2, a1, t1

# Define o Canvas
	call     setCanvasSize

# Leitura da imagem
	mul      a3, a5, a6              # Quantidade de Pixels

# Criação da imagem!
	call     criacaoImagem

# Inspeção
	call     close

# Saída
	li       a0, 0                   # Código de saída
	li       a7, 93                  # Serviço de saída
	ecall