unit PedidoVenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ExtCtrls, StdCtrls, Mask, WideStrings, DBXMySql, DB,
  SqlExpr, DBXFirebird, FMTBcd, DBCtrls, ComCtrls, DBClient, Provider, Buttons,
  Controle, Pedidos;

type
  TPedidoVendaF = class(TForm)
    dsPedidoProdutos: TDataSource;
    pnlDadosPedido: TPanel;
    lblNumeroPedido: TLabel;
    lblDataEmissao: TLabel;
    lblCodigoCliente: TLabel;
    edtNomeCliente: TEdit;
    dsPedido: TDataSource;
    dbedtDtEmissao: TDBEdit;
    dbeCliente: TDBEdit;
    pnlPedidoProdutos: TPanel;
    pnlItemPedido: TPanel;
    dbgItensPedido: TDBGrid;
    lblProduto: TLabel;
    dbeProduto: TDBEdit;
    lblQuantidade: TLabel;
    dbeQuantidade: TDBEdit;
    lblVlrUnitario: TLabel;
    dbeVlrUnitario: TDBEdit;
    lblVlr_Total: TLabel;
    dbeVlrTotal: TDBEdit;
    pnlPedidoTotal: TPanel;
    lblValorTotal: TLabel;
    dbeVlr_Total: TDBEdit;
    btnPedPrdNovo: TButton;
    btnPedPrdAlterar: TButton;
    btnPedPrdExcluir: TButton;
    btnPedPrdSalvar: TButton;
    btnPedPrdCancelar: TButton;
    btnPedidosGravar: TButton;
    btnPedidosCarregar: TBitBtn;
    btnPedidosCancelar: TButton;
    dbeNumeroPedido: TDBEdit;
    dbeDescricao: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbeClienteChange(Sender: TObject);
    procedure btnPedidosGravarClick(Sender: TObject);
    procedure btnPedidosCancelarClick(Sender: TObject);
    procedure btnPedidosCarregarClick(Sender: TObject);
    procedure btnPedPrdNovoClick(Sender: TObject);
    procedure btnPedPrdCancelarClick(Sender: TObject);
    procedure btnPedPrdAlterarClick(Sender: TObject);
    procedure btnPedPrdExcluirClick(Sender: TObject);
    procedure dbeProdutoChange(Sender: TObject);
    procedure dbeQuantidadeExit(Sender: TObject);
    procedure btnPedPrdSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgItensPedidoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgItensPedidoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    oControleConexao: TControle;

    procedure HabilitaDesabilita;
    procedure HabilitaDesabilita_PedidosProduto;
  protected
    oPedidos: TPedidos;

    function ValidaCamposPedido: Boolean;
    function ValidaCamposPedidoProdutos: Boolean;
  public
    { Public declarations }
  end;

var
  PedidoVendaF: TPedidoVendaF;

implementation

uses
  StrUtils, Math, DMConexao;

{$R *.dfm}

procedure TPedidoVendaF.btnPedidosCarregarClick(Sender: TObject);
var
  sNumeroPedido: string;
begin
  if InputQuery('Pesquisar de Pedido', 'Informe o número do pedido que deseja pesquisar.', sNumeroPedido) then
  begin
    oPedidos.PesquisarPedido(StrToIntDef(sNumeroPedido, 0), True);

    btnPedidosGravar.Enabled := (oPedidos.CdsPedidos.State in [dsInsert, dsEdit]);

    HabilitaDesabilita;
    HabilitaDesabilita_PedidosProduto;
  end;
end;

procedure TPedidoVendaF.btnPedidosCancelarClick(Sender: TObject);
var
  sNumeroPedido: string;
begin
  if InputQuery('Exclusão de Pedido', 'Informe o número do pedido que deseja excluir.', sNumeroPedido) then
    oPedidos.ExcluirPedido(StrToIntDef(sNumeroPedido, 0));

  HabilitaDesabilita;
  HabilitaDesabilita_PedidosProduto;
end;

procedure TPedidoVendaF.btnPedidosGravarClick(Sender: TObject);
begin
  if ValidaCamposPedido then
      oPedidos.GravarPedido;

  if (oPedidos.CdsPedidos.State in [dsInsert, dsEdit]) then
  begin
    btnPedidosGravar.Enabled := True;

    HabilitaDesabilita;
    HabilitaDesabilita_PedidosProduto;
  end;
end;

procedure TPedidoVendaF.btnPedPrdAlterarClick(Sender: TObject);
begin
  oPedidos.ItensProduto.CdsListaPedidosProdutos.Edit;

  HabilitaDesabilita_PedidosProduto;
end;

procedure TPedidoVendaF.btnPedPrdCancelarClick(Sender: TObject);
begin
  if (oPedidos.ItensProduto.CdsListaPedidosProdutos.State in [dsInsert, dsEdit]) then
    oPedidos.ItensProduto.CdsListaPedidosProdutos.Cancel;

  HabilitaDesabilita_PedidosProduto;
end;

procedure TPedidoVendaF.btnPedPrdExcluirClick(Sender: TObject);
begin
  if Application.MessageBox(PWideChar('Deseja excluir o produto "'+oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('PRODUTO').AsString+' - '+oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('DESCRICAO').AsString+'"?'), 'Confirmação', MB_ICONQUESTION + MB_YESNO) = mrYes then
  begin
    oPedidos.ItensProduto.ExcluirItem_PedidoProdutos(oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('AUTOINCREMENTO').AsInteger);
    if (oPedidos.CdsPedidos.State in [dsInsert, dsEdit]) then
    begin
      if oPedidos.ItensProduto.CdsListaPedidosProdutos.IsEmpty then
        oPedidos.CdsPedidos.FieldByName('VLR_TOTAL').AsCurrency := 0
      else
        oPedidos.CdsPedidos.FieldByName('VLR_TOTAL').AsCurrency := oPedidos.ItensProduto.CalcularTotal_PedidoProdutos;
      oPedidos.VlrTotal := oPedidos.CdsPedidos.FieldByName('VLR_TOTAL').AsCurrency;
      oPedidos.GravarPedido(False);
    end else
      oPedidos.CdsPedidos.Refresh;
    HabilitaDesabilita_PedidosProduto;
  end;
end;

procedure TPedidoVendaF.btnPedPrdNovoClick(Sender: TObject);
begin
  oPedidos.ItensProduto.CdsListaPedidosProdutos.Insert;
  oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('NUMEROPEDIDO').AsInteger := oPedidos.CdsPedidos.FieldByName('NumeroPedido').AsInteger;
  HabilitaDesabilita_PedidosProduto;
  if dbeProduto.CanFocus then
    dbeProduto.SetFocus;
end;

procedure TPedidoVendaF.btnPedPrdSalvarClick(Sender: TObject);
begin
  oPedidos.GravarItemPedido(False);

  HabilitaDesabilita_PedidosProduto;
end;

procedure TPedidoVendaF.dbeClienteChange(Sender: TObject);
begin
  oPedidos.Cliente := StrToIntDef(dbeCliente.Text, 0);
  edtNomeCliente.Text := oPedidos.NomeCliente;

  HabilitaDesabilita;
end;

procedure TPedidoVendaF.dbeProdutoChange(Sender: TObject);
begin
  oPedidos.ItensProduto.Produto := StrToIntDef(dbeProduto.Text,0);
  if oPedidos.ItensProduto.Produtos.PesquisarProduto(oPedidos.ItensProduto.Produto) then
  begin
    if (oPedidos.ItensProduto.CdsListaPedidosProdutos.State in [dsInsert, dsEdit]) then
    begin
      oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('DESCRICAO').AsString := oPedidos.ItensProduto.Produtos.Descricao;
      oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('QUANTIDADE').AsInteger := 1;
      oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('VLR_UNITARIO').AsCurrency := oPedidos.ItensProduto.Produtos.VlrVenda;
      oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('VLR_TOTAL').AsCurrency := oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('QUANTIDADE').AsInteger * oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('VLR_UNITARIO').AsCurrency;
    end;
  end else
  begin
    if (oPedidos.ItensProduto.CdsListaPedidosProdutos.State in [dsInsert, dsEdit]) then
    begin
      oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('DESCRICAO').AsString := '';
      oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('QUANTIDADE').AsInteger := 1;
      oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('VLR_UNITARIO').AsCurrency := 0;
      oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('VLR_TOTAL').AsCurrency := 0;
    end;
  end;
end;

procedure TPedidoVendaF.dbeQuantidadeExit(Sender: TObject);
begin
  if (oPedidos.ItensProduto.CdsListaPedidosProdutos.State in [dsInsert, dsEdit]) then
    oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('VLR_TOTAL').AsCurrency := oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('QUANTIDADE').AsInteger *
                                                                                         oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('VLR_UNITARIO').AsCurrency;
end;

procedure TPedidoVendaF.dbgItensPedidoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (Shift = [ssCtrl]) then
  begin
    Key := 0;
    Exit;
  end;

  if (Key = VK_INSERT) and (Shift = []) then
  begin
    Key := 0;
    btnPedPrdNovo.Click;
    Exit;
  end;

  if (Key = VK_DELETE) and (Shift = []) then
  begin
    Key := 0;
    btnPedPrdExcluir.Click;
    Exit;
  end;
end;

procedure TPedidoVendaF.dbgItensPedidoKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    if (not dsPedidoProdutos.DataSet.IsEmpty) then
      btnPedPrdAlterar.Click;
  end;
end;

procedure TPedidoVendaF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if oPedidos.ItensProduto.CdsListaPedidosProdutos.State in [dsInsert, dsEdit] then
  begin
    Application.MessageBox('O item do pedido está em inserção/edição, salve ou cancele a operação antes de fechar a tela do pedido.', 'Atenção', MB_ICONWARNING + MB_OK);
    Action := caNone;
    Abort;
  end;

  if oPedidos.ObrigarSalvarPedido then
    oPedidos.GravarPedido;
end;

procedure TPedidoVendaF.FormCreate(Sender: TObject);
begin
  oControleConexao := TControle.Create;

  oPedidos := TPedidos.Create(oControleConexao);
  dsPedido.DataSet := oPedidos.CdsPedidos;
  dsPedidoProdutos.DataSet := oPedidos.ItensProduto.CdsListaPedidosProdutos;
end;

procedure TPedidoVendaF.FormDestroy(Sender: TObject);
begin
  if Assigned(oPedidos) then
    FreeAndNil(oPedidos);

  if Assigned(oControleConexao) then
    FreeAndNil(oControleConexao);
end;

procedure TPedidoVendaF.FormShow(Sender: TObject);
begin
  if not oPedidos.CdsPedidos.Active then
    oPedidos.CdsPedidos.Active := True;

  oPedidos.CdsPedidos.Insert;

  if dbeCliente.CanFocus then
    dbeCliente.SetFocus;

  HabilitaDesabilita;
  HabilitaDesabilita_PedidosProduto;
end;

procedure TPedidoVendaF.HabilitaDesabilita;
begin
  btnPedidosCarregar.Enabled := (Trim(dbeCliente.Text) = '');
  btnPedidosCancelar.Enabled := (Trim(dbeCliente.Text) = '') and (oPedidos.CdsPedidos.FieldByName('NUMEROPEDIDO').AsInteger > 1) and (oPedidos.CdsPedidos.FieldByName('CLIENTE').IsNull);
end;

procedure TPedidoVendaF.HabilitaDesabilita_PedidosProduto;
begin
  btnPedPrdNovo.Enabled := (not (oPedidos.ItensProduto.CdsListaPedidosProdutos.State in [dsInsert, dsEdit]));
  btnPedPrdAlterar.Enabled := (btnPedPrdNovo.Enabled) and (not oPedidos.ItensProduto.CdsListaPedidosProdutos.IsEmpty);
  btnPedPrdExcluir.Enabled := btnPedPrdAlterar.Enabled;

  btnPedPrdSalvar.Enabled := (oPedidos.ItensProduto.CdsListaPedidosProdutos.State in [dsInsert, dsEdit]);
  btnPedPrdCancelar.Enabled := btnPedPrdSalvar.Enabled;

  if btnPedPrdSalvar.Enabled then
  begin
    dbeProduto.Color := clWindow;
    dbeProduto.ReadOnly := False;
    dbeProduto.TabStop := True;

    dbeQuantidade.Color := clWindow;
    dbeQuantidade.ReadOnly := False;
    dbeQuantidade.TabStop := True;

    dbeVlrUnitario.Color := clWindow;
    dbeVlrUnitario.ReadOnly := False;
    dbeVlrUnitario.TabStop := True;

    if dbeProduto.CanFocus then
      dbeProduto.SetFocus;
  end
  else if btnPedPrdNovo.Enabled then
  begin
    dbeProduto.Color := clBtnFace;
    dbeProduto.ReadOnly := True;
    dbeProduto.TabStop := False;

    dbeQuantidade.Color := clBtnFace;
    dbeQuantidade.ReadOnly := True;
    dbeQuantidade.TabStop := False;

    dbeVlrUnitario.Color := clBtnFace;
    dbeVlrUnitario.ReadOnly := True;
    dbeVlrUnitario.TabStop := False;

    if dbgItensPedido.CanFocus then
      dbgItensPedido.SetFocus;
  end;
end;

function TPedidoVendaF.ValidaCamposPedido: Boolean;
begin
  Result := True;

  if (oPedidos.CdsPedidos.FieldByName('DT_EMISSAO').AsDateTime = 0) then
  begin
    Result := False;
    Application.MessageBox('O campo "Dt. Emissão" deve ser preenchido.', 'Campo requisitado', MB_ICONWARNING + MB_OK);
    if dbedtDtEmissao.CanFocus then
      dbedtDtEmissao.SetFocus;
    Abort;
  end;

  if (oPedidos.CdsPedidos.FieldByName('DT_EMISSAO').AsDateTime > Date) then
  begin
    Result := False;
    Application.MessageBox('O campo "Dt. Emissão" não pode ser maior do que o dia de hoje.', 'Valor inválido', MB_ICONWARNING + MB_OK);
    if dbedtDtEmissao.CanFocus then
      dbedtDtEmissao.SetFocus;
    Abort;
  end;

  if (oPedidos.CdsPedidos.FieldByName('CLIENTE').AsInteger = 0) or (Trim(edtNomeCliente.Text) = '') then
  begin
    Result := False;
    Application.MessageBox('O campo "Cliente" deve ser preenchido com um valor válido.', 'Campo requisitado', MB_ICONWARNING + MB_OK);
    if dbeCliente.CanFocus then
      dbeCliente.SetFocus;
    Abort;
  end;

  if (oPedidos.ItensProduto.CdsListaPedidosProdutos.IsEmpty) then
  begin
    Result := False;
    Application.MessageBox('Deve ser informado pelo menos um item do pedido.', 'Item requisitado', MB_ICONWARNING + MB_OK);
    if btnPedPrdNovo.CanFocus then
      btnPedPrdNovo.SetFocus;
    Abort;
  end;
end;

function TPedidoVendaF.ValidaCamposPedidoProdutos: Boolean;
begin
  Result := True;

  if (Trim(oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('CODIGO').AsString) = '') then
  begin
    Result := False;
    Application.MessageBox('O campo "Produto" deve ser preenchido.', 'Campo requisitado', MB_ICONWARNING + MB_OK);
    if dbeProduto.CanFocus then
      dbeProduto.SetFocus;
    Abort;
  end;

  if (Trim(oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('QUANTIDADE').AsString) = '') then
  begin
    Result := False;
    Application.MessageBox('O campo "Quantidade" deve ser preenchido.', 'Campo requisitado', MB_ICONWARNING + MB_OK);
    if dbeQuantidade.CanFocus then
      dbeQuantidade.SetFocus;
    Abort;
  end;

  if (oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('QUANTIDADE').AsInteger <= 0) then
  begin
    Result := False;
    Application.MessageBox('O campo "Quantidade" deve ser maior do que zero.', 'Campo requisitado', MB_ICONWARNING + MB_OK);
    if dbeQuantidade.CanFocus then
      dbeQuantidade.SetFocus;
    Abort;
  end;

  if (Trim(oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('VLR_UNITARIO').AsString) = '') then
  begin
    Result := False;
    Application.MessageBox('O campo "Vlr Unitário" deve ser preenchido.', 'Campo requisitado', MB_ICONWARNING + MB_OK);
    if dbeQuantidade.CanFocus then
      dbeQuantidade.SetFocus;
    Abort;
  end;

  if (oPedidos.ItensProduto.CdsListaPedidosProdutos.FieldByName('VLR_UNITARIO').AsInteger <= 0) then
  begin
    Result := False;
    Application.MessageBox('O campo "Vlr Unitário" deve ser maior do que zero.', 'Campo requisitado', MB_ICONWARNING + MB_OK);
    if dbeQuantidade.CanFocus then
      dbeQuantidade.SetFocus;
    Abort;
  end;
end;

end.
