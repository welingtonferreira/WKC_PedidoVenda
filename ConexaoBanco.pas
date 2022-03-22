unit ConexaoBanco;

interface

uses
  SqlExpr, IniFiles, SysUtils, Forms, Windows;

type
  TConexaoBanco = class
    private
      function oConexaoBanco: TSQLConnection;
    public
      constructor Create;
      destructor Destroy; override;

      function getConexao: TSQLConnection;

      property ConexaoBanco: TSQLConnection read getConexao;
  end;

implementation

uses
  StrUtils, Math, Messages, DMConexao;

{ TConexaoBanco }

constructor TConexaoBanco.Create;
var
  ArquivoIni, Servidor, DataBase, DriverName, UserName, PassWord, MsgERRO: string;
  LocalServer: Integer;
  Configuracoes: TIniFile;

  procedure InicializarVariaveis;
  begin
    Servidor := '';
    DataBase := '';
    DriverName := '';
    UserName := '';
    PassWord := '';

    MsgERRO := '';
  end;

begin
  ArquivoIni := ExtractFilePath(Application.ExeName) + '\config.ini';

  InicializarVariaveis;

  if not FileExists(ArquivoIni) then
  begin
    Application.MessageBox('Arquivo de configuração não encontrado.', 'Erro de conexão', MB_ICONERROR or MB_OK);
    try
      Configuracoes := TIniFile.Create(ArquivoIni);
      Configuracoes.WriteString('Dados', 'Servidor', '127.0.0.1');
      Configuracoes.WriteString('Dados', 'DataBase', 'wkc_pedidovenda');
      Configuracoes.WriteString('Dados', 'UserName', 'root');
      Configuracoes.WriteString('Dados', 'PassWord', 'masterkey');
    finally
      FreeAndNil(Configuracoes);
    end;
  end;

  begin
    Configuracoes := TIniFile.Create(ArquivoIni);
    try
      Servidor := Configuracoes.ReadString('Dados', 'Servidor', Servidor);
      DataBase := Configuracoes.ReadString('Dados', 'DataBase', DataBase);
      DriverName := Configuracoes.ReadString('Dados', 'DriverName', DriverName);
      UserName := Configuracoes.ReadString('Dados', 'UserName', UserName);
      PassWord := Configuracoes.ReadString('Dados', 'PassWord', PassWord);
    finally
      FreeAndNil(Configuracoes);
    end;

    if not Assigned(DMConexaoF) then
      Application.CreateForm(TDMConexaoF, DMConexaoF);

    oConexaoBanco.Connected := False;
    oConexaoBanco.LoginPrompt := False;

    try
      Servidor := IfThen(Trim(Servidor) = '', '127.0.0.1', Servidor);
      DataBase := IfThen(Trim(DataBase) = '', 'wkc_pedidovenda', DataBase);
      DriverName := IfThen(Trim(DriverName) = '', 'MySQL', DriverName);
      UserName := IfThen(Trim(UserName) = '', 'root', UserName);
      PassWord := IfThen(Trim(PassWord) = '', 'masterkey', PassWord);

      oConexaoBanco.Params.Values['Database'] := DataBase;
      oConexaoBanco.Params.Values['Hostname'] := Servidor;
      oConexaoBanco.Params.Values['UserName'] := UserName;
      oConexaoBanco.Params.Values['PassWord'] := PassWord;
      oConexaoBanco.Connected := True;
    except
      on e: Exception do
      begin
        MsgERRO := 'Ocorreu o seguinte erro ao tentar conectar no MySQL.'+#13+#10#13+#10+'Erro "'+e.Message+'".';
        Application.MessageBox(PWideChar(MsgERRO), 'Erro de conexão MySQL', MB_ICONERROR + MB_OK);
      end;
    end;
  end;
end;

destructor TConexaoBanco.Destroy;
begin
  DMConexaoF.SQLConexao.Close;

  FreeAndNil(DMConexaoF);

  inherited;
end;

function TConexaoBanco.getConexao: TSQLConnection;
begin
//  Result := oConexaoBanco;
  Result := DMConexao.DMConexaoF.SQLConexao;
end;

function TConexaoBanco.oConexaoBanco: TSQLConnection;
begin
  Result := DMConexao.DMConexaoF.SQLConexao;
end;

end.
