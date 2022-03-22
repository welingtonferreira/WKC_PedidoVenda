unit PedidosProdutos;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, ComCtrls, DB, SqlExpr, DBClient,
  StrUtils, Math, Controle, Produtos;

type
  TPedidosProdutos = class
    private
      iAutoIncremento: integer;
      iNumeroPedido: integer;
      iProduto: integer;
      sDescricao: string;
      iQuantidade: integer;
      nVlrUnitario: double;
      nVlrTotal: double;

      iOldProduto: integer;
      iOldQuantidade: Integer;
      nOldVlrUnitario: double;
      nOldVlrTotal: double;

      oProdutos: TProdutos;

      function getDescricao: string;

      function getCdsPedidosProdutos: TClientDataSet;
      function getCdsListaPedidosProdutos: TClientDataSet;
    protected
      oControle: TControle;

      procedure OnAfterInsert(DataSet: TDataSet);
      procedure OnAfterEdit(DataSet: TDataSet);
      procedure OnAfterOpen(DataSet: TDataSet);

      procedure PreencherPropriedade;
      procedure PreencherPropriedadeOLD;
      procedure LimparPropriedade;
      procedure LimparPropriedadeOLD;

      property OldProduto: Integer read iOldProduto write iOldProduto;
      property OldQuantidade: Integer read iOldQuantidade write iOldQuantidade;
      property OldVlrUnitario: Double read nOldVlrUnitario write nOldVlrUnitario;
      property OldVlrTotal: Double read nOldVlrTotal write nOldVlrTotal;
    public
      constructor Create(pConexaoControle: TControle);
      destructor Destroy; override;

      procedure Carregar_PedidoProdutos(pNumeroPedido: Integer);
      function CalcularTotal_PedidoProdutos: Currency;

      function SalvarItem_PedidoProdutos: Boolean;
      procedure ExcluirItem_PedidoProdutos(pAutoIncremento: Integer);

      property AutoIncremento: Integer read iAutoIncremento;
      property NumeroPedido: integer read iNumeroPedido write iNumeroPedido;
      property Produto: Integer read iProduto write iProduto;
      property Descricao: string read getDescricao;
      property Quantidade: integer read iQuantidade write iQuantidade;
      property VlrUnitario: Double read nVlrUnitario write nVlrUnitario;
      property VlrTotal: Double read nVlrTotal write nVlrTotal;

      property Produtos: TProdutos read oProdutos;

      property CdsPedidosProdutos: TClientDataSet read getCdsPedidosProdutos;
      property CdsListaPedidosProdutos: TClientDataSet read getCdsListaPedidosProdutos;
  end;
implementation

{ TPedidosProdutos }

function TPedidosProdutos.CalcularTotal_PedidoProdutos: Currency;
var
  nTotal: Currency;
begin
  if oControle.CdsLista.State in [dsInsert, dsEdit] then
    Result := oControle.CdsLista.FieldByName('VLR_TOTAL').AsCurrency
  else
  begin
    try
      oControle.CdsLista.DisableControls;

      nTotal := 0;
      Result := 0;

      oControle.CdsLista.First;
      while not oControle.CdsLista.Eof do
      begin
        nTotal := nTotal + oControle.CdsLista.FieldByName('VLR_TOTAL').AsCurrency;

        oControle.CdsLista.Next;
      end;
    finally
      Result := nTotal;
      oControle.CdsLista.EnableControls;
    end;
  end;
end;

procedure TPedidosProdutos.Carregar_PedidoProdutos(pNumeroPedido: Integer);
begin
  oControle.CdsLista.Close;
  oControle.CdsLista.Params.ParamByName('pNumeroPedido').AsInteger := pNumeroPedido;
  oControle.CdsLista.Open;
end;

constructor TPedidosProdutos.Create(pConexaoControle: TControle);
begin
  if not Assigned(pConexaoControle) then
    oControle := TControle.Create
  else
    oControle := pConexaoControle;

  if not Assigned(oProdutos) then
    oProdutos := TProdutos.Create(pConexaoControle);

  oControle.CdsLista.AfterInsert := Self.OnAfterInsert;
  oControle.CdsLista.AfterEdit :=  Self.OnAfterEdit;
  oControle.CdsLista.AfterOpen := Self.OnAfterOpen;

  oControle.CdsLista.Close;
  oControle.CdsLista.CommandText := 'SELECT '+
                                    '  PEDIDOSPRODUTOS.AUTOINCREMENTO, '+
                                    '  PEDIDOSPRODUTOS.NUMEROPEDIDO, '+
                                    '  PEDIDOSPRODUTOS.PRODUTO, '+
                                    '  PRODUTOS.DESCRICAO, '+
                                    '  PEDIDOSPRODUTOS.QUANTIDADE, '+
                                    '  PEDIDOSPRODUTOS.VLR_UNITARIO, '+
                                    '  PEDIDOSPRODUTOS.VLR_TOTAL '+
                                    'FROM '+
                                    '  PEDIDOSPRODUTOS '+
                                    '  INNER JOIN PRODUTOS ON '+
                                    '    PRODUTOS.CODIGO = PEDIDOSPRODUTOS.PRODUTO '+
                                    'WHERE '+
                                    '  PEDIDOSPRODUTOS.NUMEROPEDIDO = :pNumeroPedido ';
  oControle.CdsLista.Params.Clear;
  oControle.CdsLista.Params.CreateParam(ftInteger, 'pNumeroPedido', ptInput);
end;

destructor TPedidosProdutos.Destroy;
begin

  inherited;
end;

procedure TPedidosProdutos.ExcluirItem_PedidoProdutos(pAutoIncremento: Integer);
begin
  if pAutoIncremento > 0 then
  begin
    oControle.SqlQuery.Close;
    oControle.SqlQuery.SQL.Clear;
    oControle.SqlQuery.SQL.Add('DELETE FROM PEDIDOSPRODUTOS WHERE AUTOINCREMENTO = :pAutoIncremento ');
    oControle.SqlQuery.Params.Clear;
    oControle.SqlQuery.Params.CreateParam(ftInteger, 'pAutoIncremento', ptInput);

    oControle.SqlQuery.ParamByName('pAutoIncremento').AsInteger := pAutoIncremento;

    try
      oControle.SqlQuery.ExecSQL;

      Self.Carregar_PedidoProdutos(Self.NumeroPedido);
    except
      on e: Exception do
      begin
        Application.MessageBox(PWideChar('Ocorreu um erro ao tentar excluir o item do pedido "'+IntToStr(Self.NumeroPedido)+'".'+#13+#10+'Erro: "'+e.Message+'"'), 'Erro na exclusão do registro', MB_ICONERROR + MB_OK);
      end;
    end;
  end;
end;

function TPedidosProdutos.getCdsListaPedidosProdutos: TClientDataSet;
begin
  Result := oControle.CdsLista;
end;

function TPedidosProdutos.getCdsPedidosProdutos: TClientDataSet;
begin
  Result := oControle.CdsResult;
end;

function TPedidosProdutos.getDescricao: string;
begin
  if oProdutos.PesquisarProduto(Self.Produto) then
    sDescricao := oProdutos.Descricao
  else
    sDescricao := '';

  Result := sDescricao;
end;

procedure TPedidosProdutos.LimparPropriedade;
begin
  Self.iAutoIncremento := 0;
  Self.NumeroPedido := 0;
  Self.Produto := 0;
  Self.Quantidade := 0;
  Self.VlrUnitario := 0;
  Self.VlrTotal := 0;
end;

procedure TPedidosProdutos.LimparPropriedadeOLD;
begin
  Self.OldProduto := 0;
  Self.OldQuantidade := 0;
  Self.OldVlrUnitario := 0;
  Self.OldVlrTotal := 0;
end;

procedure TPedidosProdutos.OnAfterEdit(DataSet: TDataSet);
begin
  Self.LimparPropriedade;
  Self.PreencherPropriedadeOLD;
end;

procedure TPedidosProdutos.OnAfterInsert(DataSet: TDataSet);
begin
  Self.LimparPropriedade;
  Self.LimparPropriedadeOLD;
end;

procedure TPedidosProdutos.OnAfterOpen(DataSet: TDataSet);
begin
  TCurrencyField(DataSet.FindField('VLR_UNITARIO')).DisplayFormat := '#,###,###,##0.00';
  TCurrencyField(DataSet.FindField('VLR_TOTAL')).DisplayFormat := '#,###,###,##0.00';

  PreencherPropriedade;
  PreencherPropriedadeOLD;
end;

procedure TPedidosProdutos.PreencherPropriedade;
begin
  if oControle.CdsLista.FieldByName('AUTOINCREMENTO').AsInteger > 0 then
    Self.iAutoIncremento := oControle.CdsLista.FieldByName('AUTOINCREMENTO').AsInteger
  else
    Self.iAutoIncremento := 0;
  Self.NumeroPedido := oControle.CdsLista.FieldByName('NUMEROPEDIDO').AsInteger;
  Self.Produto := oControle.CdsLista.FieldByName('PRODUTO').AsInteger;
  Self.Quantidade := oControle.CdsLista.FieldByName('QUANTIDADE').AsInteger;
  Self.VlrUnitario := oControle.CdsLista.FieldByName('VLR_UNITARIO').AsCurrency;
  Self.VlrTotal := oControle.CdsLista.FieldByName('VLR_TOTAL').AsCurrency;
end;

procedure TPedidosProdutos.PreencherPropriedadeOLD;
begin
  Self.OldProduto := oControle.CdsLista.FieldByName('PRODUTO').AsInteger;
  Self.OldQuantidade := oControle.CdsLista.FieldByName('QUANTIDADE').AsInteger;
  Self.OldVlrUnitario := oControle.CdsLista.FieldByName('VLR_UNITARIO').AsCurrency;
  Self.OldVlrTotal := oControle.CdsLista.FieldByName('VLR_TOTAL').AsCurrency;
end;

function TPedidosProdutos.SalvarItem_PedidoProdutos: Boolean;
begin
  if oControle.CdsLista.State = dsInsert then
  begin
    Result := True;

    LimparPropriedadeOLD;
    LimparPropriedade;
    PreencherPropriedade;

    oControle.SqlQuery.Close;
    oControle.SqlQuery.SQL.Clear;
    oControle.SqlQuery.SQL.Add('INSERT INTO PEDIDOSPRODUTOS ');
    oControle.SqlQuery.SQL.Add('  (NUMEROPEDIDO ');
    oControle.SqlQuery.SQL.Add('  ,PRODUTO ');
    oControle.SqlQuery.SQL.Add('  ,QUANTIDADE ');
    oControle.SqlQuery.SQL.Add('  ,VLR_UNITARIO ');
    oControle.SqlQuery.SQL.Add('  ,VLR_TOTAL) ');
    oControle.SqlQuery.SQL.Add('VALUES ');
    oControle.SqlQuery.SQL.Add('  (:pNumeroPedido ');
    oControle.SqlQuery.SQL.Add('  ,:pProduto ');
    oControle.SqlQuery.SQL.Add('  ,:pQuantidade ');
    oControle.SqlQuery.SQL.Add('  ,:pVlrUnitario ');
    oControle.SqlQuery.SQL.Add('  ,:pVlrTotal)');

    oControle.SqlQuery.Params.Clear;
    oControle.SqlQuery.Params.CreateParam(ftInteger, 'pNumeroPedido', ptInput);
    oControle.SqlQuery.Params.CreateParam(ftInteger, 'pProduto', ptInput);
    oControle.SqlQuery.Params.CreateParam(ftInteger, 'pQuantidade', ptInput);
    oControle.SqlQuery.Params.CreateParam(ftFloat, 'pVlrUnitario', ptInput);
    oControle.SqlQuery.Params.CreateParam(ftFloat, 'pVlrTotal', ptInput);

    oControle.SqlQuery.ParamByName('pNumeroPedido').AsInteger := Self.NumeroPedido;
    oControle.SqlQuery.ParamByName('pProduto').AsInteger := Self.Produto;
    oControle.SqlQuery.ParamByName('pQuantidade').AsInteger := Self.Quantidade;
    oControle.SqlQuery.ParamByName('pVlrUnitario').AsFloat := Self.VlrUnitario;
    oControle.SqlQuery.ParamByName('pVlrTotal').AsFloat := Self.VlrTotal;

    try
      try
        oControle.SqlQuery.ExecSQL;

        oControle.CdsLista.Cancel;
        oControle.CdsLista.Refresh;
        oControle.CdsLista.Last;
      except
        on e: Exception do
        begin
          Result := False;
          Application.MessageBox(PWideChar('Ocorreu o seguinte erro ao inserir um produto no pedido.'+#13+#10+' "'+e.Message+'".'), 'Erro de inclusão', MB_ICONERROR + MB_OK);
        end;
      end;
    finally
      oControle.SqlQuery.Close;
    end;
  end
  else if oControle.CdsLista.State = dsEdit then
  begin
    PreencherPropriedade;

    Result := (SameValue(Self.Quantidade, Self.OldQuantidade)) or
              (SameValue(Self.VlrUnitario, Self.OldVlrUnitario)) or
              (SameValue(Self.VlrTotal, Self.OldVlrTotal));

    if Result then
    begin
      oControle.SqlQuery.Close;
      oControle.SqlQuery.SQL.Clear;
      oControle.SqlQuery.SQL.Add('UPDATE ');
      oControle.SqlQuery.SQL.Add('  PEDIDOSPRODUTOS ');
      oControle.SqlQuery.SQL.Add('SET ');
      if (not SameValue(Self.Quantidade, Self.OldQuantidade)) then
        oControle.SqlQuery.SQL.Add('  QUANTIDADE = :pQuantidade, ');
      if (not SameValue(Self.VlrUnitario, Self.OldVlrUnitario)) then
        oControle.SqlQuery.SQL.Add('  VLR_UNITARIO = :pVlrUnitario, ');
      if (not SameValue(Self.VlrTotal, Self.OldVlrTotal)) then
        oControle.SqlQuery.SQL.Add('  VLR_TOTAL = :pVlrTotal ');
      oControle.SqlQuery.SQL.Add('WHERE ');
      oControle.SqlQuery.SQL.Add('  AUTOINCREMENTO = :pAutoIncremento');

      oControle.SqlQuery.Params.Clear;
      if (not SameValue(Self.Quantidade, Self.OldQuantidade)) then
        oControle.SqlQuery.Params.CreateParam(ftInteger, 'pQuantidade', ptInput);
      if (not SameValue(Self.VlrUnitario, Self.OldVlrUnitario)) then
        oControle.SqlQuery.Params.CreateParam(ftInteger, 'pVlrUnitario', ptInput);
      if (not SameValue(Self.VlrTotal, Self.OldVlrTotal)) then
        oControle.SqlQuery.Params.CreateParam(ftInteger, 'pVlrTotal', ptInput);
      oControle.SqlQuery.Params.CreateParam(ftInteger, 'pAutoIncremento', ptInput);

      if (not SameValue(Self.Quantidade, Self.OldQuantidade)) then
        oControle.SqlQuery.ParamByName('pQuantidade').AsInteger := Self.Quantidade;
      if (not SameValue(Self.VlrUnitario, Self.OldVlrUnitario)) then
        oControle.SqlQuery.ParamByName('pVlrUnitario').AsFloat := Self.VlrUnitario;
      if (not SameValue(Self.VlrTotal, Self.OldVlrTotal)) then
        oControle.SqlQuery.ParamByName('pVlrTotal').AsFloat := Self.VlrTotal;
      oControle.SqlQuery.ParamByName('pAutoIncremento').AsInteger := Self.AutoIncremento;

      try
        try
          oControle.SqlQuery.ExecSQL;

          oControle.CdsLista.Cancel;
          oControle.CdsLista.Refresh;
          oControle.CdsLista.Locate('AUTOINCREMENTO', Self.AutoIncremento, [loCaseInsensitive, loPartialKey]);
        except
          on e: Exception do
          begin
            Result := False;
            Application.MessageBox(PWideChar('Ocorreu o seguinte erro ao alterar o produto no pedido.'+#13+#10+' "'+e.Message+'".'), 'Erro na alteração', MB_ICONERROR + MB_OK);
          end;
        end;
      finally
        oControle.SqlQuery.Close;
      end;
    end;
  end;
end;

end.
