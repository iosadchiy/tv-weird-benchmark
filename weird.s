	.file	"weird.c"
	.text
	.globl	NLOCKS
	.section	.rodata
	.align 4
	.type	NLOCKS, @object
	.size	NLOCKS, 4
NLOCKS:
	.long	100000000
	.local	global_var
	.comm	global_var,4,4
	.comm	lock,40,32
	.comm	tid,16,16
	.text
	.globl	doSmt
	.type	doSmt, @function
doSmt:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$192, %rsp
	movq	%rdi, -184(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-184(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -164(%rbp)
	call	pthread_self@PLT
	movq	%rax, -160(%rbp)
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %eax
	movl	$16, %edx
	movq	%rsi, %rdi
	movq	%rdx, %rcx
	rep stosq
	movl	-164(%rbp), %eax
	cltq
	movq	%rax, -152(%rbp)
	cmpq	$1023, -152(%rbp)
	ja	.L3
	movq	-152(%rbp), %rax
	shrq	$6, %rax
	leaq	0(,%rax,8), %rdx
	leaq	-144(%rbp), %rcx
	addq	%rcx, %rdx
	movq	(%rdx), %rdx
	movq	-152(%rbp), %rcx
	andl	$63, %ecx
	movl	$1, %esi
	salq	%cl, %rsi
	movq	%rsi, %rcx
	leaq	0(,%rax,8), %rsi
	leaq	-144(%rbp), %rax
	addq	%rsi, %rax
	orq	%rcx, %rdx
	movq	%rdx, (%rax)
.L3:
	leaq	-144(%rbp), %rdx
	movq	-160(%rbp), %rax
	movl	$128, %esi
	movq	%rax, %rdi
	call	pthread_setaffinity_np@PLT
	movl	$0, -168(%rbp)
	jmp	.L4
.L5:
	leaq	lock(%rip), %rdi
	call	pthread_mutex_lock@PLT
	movl	global_var(%rip), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	movl	%eax, global_var(%rip)
	leaq	lock(%rip), %rdi
	call	pthread_mutex_unlock@PLT
	addl	$1, -168(%rbp)
.L4:
	movl	$100000000, %eax
	cmpl	%eax, -168(%rbp)
	jl	.L5
	movl	$0, %eax
	movq	-8(%rbp), %rdi
	xorq	%fs:40, %rdi
	je	.L7
	call	__stack_chk_fail@PLT
.L7:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	doSmt, .-doSmt
	.section	.rodata
.LC0:
	.string	"Usage: ./weird 1 OR ./weird 2"
.LC1:
	.string	"\n mutex init failed"
.LC2:
	.string	"\ncan't create thread"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$2, -36(%rbp)
	je	.L9
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
	movl	$1, %eax
	jmp	.L14
.L9:
	movq	-48(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -12(%rbp)
	movl	$0, %esi
	leaq	lock(%rip), %rdi
	call	pthread_mutex_init@PLT
	testl	%eax, %eax
	je	.L11
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	movl	$1, %eax
	jmp	.L14
.L11:
	movl	$0, -20(%rbp)
	leaq	-20(%rbp), %rax
	movq	%rax, %rcx
	leaq	doSmt(%rip), %rdx
	movl	$0, %esi
	leaq	tid(%rip), %rdi
	call	pthread_create@PLT
	testl	%eax, %eax
	je	.L12
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
.L12:
	cmpl	$1, -12(%rbp)
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -16(%rbp)
	leaq	-16(%rbp), %rax
	movq	%rax, %rcx
	leaq	doSmt(%rip), %rdx
	movl	$0, %esi
	leaq	8+tid(%rip), %rdi
	call	pthread_create@PLT
	testl	%eax, %eax
	je	.L13
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
.L13:
	movq	tid(%rip), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	movq	8+tid(%rip), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	leaq	lock(%rip), %rdi
	call	pthread_mutex_destroy@PLT
	movl	$0, %eax
.L14:
	movq	-8(%rbp), %rdx
	xorq	%fs:40, %rdx
	je	.L15
	call	__stack_chk_fail@PLT
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (GNU) 8.1.1 20180531"
	.section	.note.GNU-stack,"",@progbits
