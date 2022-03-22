unit DMConexao;

interface

uses
  System.SysUtils, System.Classes,
  Data.DBXMySQL, Data.DB, Data.SqlExpr, Data.FMTBcd, Datasnap.Provider,
  Datasnap.DBClient;

type
  TDMConexaoF = class(TDataModule)
    SQLConexao: TSQLConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMConexaoF: TDMConexaoF;

implementation

uses
  Windows, IniFiles, Forms, Messages, StrUtils, Math;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
