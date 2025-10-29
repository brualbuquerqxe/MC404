	.text

# Inicia a leitura das coordenadas (0 quando parar a leitura)
	.set  acionaGPS, 0xFFFF0100

# Armazena o eixo X da última posição do carro
	.set  eixoX, 0xFFFF0110

# Armazena o eixo Y da última posição do carro
	.set  eixoY, 0xFFFF0114

# Armazena o eixo Z da última posição do carro
	.set  eixoZ, 0xFFFF0118

# Define a direção do volante ( - = e + = d )
	.set  direcaoVolante, 0xFFFF0120

# Define a direção do motor
	.set  direcaoMotor, 0xFFFF0121

# Define o freio de mão
	.set  freioMao, 0xFFFF0122

