program WKC_PedidoVenda;

uses
  Forms,
  Clientes in 'Clientes.pas',
  ConexaoBanco in 'ConexaoBanco.pas',
  Controle in 'Controle.pas',
  DMConexao in 'DMConexao.pas' {DMConexaoF: TDataModule},
  Entity in 'Entity.pas',
  Pedidos in 'Pedidos.pas',
  PedidosProdutos in 'PedidosProdutos.pas',
  PedidoVenda in 'PedidoVenda.pas' {PedidoVendaF},
  Produtos in 'Produtos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMConexaoF, DMConexaoF);
  Application.CreateForm(TPedidoVendaF, PedidoVendaF);
  Application.Run;
end.
