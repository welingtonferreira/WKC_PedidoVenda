object DMConexaoF: TDMConexaoF
  OldCreateOrder = False
  Height = 274
  Width = 366
  object SQLConexao: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXMySQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver200.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=20.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,DbxMySQLDr' +
        'iver200.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMySQLDriver,Version=20.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMYSQL'
      'LibraryName=dbxmys.dll'
      'LibraryNameOsx=libsqlmys.dylib'
      'VendorLib=LIBMYSQL.dll'
      'VendorLibWin64=libmysql.dll'
      'VendorLibOsx=libmysqlclient.dylib'
      'MaxBlobSize=-1'
      'DriverName=MySQL'
      'HostName=127.0.0.1'
      'Database=wkc_pedidovenda'
      'User_Name=root'
      'Password=masterkey'
      'ServerCharSet='
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60'
      
        'ConnectionString=DriverUnit=Data.DBXMySQL,DriverPackageLoader=TD' +
        'BXDynalinkDriverLoader,DbxCommonDriver200.bpl,DriverAssemblyLoad' +
        'er=Borland.Data.TDBXDynalinkDriverLoader,Borland.Data.DbxCommonD' +
        'river,Version=20.0.0.0,Culture=neutral,PublicKeyToken=91d62ebb5b' +
        '0d1b1b,MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,Dbx' +
        'MySQLDriver200.bpl,MetaDataAssemblyLoader=Borland.Data.TDBXMySql' +
        'MetaDataCommandFactory,Borland.Data.DbxMySQLDriver,Version=20.0.' +
        '0.0,Culture=neutral,PublicKeyToken=91d62ebb5b0d1b1b,GetDriverFun' +
        'c=getSQLDriverMYSQL,LibraryName=dbxmys.dll,LibraryNameOsx=libsql' +
        'mys.dylib,VendorLib=LIBMYSQL.dll,VendorLibWin64=libmysql.dll,Ven' +
        'dorLibOsx=libmysqlclient.dylib,MaxBlobSize=-1,DriverName=MySQL,H' +
        'ostName=127.0.0.1,Database=wk_felypeprado,User_Name=root,Passwor' +
        'd=masterkey,ServerCharSet=,BlobSize=-1,ErrorResourceFile=,Locale' +
        'Code=0000,Compressed=False,Encrypted=False,ConnectTimeout=60')
    Left = 31
    Top = 14
  end
end
