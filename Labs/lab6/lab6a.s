# Preciso armazenar a entrada em um buffer que estará na seção .bss (dedicada ao armazenamento de dados não inicializados).

.section .bss

# Buffer: aloca 21 bytes, já que é o tamanho máximo da entrada (conta a pulada de linha final).

buffer:
    .skip 21

# Prontooo! Agora temos o buffer (área em que vou guardar temporariamente a minha entrada) alocado. Isso signfica que eu posso sair da seção .bss.

# A próxima seção é a .text, onde fica o código do programa.

.section .text

# A diretiva ".globl leitura" transforma o símbolo "leitura" em global, ou seja, ele pode ser acessado por outros arquivos.

.globl leitura

# A função de "leitura" busca ler a entrada do programa e armazená-la no buffer.

leitura:
    li   a0, 0  # STDIN = 0 (entrada padrão)
    la   a1, buffer # Buffer onde a entrada será armazenada
    li   a2, 21 # Número máximo de bytes a serem lidos
    li   a7, 63 # Código do serviço de leitura
    ecall # Chamada de sistema

# A diretiva ".globl escrita" transforma o símbolo "escrita" em global, ou seja, ele pode ser acessado por outros arquivos.

.globl escrita

# A função de "escrita" busca escrever a saída do programa, que está armazenada no buffer.

escrita:
    mv   t0, a0 # Copia o valor do registrador a0 (número de bytes lidos) para t0
    li   a0, 1 # STDOUT = 1 (saída padrão)
    la   a1, buffer # Carrega o endereço do buffer para o registrador a1
    mv   a2, t0 # Move o valor de t0 (número de bytes lidos) para o registrador a2
    li   a7, 64 # Código do serviço de escrita
    ecall # Chamada de sistema

# A diretiva ".globl main" transforma o símbolo "main" em global, ou seja, ele pode ser acessado por outros arquivos.

.globl main

# A função "main" chama as outras funções e finaliza o programa.

main: 
    call leitura # Chama a função de leitura
    call escrita # Chama a função de escrita
    li   a7, 10 # Código do serviço de saída
    ecall # Chamada de sistema