unit Controle;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, Variants,
  Contnrs, SqlExpr, StrUtils, Provider, DBClient, IniFiles, ConexaoBanco;

type
  TControle = class
    private
      oID: Integer;

      oConexao: TConexaoBanco;

      oSQLQuery: TSQLQuery;

      oSQLResult: TSQLQuery;
      oDspResult: TDataSetProvider;
      oCdsResult: TClientDataSet;

      oSQLLista: TSQLQuery;
      oDspLista: TDataSetProvider;
      oCdsLista: TClientDataSet;

      oTransaction: TTransactionDesc;
    public
      constructor Create;
      destructor Destroy; override;

      procedure StartTransaction;
      procedure CommitTransaction;
      procedure RollbackTransaction;

      function InTransaction: Boolean;

      property SqlQuery: TSQLQuery read oSQLQuery write oSQLQuery;

      property SqlResult: TSQLQuery read oSQLResult write oSQLResult;
      property DspResult: TDataSetProvider read oDspResult write oDspResult;
      property CdsResult: TClientDataSet read oCdsResult write oCdsResult;

      property SqlLista: TSQLQuery read oSQLLista write oSQLLista;
      property DspLista: TDataSetProvider read oDspLista write oDspLista;
      property CdsLista: TClientDataSet read oCdsLista write oCdsLista;
  end;

implementation

{ TControle }

procedure TControle.CommitTransaction;
begin
  if Self.oConexao.ConexaoBanco.InTransaction then
    Self.oConexao.ConexaoBanco.Commit(oTransaction);
end;

constructor TControle.Create;

  procedure ConfigurarSQLQ(pSQL: TSQLQuery; pNameSQL: string);
  begin
    pSQL.SQLConnection := oConexao.ConexaoBanco;
    pSQL.Name := pNameSQL;
  end;

  procedure ConfigurarDSP(pSQL: TSQLQuery; pDSP: TDataSetProvider; pNameDSP: string);
  begin
    pDSP.DataSet := pSQL;
    pDSP.Options := pDSP.Options + [poCascadeDeletes, poCascadeUpdates, poAllowCommandText, poUseQuoteChar];
    pDSP.Name := pNameDSP;
  end;

  procedure ConfigurarCDS(pDSP: TDataSetProvider; pCDS: TClientDataSet; pNameCDS: string);
  begin
    pCDS.ProviderName := pDSP.Name;
    pCDS.Name := pNameCDS;
  end;

begin
  oConexao := TConexaoBanco.Create;

  {$REGION 'Objeto Query'}
  oSQLQuery := TSQLQuery.Create(Application);
  ConfigurarSQLQ(oSQLQuery, 'oSQLQuery');
  {$ENDREGION}

  {$REGION 'Objeto Result'}
  oSQLResult := TSQLQuery.Create(Application);
  oDspResult := TDataSetProvider.Create(Application);
  oCdsResult := TClientDataSet.Create(Application);

  ConfigurarSQLQ(oSQLResult, 'oSQLResult');
  ConfigurarDSP(oSQLResult, oDspResult, 'oDspResult');
  ConfigurarCDS(oDspResult, oCdsResult, 'oCdsResult');
  {$ENDREGION}

  {$REGION 'Objeto Lista'}
  oSQLLista := TSQLQuery.Create(Application);
  oDspLista := TDataSetProvider.Create(Application);
  oCdsLista := TClientDataSet.Create(Application);

  ConfigurarSQLQ(oSQLLista, 'oSQLLista');
  ConfigurarDSP(oSQLLista, oDspLista, 'oDspLista');
  ConfigurarCDS(oDspLista, oCdsLista, 'oCdsLista');
  {$ENDREGION}

  oTransaction.TransactionID := Random(oID);
end;

destructor TControle.Destroy;
begin
  inherited;
end;

function TControle.InTransaction: Boolean;
begin
  Result := Self.oConexao.ConexaoBanco.InTransaction;
end;

procedure TControle.RollbackTransaction;
begin
  if Self.oConexao.ConexaoBanco.InTransaction then
    Self.oConexao.ConexaoBanco.Rollback(oTransaction);
end;

procedure TControle.StartTransaction;
begin
  if (not Self.oConexao.ConexaoBanco.InTransaction) then
    Self.oConexao.ConexaoBanco.StartTransaction(oTransaction);
end;

end.
