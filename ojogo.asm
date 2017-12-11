include ..\Irvine32.inc
; [x] Desenvolver o procedimento que imprime a tela do menu inicial.
; [x] Desenvolver o procedimento que imprime a tela sobre.
; [x] Desenvolver o procedimento que imprime a tela de instruções.
; [x] Desenvolver a tela de congratulações ao jogador.
; [x] Implementar a união entre as diversas telas presentes no jogo.
; [x] Definir a configuração de, no mínimo, três campos.
; [x] Desenvolver o procedimento que imprime um campo pré-definido na tela.
; [x] Desenvolver o procedimento que trata da movimentação do personagem no campo, bem como incrementa a variável qtdMovimentos (2.2.5).
; [x] Desenvolver a colisão entre jogador e caixa.
; [x] Desenvolver a colisão com as paredes do campo.
; [x] Desenvolver o procedimento que trata do movimento das caixas.
; [x] Desenvolver o procedimento que atualiza a variável qtdCaixasPosicionadas (2.2.4), caso uma caixa entre no local desejado, ou saia do mesmo.
; [x] Desenvolver o procedimento que, após todas as caixas estarem posicionadas em seus respectivos locais, passa para a próxima fase ou, caso seja a última fase, apresenta a tela de congratulações ao jogador.
; [x] Desenvolver o procedimento que permita ao jogador reiniciar a fase para a sua configuração original.
; NOPE [ ] Desenvolver o procedimento que permita ao jogador iniciar um novo jogo, partindo da configuração inicial da primeira fase.
; [x] Ligar novo jogo a tela de congatulações
; [x] Testes.
; [ ] Correções de eventuais erros.



.data

posicao DWORD ?														; Posição do jogador no mapa. posicao/10 = row, posicao%10 = column

telaMenu BYTE  10, 10, 9, 9, "SOKOBAN", 10, 10						; Menu Inicial
			  BYTE  9, 9, "(1) Jogar", 10						
			  BYTE  9, 9, "(2) Ajuda", 10
			  BYTE  9, 9, "(3) Sobre", 10
			  BYTE 	9, 9, "(0) Sair", 10, 10, 0


imprimeQtdMovimentos BYTE "Quantidade de movimentos: ", 0			

imprimeComandosEmJogo 	BYTE "Aperte 0 para voltar ao menu inicial", 10							; Imprime os comandos dentro da tela de jogo
						BYTE "Aperte 1 para retornar a configuracao inicial do campo", 10, 0

telaSobre BYTE 10, 10, 10, 9, 9, "Sobre", 10, 10					; Sobre
		  BYTE 9,9,"Desenvolvido por:", 10
		  BYTE 9,9,9, "Joao Gabriel Melo Barbirato", 10
		  BYTE 9,9,9, "Nicholas Resende Franco de Oliveira Lopes", 10
		  BYTE 9,9,9, "Renata Sarmet Smiderle Mendes", 10, 10
		  BYTE 9,9,"Disciplina:", 10
		  BYTE 9,9,9, "Laboratorio de Arquitetura e Organizacao de Computadores 2", 10, 10
		  BYTE 9,9,"Disciplina:", 10
		  BYTE 9,9,9, "Luciano de Oliveira Neris", 10, 10
		  BYTE 9,9,"(0) Voltar", 10, 0

telaAjuda BYTE 10, 10, 9, 9, "Ajuda", 10, 10						; Tela de ajuda ao jogador
		  BYTE 9, 9, "'!' representa o personagem", 10
		  BYTE 9, 9, "'.' representa cada bloco do chao", 10
		  BYTE 9, 9, "'+' representa cada bloco das paredes", 10
		  BYTE 9, 9, "' ' representa o vazio", 10
		  BYTE 9, 9, "'o' representa as caixas", 10
		  BYTE 9, 9, "'X' representa os lugares para posicionar as caixas", 10
		  BYTE 9, 9, "'O' representa as caixas ja posicionadas nos locais demarcaados", 10, 10
		  BYTE 9, 9, "O objetivo e posicionar todas as caixas nos locais demarcados!", 10, 10, 10
		  BYTE 9, 9, "(0) Voltar", 10, 0


telaCongratulacoes BYTE 10, 10																						; Tela de congratulações
					BYTE " _____                             _         _       _   _                 ", 10
					BYTE "/  __ \                           | |       | |     | | (_)                ", 10
					BYTE "| /  \/ ___  _ __   __ _ _ __ __ _| |_ _   _| | __ _| |_ _  ___  _ __  ___ ", 10
					BYTE "| |    / _ \| '_ \ / _` | '__/ _` | __| | | | |/ _` | __| |/ _ \| '_ \/ __|", 10
					BYTE "| \__/\ (_) | | | | (_| | | | (_| | |_| |_| | | (_| | |_| | (_) | | | \__ \", 10
					BYTE " \____/\___/|_| |_|\__, |_|  \__,_|\__|\__,_|_|\__,_|\__|_|\___/|_| |_|___/", 10
					BYTE "                    __/ |                                                  ", 10
					BYTE "                   |___/                                                   ", 10, 10
					BYTE "                                                                           ", 10, 10
					BYTE "   (0) Voltar ao menu principal", 10, 0


campo BYTE 101 dup (?) 													; Variável campo, a ser preenchida com o mapa atual
campoAtual BYTE 1														; Variável que rastreia qual o mapa atual do jogador
localOcupado BYTE 0														; Variável que checa se o usuário estava em uma posição onde existia um x anteriormente
qtdMovimentos DWORD 0													; Contador de quantos movimentos o jogador realizou em um determinado mapa
qtdCaixas BYTE 0														; Quantidade de caixas existentes em um determinado mapa
qtdCaixasPosicionadas BYTE 0											; Quantidade de caixas posicionadas no local correto

; posicao = 65d ou 41h													
primeiroCampo BYTE "          "											; Variável referente à configuração inicial do primeiro campo
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
segundoCampo  BYTE "          "											; Variável referente à configuração inicial do segundo campo
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
terceiroCampo BYTE "          "											; Variável referente à configuração inicial do segundo campo
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
beep PROTO

main PROC
									; Iniciar Menu
menuPrincipal:	
	mov eax, lightGreen
	call SetTextColor
	invoke Clrscr
	mov edx, OFFSET telaMenu
	invoke WriteString

espereImputMenuPrincipal:
	mov eax, 250
	invoke Delay
	invoke ReadKey
	jz espereImputMenuPrincipal

	cmp al, 31h						; ir para (1) NovoJogo
	je novoJogo
	cmp al, 32h						; ir para (2) Ajuda
	je Ajuda
	cmp al, 33h						; ir para (3) Sobre
	je Sobre
	cmp al, 30h
	je Sair
	jmp menuPrincipal

Sobre:								; ~~~~~~~~ Tela sobre ~~~~~~~~~
	mov eax, yellow
	call SetTextColor
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
	mov eax, lightCyan				; ~~~~~~~~ Tela Ajuda ~~~~~~~~
	call SetTextColor
	invoke Clrscr					; Limpe a tela
	mov edx, OFFSET telaAjuda 		; Escrever o texto da tela sobre
	invoke WriteString

espereImputAjuda:
	invoke ReadKey
	jz espereImputAjuda

	cmp al, 30h
	je menuPrincipal
	jmp Ajuda

novoJogo:							;  ~~~~~~~~ Novo Jogo ~~~~~~~~
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

;  ~~~~~~~~ atualiza a variavel campo ~~~~~~~~
atualizaCampoAtual PROC
	mov ecx, 0						; loop
AtualizaL1:
	mov al, [edx+ecx]
	mov campo[ecx], al				; move _campo pra campo
	inc ecx
	cmp ecx, 100
	jnz AtualizaL1

	ret
atualizaCampoAtual ENDP

; ~~~~~~~~ imprime um campo ~~~~~~~~
imprimeTelaJogo PROC 				
	mov ecx, 0						
ImprimeL1:
	call Crlf
	mov esi, 0
ImprimeL2:
	mov eax, lightGray+(white*16)
	call SetTextColor

	mov al, campo[ecx]				; move campo para writechar
	; pintar
	cmp al, '!'						; pinta personagem
	jz pintaPersonagem
	cmp al, 'x'						; lugar
	jz pintarLugar
	cmp al, 'X'						; caixa dentro
	jz pintarCaixaDentro			
	cmp al, 'o'						; caixa nao posicionada
	jz pintarCaixaFora				
	cmp al, '+'						; parede
	jnz parePintar					

	push eax
	mov eax, lightCyan+(gray*16)
	call SetTextColor
	pop eax
	jmp parePintar

pintarCaixaFora:
	push eax
	mov eax, red+(white*16)
	call SetTextColor
	pop eax
	jmp parePintar

pintarCaixaDentro:
	push eax
	mov eax, lightGreen+(white*16)
	call SetTextColor
	pop eax
	jmp parePintar

pintarLugar:
	push eax
	mov eax, lightMagenta+(white*16)
	call SetTextColor
	pop eax
	jmp parePintar

pintaPersonagem:
	push eax
	mov eax, green+(white*16)
	call SetTextColor
	pop eax

parePintar:
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

	mov eax, white
	call SetTextColor
	mov edx, OFFSET imprimeQtdMovimentos
	invoke WriteString
	mov eax, qtdMovimentos
	call WriteDec
	call Crlf
	call Crlf
	mov edx, OFFSET imprimeComandosEmJogo
	invoke WriteString
	call Crlf
	call Crlf
	ret
imprimeTelaJogo ENDP

; ~~~~~~~~ Loop principal do jogo ~~~~~~~~
jogoLoop PROC
resetarJogo:
	mov qtdMovimentos, 0
	mov qtdCaixasPosicionadas, 0
	mov al, campoAtual
	cmp al, 1
	jz Campo1
	cmp al, 2
	jz Campo2
	jmp Campo3

campo1:													; ~~~~~~~~ Preenche a variável campo com o campo 1 ~~~~~~~~
	mov edx, OFFSET primeiroCampo
	mov posicao, 65d
	mov qtdCaixas, 4
	call atualizaCampoAtual
	jmp LoopEvento

campo2::													; ~~~~~~~~ Preenche a variável campo com o campo 2 ~~~~~~~~
	mov edx, OFFSET segundoCampo
	mov posicao, 21d
	mov qtdCaixas, 3
	call atualizaCampoAtual
	jmp LoopEvento

campo3::													; ~~~~~~~~ Preenche a variável campo com o campo 3 ~~~~~~~~
	mov edx, OFFSET terceiroCampo
	mov posicao, 52d
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

	call movimenta					; ~~~~~~~~ chamada do procedimento de movimento ~~~~~~~~~~

	mov al, qtdCaixasPosicionadas	; ~~~~~~~~ Compara a quantidade de caixas existentes no mapa com as posicionadas em local correto ~~~~~~~~~~
	cmp al, qtdCaixas
	jz proximoCampo

	jmp loopEvento

proximoCampo:						; ~~~~~~~~ Caso todas as caixas tenham sido posicionadas no local correto, vai ao próximo campo ou à tela de congratulações ~~~~~~~~~~
	inc campoAtual
	cmp campoAtual, 4
	jz congratulacoes
	jmp resetarJogo


congratulacoes:					; ~~~~~~~~~ tela de ganhou ~~~~~~~~~~
	invoke Clrscr
	mov edx, OFFSET telaCongratulacoes
	invoke WriteString

cz2:
	invoke ReadKey
	jz cz2
	cmp al, 30h


saidaJogoLoop:
	ret
jogoLoop ENDP

; ~~~~~~~~ Movimentar personagem ~~~~~~~~
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

moveEsquerda:; ~~~~~~~~ Tratamento de todos os movimentos para a esquerda ~~~~~~~~~~
	mov edx, posicao 					; ~~~~~~~~ Define edx como posicao ~~~~~~~~~~
	mov ecx, posicao 					; ~~~~~~~~ Define ecx como posicao-1 ~~~~~~~~~~
	dec ecx
	mov al, campo[ecx]
	cmp al, 43d					
	jz movimentoInvalido
	cmp al, 111d
	jz movimentaCaixaEsquerda
	cmp al, 88d
	jz movimentaCaixaEsquerda
	cmp al, 46d
	jz moveChaoEsquerda

	mov bl, localOcupado 					; ~~~~~~~~ Tratamento caso o usuário estivesse em um campo marcado com x e se movendo para outro x  ~~~~~~~~~~
	cmp bl, 1
	jz movePosicaoEsquerdaOcupado
	mov localOcupado, 1
	mov campo[edx], 46d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento

movePosicaoEsquerdaOcupado:	
	mov campo[edx], 120d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento
	

moveChaoEsquerda:					 					; ~~~~~~~~ Tratamento caso o usuário esteja se movendo para um .  ~~~~~~~~~~
	mov bl, localOcupado
	cmp bl, 1
	jz moveChaoEsquerdaOcupado		 					; ~~~~~~~~ Checa se o campo em que o usuário estava era um x ~~~~~~~~~~
	mov campo[edx], 46d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento

moveChaoEsquerdaOcupado:
	mov localOcupado, 0
	mov campo[edx], 120d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento


movimentaCaixaEsquerda:					 				; ~~~~~~~~ Tratamento do movimento do usuário caso esteja se movendo para uma caixa  ~~~~~~~~~~
	mov ebx, posicao
	dec ebx
	dec ebx
	mov ah, campo[ebx]
	cmp ah, 43d							 				; ~~~~~~~~ Dos casos em que o movimento é inválido ~~~~~~~~~~
	jz movimentoInvalido
	cmp ah, 111d
	jz movimentoInvalido
	cmp ah, 88d
	jz movimentoInvalido


	cmp ah, 46d						
	jz movimentaCaixaEsquerdaChao		 				; ~~~~~~~~ Se a caixa for se mover para um chão  ~~~~~~~~~~
	push ebx
	mov bl, localOcupado
	cmp bl, 1
	jz localOcupadoEsquerda 	 						; ~~~~~~~~ Se a caixa for se mover para um x  ~~~~~~~~~~
	mov campo[edx], 46d
	cmp al, 88d											; ~~~~~~~~ Se a caixa a ser movida estivesse no local correto, 'X' ~~~~~~~~~~
	jz moveEsquerdaFimOcupado
	mov localOcupado, 0
	call beep
	inc qtdCaixasPosicionadas
	jmp moveEsquerdaFim


localOcupadoEsquerda:  									; ~~~~~~~~ Trata do fato de o lugar para o qual o jogador vai ser ou não um x ~~~~~~~~~~
	mov campo[edx], 120d
	cmp al, 88d
	jz moveEsquerdaFim 
	mov localOcupado, 0
	call beep
	inc qtdCaixasPosicionadas
	jmp moveEsquerdaFim

moveEsquerdaFimOcupado:
	mov localOcupado, 1
moveEsquerdaFim:
	mov campo[ecx], 33d		; !
	mov posicao, ecx
	pop ebx
	mov campo[ebx], 88d
	jmp fimMovimento

movimentaCaixaEsquerdaChao:
	push ebx
	mov bl, localOcupado
	cmp bl, 1
	jz localOcupadoEsquerdaChao
	mov campo[edx], 46d
	cmp al, 88d
	jz moveEsquerdaFimChao
	mov localOcupado, 0
	jmp moveEsquerdaFimChaoNo


localOcupadoEsquerdaChao:
	mov campo[edx], 120d
	cmp al, 88d
	jz moveEsquerdaFimChao
	mov localOcupado, 0
	jmp moveEsquerdaFimChaoNo
	
moveEsquerdaFimChao:
	dec qtdCaixasPosicionadas
moveEsquerdaFimChaoNo:
	mov campo[ecx], 33d
	mov posicao, ecx
	pop ebx
	mov campo[ebx], 111d
	jmp fimMovimento

moveDireita:; ~~~~~~~~ Tratamento de todos os movimentos para a direita ~~~~~~~~~~
	mov edx, posicao 					; ~~~~~~~~ Define edx como posicao ~~~~~~~~~~
	mov ecx, posicao; ~~~~~~~~ Define ecx como posicao+1 ~~~~~~~~~~
	inc ecx
	mov al, campo[ecx]
	cmp al, 43d					
	jz movimentoInvalido
	cmp al, 111d
	jz movimentaCaixaDireita
	cmp al, 88d
	jz movimentaCaixaDireita
	cmp al, 46d
	jz moveChaoDireita

	mov bl, localOcupado 					; ~~~~~~~~ Tratamento caso o usuário estivesse em um campo marcado com x e se movendo para outro x  ~~~~~~~~~~
	cmp bl, 1
	jz movePosicaoDireitaOcupado
	mov localOcupado, 1
	mov campo[edx], 46d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento

movePosicaoDireitaOcupado:
	mov campo[edx], 120d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento
	

moveChaoDireita:; ~~~~~~~~ Tratamento caso o usuário esteja se movendo para um .  ~~~~~~~~~~
	mov bl, localOcupado
	cmp bl, 1
	jz moveChaoDireitaOcupado		 					; ~~~~~~~~ Checa se o campo em que o usuário estava era um x ~~~~~~~~~~
	mov campo[edx], 46d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento

moveChaoDireitaOcupado:
	mov localOcupado, 0
	mov campo[edx], 120d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento


movimentaCaixaDireita:; ~~~~~~~~ Tratamento do movimento do usuário caso esteja se movendo para uma caixa  ~~~~~~~~~~
	mov ebx, posicao
	inc ebx
	inc ebx
	mov ah, campo[ebx]
	cmp ah, 43d							 				; ~~~~~~~~ Dos casos em que o movimento é inválido ~~~~~~~~~~
	jz movimentoInvalido
	cmp ah, 111d
	jz movimentoInvalido
	cmp ah, 88d
	jz movimentoInvalido


	cmp ah, 46d						
	jz movimentaCaixaDireitaChao		 				; ~~~~~~~~ Se a caixa for se mover para um chão  ~~~~~~~~~~
	push ebx
	mov bl, localOcupado
	cmp bl, 1
	jz localOcupadoDireita 	 						; ~~~~~~~~ Se a caixa for se mover para um x  ~~~~~~~~~~
	mov campo[edx], 46d
	cmp al, 88d											; ~~~~~~~~ Se a caixa a ser movida estivesse no local correto, 'X' ~~~~~~~~~~
	jz moveDireitaFimOcupado
	mov localOcupado, 0
	call beep
	inc qtdCaixasPosicionadas
	jmp moveDireitaFim


localOcupadoDireita:  									; ~~~~~~~~ Trata do fato de o lugar para o qual o jogador vai ser ou não um x ~~~~~~~~~~
	mov campo[edx], 120d
	cmp al, 88d
	jz moveDireitaFim 
	mov localOcupado, 0
	call beep
	inc qtdCaixasPosicionadas
	jmp moveDireitaFim

moveDireitaFimOcupado:
	mov localOcupado, 1
moveDireitaFim:
	mov campo[ecx], 33d		; !
	mov posicao, ecx
	pop ebx
	mov campo[ebx], 88d
	jmp fimMovimento

movimentaCaixaDireitaChao:
	push ebx
	mov bl, localOcupado
	cmp bl, 1
	jz localOcupadoDireitaChao
	mov campo[edx], 46d
	cmp al, 88d
	jz moveDireitaFimChao
	mov localOcupado, 0
	jmp moveDireitaFimChaoNo


localOcupadoDireitaChao:
	mov campo[edx], 120d
	cmp al, 88d
	jz moveDireitaFimChao
	mov localOcupado, 0
	jmp moveDireitaFimChaoNo
	
moveDireitaFimChao:
	dec qtdCaixasPosicionadas
moveDireitaFimChaoNo:
	mov campo[ecx], 33d
	mov posicao, ecx
	pop ebx
	mov campo[ebx], 111d
	jmp fimMovimento
moveBaixo:; ~~~~~~~~ Tratamento de todos os movimentos para baixo ~~~~~~~~~~
	mov edx, posicao 					; ~~~~~~~~ Define edx como posicao ~~~~~~~~~~
	mov ecx, posicao; ~~~~~~~~ Define ecx como posicao+10 ~~~~~~~~~~
	push edx
	mov edx, 10d
	add ecx, edx
	pop edx
	mov al, campo[ecx]
	cmp al, 43d					
	jz movimentoInvalido
	cmp al, 111d
	jz movimentaCaixaBaixo
	cmp al, 88d
	jz movimentaCaixaBaixo
	cmp al, 46d
	jz moveChaoBaixo

	mov bl, localOcupado 					; ~~~~~~~~ Tratamento caso o usuário estivesse em um campo marcado com x e se movendo para outro x  ~~~~~~~~~~
	cmp bl, 1
	jz movePosicaoBaixoOcupado
	mov localOcupado, 1
	mov campo[edx], 46d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento

movePosicaoBaixoOcupado:
	mov campo[edx], 120d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento
	

moveChaoBaixo:; ~~~~~~~~ Tratamento caso o usuário esteja se movendo para um .  ~~~~~~~~~~
	mov bl, localOcupado
	cmp bl, 1
	jz moveChaoBaixoOcupado		 					; ~~~~~~~~ Checa se o campo em que o usuário estava era um x ~~~~~~~~~~
	mov campo[edx], 46d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento

moveChaoBaixoOcupado:
	mov localOcupado, 0
	mov campo[edx], 120d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento


movimentaCaixaBaixo:; ~~~~~~~~ Tratamento do movimento do usuário caso esteja se movendo para uma caixa  ~~~~~~~~~~
	mov ebx, posicao
	push edx
	mov edx, 20d
	add ebx, edx
	pop edx
	mov ah, campo[ebx]
	cmp ah, 43d							 				; ~~~~~~~~ Dos casos em que o movimento é inválido ~~~~~~~~~~
	jz movimentoInvalido
	cmp ah, 111d
	jz movimentoInvalido
	cmp ah, 88d
	jz movimentoInvalido


	cmp ah, 46d
	jz movimentaCaixaBaixoChao		 				; ~~~~~~~~ Se a caixa for se mover para um chão  ~~~~~~~~~~
	push ebx
	mov bl, localOcupado
	cmp bl, 1
	jz localOcupadoBaixo 	 						; ~~~~~~~~ Se a caixa for se mover para um x  ~~~~~~~~~~
	mov campo[edx], 46d
	cmp al, 88d											; ~~~~~~~~ Se a caixa a ser movida estivesse no local correto, 'X' ~~~~~~~~~~
	jz moveBaixoFimOcupado
	mov localOcupado, 0
	call beep
	inc qtdCaixasPosicionadas
	jmp moveBaixoFim


localOcupadoBaixo:  									; ~~~~~~~~ Trata do fato de o lugar para o qual o jogador vai ser ou não um x ~~~~~~~~~~
	mov campo[edx], 120d
	cmp al, 88d
	jz moveBaixoFim 
	mov localOcupado, 0
	call beep
	inc qtdCaixasPosicionadas
	jmp moveBaixoFim

moveBaixoFimOcupado:
	mov localOcupado, 1
moveBaixoFim:
	mov campo[ecx], 33d		; !
	mov posicao, ecx
	pop ebx
	mov campo[ebx], 88d
	jmp fimMovimento

movimentaCaixaBaixoChao:
	push ebx
	mov bl, localOcupado
	cmp bl, 1
	jz localOcupadoBaixoChao
	mov campo[edx], 46d
	cmp al, 88d
	jz moveBaixoFimChao
	mov localOcupado, 0
	jmp moveBaixoFimChaoNo


localOcupadoBaixoChao:
	mov campo[edx], 120d
	cmp al, 88d
	jz moveBaixoFimChao
	mov localOcupado, 0
	jmp moveBaixoFimChaoNo
	
moveBaixoFimChao:
	dec qtdCaixasPosicionadas
moveBaixoFimChaoNo:
	mov campo[ecx], 33d
	mov posicao, ecx
	pop ebx
	mov campo[ebx], 111d
	jmp fimMovimento

moveCima:; ~~~~~~~~ Tratamento de todos os movimentos para cima ~~~~~~~~~~
	mov edx, posicao 					; ~~~~~~~~ Define edx como posicao ~~~~~~~~~~
	mov ecx, posicao; ~~~~~~~~ Define ecx como posicao-10 ~~~~~~~~~~
	push edx
	mov edx, 10d
	sub ecx, edx
	pop edx
	mov al, campo[ecx]
	cmp al, 43d					
	jz movimentoInvalido
	cmp al, 111d
	jz movimentaCaixaCima
	cmp al, 88d
	jz movimentaCaixaCima
	cmp al, 46d
	jz moveChaoCima

	mov bl, localOcupado 					; ~~~~~~~~ Tratamento caso o usuário estivesse em um campo marcado com x e se movendo para outro x  ~~~~~~~~~~
	cmp bl, 1
	jz movePosicaoCimaOcupado		 					; ~~~~~~~~ Checa se o campo em que o usuário estava era um x ~~~~~~~~~~
	mov localOcupado, 1
	mov campo[edx], 46d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento

movePosicaoCimaOcupado:
	mov campo[edx], 120d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento
	

moveChaoCima:; ~~~~~~~~ Tratamento caso o usuário esteja se movendo para um .  ~~~~~~~~~~
	mov bl, localOcupado
	cmp bl, 1
	jz moveChaoCimaOcupado
	mov campo[edx], 46d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento

moveChaoCimaOcupado:
	mov localOcupado, 0
	mov campo[edx], 120d
	mov campo[ecx], 33d
	mov posicao, ecx
	jmp fimMovimento


movimentaCaixaCima:; ~~~~~~~~ Tratamento do movimento do usuário caso esteja se movendo para uma caixa  ~~~~~~~~~~
	mov ebx, posicao
	push edx
	mov edx, 20d
	sub ebx, edx
	pop edx
	mov ah, campo[ebx]
	cmp ah, 43d							 				; ~~~~~~~~ Dos casos em que o movimento é inválido ~~~~~~~~~~
	jz movimentoInvalido
	cmp ah, 111d
	jz movimentoInvalido
	cmp ah, 88d
	jz movimentoInvalido


	cmp ah, 46d
	jz movimentaCaixaCimaChao		 				; ~~~~~~~~ Se a caixa for se mover para um chão  ~~~~~~~~~~
	push ebx
	mov bl, localOcupado
	cmp bl, 1
	jz localOcupadoCima 	 						; ~~~~~~~~ Se a caixa for se mover para um x  ~~~~~~~~~~
	mov campo[edx], 46d
	cmp al, 88d											; ~~~~~~~~ Se a caixa a ser movida estivesse no local correto, 'X' ~~~~~~~~~~
	jz moveCimaFimOcupado
	mov localOcupado, 0
	call beep
	inc qtdCaixasPosicionadas
	jmp moveCimaFim


localOcupadoCima:  									; ~~~~~~~~ Trata do fato de o lugar para o qual o jogador vai ser ou não um x ~~~~~~~~~~
	mov campo[edx], 120d
	cmp al, 88d
	jz moveCimaFim 
	mov localOcupado, 0
	call beep
	inc qtdCaixasPosicionadas
	jmp moveCimaFim

moveCimaFimOcupado:
	mov localOcupado, 1
moveCimaFim:
	mov campo[ecx], 33d		; !
	mov posicao, ecx
	pop ebx
	mov campo[ebx], 88d
	jmp fimMovimento

movimentaCaixaCimaChao:
	push ebx
	mov bl, localOcupado
	cmp bl, 1
	jz localOcupadoCimaChao
	mov campo[edx], 46d
	cmp al, 88d
	jz moveCimaFimChao
	mov localOcupado, 0
	jmp moveCimaFimChaoNo


localOcupadoCimaChao:
	mov campo[edx], 120d
	cmp al, 88d
	jz moveCimaFimChao
	mov localOcupado, 0
	jmp moveCimaFimChaoNo
	
moveCimaFimChao:
	dec qtdCaixasPosicionadas
moveCimaFimChaoNo:
	mov campo[ecx], 33d
	mov posicao, ecx
	pop ebx
	mov campo[ebx], 111d
	jmp fimMovimento

fimMovimento:
	inc qtdMovimentos

movimentoInvalido:
	ret
movimenta ENDP

; ~~~~~~~~ Procedimento de som simples ~~~~~~~~
beep PROC
	push eax
	mov al, 7
	call WriteChar
	pop eax
	ret
beep ENDP


END main
