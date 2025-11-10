	.text
	.align 4

int_handler:
###### Syscall and Interrupts handler ######

# <= Implement your syscall handler here

	csrr   t0, mepc        # load return address
	addi   t0, t0, 4       # adds 4 to the return address (to return after ecall)
	csrw   mepc, t0        # stores the return address back on mepc
	mret                   # Recover remaining context (pc <- mepc)


	.globl _start
_start:

	la     t0, int_handler # Load the address of the routine that will handle interrupts
	csrw   mtvec, t0       # (and syscalls) on the register MTVEC to set the interrupt array.

	csrr   t1, mstatus     # Atualiza o mstatus.MPP
	li     t2, 0x1800
	and    t1, t1, t2      # Identificador do modo usuário
	csrw   mstatus, t1

	la     t0, user_main   # Chama a função do usuário (endereço de entrada)
	csrw   mepc, t0

	mret                   # Direciona o fluxo de execução

	.globl control_logic
control_logic:
# implement your control logic here, using only the defined syscalls
