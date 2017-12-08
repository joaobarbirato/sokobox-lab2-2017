include ..\Irvine32.inc
; [x] Desenvolver o procedimento que imprime a tela do menu inicial.
; [x] Desenvolver o procedimento que imprime a tela sobre.
; [x] Desenvolver o procedimento que imprime a tela de instruções.
; [x] Desenvolver a tela de congratulações ao jogador.
; [x] Implementar a união entre as diversas telas presentes no jogo.
; [x] Definir a configuração de, no mínimo, três campos.
; [x] Desenvolver o procedimento que imprime um campo pré-definido na tela.
; [ ] Desenvolver o procedimento que trata da movimentação do personagem no campo, bem como incrementa a variável qtdMovimentos (2.2.5).
; [ ] Desenvolver a colisão entre jogador e caixa.
; [ ] Desenvolver a colisão com as paredes do campo.
; [ ] Desenvolver o procedimento que trata do movimento das caixas.
; [ ] Desenvolver o procedimento que atualiza a variável qtdCaixasPosicionadas (2.2.4), caso uma caixa entre no local desejado, ou saia do mesmo.
; [ ] Desenvolver o procedimento que, após todas as caixas estarem posicionadas em seus respectivos locais, passa para a próxima fase ou, caso seja a última fase, apresenta a tela de congratulações ao jogador.
; [ ] Desenvolver o procedimento que permita ao jogador reiniciar a fase para a sua configuração original.
; NOPE [ ] Desenvolver o procedimento que permita ao jogador iniciar um novo jogo, partindo da configuração inicial da primeira fase.
; [ ] Ligar novo jogo a tela de congatulações
; [ ] Testes.
; [ ] Correções de eventuais erros.



.data

posicao BYTE (?)

telaMenu BYTE "SOKOBAN", 10, 10
			  BYTE "(1) Novo Jogo", 10
			  BYTE "(2) Ajuda", 10
			  BYTE "(3) Sobre", 10
			  BYTE "(0) Sair", 10, 10, 0

telaSobre BYTE "Sobre", 10, 10
		  BYTE "Desenvolvido por:", 10
		  BYTE 9, "Joao Gabriel Melo Barbirato", 10
		  BYTE 9, "Nicholas Resende Franco de Oliveira Lopes", 10
		  BYTE 9, "Renata Sarmet Smiderle Mendes", 10, 10
		  BYTE "Disciplina:", 10
		  BYTE 9, "Laboratorio de Arquitetura e Organizacao de Computadores 2", 10, 10
		  BYTE "Disciplina:", 10
		  BYTE 9, "Luciano de Oliveira Neris", 10, 10
		  BYTE "(0) Voltar", 10, 0

telaAjuda BYTE "Ajuda", 10, 10
		  BYTE "'!' representa o personagem", 10
		  BYTE "'.' representa cada bloco do chao", 10
		  BYTE "'+' representa cada bloco das paredes", 10
		  BYTE "' ' representa o vazio", 10
		  BYTE "'o' representa as caixas", 10
		  BYTE "'X' representa os lugares para posicionar as caixas", 10
		  BYTE "'O' representa as caixas ja posicionadas nos locais demarcaados", 10, 10
		  BYTE "O objetivo e posicionar todas as caixas nos locais demarcados!", 10, 10, 10
		  BYTE "(0) Voltar", 10, 0

telaCongratuacoes BYTE "Parabens", 10, 10
		  BYTE "Voce ganhou!", 10, 10
		  BYTE "Press any button", 10, 0

campo BYTE 101 dup (?) 
campoAtual BYTE 1
localOcupado BYTE 0
qtdMovmento BYTE 0
qtdCaixas BYTE 0
qtdCaixasPosicionadas BYTE 0

; TODO: resolver esse char 10d (fazer lógica de pular linha)

; posicao = 65d ou 41h
primeiroCampo BYTE "          "
			  BYTE "          "
			  BYTE "   +++    "
			  BYTE "   +x+    "
			  BYTE "   +.++++ "
			  BYTE " +++o.ox+ "
			  BYTE " +x.o!+++ "
			  BYTE " ++++o+   "
			  BYTE "    +x+   "
			  BYTE "    +++   ", 0

; posicao = 21d ou 15h
segundoCampo  BYTE "          "
			  BYTE "+++++     "
			  BYTE "+!..+     "
			  BYTE "+.oo+ +++ "
			  BYTE "+.o.+ +x+ "
			  BYTE "+++.+++x+ "
			  BYTE " ++....x+ "
			  BYTE " +...+..+ "
			  BYTE " +...++++ "
			  BYTE " +++++    ", 0

; posicao = 52d ou 34h
terceiroCampo BYTE "          "
			  BYTE "          "
			  BYTE " +++++++  "
			  BYTE " +.....+++"
			  BYTE "++o+++...+"
			  BYTE "+.!.o..o.+"
			  BYTE "+.xx+.o.++"
			  BYTE "++xx+...+ "
			  BYTE " ++++++++ "
			  BYTE "          ", 0


.code

imprimeTela PROTO
jogoLoop PROTO
atualizaCampoAtual PROTO

main PROC
	; Iniciar Menu
menuPrincipal:
	invoke Clrscr
	mov edx, OFFSET telaMenu
	invoke WriteString

espereImputMenuPrincipal:
	mov eax, 250
	invoke Delay
	invoke ReadKey
	jz espereImputMenuPrincipal
									; TODO: desaparecer o numero entrado pelo usuario
	cmp al, 31h						; ir para (1) NovoJogo
	je novoJogo
	cmp al, 32h						; ir para (2) Ajuda
	je Ajuda
	cmp al, 33h						; ir para (3) Sobre
	je Sobre
	cmp al, 30h
	je Sair
	jmp menuPrincipal

Sobre:
	invoke Clrscr					; Limpe a tela
	mov edx, OFFSET telaSobre 		; Escrever o texto da tela sobre
	invoke WriteString

espereImputSobre:
	invoke ReadKey
	jz espereImputSobre

	cmp al, 30h
	je menuPrincipal
	jmp Sobre

Ajuda:
	invoke Clrscr					; Limpe a tela
	mov edx, OFFSET telaAjuda 		; Escrever o texto da tela sobre
	invoke WriteString

espereImputAjuda:
	invoke ReadKey
	jz espereImputAjuda

	cmp al, 30h
	je menuPrincipal
	jmp Sobre

novoJogo:
	call jogoLoop
	jmp menuPrincipal

espereImputJogo:
	invoke ReadKey
	jz espereImputJogo

	cmp al, 30h
	je Sair
	jmp novoJogo

Sair:
	invoke Clrscr
	exit
main ENDP

; atualiza a variavel campo
atualizaCampoAtual PROC uses edx
	mov ecx, 0						; loop
AtualizaL1:
	mov al, [edx+ecx]
	mov campo[ecx], al				; move _campo pra campo
	inc ecx
	cmp ecx, 100
	jnz AtualizaL1

	ret
atualizaCampoAtual ENDP

; imprime um campo
imprimeTelaJogo PROC 				; uses campo
	mov ecx, 0						;
ImprimeL1:
	call Crlf
	mov esi, 0
ImprimeL2:
	;int 3
	mov al, campo[ecx]				; move campo pra writechar
	call WriteChar
	inc esi
	inc ecx
	cmp ecx, 100
	jz ImprimeSair
	cmp esi, 10
	jz ImprimeL1
	jmp ImprimeL2

ImprimeSair:
	call Crlf
	call Crlf
	call Crlf
	ret
imprimeTelaJogo ENDP


jogoLoop PROC

resetarJogo:
	mov qtdMovmento, 0
	mov qtdCaixasPosicionadas, 0
	mov eax, campoAtual
	cmp eax, 1
	jz Campo1
	cmp eax, 2
	jz Campo2
	jmp Campo3

campo1:
	mov edx, OFFSET primeiroCampo
	mov posicao, 65d
	mov qtdCaixas, 4
	call atualizaCampoAtual
	jmp LoopEvento

campo2:
	mov edx, OFFSET segundoCampo
	mov posicao, 65d
	mov qtdCaixas, 3
	call atualizaCampoAtual
	jmp LoopEvento

campo3:
	mov edx, OFFSET terceiroCampo
	mov posicao, 65d
	mov qtdCaixas, 4
	call atualizaCampoAtual

loopEvento:
	invoke Clrscr
	call imprimeTelaJogo
	call ReadKey					; input

espereEntrada:
	mov eax, 250
	invoke Delay
	invoke ReadKey
	jz espereEntrada

	cmp al, 30h						; menu principal
	jz saidaJogoLoop
	cmp al, 31h
	jz resetarJogo

	call movimenta

saidaJogoLoop:
	ret
jogoLoop ENDP

movimenta PROC	
	cmp dx, VK_LEFT					; esquerda
	jz moveEsquerda
	cmp dx, VK_UP					; cima
	jz moveCima
	cmp dx, VK_RIGHT				; direita
	jz moveDireita
	cmp dx, VK_DOWN					; baixo
	jz moveBaixo
	jmp movimentoInvalido

moveEsquerda:
	mov al, campo[posicao-1]
	cmp al, 43d					
	jz movimentoInvalido
	cmp al, 111d
	jz movimentaCaixaEsquerda
	cmp al, 88d
	jz movimentaCaixaEsquerda
									; + (parede) 43d
									; . (chao) 46d
									; o (caixa) 111d
									; x (posicao certa sem caixa) 120d
									; X (caixa na posicao certa) 88d
movimentaCaixaEsquerda:
	mov ah, campo[posicao-2]
	cmp ah, 43d
	jz movimentoInvalido
	cmp ah, 111d
	jz movimentoInvalido
	cmp ah, 88d
	jz movimentoInvalido


	cmp ah, 46d						; programação orientada a go to
	jz movimentaCaixaEsquerdaChao
	mov bl, localOcupado
	cmp bl, 1
	jz localOcupadoEsquerda
	mov campo[posicao], 46d
	cmp al, 88d
	jz localOcupadoEsquerdaMantem
	mov localOcupado, 0
	jmp localOcupadoEsquerdaMantem


localOcupadoEsquerda:
	mov campo[posicao], 111d
	cmp al, 88d
	jz localOcupadoEsquerdaMantem 
	mov localOcupado, 0
	jmp localOcupadoEsquerdaMantem

localOcupadoEsquerdaMantem:
	mov campo[posicao-1], 33d		; !
	mov campo[posicao-2], 88d
	jmp fimMovimento

movimentaCaixaEsquerdaChao:
	mov bl, localOcupado
	cmp bl, 1
	jz localOcupadoEsquerdaChao

localOcupadoEsquerdaChao:

	

moveDireita:

moveBaixo:

moveCima:





fimMovimento:

movimentoInvalido:
	ret
movimenta ENDP


END main
