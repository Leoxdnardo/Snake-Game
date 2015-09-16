.data
vet: .word 0: 8

msg_pedido0: 	.asciiz "Entre com o tamanho do vetor (1, 8]:\n"
msg_erro: 	.asciiz "Valor inválido.\n"

msg_pedido1:	 .asciiz "Entre com os valores para o vetor:\n"

msg_vet_comeco: .asciiz "vet["
msg_vet_fim:	.asciiz "] = "

msg_informacao: .asciiz "Os novos valores dentro do vetor são:\n"

msg_nova_linha: .asciiz "\n"

.text	
VALIDACAO:
	li $v0, 4 		# print string
	la $a0, msg_pedido0 	# carrega a string no argumento
	syscall

	li $v0, 5 		# read integer
	syscall
	add $s0, $zero, $v0 	# $s0 agora tem o valor lido do usuário
	
	li $s1, 1 		# valor mínimo
	li $s2, 8 		# valor máximo

	# se valor for maior que 1 e maior que ou igual a 8 então sai da validação
	sgt $t0, $s0, $s1
	sle $t1, $s0, $s2
	and $s3, $t0, $t1
	bne $s3, $zero, EXIT_VALIDACAO
	
	# reclama que o usuário colocou um valor diferente do pedido
	li $v0, 4 		# print string
	la $a0, msg_erro	# carrega a string no argumento
	syscall
	j VALIDACAO 		# volta pro começo da validação
	
EXIT_VALIDACAO:
	li $v0, 4 		# print string
	la $a0, msg_pedido1 	# carrega a string no argumento
	syscall

	# $s0 agora tem a quantidade de elementos que o usuário escolheu
	# $s1 guarda a posicao atual do loop
	# $s2 contem a posicao inicial do vet
	li $s1, 0
	la $s2, vet

# percorre o vetor e o enche com valores inseridos pelo usuário	
LOOP0:
	li $v0, 4 		# print string
	la $a0, msg_vet_comeco 	# carrega a string no argumento
	syscall
	
	li $v0, 1 		# print integer
	add $a0, $zero, $s1
	syscall
	
	li $v0, 4 		# print string
	la $a0, msg_vet_fim 	# carrega a string no argumento
	syscall
	
	li $v0, 5 		# read integer
	syscall			# ($v0 = integer entrada pelo usuário)
	
	# multiplica o valor atual do loop por 4
	add $t0, $zero, $s1
	add $t0, $t0, $t0	# $t0 = $t0 * 2
	add $t0, $t0, $t0	# $t0 = $t0 * 2
	
	add $t1, $s2, $t0	# $t1 guarda a posicao do vetor
	
	sw $v0, 0 ($t1)

	addi $s1, $s1, 1 	# $s1++
	
	bge $s1, $s0, EXIT_LOOP0
	j LOOP0

EXIT_LOOP0:

	li $s1, 0
# percorre o vetor e onde tiver valor impar, remove 1 dele
LOOP1:	
	# multiplica o valor atual do loop por 4
	add $t0, $zero, $s1
	add $t0, $t0, $t0	# $t0 = $t0 * 2
	add $t0, $t0, $t0	# $t0 = $t0 * 2
	
	add $t1, $s2, $t0	# $t1 guarda a posicao do vetor
	
	lw $t2, 0 ($t1)		# $t2 guarda o valor contido no vetor na posicao
	
	andi $t3, $t2, 1	# $t3 guarda a resposta se é impar
	
	beqz $t3, EXIT_IMPAR	# se $t2 for par então pula a parte de diminuir de impar 
	
# IMPAR
	subi $t2, $t2, 1	# diminui 1
	sw $t2, 0 ($t1)		# salva de volta no vetor

EXIT_IMPAR:
	addi $s1, $s1, 1 	# $s1++
	
	bge $s1, $s0, EXIT_LOOP1
	j LOOP1

EXIT_LOOP1:

	li $v0, 4 		# print string
	la $a0, msg_informacao 	# carrega a string no argumento
	syscall

	li $s1, 0
# percorre o vetor falando os valores dele
LOOP2:	
	li $v0, 4 		# print string
	la $a0, msg_vet_comeco 	# carrega a string no argumento
	syscall
	
	li $v0, 1 		# print integer
	add $a0, $zero, $s1
	syscall
	
	li $v0, 4 		# print string
	la $a0, msg_vet_fim 	# carrega a string no argumento
	syscall
	
	# multiplica o valor atual do loop por 4
	add $t0, $zero, $s1
	add $t0, $t0, $t0	# $t0 = $t0 * 2
	add $t0, $t0, $t0	# $t0 = $t0 * 2
	
	add $t1, $s2, $t0	# $t1 guarda a posicao do vetor
	
	lw $t2, 0 ($t1) 	# carrega o valor do vetor na posicao
	
	# imprime o valor
	li $v0, 1
	add $a0, $t2, $zero
	syscall
	
	li $v0, 4 		# print string
	la $a0, msg_nova_linha
	syscall
	
	addi $s1, $s1, 1 	# $s1++
	
	bge $s1, $s0, EXIT_LOOP2
	j LOOP2

EXIT_LOOP2:
