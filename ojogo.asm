include ..\Irvine32.inc

.data
telaMenu BYTE "SOKOBAN", 10, 10
			  BYTE "(1) Novo Jogo", 10
			  BYTE "(2) Ajuda", 10
			  BYTE "(3) Sobre", 10
			  BYTE "(0) Sair", 10, 10, 0

telaSobre BYTE "tela de sobre", 10, 0
telaAjuda BYTE "tela de ajuda", 10, 0

; TODO: resolver esse char 10d (fazer lógica de pular linha)
primeiroCampo BYTE "          ", 10
	rSize = ($ - primeiroCampo)
	nCols = rSize
			  BYTE " +++++++  ", 10
			  BYTE " +!....+  ", 10
			  BYTE " +++++.+  ", 10
			  BYTE "     +.+  ", 10
			  BYTE "     +o+  ", 10
			  BYTE "     +.+  ", 10
			  BYTE "     +x+  ", 10
			  BYTE "     +++  ", 10
			  BYTE "          "
	cSize = (($ - primeiroCampo) / rSize) 
	nRows = cSize

.code
main PROC

	; Iniciar Menu
MenuPrincipal:
	mov edx, OFFSET telaMenu
	invoke WriteString
	invoke readInt					; TODO: desaparecer o numero entrado pelo usuario
	cmp eax, 1						; ir para (1) NovoJogo
	je NovoJogo
	cmp eax, 2						; ir para (2) Ajuda
	je Ajuda
	cmp eax, 3						; ir para (3) Sobre
	je Sobre
	cmp eax, 0
	je Sair
	jmp MenuPrincipal

Sobre:
	invoke Clrscr					; Limpe a tela
	mov edx, OFFSET telaSobre 		; Escrever o texto da tela sobre
	invoke WriteString
	invoke readInt
	cmp eax, 0
	je MenuPrincipal
	jmp Sobre

Ajuda:
	invoke Clrscr					; Limpe a tela
	mov edx, OFFSET telaAjuda 		; Escrever o texto da tela sobre
	invoke WriteString
	invoke readInt
	cmp eax, 0
	je MenuPrincipal
	jmp Sobre

NovoJogo:
	invoke Clrscr					; Limpe a tela
	mov edx, OFFSET primeiroCampo
	invoke WriteString
	invoke readInt
	cmp eax, 0
	je Sair
	jmp NovoJogo

Sair:
	int 3
	exit
main ENDP

END main
