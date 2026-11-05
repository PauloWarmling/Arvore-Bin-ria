program ArvoreBinariaBusca;

type
    PtrNodoArvBin = ^NodoArvBin;
    NodoArvBin = Record
        Conteudo: Integer;
        ArvEsq, ArvDir, Pai: PtrNodoArvBin;
    End;

var
    Raiz: PtrNodoArvBin;
    Opcao, Val: Integer;

{ Inicializa a árvore }
procedure InicializaArvBin(var Raiz: PtrNodoArvBin);
begin
    Raiz := nil;
end;

{ Função auxiliar para calcular o maior entre dois números }
function Maior(A, B: Integer): Integer;
begin
    if A > B then
        Maior := A
    else
        Maior := B;
end;

{ Inserir nó em uma árvore de busca }
procedure Inserir(var Raiz: PtrNodoArvBin; X: Integer; PaiNodo: PtrNodoArvBin);
begin
    if Raiz = nil then
    begin
        new(Raiz);
        Raiz^.Conteudo := X;
        Raiz^.ArvEsq := nil;
        Raiz^.ArvDir := nil;
        Raiz^.Pai := PaiNodo;
    end
    else if X < Raiz^.Conteudo then
        Inserir(Raiz^.ArvEsq, X, Raiz)
    else if X > Raiz^.Conteudo then
        Inserir(Raiz^.ArvDir, X, Raiz);
end;

{ Função para encontrar o menor valor da árvore (usado na exclusão) }
function MenorValor(Raiz: PtrNodoArvBin): PtrNodoArvBin;
begin
    if Raiz^.ArvEsq <> nil then
        MenorValor := MenorValor(Raiz^.ArvEsq)
    else
        MenorValor := Raiz;
end;

{ Excluir nó de uma árvore }
function Excluir(Raiz: PtrNodoArvBin; X: Integer): PtrNodoArvBin;
var
    Temp: PtrNodoArvBin;
begin
    if Raiz = nil then
        Excluir := nil
    else if X < Raiz^.Conteudo then
        Raiz^.ArvEsq := Excluir(Raiz^.ArvEsq, X)
    else if X > Raiz^.Conteudo then
        Raiz^.ArvDir := Excluir(Raiz^.ArvDir, X)
    else
    begin
        { Caso 1 e 2: Sem filho ou apenas 1 filho }
        if Raiz^.ArvEsq = nil then
        begin
            Temp := Raiz^.ArvDir;
            dispose(Raiz);
            Excluir := Temp;
        end
        else if Raiz^.ArvDir = nil then
        begin
            Temp := Raiz^.ArvEsq;
            dispose(Raiz);
            Excluir := Temp;
        end
        else
        begin
            { Caso 3: Nó com 2 filhos }
            Temp := MenorValor(Raiz^.ArvDir);
            Raiz^.Conteudo := Temp^.Conteudo;
            Raiz^.ArvDir := Excluir(Raiz^.ArvDir, Temp^.Conteudo);
            Excluir := Raiz;
        end;
    end;
end;

{ Verificar se um elemento pertence à árvore }
function PesquisaArvBinPesq(Raiz: PtrNodoArvBin; X: Integer): PtrNodoArvBin;
var
    Ptr: PtrNodoArvBin;
begin
    Ptr := Raiz;
    while (Ptr <> nil) and (Ptr^.Conteudo <> X) do
    begin
        if X > Ptr^.Conteudo then
            Ptr := Ptr^.ArvDir
        else
            Ptr := Ptr^.ArvEsq;
    end;
    PesquisaArvBinPesq := Ptr;
end;

{ Percorrer árvore - Pré-Ordem }
procedure PreOrdem(Raiz: PtrNodoArvBin);
begin
    if Raiz <> nil then
    begin
        write(Raiz^.Conteudo, ' ');
        PreOrdem(Raiz^.ArvEsq);
        PreOrdem(Raiz^.ArvDir);
    end;
end;

{ Percorrer árvore - Em-Ordem }
procedure EmOrdem(Raiz: PtrNodoArvBin);
begin
    if Raiz <> nil then
    begin
        EmOrdem(Raiz^.ArvEsq);
        write(Raiz^.Conteudo, ' ');
        EmOrdem(Raiz^.ArvDir);
    end;
end;

{ Percorrer árvore - Pós-Ordem }
procedure PosOrdem(Raiz: PtrNodoArvBin);
begin
    if Raiz <> nil then
    begin
        PosOrdem(Raiz^.ArvEsq);
        PosOrdem(Raiz^.ArvDir);
        write(Raiz^.Conteudo, ' ');
    end;
end;

{ Escrever as folhas de uma árvore }
procedure MostraNodosFolha(Raiz: PtrNodoArvBin);
begin
    if Raiz <> nil then
    begin
        if (Raiz^.ArvEsq = nil) and (Raiz^.ArvDir = nil) then
            write(Raiz^.Conteudo, ' ');
        MostraNodosFolha(Raiz^.ArvEsq);
        MostraNodosFolha(Raiz^.ArvDir);
    end;
end;

{ Verificar a altura da árvore }
function Altura(Raiz: PtrNodoArvBin): Integer;
begin
    if Raiz = nil then
        Altura := -1
    else
        Altura := 1 + Maior(Altura(Raiz^.ArvEsq), Altura(Raiz^.ArvDir));
end;

{ Verificar o nível em que se encontra um elemento da árvore }
function NivelElemento(Raiz: PtrNodoArvBin; X: Integer; NivelAtual: Integer): Integer;
begin
    if Raiz = nil then
        NivelElemento := -1 { Elemento não encontrado }
    else if Raiz^.Conteudo = X then
        NivelElemento := NivelAtual
    else if X < Raiz^.Conteudo then
        NivelElemento := NivelElemento(Raiz^.ArvEsq, X, NivelAtual + 1)
    else
        NivelElemento := NivelElemento(Raiz^.ArvDir, X, NivelAtual + 1);
end;

{ Conta o número total de nós }
procedure ContaNodos(Raiz: PtrNodoArvBin; var Cont: Integer);
begin
    if Raiz <> nil then
    begin
        inc(Cont);
        ContaNodos(Raiz^.ArvEsq, Cont);
        ContaNodos(Raiz^.ArvDir, Cont);
    end;
end;

{ Função auxiliar que calcula 2^N }
function Potencia2(Exp: Integer): Integer;
var
    I, Res: Integer;
begin
    Res := 1;
    for I := 1 to Exp do
        Res := Res * 2;
    Potencia2 := Res;
end;

{ Verificar se uma árvore é completa ou não }
function EhCompleta(Raiz: PtrNodoArvBin): Boolean;
var
    H, TotalNos, NosEsperados: Integer;
begin
    if Raiz = nil then
        EhCompleta := true
    else
    begin
        H := Altura(Raiz);
        TotalNos := 0;
        ContaNodos(Raiz, TotalNos);
        
        { Uma árvore estritamente completa de altura H deve ter (2^(H+1) - 1) nós }
        NosEsperados := Potencia2(H + 1) - 1;
        
        EhCompleta := (TotalNos = NosEsperados);
    end;
end;

{ --- PROGRAMA PRINCIPAL --- }
begin
    InicializaArvBin(Raiz);
    
    repeat
        writeln;
        writeln('===== MENU ARVORE BINARIA =====');
        writeln('1. Inserir no');
        writeln('2. Excluir no');
        writeln('3. Verificar se elemento pertence');
        writeln('4. Percorrer arvore (Pre, Em e Pos ordem)');
        writeln('5. Escrever as folhas');
        writeln('6. Verificar altura da arvore');
        writeln('7. Verificar nivel de um elemento');
        writeln('8. Verificar se e completa');
        writeln('0. Sair');
        write('Escolha uma opcao: ');
        readln(Opcao);
        writeln;

        case Opcao of
            1: begin
                write('Digite o valor a ser inserido: ');
                readln(Val);
                Inserir(Raiz, Val, nil);
                writeln('Elemento inserido com sucesso!');
            end;
            
            2: begin
                write('Digite o valor a ser excluido: ');
                readln(Val);
                if PesquisaArvBinPesq(Raiz, Val) <> nil then
                begin
                    Raiz := Excluir(Raiz, Val);
                    writeln('Elemento excluido!');
                end
                else
                    writeln('Elemento nao encontrado na arvore.');
            end;

            3: begin
                write('Digite o valor para pesquisar: ');
                readln(Val);
                if PesquisaArvBinPesq(Raiz, Val) <> nil then
                    writeln('O elemento ', Val, ' PERTENCE a arvore.')
                else
                    writeln('O elemento ', Val, ' NAO PERTENCE a arvore.');
            end;

            4: begin
                write('Pre-Ordem: ');
                PreOrdem(Raiz);
                writeln;
                write('Em-Ordem:  ');
                EmOrdem(Raiz);
                writeln;
                write('Pos-Ordem: ');
                PosOrdem(Raiz);
                writeln;
            end;

            5: begin
                write('Folhas da arvore: ');
                MostraNodosFolha(Raiz);
                writeln;
            end;

            6: begin
                writeln('A altura da arvore e: ', Altura(Raiz));
            end;

            7: begin
                write('Digite o valor para verificar o nivel: ');
                readln(Val);
                Val := NivelElemento(Raiz, Val, 0);
                if Val <> -1 then
                    writeln('O elemento esta no Nivel: ', Val)
                else
                    writeln('Elemento nao encontrado.');
            end;

            8: begin
                if EhCompleta(Raiz) then
                    writeln('A arvore E COMPLETA.')
                else
                    writeln('A arvore NAO E COMPLETA.');
            end;
        end;

    until Opcao = 0;
end.