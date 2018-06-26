	.file	"weird.c"
	.text
	.globl	n_cycles
	.data
	.align 4
	.type	n_cycles, @object
	.size	n_cycles, 4
n_cycles:
	.long	10000000
	.globl	mode
	.bss
	.align 4
	.type	mode, @object
	.size	mode, 4
mode:
	.zero	4
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
	movl	global_var(%rip), %eax
	addl	$1, %eax
	movl	%eax, global_var(%rip)
	leaq	lock(%rip), %rdi
	call	pthread_mutex_unlock@PLT
	addl	$1, -168(%rbp)
.L4:
	movl	-168(%rbp), %edx
	movl	n_cycles(%rip), %eax
	cmpl	%eax, %edx
	jb	.L5
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
	.align 8
.LC0:
	.string	"Usage: ./weird <n_cycles> <up|smp>"
.LC1:
	.string	"up"
.LC2:
	.string	"\n mutex init failed"
.LC3:
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
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$3, -20(%rbp)
	je	.L9
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
	movl	$1, %eax
	jmp	.L16
.L9:
	movq	-32(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, n_cycles(%rip)
	movq	-32(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	leaq	.LC1(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L11
	movl	$1, %eax
	jmp	.L12
.L11:
	movl	$2, %eax
.L12:
	movl	%eax, mode(%rip)
	movl	$0, %esi
	leaq	lock(%rip), %rdi
	call	pthread_mutex_init@PLT
	testl	%eax, %eax
	je	.L13
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movl	$1, %eax
	jmp	.L16
.L13:
	movl	$0, -16(%rbp)
	leaq	-16(%rbp), %rax
	movq	%rax, %rcx
	leaq	doSmt(%rip), %rdx
	movl	$0, %esi
	leaq	tid(%rip), %rdi
	call	pthread_create@PLT
	testl	%eax, %eax
	je	.L14
	leaq	.LC3(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
.L14:
	movl	mode(%rip), %eax
	cmpl	$1, %eax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -12(%rbp)
	leaq	-12(%rbp), %rax
	movq	%rax, %rcx
	leaq	doSmt(%rip), %rdx
	movl	$0, %esi
	leaq	8+tid(%rip), %rdi
	call	pthread_create@PLT
	testl	%eax, %eax
	je	.L15
	leaq	.LC3(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
.L15:
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
.L16:
	movq	-8(%rbp), %rdx
	xorq	%fs:40, %rdx
	je	.L17
	call	__stack_chk_fail@PLT
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (GNU) 8.1.1 20180531"
	.section	.note.GNU-stack,"",@progbits
