unit Clientes;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, ComCtrls, DB, SqlExpr, DBClient,
  StrUtils, Math, Controle;

type
  TClientes = class
    private
      iCodigo: integer;
      sNome: string;
      sCidade: string;
      sUF: string;
    protected
      oControle: TControle;

      procedure LimparRegistro;
    public
      constructor Create(pConexaoControle: TControle);
      destructor Destroy; override;

      function PesquisarCliente(pCodigo: integer): Boolean;

      property codigo: Integer read iCodigo write iCodigo;
      property nome: string read sNome write sNome;
      property cidade: string read sCidade write sCidade;
      property UF: string read sUF write sUF;
  end;

implementation

{ TClientes }

constructor TClientes.Create(pConexaoControle: TControle);
begin
  if not Assigned(pConexaoControle) then
    oControle := TControle.Create
  else
    oControle := pConexaoControle;
end;

destructor TClientes.Destroy;
begin

  inherited;
end;

procedure TClientes.LimparRegistro;
begin
  Self.codigo := 0;
  Self.nome := '';
  Self.cidade := '';
  Self.UF := '';
end;

function TClientes.PesquisarCliente(pCodigo: integer): Boolean;
begin
  if (pCodigo > 0) then
  begin
    if (not SameValue(Self.codigo, pCodigo)) then
    begin
      oControle.SqlQuery.Close;
      oControle.SqlQuery.SQL.Clear;
      oControle.SqlQuery.SQL.Add('SELECT CODIGO, NOME, CIDADE, UF ');
      oControle.SqlQuery.SQL.Add('  FROM CLIENTES ');
      oControle.SqlQuery.SQL.Add(' WHERE CODIGO = :pCodCliente ');

      oControle.SqlQuery.Params.Clear;
      oControle.SqlQuery.Params.CreateParam(ftInteger, 'pCodCliente', ptInput);
      oControle.SqlQuery.ParamByName('pCodCliente').AsInteger := pCodigo;

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
            Self.codigo := oControle.SqlQuery.FieldByName('CODIGO').AsInteger;
            Self.nome := oControle.SqlQuery.FieldByName('NOME').AsString;
            Self.cidade := oControle.SqlQuery.FieldByName('CIDADE').AsString;
            Self.UF := oControle.SqlQuery.FieldByName('UF').AsString;

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
    end else
      Result := True;
  end else
    Result := False;
end;

end.
