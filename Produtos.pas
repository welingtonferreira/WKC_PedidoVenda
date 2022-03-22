unit Produtos;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, ComCtrls, DB, SqlExpr, DBClient,
  StrUtils, Math, Controle;

type
  TProdutos = class
    private
      iCodigo: Integer;
      sDescricao: string;
      nVlrVenda: Double;
    protected
      oControle: TControle;

      procedure LimparRegistro;
    public
      constructor Create(pConexaoControle: TControle);
      destructor Destroy; override;

      function PesquisarProduto(pCodigo: Integer): Boolean;

      property Codigo: integer read iCodigo write iCodigo;
      property Descricao: string read sDescricao write sDescricao;
      property VlrVenda: Double read nVlrVenda write nVlrVenda;
  end;

implementation

{ TProdutos }

constructor TProdutos.Create(pConexaoControle: TControle);
begin
  if not Assigned(pConexaoControle) then
    oControle := TControle.Create
  else
    oControle := pConexaoControle;
end;

destructor TProdutos.Destroy;
begin

  inherited;
end;

procedure TProdutos.LimparRegistro;
begin
  Self.Codigo := 0;
  Self.Descricao := '';
  Self.VlrVenda := 0;
end;

function TProdutos.PesquisarProduto(pCodigo: Integer): Boolean;
begin
  if (pCodigo > 0) then
  begin
    Result := True;

    if (not SameValue(Self.Codigo, pCodigo)) then
    begin
      oControle.SqlQuery.Close;
      oControle.SqlQuery.SQL.Clear;
      oControle.SqlQuery.SQL.Add('SELECT CODIGO, DESCRICAO, VLR_VENDA');
      oControle.SqlQuery.SQL.Add('  FROM PRODUTOS ');
      oControle.SqlQuery.SQL.Add(' WHERE CODIGO = :pCodigo ');

      oControle.SqlQuery.Params.Clear;
      oControle.SqlQuery.Params.CreateParam(ftInteger, 'pCodigo', ptInput);
      oControle.SqlQuery.ParamByName('pCodigo').AsInteger := pCodigo;

      try
        try
          oControle.SqlQuery.Open;
        finally
          if oControle.SqlQuery.IsEmpty then
          begin
            LimparRegistro;

            Result := False;
          end else
          begin
            Self.Codigo := oControle.SqlQuery.FieldByName('CODIGO').AsInteger;
            Self.Descricao := oControle.SqlQuery.FieldByName('DESCRICAO').AsString;
            Self.VlrVenda := oControle.SqlQuery.FieldByName('VLR_VENDA').AsCurrency;

            Result := True;
          end;

          oControle.SqlQuery.Close;
        end;
      except
        on e: Exception do
        begin
          Result := False;
          Application.MessageBox(PWideChar('Ocorreu o seguinte erro ao pesquisar um cliente, "'+e.Message+'"'), 'Erro de pesquisa', MB_ICONERROR + MB_OK);
        end;
      end;
    end;
  end else
    Result := False;
end;

end.
