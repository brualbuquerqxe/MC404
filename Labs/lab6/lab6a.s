# Preciso armazenar a entrada em um buffer que estará na seção .bss (dedicada ao armazenamento de dados não inicializados).

.section .bss

# Buffer: aloca 20 bytes, já que é o tamanho máximo da entrada (conta a pulada de linha final).
buffer:
    .skip 20

# Prontooo! Agora temos o buffer (área em que vou guardar temporariamente a minha entrada) alocado. Isso signfica que eu posso sair da seção .bss.

# A próxima seção é a .text, onde fica o código do programa.

.section .text

.globl leitura

# A função de "leitura" busca ler a entrada do programa e armazená-la no buffer.
leitura:
    li   a0, 0  # STDIN = 0 (entrada padrão)
    la   a1, buffer # Buffer onde a entrada será armazenada
    li   a2, 20 # Número máximo de bytes a serem lidos
    li   a7, 63 # Código do serviço de leitura
    ecall # Chamada de sistema
    ret # Retorna da função, sendo a0 o lugar que vai estar armazenado o número de bytes lidos

.globl escrita

# A função de "escrita" busca escrever a saída do programa, que está armazenada no buffer.
escrita:
    mv   t0, a0 # Copia o valor do registrador a0 (número de bytes lidos) para t0
    li   a0, 1 # STDOUT = 1 (saída padrão)
    la   a1, buffer # Carrega o endereço do buffer para o registrador a1
    mv   a2, t0 # Move o valor de t0 (número de bytes lidos) para o registrador a2
    li   a7, 64 # Código do serviço de escrita
    ecall # Chamada de sistema
    ret # Retorna da função, sendo a0 o lugar que vai estar armazenado o número de bytes escritos

.globl repeticao_conversao_int

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

.globl raiz_quadrada

raiz_quadrada:

    beqz a0, rq_zero        # se n == 0
    li   t1, 1
    beq  a0, t1, rq_one     # se n == 1

    li t6, 2 # Carrega o valor 2 no registrador t6
    div a2, a0, t6 # Divide o número por 2 para obter uma aproximação inicial (k)
    li s1, 10 # Número de iterações para melhorar a precisão

iteracoes_raiz:
    div s2, a0, a2 # Divide o número pelo valor atual de k
    add a2, a2, s2 # Soma k com o resultado da divisão
    div a2, a2, t6 # Divide a soma por 2 para obter a nova aproximação (novo k)
    addi s1, s1, -1 # Decrementa o contador de iterações
    bnez s1, iteracoes_raiz # Se ainda houver iterações restantes, repete o processo

    mv a0, a2 # Move o valor final da raiz quadrada para a0

    ret # Retorna da função, sendo a2 o lugar que vai estar armazenado a raiz quadrada final

rq_zero:
    mv   a0, x0
    ret
rq_one:
    li   a0, 1
    ret

.globl int_to_string

int_to_string:
    li   t5, 1000
    divu t0, a0, t5
    remu a0, a0, t5
    addi t0, t0, '0'
    sb   t0, 0(a1)

    li   t5, 100
    divu t0, a0, t5      
    remu a0, a0, t5
    addi t0, t0, '0'
    sb   t0, 1(a1)

    li   t5, 10
    divu t0, a0, t5      
    remu a0, a0, t5
    addi t0, t0, '0'
    sb   t0, 2(a1)

    addi t0, a0, '0'     
    sb   t0, 3(a1)

    addi a1, a1, 4       # retorna destino avançado
    ret

# A diretiva ".globl main" transforma o símbolo "main" em global, ou seja, ele pode ser acessado por outros arquivos.

.globl main

# A função "main" chama as outras funções e finaliza o programa.
main: 
    call leitura # Chama a função de leitura

    la a1, buffer # Carrega o endereço do buffer no registrador a1
    call repeticao_conversao_int # Chama a função de extração do número

    call raiz_quadrada # Chama a função de cálculo da raiz quadrada

    la a1, buffer # Carrega o endereço do buffer no registrador a1
    call int_to_string # Chama a função de conversão de inteiro para string

    li a0, 4 # Número de bytes a serem escritos (4 dígitos)
    call escrita # Chama a função de escrita

    # FIM
    li a0, 0 # Saída com código 0
    li a7, 10 # Código do serviço de saída
    ecall