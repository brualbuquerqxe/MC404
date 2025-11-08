	.section .data

# Define o tempo total do sistema
_system_time:
	.word    0

	.section .bss

# Final da pilha de ISR
isrStackFinal:
	.skip    1024                             # Aloca 1024 bytes para a pilha

# Base da pilha de ISRs
isrStackBase:

# Final da pilha normal (que será usada de fato pelas funções)
pilhaNormalFinal:
	.skip    1024

# Base da pilha normal
pilhaNormalBase:

	.section .text

# Define a variável como global
	.globl   _system_time

# Define as funções como globais (acessadas do arquivo .c)

	.globl   _start
	
	.globl   ISR_principal

	.globl   play_note

# General purpose timer: inicia a leitura da hora atual do sistema (1 = começa a ler)
	.set     habilitaLeituraTempo, 0xFFFF0100

# General purpose timer: armazena o tempo da última leitura
	.set     armazenaTempo, 0xFFFF0104

# General purpose timer: armazena o tempo da interrupção (100 ms)
	.set     periodoInterrupcao, 0xFFFF0108

# MIDI: armazena o canal (faz tocar nota)
	.set     armazenaCh, 0xFFFF0300

# MIDI: identificação do instrumento
	.set     armazenaID, 0xFFFF0302

# MIDI: armazena a nota do instrumento
	.set     armazenaNota, 0xFFFF0304

# MIDI: armazena a velocidade
	.set     armazenaVel, 0xFFFF0305

# MIDI: armazena a duração
	.set     armazenaDur, 0xFFFF0306


_start:

# Grava o endereço da ISR principal no mtvec
	la       a0, ISR_principal
	csrw     mtvec, a0

# mscratch aponta para uma pilha alocada especialmente para as ISRs
	la       a0, isrStackBase                 # Base da pilha de ISR
	csrw     mscratch, a0                     # Registrador auxiliar com a base da pilha

# Direciona o ponteiro para a pilha que será de fato usado no programa (não a pilha ISR)
	la       sp, pilhaNormalBase

# Configuração dos periféricos presentes
	li       a0, 0
	li       a1, habilitaLeituraTempo         # Carrega o endereço
	sw       a0, 0(a1)                        # Começa desligado

	li       a1, armazenaTempo                # Contabiliza o tempo desde a última leitura
	sw       a0, 0(a1)                        # Começa em 0s

	li       a0, 100                          # Período entre as interrupções
	li       a1, periodoInterrupcao
	sw       a0, 0(a1)

# Habilita o tratamento de interrupções pela CPU
	li       a0, 0x8
	csrs     mstatus, a0

# Habilita o tratamento de interrupções externas pela CPU
	li       a0, 0x800
	csrs     mie, a0

	jal      main                             # Chama a função principal

ISR_principal:

# Salvar o contexto
	csrrw    sp, mscratch, sp                 # Salva o contexto na pilha da ISR
	addi     sp, sp, -64                      # Aloca espaço na pilha da ISR
	sw       a0, 0(sp)                        # Salva contexto
	sw       a1, 4(sp)                        # Salva contexto


# Trata a interrupção
	li       t0, 1                            # Habilita a leitura do tempo
	li       t1, habilitaLeituraTempo         # Endereço do habilitador do tempo
	sb       t0, 0(t1)

busy_waiting: # Espera o habilitador ser = 0 (quando passar os 100 ms, é desabilitado)
	lb       t0, 0(t1)                        # Carrega byte (verificar valor)
	bnez     t0, busy_waiting                 # Se entrar no loop, ainda está habilitado

	li       t1, armazenaTempo                # Lê o tempo que passou
	lw       t0, 0(t1)                        # Armazena o valor lido

	la       t1, _system_time                 # Endereço da variável global _system_time
	sw       t0, (t1)                         # Copia o tempo para a variável global _system_time

	li       t0, 100
	li       t1, periodoInterrupcao
	sw       t0, (t1)                         # Guardando 100 no periodoInterrupcao de novo (saiu depois que desativou)

# Recupera o contexto
	lw       a1, 4(sp)                        # Recupera a1
	lw       a0, 0(sp)                        # Recupera a0
	addi     sp, sp, 64                       # Desaloca espaço da pilha da ISR
	csrrw    sp, mscratch, sp                 # Troca sp com mscratch novamente
	mret                                      # Retorno da interrupção

play_note:

	addi     sp, sp, -4                       # Armazena o endereço de retorno na pilha
	sw       ra, 0(sp)

	li       s1, armazenaCh                   # Carrega o endereço
	sb       a0, 0(s1)                        # Armazena canal

	li       s1, armazenaID                   # Carrega o endereço
	sb       a1, 0(s1)                        # Armazena ID

	li       s1, armazenaNota                 # Carrega o endereço
	sb       a2, 0(s1)                        # Armazena nota

	li       s1, armazenaVel                  # Carrega a velocidade
	sb       a3, 0(s1)                        # Armazena a velocidade

	li       s1, armazenaDur                  # Carrega a duração
	sb       a4, 0(s1)                        # Armazena a duração

	lw       ra, 0(sp)                        # Recuperando o endereço de retorno
	addi     sp, sp, 4                        # Desempilha

	ret