# Seção para dados não inicializados.
	.section  .bss

bufferEntrada:
	.skip     7                        # Pode ter sinal ou não

bufferSaida:
	.skip     5                        # O máximo de nós é 1000

bufferLinha:
	.skip     2                        # Adiciona comando que pula linha

# Seção que está com o código e as funções.
	.section  .text

	.globl    _start

	.globl    puts

	.globl    gets

	.globl    atoi

	.globl    linked_list_search

	.globl    exit

# Inicia o programa a partir do rótulo "_start".
_start:
	call      main
	li        a0, 0                    # Código de saída
	li        a7, 93                   # Serviço de saída
	ecall

# Função que escreve a saída e adicona um caracter a mais de "\n"
puts:
	li        t2, 0                    # Contador

.checa_fim:
# Endereço = a0
	lw        t1, 0 (a0)               # Carrega o caracter
	beq       t1, zero, .fim1          # Encontrou "\0"
	addi      t2, t2, 1                # Aumenta o contador
	addi      a0, a0, 1                # Próximo caracter
	j         .checa_fim
.fim1:
	addi      t2, t2, 1                # Contador considera o "\n"
	li        t3, '\n'                 # Caracter que pula linha
	sw        t3, 0(a0)                # Troca o "\0" por "\n"
	sw        zero, 1(a0)              # Adiciona o "\0" no final
	sub       a0, a0, t2               # Volta o ponteiro para o início
.escreve:
	li        a0, 1                    # Saída STDOUT
	la        a1, bufferSaida          # Endereço do buffer
	mv        a2, t2                   # Número de bytes
	li        a7, 64                   # Chamada de escrita
	ecall                              # Chama sistema
	ret

# Armazena a entrada até a aparição de um caracter de nova linha
gets:
	li        t1, 0                    # Contador
	li        t2, '\n'                 # Caracter de nova linha
.semPulaLinha:
	lw        t3, 0(a0)                # Carrega o caracter
	addi      t1, t1, 1                # Aumenta o contador
	beq       t3, t2, .fim2            # Encontrou o caracter de nova linha
	beq       t3, zero, .fim2          # Encontrou o caracter de fim
	addi      a0, a0, 1                # Próximo caracter
	j         .semPulaLinha
.fim2:
	sw        zero, 0(a0)              # Adiciona o "\0"
	sub       a0, a0, t1               # Volta o ponteiro para o início
	ret

# Converte string para inteiro
atoi:
	li        t0, 0                    # Soma final
	li        t1, 0                    # Contador de números
	li        t2, '-'                  # Negativo
	li        t3, '+'                  # Positivo
	li        t4, 1                    # Multiplicador
.converteInt:
	lw        t5, 0(a0)                # Lê caracter

	beq       t5, t2, .negativo        # Se for negativo
	beq       t5, t3, .segue           # Se for positivo

	li        t6, '0'
	blt       t5, t6, .naoNumero       # Não é número
	li        t6, '9'
	blt       t6, t5, .naoNumero       # Não é número
.ENumero:
	li        t6, 10                   #Multiplicador
	mul       t0, t0, t6               # Multiplica a soma atual por 10
	addi      t5, t5, -'0'             # Converte para número
	add       t0, t0, t5               # Soma o número
.segue:
	addi      a0, a0, 1                # Próximo caracter
	j         .converteInt
	naoNumero
	beqz      t1, .segue
	mul       a0, t0, t4               # Aplica o sinal
	ret
.negativo:
	li        t4, -1                   # Muda para negativo
	j         .segue

# Procura na lista ligada o valor dado
linked_list_search:
	li        t5, 0                    # Contador de nós
.loopLista:
	lw        t1, 0(a0)                # Primeiro valor da soma
	lw        t2, 4(a0)                # Segundo valor da soma

	add       t3, t1, t2               # Soma os dois valores

	beq       t3, a1, .valorEncontrado

	lw        t4, 8(a0)                # Próximo nó
	beqz      t4, .fimLista            # Se for nulo, fim da lista

	addi      t5, t5, 1                # Aumenta o contador
	mv        a0, t4                   # Próximo nó
	j         .loopLista

.valorEncontrado:
	mv        a0, t5                   # Retorna o contador de nós
	ret
.fimLista:
	li        a0, -1                   # Valor não encontrado
	ret


exit:
	li        a0, 0                    # Código de saída
	li        a7, 93                   # Serviço de saída
	ecall