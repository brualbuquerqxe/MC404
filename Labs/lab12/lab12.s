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

# Função que configura o carro para andar para frente
	.globl   preparaVeiculo

# Prepara o carro para se deslocar
preparaVeiculo:

	li       a0, acionaGPS              # Extrai o endereço para acionar o GPS ( = 1)
	li       a1, 1                      # Ativa a configuração
	sb       a1, 0(a0)                  # GPS ativado

	li       a0, direcaoMotor           # Extrai o endereço para acionar o motor ( = 1)
	sb       a1, 0(a0)                  # Para frente, sempre!

	li       a0, freioMao               # Extrai o endereço para desativar o freio de mão ( = 0)
	li       a1, 0                      # Desativa a configuração
	sb       a1, 0(a0)                  # Freio de mão desativado

	ret                                 # Carro já configurado para andar

verificaDistancia:
	li       a0, eixoX
	lw       t1, 0(a0)                  # Carrega a coordenada no eixo X

	li       a0, eixoY
	lw       t2, 0(a0)                  # Carrega a coordenada no eixo Y

	li       a0, eixoZ
	lw       t3, 0(a0)                  # Carrega a coordenada no eixo Z

	li       t4, 73                     # t4 = eixo X final
	li       t5, 1                      # t5 = eixo Y final
	li       t6, -19                    # t6 = eixo Z final

	li       s1, 225                    # s1 = distância máxima = 225

	sub      s2, t1, t4                 #(X - Xo)
	mul      s2, s2, s2                 #(X - Xo) * (X - Xo)

	sub      s3, t2, t5                 #(Y - Yo)
	mul      s3, s3, s3                 #(Y - Yo) * (Y - Yo)

	sub      s4, t3, t6                 #(Z - Zo)
	mul      s4, s4, s4                 #(Z - Zo) * (Z - Zo)

	add      s2, s2, s3
	add      s2, s2, s4

	blt      s2, s1, .fim               # Distância menor que 15 m

.fim:

	li       a0, acionaGPS              # Extrai o endereço para acionar o GPS ( = 0)
	li       a1, 0                      # Desativa a configuração
	sb       a1, 0(a0)                  # GPS ativado

	li       a0, direcaoMotor           # Extrai o endereço para acionar o motor ( = 0)
	sb       a1, 0(a0)                  # Para frente, sempre!

	li       a0, freioMao               # Extrai o endereço para desativar o freio de mão ( = 1)
	li       a1, 1                      # Desativa a configuração
	sb       a1, 0(a0)                  # Freio de mão desativado

	li       a0, 0                      # Código de saída
	li       a7, 93                     # Serviço de saída
	ecall
