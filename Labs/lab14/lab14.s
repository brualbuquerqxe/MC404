	.section .text

# General purpose timer: inicia a leitura da hora atual do sistema
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