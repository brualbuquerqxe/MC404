	.data
	.globl my_var           # Declaração de variável global
my_var:
	.word  10               # Inicialização da variável

	.text
	.globl increment_my_var

# Incrementa 1 na variável
increment_my_var:
	la     a0, my_var       # Endereço da variável global
	lw     a1, 0(a0)        # Carrega o valor da variável
	addi   a1, a1, 1
	sw     a1, 0(a0)
	ret