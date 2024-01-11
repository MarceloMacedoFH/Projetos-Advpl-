#include "Totvs.ch"
#INCLUDE "RWMAKE.CH"
#include "Protheus.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120BRW  ºAutor  ³Mauricio Think Fast º Data ³  06/04/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para incluir botão a de alteração da      º±±
±±º          ³ data de entrega prevista.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Uso exclusivo Eximport - Pedido de Compra                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120BRW()
	aadd(aRotina, {OemToAnsi("Manut. Dt. Entrega"), "U_MNTDTCP", 0 , 4} )
  //If RetCodUsr() == "000000"
	aadd(aRotina, {OemToAnsi("*Reenvio Wkf.PC"), "U_MT120REE", 0 , 4} )
  //EndIf

Return

//*******************************************************************************
//*
//*******************************************************************************
User Function MNTDTCP()
Local oButton3
Local oButton4
Local oGet1
Local cGet1   := SC7->C7_NUM
Local oGet2
Local cGet2   := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")
Local oGet5 
Local dGet5   := SC7->C7_DATPRF
Local oGroup1
Local oGroup2
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oGet6
Local oDlg
Local cGet6     :=  SC7->C7_XFOLLOW
Local cVar      :=  ""
Local aButtons  := {}
Local oDtPCsc 
Local cPedido   := SC7->C7_NUM
Private aCampos := {}
Private oGet3 
Private cGet3   := "" //ALLTRIM(SC7->C7_PRODUTO)+" - "+ALLTRIM(SC7->C7_DESCRI)
Private oLbx


DbSelectArea("SC7")
DbSetOrder(1)
DBSEEK( xFilial("SC7") + cPedido )

while !Eof() .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cPedido

  aAdd(aCampos,{SC7->C7_ITEM,SC7->C7_PRODUTO,Left(SC7->C7_DESCRI,100),SC7->C7_DATPRF,SC7->C7_DATPRF,SC7->(RECNO())})

  DBSELECTAREA( "SC7" )
  DBSKIP()

Enddo 

If Len(aCampos) == 0
  
  aAdd(aCampos,{"","","","",""})

ENDIF


DEFINE MSDIALOG oDtPCsc TITLE "Alteração de Prazo" FROM 000, 000  TO 600, 999 COLORS 0, 16777215 PIXEL
DEFINE FONT oBold10  NAME "Arial" SIZE 0, -10 BOLD
DEFINE FONT oBold12  NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oBold15  NAME "Arial" SIZE 0, -15 BOLD
DEFINE FONT oBold22  NAME "Arial" SIZE 0, -22 BOLD
DEFINE FONT oBold32  NAME "Arial" SIZE 0, -32 BOLD

    @ 050, 002 GROUP oGroup1 TO 098, 498 OF oDtPCsc COLOR 0, 16777215 PIXEL //130,246
    @ 029, 046 SAY oSay1 PROMPT "Alteração da Data de Entrega " SIZE 400, 020 OF oDtPCsc COLORS 0, 16777215 PIXEL FONT oBold32 Center

    @ 058, 006 SAY oSay2 PROMPT "Pedido:" SIZE 026, 010 OF oDtPCsc COLORS 0, 16777215 PIXEL FONT oBold12
    @ 057, 045 MSGET oGet1 VAR cGet1 SIZE 452, 010 OF oDtPCsc COLORS 0, 16777215 PIXEL when .F. FONT oBold15

    @ 080, 006 SAY oSay3 PROMPT "Fornecedor: " SIZE 035, 020 OF oDtPCsc COLORS 0, 16777215 PIXEL FONT oBold12
    @ 078, 045 MSGET oGet2 VAR cGet2 SIZE 452, 010 OF oDtPCsc COLORS 0, 16777215 PIXEL WHEN .F. FONT oBold15

    @ 100, 02 LISTBOX oLbx VAR cVar Fields HEADER "Item","Produto","Descrição","Dt.Entrega Atual","Dt.Entrega Nova" SIZE 495,127 Pixel OF oDlg Font oBold12
    oLbx:SetArray(aCampos)
    oLbx:bLine    := {||{aCampos[oLbx:nAt, 1],aCampos[oLbx:nAt, 2],aCampos[oLbx:nAt, 3],aCampos[oLbx:nAt, 4],aCampos[oLbx:nAt, 5]}}
    oLbx:cToolTip :=  oDtPCsc:cTitle
    oLbx:lHScroll := .T. // NoScroll
    oLbx:bChange  := {|| POSICIONA()}

    @ 230, 002 GROUP oGroup2 TO 299, 498 OF oDtPCsc COLOR 0, 16777215 PIXEL 
    @ 244, 006 SAY oSay4 PROMPT "Produto: " SIZE 025, 007 OF oDtPCsc COLORS 0, 16777215 PIXEL FONT oBold12
    @ 240, 035 MSGET oGet3 VAR cGet3 SIZE 290, 015 OF oDtPCsc COLORS 0, 16777215 PIXEL WHEN .F. FONT oBold15
    
    @ 274, 006 SAY oSay6 PROMPT "Motivo: " SIZE 025, 007 OF oDtPCsc COLORS 0, 16777215 PIXEL FONT oBold12
    @ 270, 035 MSGET oGet6 VAR cGet6 SIZE 290, 015 OF oDtPCsc COLORS 0, 16777215 PIXEL FONT oBold15
    
    @ 232, 380 SAY oSay5 PROMPT "Nova Data de Entrega: " Size 080,25 OF oDtPCsc COLOR 0, 16777215 PIXEL Font oBold12
    @ 240, 355 MSGET oGet5 VAR dGet5 SIZE 117, 014 OF oDtPCsc COLORS 0, 16777215 PIXEL FONT oBold32

    @ 270, 369 BUTTON oButton3 PROMPT "Atualiza Item" SIZE 040, 015 Action(ATTDATA(dGet5,oGet5,1)) OF oDtPCsc PIXEL 
    @ 270, 418 BUTTON oButton4 PROMPT "Atualiza Todos" SIZE 040, 015 Action(ATTDATA(dGet5,oGet5,2)) OF oDtPCsc PIXEL 

    //@ 260, 126 BUTTON oButton1 PROMPT "Confirmar" SIZE 080, 014 OF oDtPCsc ACTION {|| GRAVA(dGet5,cGet6), oDtPCsc:END() } PIXEL FONT oBold12
    //@ 260, 292 BUTTON oButton2 PROMPT "Sair" SIZE 080, 014 OF oDtPCsc ACTION {|| oDtPCsc:END()  } PIXEL FONT oBold12

  ACTIVATE MSDIALOG oDtPCsc CENTER On Init EnchoiceBar(oDtPCsc,{|| GRAVA(dGet5,cGet6),oDtPCsc:End()}, {|| oDtPCsc:End()},, aButtons )

Return

//*******************************************************************************
//*Função para Gravar alterações feitas nas datas de entregas. 
//*******************************************************************************
STATIC Function GRAVA(dGet5,cGet6)

Local nX := 1

For nX := 1 to Len(aCampos)
  SC7->(Dbgoto(aCampos[nX,6]))
  If SC7->(!Eof())
    SC7->( RECLOCK("SC7",.F.) )
    SC7->C7_DATPRF := aCampos[nX,5]
    SC7->C7_XFOLLOW := cGet6
    SC7->( MSUNLOCK() )
  EndIF
Next nX 

AVISO("Atualização","Alteração efetuada com sucesso !!!")

RETURN

User Function MT120REE()

Local aArea := GETAREA()

Private cNamUser 	:= ""

If SC7->C7_CONAPRO $ "L/R"

    dbSelectArea("SA2")
    dbSetOrder(1)
    dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

    If SA2->A2_XPEDCOM =="1"

        dbSelectArea("SCR")
        dbSetOrder(1)
        dbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM)

        cNamUser 	:= UsrRetName( SCR->CR_USERLIB )//Retorna o nome do us

        If SC7->C7_CONAPRO = "L"
          //Quando o pedido for Aprovado
          U_RCOMRWF01(SC7->C7_NUM,cNamUser,1/*nOpc*/)

        ElseIf SC7->C7_CONAPRO = "R"
          //Quando o pedido for Rejeitado
          U_RCOMRWF01(SC7->C7_NUM,cNamUser,2/*nOpc*/)
        EndIf
    EndIf

EndIf

RESTAREA(aArea)

Return


// Função para Preencher a descrição do produto 
Static Function POSICIONA()

  cGet3 := aCampos[oLbx:nAt, 3]

  oGet3:Refresh()

Return 

//Função para Atualizar a data no ListBox 
Static Function ATTDATA(dGet5,oGet5,nAtt)

  Local nX := 1

  If nAtt == 1
    aCampos[oLbx:nAt,5] := dGet5
  else
    For nX := 1 to Len(aCampos)
      aCampos[nX,5] := dGet5
      oGet5:Refresh()
    Next nX
  EndIf

Return 
