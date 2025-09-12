# Preciso armazenar a entrada em um buffer que estará na seção .bss (dedicada ao armazenamento de dados não inicializados).

.section .bss

# Buffer: aloca 20 bytes, já que é o tamanho máximo da entrada (conta a pulada de linha final).

buffer:
    .skip 20

# Prontooo! Agora temos o buffer (área em que vou guardar temporariamente a minha entrada) alocado. Isso signfica que eu posso sair da seção .bss.

# A próxima seção é a .text, onde fica o código do programa.

.section .text

# A diretiva ".globl leitura" transforma o símbolo "leitura" em global, ou seja, ele pode ser acessado por outros arquivos.

.globl leitura

# A função de "leitura" busca ler a entrada do programa e armazená-la no buffer.

leitura:
    li   a0, 0  # STDIN = 0 (entrada padrão)
    la   a1, buffer # Buffer onde a entrada será armazenada
    li   a2, 20 # Número máximo de bytes a serem lidos
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

# A diretiva ".globl extracao_numero" transforma o símbolo "extracao_numero" em global, ou seja, ele pode ser acessado por outros arquivos.

.globl extracao_numero

# A função "extracao_numero" extrai o número da string armazenada no buffer e o converte para um valor inteiro.

extracao_numero:

    li   a0, 0 # Inicializa o registrador a0 com 0 (onde o número final será armazenado)

    lbu t0, 0(a1) # Leitura do primeiro caractere da string (coloca em um registrador temporário)
    addi t0, t0, -'0' # Converte o caractere ASCII para um inteiro
    mul t0, t0, 1000 # Multiplica o valor por 1000 (primeiro dígito)
    add a0, a0, t0 # Adiciona o valor ao registrador a0(soma)

    lbu t0, 1(a1) # Leitura do segundo caractere da string (coloca em um registrador temporário)
    addi t0, t0, -'0' # Converte o caractere ASCII para um inteiro
    mul t0, t0, 100 # Multiplica o valor por 100 (segundo dígito)
    add a0, a0, t0 # Adiciona o valor ao registrador a0(soma)

    lbu t0, 2(a1) # Leitura do terceiro caractere da string (coloca em um registrador temporário)
    addi t0, t0, -'0' # Converte o caractere ASCII para um inteiro
    mul t0, t0, 10 # Multiplica o valor por 10 (terceiro dígito)
    add a0, a0, t0 # Adiciona o valor ao registrador a0(soma)

    lbu t0, 3(a1) # Leitura do quarto caractere da string (coloca em um registrador temporário)
    addi t0, t0, -'0' # Converte o caractere ASCII para um inteiro
    mul t0, t0, 1 # Multiplica o valor por 1 (quarto dígito)
    add a0, a0, t0 # Adiciona o valor ao registrador a0(soma)

    ret # Retorna da função, sendo a0 o lugar que vai estar armazenado o número final

# A diretiva ".globl raiz_quadrada" transforma o símbolo "raiz_quadrada" em global, ou seja, ele pode ser acessado por outros arquivos.

.globl raiz_quadrada

# A função "raiz_quadrada" calcula a raiz quadrada do número armazenado em a0 e retorna o resultado em a0.

raiz_quadrada:
    










# A diretiva ".globl main" transforma o símbolo "main" em global, ou seja, ele pode ser acessado por outros arquivos.

.globl main

# A função "main" chama as outras funções e finaliza o programa.

main: 
    call leitura # Chama a função de leitura
    call escrita # Chama a função de escrita
    li   a7, 10 # Código do serviço de saída
    ecall # Chamada de sistema