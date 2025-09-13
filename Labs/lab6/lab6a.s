# Preciso armazenar a entrada em um buffer que estará na seção .bss (dedicada ao armazenamento de dados não inicializados).

.section .bss

# Buffer: aloca 20 bytes, já que é o tamanho máximo da entrada (conta a pulada de linha final).
buffer:
    .skip 20

# Prontooo! Agora temos o buffer (área em que vou guardar temporariamente a minha entrada) alocado. Isso signfica que eu posso sair da seção .bss.

# A próxima seção é a .text, onde fica o código do programa e define as funções.

.section .text

.globl _start

.globl leitura

.globl escrita

.globl repeticao_conversao_int

.globl raiz_quadrada

.globl main

.globl int_to_string

# Inicia o programa a partir do rótulo "_start".
_start:
    call main
    li   a0, 0         # Código de saída
    li   a7, 93        # Serviço de saída
    ecall

# A função de "leitura" busca ler a entrada do programa e armazená-la no buffer.
leitura:
    li   a0, 0  # STDIN = 0 (entrada padrão)
    la   a1, buffer # Buffer onde a entrada será armazenada
    li   a2, 20 # Número máximo de bytes a serem lidos
    li   a7, 63 # Código do serviço de leitura
    ecall # Chamada de sistema
    ret # Retorna da função, sendo a0 o lugar que vai estar armazenado o número de bytes lidos

# A função de "escrita" busca escrever a saída do programa, que está armazenada no buffer.
escrita:
    mv   t0, a0 # Copia o valor do registrador a0 (número de bytes lidos) para t0
    li   a0, 1 # STDOUT = 1 (saída padrão)
    la   a1, buffer # Carrega o endereço do buffer para o registrador a1
    mv   a2, t0 # Move o valor de t0 (número de bytes lidos) para o registrador a2
    li   a7, 64 # Código do serviço de escrita
    ecall # Chamada de sistema
    ret # Retorna da função, sendo a0 o lugar que vai estar armazenado o número de bytes escritos

# A função "repeticao_conversao_int" extrai o número da string armazenada no buffer e o converte para um valor inteiro.
repeticao_conversao_int:
    li t2, 4 # Como são 4 algarismos na entrada, inicializa o contador com 4
    li a0, 0 # Inicializa o registrador a0 com 0 (onde o número final será armazenado)
    li t1, 1000 # Multiplicador inicial (1000 para o primeiro dígito)
    li t3, 0 # Inicializa o índice para percorrer a string
    li t4, 10 # Carrega o valor 10 no registrador t4

# A função "repeticao_extracao_numero" converte cada algarismo da string em um número inteiro.
repeticao_extracao_numero:
    add  t5, a1, t3 # Calcula o endereço do caractere atual
    lbu t0, 0(t5) # Leitura do primeiro caractere da string (coloca em um registrador temporário)
    addi t0, t0, -'0' # Converte o caractere ASCII para um inteiro
    mul t0, t0, t1 # Multiplica o valor pelo multiplicador (1000 para o primeiro dígito)
    add a0, a0, t0 # Adiciona o valor ao registrador a0(soma)

    addi t3, t3, 1 # Incrementa o índice para o próximo caractere
    addi t2, t2, -1 # Decrementa o contador
    div t1, t1, t4 # Atualiza o multiplicador (divide por 10 para o próximo dígito)

    bnez t2, repeticao_extracao_numero # Se o contador for maior que zero, repete o processo

    ret # Retorna da função, sendo a0 o lugar que vai estar armazenado o número final

# A função "raiz_quadrada" calcula a raiz quadrada inteira do número armazenado em a0.
raiz_quadrada:

    beqz a0, rq_zero        # Exceção quando o número for zero
    li   t1, 1
    beq  a0, t1, rq_one     # Exceção quando o número for um

    li t6, 2 # Carrega o valor 2 no registrador t6
    div a2, a0, t6 # Divide o número por 2 para obter uma aproximação inicial (k)

    li t2, 10 # Número de iterações para melhorar a precisão

# No livro estava falando de uma forma de chegar na raiz usando, no máximo, 10 iterações.
iteracoes_raiz:
    div t3, a0, a2 # Divide o número pelo valor atual de k (antes era s2)
    add a2, a2, t3 # Soma k com o resultado da divisão
    div a2, a2, t6 # Divide a soma por 2 para obter a nova aproximação (novo k)
    addi t2, t2, -1 # Decrementa o contador de iterações (antes era s1)
    bnez t2, iteracoes_raiz # Se ainda houver iterações restantes, repete o processo

    mv a0, a2 # Move o valor final da raiz quadrada para a0

    ret # Retorna da função, sendo a2 o lugar que vai estar armazenado a raiz quadrada final

# Exceção quando o número for zero
rq_zero:
    mv   a0, x0 # Retorna 0
    ret

# Exceção quando o número for um
rq_one:
    li   a0, 1 # Retorna 1
    ret

# A função "int_to_string" converte o número inteiro armazenado em a0 para uma string de 4 dígitos, armazenando-a no endereço apontado por a1.
int_to_string:
    li   t5, 1000 # Divisor inicial (1000 para o primeiro dígito)
    divu t0, a0, t5 # Divide o número pelo divisor
    remu a0, a0, t5 # Resto da divisão (atualiza a0 para o próximo dígito)
    addi t0, t0, '0' # Converte o dígito para caractere ASCII
    sb   t0, 0(a1) # Armazena o caractere na posição correta do buffer

    li   t5, 100 # Divisor para o segundo dígito
    divu t0, a0, t5 # Divide o número pelo divisor
    remu a0, a0, t5 # Resto da divisão (atualiza a0 para o próximo dígito)
    addi t0, t0, '0' # Converte o dígito para caractere ASCII
    sb   t0, 1(a1) # Armazena o caractere na posição correta do buffer

    li   t5, 10 # Divisor para o terceiro dígito
    divu t0, a0, t5 # Divide o número pelo divisor
    remu a0, a0, t5 # Resto da divisão (atualiza a0 para o próximo dígito)
    addi t0, t0, '0' # Converte o dígito para caractere ASCII
    sb   t0, 2(a1) # Armazena o caractere na posição correta do buffer

    addi t0, a0, '0' # Converte o dígito para caractere ASCII
    sb   t0, 3(a1) # Armazena o caractere na posição correta do buffer

    addi a1, a1, 4 # Avança o ponteiro de destino em 4 posições (precisa chegar no próximo bloco de 4 dígitos)
    ret

# A função "main" chama as outras funções e finaliza o programa.
main: 
    call leitura # Chama a função de leitura

    # === loop para processar os 4 números em-loco (no próprio buffer) ===
    # s0 = ponteiro de leitura (início de cada bloco de 4 dígitos)
    # s1 = ponteiro de escrita (mesmo endereço; sobrescreve com o resultado de 4 dígitos)

    li   s2, 4          # Contador de 4 números que serão processados
    la   s0, buffer     # Aponta para onde ler o primeiro número
    la   s1, buffer     # Aponta para onde escrever o primeiro número

# Início do loop para processar os 4 números
loop_quatronumeros:
    
    mv   a1, s0 # Move o ponteiro de leitura (s0) para a1

    call repeticao_conversao_int # Chama a função de extração do número

    call raiz_quadrada # Chama a função de cálculo da raiz quadrada

    mv   a1, s1 # Move o ponteiro de escrita (s1) para a1
    call int_to_string # Chama a função de conversão de inteiro para string

    addi s0, s0, 4 # Avança o ponteiro de leitura para o próximo número
    addi s1, s1, 4 # Avança o ponteiro de escrita para o próximo número

    # Decrementa contador; se acabou, sai; se não, pula o separador (' ' ou '\n') e continua
    addi s2, s2, -1     # <<< MUDANÇA: decrementa s2
    beqz s2, fim_loop   # <<< MUDANÇA: testa s2

    # Pula o espaço entre números (mantém o separador original da entrada)
    addi s0, s0, 1
    addi s1, s1, 1
    j    loop_impressao

loop_impressao:
    la   t1, buffer    # Aponta para o início do buffer
    li   t0, ' ' # Caractere de espaço
    sb   t0, 4(t1) # Espaço depois do primeiro número
    sb   t0, 9(t1) # Espaço depois do segundo número
    sb   t0, 14(t1) # Espaço depois do terceiro número
    li   t0, '\n' # Caractere de nova linha
    sb   t0, 19(t1) # Nova linha no final

    li a0, 20 # Número de bytes que vão ser escritos
    call escrita # Chama a função de escrita! Final!

    # Saída
    li a0, 0 # Código de saída
    li a7, 93 # Serviço de saída
    ecall