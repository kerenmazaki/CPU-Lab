.data 
	i: .word 1 
	j: .word 2
	g: .word 3
	h: .word 4
	f: .word 5
.text
	lw $t1,0
	lw $t2,4
	lw $t3,8
	lw $t4,12
	slt $t0,$t1,$t2
	sub $t4, $t3, $t2
	mul $t4, $t3, $t2
	lui $t6, 100
	and $t4,$t3,$t2	
	or $t4,$t3,$t2
	xor $t4,$t3,$t2
	sll $t4,$t3,3
	srl $t4,$t2,2
	sw $t4,12
	addi $t4,$t3,5
	andi $t4,$t3,5
	ori $t4,$t3,5
	xori $t4,$t3,5
	slti $t4,$t3,1
TWO:	add $t5,$t3,$t4
ONE:	jal IF
	j THREE
	add $t5,$t3,$t4
IF:	move $t5,$t3 
	jr $ra
THREE:	bne $t0,$t1,END 
ELSE:  	sub $t5,$t3,$t4 
END: 	sw $t5,f	
