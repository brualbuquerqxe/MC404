# Seção para dados não inicializados.
	.section .bss

bufferEntrada:
	.skip    120                        # Pode ter sinal ou não

bufferSaida:
	.skip    120

# Seção que está com o código e as funções.
	.section .text

	.globl   puts

	.globl   gets

	.globl   atoi

	.globl   itoa

	.globl   recursive_tree_search

	.globl   exit

# Função que escreve a saída e adicona um caracter a mais de "\n"
puts:
	li       t2, 0                      # Contador
	mv       t0, a0                     # Salva o endereço inicial
.checa_fim:
# Endereço = t0
	lb       t1, 0 (t0)                 # Carrega o caracter
	beq      t1, zero, .fim1            # Encontrou "\0"
	addi     t2, t2, 1                  # Aumenta o contador
	addi     t0, t0, 1                  # Próximo caracter
	j        .checa_fim
.fim1:
	li       t3, '\n'                   # Caracter que pula linha
	sb       t3, 0(t0)                  # Troca o "\0" por "\n"
	sb       zero, 1(t0)                # Adiciona o "\0" no final
	sub      t0, t0, t2                 # Volta o ponteiro para o início
.escreve:
	li       a0, 1                      # Saída STDOUT
	mv       a1, t0                     # Endereço do buffer
	addi     a2, t2, 1                  # Número de bytes
	li       a7, 64                     # Chamada de escrita
	ecall                               # Chama sistema
	ret

# Armazena a entrada até a aparição de um caracter de nova linha
gets:
	mv       t0, a0                     # Ponteiro para o início do buffer
	li       t1, 0                      # Contador
	li       t2, '\n'                   # Caracter de nova linha

.leituraCaracter:
	li       a0, 0                      # Entrada STDIN
	add      a1, t0, t1                 # Ponteiro para o início do buffer
	li       a2, 1                      # Número de bytes que serão lidos
	li       a7, 63                     # Chamada de leitura
	ecall                               # Chama sistema

.continuaLeitura:
	beqz     a0, .fim2                  # Chegou em '/0'

	lb       t3, 0(a1)                  # Carrega o caracter
	beq      t3, t2, .fim2              # Encontrou o caracter de nova linha
	addi     t1, t1, 1                  # Próximo caracter

	j        .leituraCaracter

.fim2:
	sb       zero, 0(a1)                # Adiciona o "\0"
	mv       a0, t0                     # Retorna o ponteiro inicial
	ret

# Converte string para inteiro
atoi:
	li       t0, 0                      # Soma final
	li       t1, 0                      # Contador de números
	li       t2, '-'                    # Negativo
	li       t3, '+'                    # Positivo
	li       t4, 1                      # Multiplicador

.converteInt:
	lb       t5, 0(a0)                  # Lê caracter

	beqz     t5, .fim3

	beq      t5, t2, .negativo1         # Se for negativo
	beq      t5, t3, .segue             # Se for positivo

	li       t6, '0'
	blt      t5, t6, .naoNumero         # Não é número
	li       t6, '9'
	blt      t6, t5, .naoNumero         # Não é número

.ENumero:
	addi     t1, t1, 1                  # Conta o número de dígitos
	li       t6, 10                     #Multiplicador
	mul      t0, t0, t6                 # Multiplica a soma atual por 10
	addi     t5, t5, -'0'               # Converte para número
	add      t0, t0, t5                 # Soma o número

.segue:
	addi     a0, a0, 1                  # Próximo caracter
	j        .converteInt

.naoNumero:
	beqz     t1, .segue
	mul      a0, t0, t4                 # Aplica o sinal
	ret

.negativo1:
	li       t4, -1                     # Muda para negativo
	j        .segue

.fim3:
	mul      a0, t0, t4                 # aplica sinal
	ret


# Converte inteiro para string
itoa:
	mv       t0, a0                     # Valor do nó

	mv       t1, a1                     # Onde escrever

	mv       t6, a1                     # Guarda ponteiro inicial
	mv       t2, a2                     # Base do número

	li       t3, 0                      # Se for negativo, t3 = 1

	li       t5, 10
	bne      t2, t5, .converte          # se base for 16, pula o tratamento de sinal

	blt      t0, zero, .negativo2
	j        .converte

.negativo2:
	li       t5, -1                     # Indica que é negativo
	mul      t0, t0, t5                 # Inverte o valor
	li       t3, 1                      # Indica ser negativo

.converte:
.loop:
	rem      t4, t0, t2                 # t4 = Resto
	div      t0, t0, t2                 # t0 = Divisão

# converte resto para caractere ASCII
	li       t5, 10
	blt      t4, t5, .digito            # É um dígito!
	addi     t4, t4, -10
	addi     t4, t4, 'A'                # letras maiúsculas A–F
	j        .grava

.digito:
	addi     t4, t4, '0'                # Converte para ASCII

.grava:
	sb       t4, 0(t1)                  # Escreve caractere
	addi     t1, t1, 1                  # Avança o ponteiro
	bnez     t0, .loop                  # Repete até valor zerar

	beqz     t3, .naoNegativo           # Se não for negativo, pula

	li       t4, '-'                    # Adiciona o sinal de negativo
	sb       t4, 0(t1)
	addi     t1, t1, 1
.naoNegativo:
	sb       zero, 0(t1)                # Adiciona "\0" no final

.inverteNumero:
	addi     t1, t1, -1                 # Ponteiro para último caractere válido
	mv       t2, t6                     # t2 = início
.reverte:
	bge      t2, t1, .fim
	lb       t4, 0(t2)                  # Troca caracteres
	lb       t5, 0(t1)
	sb       t5, 0(t2)
	sb       t4, 0(t1)
	addi     t2, t2, 1
	addi     t1, t1, -1
	j        .reverte

.fim:
	mv       a0, t6                     # Retorno: ponteiro original da string
	ret

# Busca recursiva na árvore binária
recursive_tree_search:
	li       t3, 1                      # Contador de nível
	li       t4, 0                      # Encontrei?
	mv       fp, sp                     # Frame pointer da pilha (ínicio)
.loop2:
	beqz     a0, .fimArvore             # Se o nó for nulo, cheguei no fim

	lw       t0, 0(a0)                  # Valor do nó
	lw       t1, 4(a0)                  # Filho esquerdo
	lw       t2, 8(a0)                  # Filho direito

	beq      a1, t0, .acabouDeEncontrar # Acheii!

# Se existir direita e vou pra esquerda, preciso empilhar a direita e o nível do pai
	beqz     t1, .checaDireita          # Se o esquerdo for nulo, olho apenas a direita
	beqz     t2, .desceEsquerda         # Se tem esquerda, desce na esquerda
	addi     sp, sp, -8
	sw       t3, 0(sp)                  # salva nível do nó do pai
	sw       t2, 4(sp)                  # Salva ponteiro do direito (vai descer pra lá direto depois)
	j        .desceEsquerda

.checaDireita:
# Não tem esquerdo: se tiver direito, vai para .desceDireita; senão, backtrack
	beqz     t2, .fimArvore             # Se o direito também for nulo, cheguei no fim da árvore
	j        .desceDireita

.desceEsquerda:
	mv       a0, t1                     # vai para a esquerda
	addi     t3, t3, 1                  # nível++
	j        .loop2

.desceDireita:
# Aqui SEMPRE estamos indo para o filho direito do nó cujo nível está em t3 (pai)
	mv       a0, t2                     # vai para a direita
	addi     t3, t3, 1                  # nível++
	j        .loop2

.fimArvore:
	beq      sp, fp, .naoEncontrou      # Se chegou na base da pilha (fp), não achou

# Desempilha (nível do pai, ponteiro do direito) e desceDireita
	lw       t3, 0(sp)                  # nível do pai
	lw       t2, 4(sp)                  # ponteiro do direito
	addi     sp, sp, 8
	j        .desceDireita              # usa o mesmo caminho de descida direita

.acabouDeEncontrar:
	li       t4, 1                      # Mostra que já encontrou
	mv       a0, t3                     # Resposta será o nível atual
	ret

.naoEncontrou:
	li       a0, 0                      # Resposta será zero
	ret


# Finaliza o programa
exit:
	li       a0, 0                      # Código de saída
	li       a7, 93                     # Serviço de saída
	ecall
