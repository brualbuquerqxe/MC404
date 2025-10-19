	.text
	.global fill_array_int
	.global fill_array_short
	.global fill_array_char


fill_array_int:

	addi    sp, sp, -404

	sw      ra, 400(sp)          # Guarda o endereço de retorno

	li      t0, 0                # Contador
	li      t1, 100              # Limite superior
	blt     t0, t1, .loop        # Se o contador for menor do que 100

.loop:
	slli    t2, t0, 2            # novo Endereço
	add     t3, sp, t2           # Endereço no array, já que cad aint são 4 bytes

	sw      t0, 0(t3)            # Carrega o valor no endereço

	addi    t0, t0, 1            # Aumenta o contador
	beq     t0, t1, .fim         # Se o contador chegar em 100, fim do array
	j    .loop                # Caso contrário, segue

.fim:
	mv      a0, sp               # Endereço do início do ponteiro
	call    mystery_function_int

	lw      ra, 400(sp)          # Carrega o endereço de retorno
	addi    sp, sp, 404          # Desempilha
	ret

fill_array_short:

	addi    sp, sp, -204

	sw      ra, 200(sp)          # Guarda o endereço de retorno

	li      t0, 0                # Contador
	li      t1, 100              # Limite superior
	blt     t0, t1, .loop2        # Se o contador for menor do que 100

.loop2:
	slli    t2, t0, 1            # novo Endereço
	add     t3, sp, t2           # Endereço no array, já que cad aint são 2 bytes

	sh      t0, 0(t3)            # Carrega o valor no endereço

	addi    t0, t0, 1            # Aumenta o contador
	beq     t0, t1, .fim2         # Se o contador chegar em 100, fim do array
	j    .loop2                # Caso contrário, segue

.fim2:
	mv      a0, sp               # Endereço do início do ponteiro
	call    mystery_function_short

	lw      ra, 200(sp)          # Carrega o endereço de retorno
	addi    sp, sp, 204          # Desempilha
	ret

fill_array_char:

	addi    sp, sp, -104

	sw      ra, 100(sp)          # Guarda o endereço de retorno

	li      t0, 0                # Contador
	li      t1, 100              # Limite superior
	blt     t0, t1, .loop3        # Se o contador for menor do que 100

.loop3:
	add     t3, sp, t0           # Endereço no array, já que cad aint são 2 bytes

	sb      t0, 0(t3)            # Carrega o valor no endereço

	addi    t0, t0, 1            # Aumenta o contador
	beq     t0, t1, .fim3         # Se o contador chegar em 100, fim do array
	j    .loop3                # Caso contrário, segue

.fim3:
	mv      a0, sp               # Endereço do início do ponteiro
	call    mystery_function_char

	lw      ra, 100(sp)          # Carrega o endereço de retorno
	addi    sp, sp, 104          # Desempilha
	ret