	.section .text

# Inicia a leitura das coordenadas (0 quando parar a leitura)
	.set     acionaGPS, 0xFFFF0100

# Armazena o eixo X da última posição do carro
	.set     eixoX, 0xFFFF0110

# Armazena o eixo Y da última posição do carro
	.set     eixoY, 0xFFFF0114

# Armazena o eixo Z da última posição do carro
	.set     eixoZ, 0xFFFF0118

# Define a direção do volante ( - = e + = d )
	.set     direcaoVolante, 0xFFFF0120

# Define a direção do motor
	.set     direcaoMotor, 0xFFFF0121

# Define o freio de mão
	.set     freioMao, 0xFFFF0122

# Função que verifica se a distância é menor que 15
	.globl   verificaDistancia


verificaDistancia:
# t1 = eixo X
# t2 = eixo Y
# t3 = eixo Z

# t4 = eixo X final
# t5 = eixo Y final
# t6 = eixo Z final

# s1 = distância máxima = 225

	sub      s2, t1, t4                 #(X - Xo)
	mul      s2, s2, s2                 #(X - Xo) * (X - Xo)

	sub      s3, t2, t5                 #(Y - Yo)
	mul      s3, s3, s3                 #(Y - Yo) * (Y - Yo)

	sub      s4, t3, t6                 #(Z - Zo)
	mul      s4, s4, s4                 #(Z - Zo) * (Z - Zo)

	add      s2, s2, s3
	add      s2, s2, s4

	blt      s2, s1, .chegou         # Distância menor que 15 m

.chegou:
	li       a0, 0                      # Código de saída
	li       a7, 93                     # Serviço de saída
	ecall
