unit Pedidos;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, ComCtrls, DB, SqlExpr, DBClient,
  StrUtils, Math, Controle, Clientes, PedidosProdutos;

type
  TPedidos = class
    private
      iNumeroPedido: integer;
      dtDtEmissao: TDate;
      iCliente: integer;
      sNomeCliente: string;
      nVlrTotal: double;

      iOldNumeroPedido: integer;
      dtOldDtEmissao: TDate;
      iOldCliente: integer;
      nOldVlrTotal: double;

      oClientes: TClientes;
      oPedidosProdutos: TPedidosProdutos;

      function getNomeCliente: string;

      procedure LimparPropriedades;
      procedure PreencherPropriedades;
      procedure PreencherOldValue;
    protected
      oControle: TControle;

      procedure OnAfterInsert(DataSet: TDataSet);
      procedure OnAfterEdit(DataSet: TDataSet);
      procedure OnAfterOpen(DataSet: TDataSet);

      procedure InserirPedido(pResetarCDS: Boolean = True);
      procedure AlterarPedido(pResetarCDS: Boolean = True);

      procedure setNumeroPedido(pNumeroPedido: Integer);
      function getNumeroPedido: Integer;

      function getCdsPedidos: TClientDataSet;
      function getNewPK: Integer;

      property OldNumeroPedido: integer read iOldNumeroPedido;
      property OldDtEmissao: TDate read dtOldDtEmissao;
      property OldCliente: integer read iOldCliente;
      property OldVlrTotal: double read nOldVlrTotal;
    public
      constructor Create(pConexaoControle: TControle);
      destructor Destroy; override;

      function PesquisarPedido(pNumeroPedido: Integer; pCarregarCDS: Boolean = False): Boolean;
      function ObrigarSalvarPedido: Boolean;

      procedure AtualziarCDSResult;
      procedure GravarPedido(pResetarCDS: Boolean = True);
      procedure GravarItemPedido(pResetarCDS: Boolean = True);
      procedure ExcluirPedido(pNumeroPedido: Integer);

      //property NumeroPedido: integer read iNumeroPedido write iNumeroPedido;
      property NumeroPedido: integer read getNumeroPedido write setNumeroPedido;
      property DtEmissao: TDate read dtDtEmissao write dtDtEmissao;
      property Cliente: integer read iCliente write iCliente;
      property NomeCliente: string read getNomeCliente;
      property VlrTotal: double read nVlrTotal write nVlrTotal;

      property CdsPedidos: TClientDataSet read getCdsPedidos;

      property ItensProduto: TPedidosProdutos read oPedidosProdutos;
  end;

implementation

{ TPedidos }

function TPedidos.ObrigarSalvarPedido: Boolean;
begin
  Result := Self.OldVlrTotal <> Self.VlrTotal;
end;

procedure TPedidos.OnAfterEdit(DataSet: TDataSet);
begin
  oPedidosProdutos.Carregar_PedidoProdutos(DataSet.FieldByName('NUMEROPEDIDO').AsInteger);
  DataSet.FieldByName('VLR_TOTAL').AsCurrency := oPedidosProdutos.CalcularTotal_PedidoProdutos;

  Self.PreencherPropriedades;
  Self.PreencherOldValue;
end;

procedure TPedidos.OnAfterInsert(DataSet: TDataSet);
begin
  Self.LimparPropriedades;
  Self.PreencherPropriedades;

  DataSet.FieldByName('NUMEROPEDIDO').AsInteger := getNewPK;
  DataSet.FieldByName('DT_EMISSAO').AsDateTime := Date;
  DataSet.FieldByName('VLR_TOTAL').AsCurrency := 0;

  oControle.SqlQuery.Close;

  oPedidosProdutos.Carregar_PedidoProdutos(DataSet.FieldByName('NUMEROPEDIDO').AsInteger);
end;

procedure TPedidos.OnAfterOpen(DataSet: TDataSet);
begin
  TCurrencyField(DataSet.FindField('VLR_TOTAL')).DisplayFormat := '#,###,###,##0.00';
  TDateField(DataSet.FindField('DT_EMISSAO')).EditMask := '99/99/9999;1;_';
end;

function TPedidos.PesquisarPedido(pNumeroPedido: Integer; pCarregarCDS: Boolean): Boolean;
begin
  if (pNumeroPedido > 0) then
  begin
    if not pCarregarCDS then
    begin
      if ((not oControle.SqlQuery.Active) or
         ((oControle.SqlQuery.Active) and (not SameValue(oControle.SqlQuery.FieldByName('NUMEROPEDIDO').AsInteger, pNumeroPedido)))) then
      begin
        oControle.SqlQuery.Close;
        oControle.SqlQuery.SQL.Clear;
        oControle.SqlQuery.SQL.Add('SELECT ');
        oControle.SqlQuery.SQL.Add('  PEDIDOS.NUMEROPEDIDO, ');
        oControle.SqlQuery.SQL.Add('  PEDIDOS.DT_EMISSAO, ');
        oControle.SqlQuery.SQL.Add('  PEDIDOS.CLIENTE, ');
        oControle.SqlQuery.SQL.Add('  CLIENTES.NOME, ');
        oControle.SqlQuery.SQL.Add('  PEDIDOS.VLR_TOTAL ');
        oControle.SqlQuery.SQL.Add('FROM ');
        oControle.SqlQuery.SQL.Add('  PEDIDOS ');
        oControle.SqlQuery.SQL.Add('  INNER JOIN CLIENTES ON ');
        oControle.SqlQuery.SQL.Add('    CLIENTES.CODIGO = PEDIDOS.CLIENTE ');
        oControle.SqlQuery.SQL.Add('WHERE  ');
        oControle.SqlQuery.SQL.Add('  PEDIDOS.NUMEROPEDIDO = :pNumeroPedido ');
        oControle.SqlQuery.Params.Clear;
        oControle.SqlQuery.Params.CreateParam(ftInteger, 'pNumeroPedido', ptInput);
        oControle.SqlQuery.Params.ParamByName('pNumeroPedido').AsInteger := pNumeroPedido;

        try
          oControle.SqlQuery.Open;

          if oControle.SqlQuery.IsEmpty then
          begin
            LimparPropriedades;
            Result := False;
          end else
          begin
            Self.NumeroPedido := oControle.SqlQuery.FieldByName('NUMEROPEDIDO').AsInteger;
            Self.DtEmissao := oControle.SqlQuery.FieldByName('DT_EMISSAO').AsDateTime;
            Self.Cliente := oControle.SqlQuery.FieldByName('CLIENTE').AsInteger;
            sNomeCliente := oControle.SqlQuery.FieldByName('NOME').AsString;
            Self.VlrTotal := oControle.SqlQuery.FieldByName('VLR_TOTAL').AsCurrency;

            Result := True;
          end;
        except
          Result := False;
        end;
      end;
    end else
    begin
      oControle.CdsResult.Active := False;
      oControle.CdsResult.Params.ParamByName('pNumeroPedido').AsInteger := pNumeroPedido;
      oControle.CdsResult.Active := True;

      if (not oControle.CdsResult.IsEmpty) then
      begin
        oPedidosProdutos.Carregar_PedidoProdutos(pNumeroPedido);

        oControle.CdsResult.Edit;
        Result := True;
      end else
        Result := False;
    end;
  end else
    Result := False;
end;

procedure TPedidos.PreencherOldValue;
begin
  iOldNumeroPedido := oControle.CdsResult.FieldByName('NUMEROPEDIDO').AsInteger;
  dtOldDtEmissao := oControle.CdsResult.FieldByName('DT_EMISSAO').AsDateTime;
  iOldCliente := oControle.CdsResult.FieldByName('CLIENTE').AsInteger;
  nOldVlrTotal := oControle.CdsResult.FieldByName('VLR_TOTAL').AsCurrency;
end;

procedure TPedidos.PreencherPropriedades;
begin
  iNumeroPedido := oControle.CdsResult.FieldByName('NUMEROPEDIDO').AsInteger;
  dtDtEmissao := oControle.CdsResult.FieldByName('DT_EMISSAO').AsDateTime;
  iCliente := oControle.CdsResult.FieldByName('CLIENTE').AsInteger;
  nVlrTotal := oControle.CdsResult.FieldByName('VLR_TOTAL').AsCurrency;
  if oPedidosProdutos.CdsListaPedidosProdutos.State in [dsInsert, dsEdit] then
    nVlrTotal := nVlrTotal + oPedidosProdutos.CalcularTotal_PedidoProdutos;
end;

procedure TPedidos.setNumeroPedido(pNumeroPedido: Integer);
begin
  iNumeroPedido := pNumeroPedido;
  oPedidosProdutos.NumeroPedido := pNumeroPedido;
end;

procedure TPedidos.AlterarPedido(pResetarCDS: Boolean = True);
var
  bTemAlteracao: Boolean;
begin
  bTemAlteracao := (not SameValue(Self.DtEmissao, Self.OldDtEmissao)) or
                   (not SameValue(Self.Cliente, Self.OldCliente)) or
                   (not SameValue(Self.VlrTotal, Self.OldVlrTotal));

  if bTemAlteracao then
  begin
    PreencherPropriedades;

    oControle.SqlQuery.Close;
    oControle.SqlQuery.SQL.Clear;
    oControle.SqlQuery.SQL.Add('UPDATE ');
    oControle.SqlQuery.SQL.Add('  PEDIDOS ');
    oControle.SqlQuery.SQL.Add('SET ');
    if not SameValue(Self.DtEmissao, Self.OldDtEmissao) then
      oControle.SqlQuery.SQL.Add('  DT_EMISSAO = CAST('+QuotedStr(FormatDateTime('DD.MM.YYYY', Self.DtEmissao))+' AS DATE), ');

    if not SameValue(Self.Cliente, Self.OldCliente) then
      oControle.SqlQuery.SQL.Add('  CLIENTE = :pCliente, ');
    if not SameValue(Self.VlrTotal, Self.OldVlrTotal) then
      oControle.SqlQuery.SQL.Add('  VLR_TOTAL = :pVlrTotal, ');

    oControle.SqlQuery.SQL.Text := Copy(oControle.SqlQuery.SQL.Text, 0, Length(Trim(oControle.SqlQuery.SQL.Text)) - 1) + ' '; // remove o últmo ", ".

    oControle.SqlQuery.SQL.Add('WHERE ');
    oControle.SqlQuery.SQL.Add('  NUMEROPEDIDO = :pNumeroPedido ');

    oControle.SqlQuery.Params.Clear;
    oControle.SqlQuery.Params.CreateParam(ftInteger, 'pNumeroPedido', ptInput);
    if not SameValue(Self.Cliente, Self.OldCliente) then
      oControle.SqlQuery.Params.CreateParam(ftInteger, 'pCliente', ptInput);
    if not SameValue(Self.VlrTotal, Self.OldVlrTotal) then
      oControle.SqlQuery.Params.CreateParam(ftFloat, 'pVlrTotal', ptInput);

    oControle.SqlQuery.Params.ParamByName('pNumeroPedido').AsInteger := Self.NumeroPedido;
    if not SameValue(Self.Cliente, Self.OldCliente) then
      oControle.SqlQuery.Params.ParamByName('pCliente').AsInteger := Self.Cliente;
    if not SameValue(Self.VlrTotal, Self.OldVlrTotal) then
      oControle.SqlQuery.Params.ParamByName('pVlrTotal').AsCurrency := Self.VlrTotal;

    try
      oControle.SqlQuery.ExecSQL;

      if pResetarCDS then
      begin
        Application.MessageBox(PWideChar('Pedido alterado com sucesso.'), 'Informação', MB_ICONINFORMATION + MB_OK);

        LimparPropriedades;
        oControle.CdsResult.Cancel;
        oControle.CdsResult.Insert;
      end;
    except
      on e: Exception do
      begin
        Application.MessageBox(PWideChar('Ocorreu o seguinte erro ao alterar o pedido.'+#13+#10+' "'+e.Message+'".'), 'Erro na alteração', MB_ICONERROR + MB_OK);
      end;
    end;
  end else
  begin
    LimparPropriedades;
    oControle.CdsResult.Cancel;
    if pResetarCDS then
      oControle.CdsResult.Insert
    else
    begin
      oControle.CdsResult.Refresh;
      if oControle.CdsResult.Locate('NUMEROPEDIDO', Self.NumeroPedido, [loPartialKey, loCaseInsensitive]) then
      begin
        oControle.CdsResult.Edit;
        Self.PreencherPropriedades;
        Self.PreencherOldValue;
      end;
    end;
  end;
end;

procedure TPedidos.AtualziarCDSResult;
begin
  try
    oControle.CdsResult.DisableControls;

    oControle.CdsResult.Cancel;
    oControle.CdsResult.Close;
    oControle.CdsResult.Params.ParamByName('pNumeroPedido').AsInteger := Self.NumeroPedido;
    oControle.CdsResult.Open;

    oControle.CdsResult.Locate('NUMEROPEDIDO', Self.NumeroPedido, [loPartialKey, loCaseInsensitive]);
    oControle.CdsResult.Edit;
  finally
    oControle.CdsResult.EnableControls;
  end;
end;

constructor TPedidos.Create(pConexaoControle: TControle);
begin
  if not Assigned(oControle) then
    oControle := pConexaoControle;

  if not Assigned(oClientes) then
    oClientes := TClientes.Create(pConexaoControle);

  {$REGION 'Configuração do CDS Pedidos'}
  oControle.CdsResult.AfterInsert := Self.OnAfterInsert;
  oControle.CdsResult.AfterEdit := Self.OnAfterEdit;
  oControle.CdsResult.AfterOpen := Self.OnAfterOpen;

  oControle.CdsResult.Close;
  oControle.CdsResult.CommandText := 'SELECT '+
                                     '  PEDIDOS.NUMEROPEDIDO, '+
                                     '  PEDIDOS.DT_EMISSAO, '+
                                     '  PEDIDOS.CLIENTE, '+
                                     '  CLIENTES.NOME, '+
                                     '  PEDIDOS.VLR_TOTAL '+
                                     'FROM '+
                                     '  PEDIDOS '+
                                     '  INNER JOIN CLIENTES ON '+
                                     '    CLIENTES.CODIGO = PEDIDOS.CLIENTE '+
                                     'WHERE '+
                                     '  PEDIDOS.NUMEROPEDIDO = :pNumeroPedido ';
  oControle.CdsResult.Params.Clear;
  oControle.CdsResult.Params.CreateParam(ftInteger, 'pNumeroPedido', ptInput);
  {$ENDREGION}

  if not Assigned(oPedidosProdutos) then
    oPedidosProdutos := TPedidosProdutos.Create(pConexaoControle);
end;

destructor TPedidos.Destroy;
begin
  if Assigned(oClientes) then
    FreeAndNil(oClientes);

  inherited;
end;

procedure TPedidos.ExcluirPedido(pNumeroPedido: Integer);
begin
  if PesquisarPedido(pNumeroPedido) then
  begin
    try
      oControle.StartTransaction;

      oControle.SqlQuery.Close;
      oControle.SqlQuery.SQL.Clear;
      oControle.SqlQuery.SQL.Add('DELETE FROM PEDIDOSPRODUTOS WHERE NUMEROPEDIDO = :pNumeroPedido');
      oControle.SqlQuery.Params.Clear;
      oControle.SqlQuery.Params.CreateParam(ftInteger, 'pNumeroPedido', ptInput);
      oControle.SqlQuery.Params.ParamByName('pNumeroPedido').AsInteger := pNumeroPedido;

      try
        oControle.SqlQuery.ExecSQL;
      except
        on e: Exception do
        begin
          if oControle.InTransaction then
            oControle.RollbackTransaction;
          Application.MessageBox(PWideChar('Ocorreu o seguinte erro ao excluir o pedido de número "'+IntToStr(pNumeroPedido)+'". Por favor, verifique o erro à seguir:'+#13+#10+'Erro: "'+e.Message+'".'), 'Erro', MB_ICONERROR + MB_OK);
        end;
      end;

      oControle.SqlQuery.Close;
      oControle.SqlQuery.SQL.Clear;
      oControle.SqlQuery.SQL.Add('DELETE FROM PEDIDOS WHERE NUMEROPEDIDO = :pNumeroPedido');
      oControle.SqlQuery.Params.Clear;
      oControle.SqlQuery.Params.CreateParam(ftInteger, 'pNumeroPedido', ptInput);
      oControle.SqlQuery.Params.ParamByName('pNumeroPedido').AsInteger := pNumeroPedido;

      try
        oControle.SqlQuery.ExecSQL;

        Application.MessageBox(PWideChar('O pedido de número "'+IntToStr(pNumeroPedido)+'" foi excluído com sucesso.'), 'Informação', MB_ICONINFORMATION + MB_OK);
      except
        on e: Exception do
        begin
          if oControle.InTransaction then
            oControle.RollbackTransaction;
          Application.MessageBox(PWideChar('Ocorreu o seguinte erro ao excluir o pedido de número "'+IntToStr(pNumeroPedido)+'". Por favor, verifique o erro à seguir:'+#13+#10+'Erro: "'+e.Message+'".'), 'Erro', MB_ICONERROR + MB_OK);
        end;
      end;
    finally
      if oControle.InTransaction then
        oControle.CommitTransaction;

      if (oControle.CdsResult.State in [dsInsert, dsEdit]) then
        oControle.CdsResult.Cancel;
      if (oControle.CdsResult.Active) and (not (oControle.CdsResult.State in [dsInsert, dsEdit])) then
        oControle.CdsResult.Insert;
    end;
  end else
    Application.MessageBox(PWideChar('Não foi possível excluir o pedido de número "'+IntToStr(pNumeroPedido)+'", pois o pedido não existe.'), 'Atenção', MB_ICONWARNING + MB_OK);
end;

function TPedidos.getCdsPedidos: TClientDataSet;
begin
  Result := oControle.CdsResult;
end;

function TPedidos.getNewPK: Integer;
begin
  oControle.SqlQuery.Close;
  oControle.SqlQuery.SQL.Clear;
  oControle.SqlQuery.SQL.Add('SELECT COALESCE(MAX(NUMEROPEDIDO),0) + 1 NEWPK FROM PEDIDOS');
  try
    oControle.SqlQuery.Open;

    Result := oControle.SqlQuery.FieldByName('NEWPK').AsInteger;
  except
    on e: Exception do
    begin
      Application.MessageBox(PWideChar('Ocorreu o seguinte erro ao buscar o novo número do pedido.'+#13+#10+'Erro: "'+e.Message+'".'), 'Erro', MB_ICONERROR + MB_OK);
      Result := 0;
    end;
  end;
end;

function TPedidos.getNomeCliente: string;
begin
  if oClientes.PesquisarCliente(Self.Cliente) then
  begin
    sNomeCliente := oClientes.nome;
  end else
    sNomeCliente := '';

  Result := sNomeCliente;
end;

function TPedidos.getNumeroPedido: Integer;
begin
  Result := iNumeroPedido;
end;

procedure TPedidos.GravarItemPedido(pResetarCDS: Boolean = True);
begin
  if (Self.CdsPedidos.State in [dsInsert]) then
    Self.GravarPedido(pResetarCDS);

  if (oPedidosProdutos.CdsListaPedidosProdutos.State in [dsInsert, dsEdit]) then
    if oPedidosProdutos.SalvarItem_PedidoProdutos then
    begin
      Self.VlrTotal := oPedidosProdutos.CalcularTotal_PedidoProdutos;
      oControle.CdsResult.FieldByName('VLR_TOTAL').AsCurrency := Self.VlrTotal;

      Self.AlterarPedido(pResetarCDS);

      Self.AtualziarCDSResult;
    end;
end;

procedure TPedidos.GravarPedido(pResetarCDS: Boolean = True);
begin
  if oControle.CdsResult.State in [dsInsert] then
    InserirPedido(pResetarCDS)
  else if oControle.CdsResult.State in [dsEdit] then
    AlterarPedido(pResetarCDS);
end;

procedure TPedidos.InserirPedido(pResetarCDS: Boolean = True);
var
  iNewPK: integer;
  iNumPedido: integer;
begin
  PreencherPropriedades;

  iNewPK := getNewPK;
  if Self.NumeroPedido < iNewPK then
  begin
    Application.MessageBox(PWideChar('O número do pedido será atualizado para: "'+IntToStr(iNewPK)+'".'), 'Informação', MB_ICONINFORMATION + MB_OK);
    Self.NumeroPedido := iNewPK;
    if oControle.CdsResult.State in [dsInsert] then
      oControle.CdsResult.FieldByName('NUMEROPEDIDO').AsInteger := iNewPK;
  end;

  oControle.SqlQuery.Close;
  oControle.SqlQuery.SQL.Clear;
  oControle.SqlQuery.SQL.Add('INSERT INTO PEDIDOS ');
  oControle.SqlQuery.SQL.Add('  (NUMEROPEDIDO, DT_EMISSAO, CLIENTE, VLR_TOTAL) ');
  oControle.SqlQuery.SQL.Add('VALUES ');
  oControle.SqlQuery.SQL.Add('  (:pNumeroPedido, :pDtEmissao, :pCliente, :pVlrTotal) ');

  oControle.SqlQuery.Params.Clear;
  oControle.SqlQuery.Params.CreateParam(ftInteger, 'pNumeroPedido', ptInput);
  oControle.SqlQuery.Params.CreateParam(ftDate, 'pDtEmissao', ptInput);
  oControle.SqlQuery.Params.CreateParam(ftInteger, 'pCliente', ptInput);
  oControle.SqlQuery.Params.CreateParam(ftFloat, 'pVlrTotal', ptInput);
  oControle.SqlQuery.Params.ParamByName('pNumeroPedido').AsInteger := Self.NumeroPedido;
  oControle.SqlQuery.Params.ParamByName('pDtEmissao').AsDate := Self.DtEmissao;
  oControle.SqlQuery.Params.ParamByName('pCliente').AsInteger := Self.Cliente;
  oControle.SqlQuery.Params.ParamByName('pVlrTotal').AsCurrency := Self.VlrTotal;

  try
    oControle.SqlQuery.ExecSQL;

    if pResetarCDS then
    begin
      Application.MessageBox(PWideChar('Pedido cadastrador com sucesso.'), 'Informação', MB_ICONINFORMATION + MB_OK);
      LimparPropriedades;

      oControle.CdsResult.Cancel;
      oControle.CdsResult.Insert;
    end;
  except
    on e: Exception do
    begin
      Application.MessageBox(PWideChar('Ocorreu o seguinte erro ao inserir um novo pedido.'+#13+#10+' "'+e.Message+'".'), 'Erro de inclusão', MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TPedidos.LimparPropriedades;
begin
  iNumeroPedido := 0;
  dtDtEmissao := 0;
  iCliente := 0;
  sNomeCliente := '';
  nVlrTotal := 0;

  iOldNumeroPedido := 0;
  dtOldDtEmissao := 0;
  iOldCliente := 0;
  nOldVlrTotal := 0;
end;

end.
