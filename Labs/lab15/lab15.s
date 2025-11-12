	.text
	.align 4

# Define a direção do volante ( - = e + = d )
	.set   direcaoVolante, 0xFFFF0120

# Define a direção do motor
	.set   direcaoMotor, 0xFFFF0121

# Define o freio de mão
	.set   freioMao, 0xFFFF0122

int_handler:

	csrr   t0, mcause                                                       # Leitura da causa da interrupção
	li     t1, 8                                                            # ECALL from U-mode
	bne    t1, t0, .end_int_handler

	/*     syscall_set_engine_and_steering */
	li     t2, 10                                                           # Carrega o ID da syscall
	beq    a7, t2, syscall_set_engine_and_steering                          # Liga o motor e regula a direção

	/*     syscall_set_hand_brake */
	li     t2, 11                                                           # Carrega o ID da syscall
	beq    a7, t2, syscall_set_hand_brake                                   # Ativa ou desativa o freio de mão

	/*     Se chegou aqui, não reconhece a syscall e recupera o contexto */
.end_int_handler:
	csrr   t0, mepc                                                         # load return address
	addi   t0, t0, 4                                                        # adds 4 to the return address (to return after ecall)
	csrw   mepc, t0                                                         # stores the return address back on mepc
	mret                                                                    # Recover remaining context (pc <- mepc)

	/*     syscall_set_engine_and_steering */
syscall_set_engine_and_steering:
	li     t3, direcaoMotor                                                 # Extrai o endereço para acionar o motor ( = 1)
	sb     a0, 0(t3)                                                        # Para frente, sempre!

	li     t4, direcaoVolante                                               # Extrai o endereço para deixar o volante reto
	sb     a1, 0(t4)                                                        # Freio de mão desativado

	j      .end_int_handler                                                 # Retorna do handler

	/*     syscall_set_hand_brake */
syscall_set_hand_brake:
	li     t3, freioMao                                                     # Extrai o endereço do freio de mão
	sb     a0, 0(t3)                                                        # Para frente, sempre!

	j      .end_int_handler                                                 # Retorna do handler


	.globl _start
_start:

	la     t0, int_handler                                                  # Load the address of the routine that will handle interrupts
	csrw   mtvec, t0                                                        # (and syscalls) on the register MTVEC to set the interrupt array.

	csrr   t1, mstatus                                                      # Atualiza o mstatus.MPP
	li     t2, 0x1800
	and    t1, t1, t2                                                       # Identificador do modo usuário
	csrw   mstatus, t1

	la     t0, user_main                                                    # Chama a função do usuário (endereço de entrada)
	csrw   mepc, t0

	mret                                                                    # Direciona o fluxo de execução


	.globl control_logic
control_logic:

	/*     Desativa o freio de mão */
	li     a7, 11                                                           # syscall_set_hand_brake
	li     a0, 0                                                            # Desativa o freio de mão
	ecall                                                                   # Executa a chamada do sistema

	/*     Liga o motor e regula a direção */
	li     a7, 10                                                           # syscall_set_engine_and_steering
	li     a0, 1                                                            # Para frente, sempre!
	li     a1, -15                                                          # Volante levemente virado para a esquerda
	ecall                                                                   # Executa a chamada do sistema

	ret                                                                     # Retorna, já que ele já está andando no ângulo certo!