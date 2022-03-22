object PedidoVendaF: TPedidoVendaF
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Pedido de Venda'
  ClientHeight = 416
  ClientWidth = 747
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDadosPedido: TPanel
    Left = 0
    Top = 0
    Width = 747
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      747
      64)
    object lblNumeroPedido: TLabel
      Left = 8
      Top = 12
      Width = 47
      Height = 13
      Caption = 'N'#186' Pedido'
    end
    object lblDataEmissao: TLabel
      Left = 183
      Top = 12
      Width = 56
      Height = 13
      Caption = 'Dt. Emiss'#227'o'
    end
    object lblCodigoCliente: TLabel
      Left = 8
      Top = 39
      Width = 33
      Height = 13
      Caption = 'Cliente'
    end
    object edtNomeCliente: TEdit
      Left = 142
      Top = 35
      Width = 597
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object dbedtDtEmissao: TDBEdit
      Left = 245
      Top = 8
      Width = 76
      Height = 21
      DataField = 'DT_EMISSAO'
      DataSource = dsPedido
      TabOrder = 2
    end
    object dbeCliente: TDBEdit
      Left = 61
      Top = 35
      Width = 75
      Height = 21
      DataField = 'CLIENTE'
      DataSource = dsPedido
      TabOrder = 3
      OnChange = dbeClienteChange
    end
    object btnPedidosCarregar: TBitBtn
      Left = 142
      Top = 6
      Width = 35
      Height = 25
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000002A000000DC0000004F000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000002A000000E8000000FF000000DC000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000027000000E6000000FF000000E90000002C000000000000
        0000000000000000003B000000A6000000E3000000FA000000E5000000A70000
        003000000025000000E8000000FF000000E80000002A00000000000000000000
        000400000095000000FF000000FF000000FF000000FF000000FF000000FF0000
        00FE00000099000000B1000000E80000002A0000000000000000000000000000
        0095000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
        00FF000000FF00000099000000250000000000000000000000000000003C0000
        00FF000000FF000000FF000000FF000000C000000044000000BF000000FF0000
        00FF000000FF000000FE00000030000000000000000000000000000000A70000
        00FF000000FF000000FF000000FF0000009B0000000000000099000000FF0000
        00FF000000FF000000FF000000A6000000000000000000000000000000E50000
        00FF000000FF000000C0000000990000005D000000000000005C000000990000
        00BF000000FF000000FF000000E6000000000000000000000000000000F90000
        00FF000000FF0000004700000000000000000000000000000000000000000000
        0045000000FF000000FF000000F9000000000000000000000000000000E50000
        00FF000000FF000000BE000000990000005D000000000000005C000000990000
        00BE000000FF000000FF000000E4000000000000000000000000000000A90000
        00FF000000FF000000FF000000FF0000009B0000000000000099000000FF0000
        00FF000000FF000000FF000000A60000000000000000000000000000003E0000
        00FF000000FF000000FF000000FF000000BF00000044000000BE000000FF0000
        00FF000000FF000000FF0000003B000000000000000000000000000000000000
        0097000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
        00FF000000FF0000009500000000000000000000000000000000000000000000
        000400000097000000FF000000FF000000FF000000FF000000FF000000FF0000
        00FF000000950000000400000000000000000000000000000000000000000000
        0000000000000000003D000000A8000000E5000000F9000000E4000000A70000
        003C000000000000000000000000000000000000000000000000}
      TabOrder = 1
      TabStop = False
      OnClick = btnPedidosCarregarClick
    end
    object dbeNumeroPedido: TDBEdit
      Left = 61
      Top = 8
      Width = 75
      Height = 21
      TabStop = False
      Color = clBtnFace
      DataField = 'NUMEROPEDIDO'
      DataSource = dsPedido
      ReadOnly = True
      TabOrder = 0
    end
  end
  object pnlPedidoProdutos: TPanel
    Left = 0
    Top = 64
    Width = 747
    Height = 314
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    object lblProduto: TLabel
      Left = 8
      Top = 10
      Width = 38
      Height = 13
      Caption = 'Produto'
    end
    object lblQuantidade: TLabel
      Left = 351
      Top = 10
      Width = 56
      Height = 13
      Caption = 'Quantidade'
    end
    object lblVlrUnitario: TLabel
      Left = 472
      Top = 10
      Width = 52
      Height = 13
      Caption = 'Vlr Unit'#225'rio'
    end
    object lblVlr_Total: TLabel
      Left = 615
      Top = 10
      Width = 39
      Height = 13
      Caption = 'Vlr Total'
    end
    object pnlItemPedido: TPanel
      AlignWithMargins = True
      Left = 8
      Top = 71
      Width = 731
      Height = 21
      Margins.Left = 7
      Margins.Top = 70
      Margins.Right = 7
      Margins.Bottom = 0
      Align = alTop
      Caption = 'I t e n s     d o     P e d i d o'
      TabOrder = 0
    end
    object dbgItensPedido: TDBGrid
      AlignWithMargins = True
      Left = 8
      Top = 92
      Width = 731
      Height = 214
      Margins.Left = 7
      Margins.Top = 0
      Margins.Right = 7
      Margins.Bottom = 7
      Align = alClient
      DataSource = dsPedidoProdutos
      Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyDown = dbgItensPedidoKeyDown
      OnKeyPress = dbgItensPedidoKeyPress
      Columns = <
        item
          Expanded = False
          FieldName = 'PRODUTO'
          Title.Caption = 'Produto'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRICAO'
          Title.Caption = 'Descri'#231#227'o'
          Width = 405
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QUANTIDADE'
          Title.Caption = 'Qtda.'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VLR_UNITARIO'
          Title.Alignment = taRightJustify
          Title.Caption = 'R$ Unit'#225'rio'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VLR_TOTAL'
          Title.Alignment = taRightJustify
          Title.Caption = 'R$ Total'
          Width = 80
          Visible = True
        end>
    end
    object dbeProduto: TDBEdit
      Left = 52
      Top = 6
      Width = 45
      Height = 21
      DataField = 'PRODUTO'
      DataSource = dsPedidoProdutos
      TabOrder = 2
      OnChange = dbeProdutoChange
    end
    object dbeQuantidade: TDBEdit
      Left = 413
      Top = 6
      Width = 52
      Height = 21
      DataField = 'QUANTIDADE'
      DataSource = dsPedidoProdutos
      TabOrder = 4
      OnExit = dbeQuantidadeExit
    end
    object dbeVlrUnitario: TDBEdit
      Left = 530
      Top = 6
      Width = 79
      Height = 21
      DataField = 'VLR_UNITARIO'
      DataSource = dsPedidoProdutos
      TabOrder = 5
      OnExit = dbeQuantidadeExit
    end
    object dbeVlrTotal: TDBEdit
      Left = 660
      Top = 6
      Width = 79
      Height = 21
      TabStop = False
      Color = clBtnFace
      DataField = 'VLR_TOTAL'
      DataSource = dsPedidoProdutos
      ReadOnly = True
      TabOrder = 6
    end
    object btnPedPrdNovo: TButton
      Left = 8
      Top = 33
      Width = 75
      Height = 25
      Caption = 'Novo'
      TabOrder = 7
      OnClick = btnPedPrdNovoClick
    end
    object btnPedPrdAlterar: TButton
      Left = 89
      Top = 33
      Width = 75
      Height = 25
      Caption = 'Alterar'
      Enabled = False
      TabOrder = 8
      OnClick = btnPedPrdAlterarClick
    end
    object btnPedPrdExcluir: TButton
      Left = 170
      Top = 33
      Width = 75
      Height = 25
      Caption = 'Excluir'
      Enabled = False
      TabOrder = 9
      OnClick = btnPedPrdExcluirClick
    end
    object btnPedPrdSalvar: TButton
      Left = 579
      Top = 33
      Width = 75
      Height = 25
      Caption = 'Salvar'
      Enabled = False
      TabOrder = 10
      OnClick = btnPedPrdSalvarClick
    end
    object btnPedPrdCancelar: TButton
      Left = 660
      Top = 33
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      Enabled = False
      TabOrder = 11
      OnClick = btnPedPrdCancelarClick
    end
    object dbeDescricao: TDBEdit
      Left = 103
      Top = 6
      Width = 242
      Height = 21
      TabStop = False
      Color = clBtnFace
      DataField = 'DESCRICAO'
      DataSource = dsPedidoProdutos
      ReadOnly = True
      TabOrder = 3
    end
  end
  object pnlPedidoTotal: TPanel
    Left = 0
    Top = 378
    Width = 747
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      747
      38)
    object lblValorTotal: TLabel
      Left = 591
      Top = 12
      Width = 39
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Vlr Total'
    end
    object dbeVlr_Total: TDBEdit
      Left = 636
      Top = 8
      Width = 103
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      DataField = 'VLR_TOTAL'
      DataSource = dsPedido
      TabOrder = 0
    end
    object btnPedidosGravar: TButton
      Left = 8
      Top = 6
      Width = 89
      Height = 25
      Caption = 'Gravar Pedido'
      TabOrder = 1
      OnClick = btnPedidosGravarClick
    end
    object btnPedidosCancelar: TButton
      Left = 103
      Top = 6
      Width = 90
      Height = 25
      Caption = 'Cancelar Pedido'
      TabOrder = 2
      OnClick = btnPedidosCancelarClick
    end
  end
  object dsPedidoProdutos: TDataSource
    Left = 216
    Top = 200
  end
  object dsPedido: TDataSource
    Left = 120
    Top = 200
  end
end
