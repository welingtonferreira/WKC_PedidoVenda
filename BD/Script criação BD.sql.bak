create table clientes (
  codigo int primary key not null,
  nome varchar(80) not null,
  cidade varchar(60) not null,
  uf char(2) not null
);

create table produtos (
  codigo int primary key not null,
  descricao varchar(80) not null,
  vlr_venda real not null
);

create table pedidos (
  numeropedido int primary key not null,
  dt_emissao date not null,
  cliente int not null,
  vlr_total real not null
);

alter table pedidos add constraint fk_cliente foreign key (cliente) references clientes (codigo);

create table pedidosprodutos (
  autoincremento int not null primary key auto_increment,
  numeropedido int not null,
  produto int not null,
  quantidade int not null,
  vlr_unitario real not null,
  vlr_total real not null
);

alter table pedidosprodutos add constraint fk_pedidos foreign key (numeropedido) references pedidos (numeropedido);
alter table pedidosprodutos add constraint fk_produto foreign key (produto) references produtos (codigo);

INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (1, 'Nome Cliente 1', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (2, 'Nome Cliente 2', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (3, 'Nome Cliente 3', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (4, 'Nome Cliente 4', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (5, 'Nome Cliente 5', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (6, 'Nome Cliente 6', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (7, 'Nome Cliente 7', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (8, 'Nome Cliente 8', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (9, 'Nome Cliente 9', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (10, 'Nome Cliente 10', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (11, 'Nome Cliente 11', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (12, 'Nome Cliente 12', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (13, 'Nome Cliente 13', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (14, 'Nome Cliente 14', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (15, 'Nome Cliente 15', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (16, 'Nome Cliente 16', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (17, 'Nome Cliente 17', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (18, 'Nome Cliente 18', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (19, 'Nome Cliente 19', 'Curitiba', 'PR');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (20, 'Nome Cliente 20', 'Curitiba', 'PR');



INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (1, 'Descricao Produto 1', 5);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (2, 'Descricao Produto 2', 10);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (3, 'Descricao Produto 3', 15);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (4, 'Descricao Produto 4', 20);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (5, 'Descricao Produto 5', 25);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (6, 'Descricao Produto 6', 30);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (7, 'Descricao Produto 7', 35);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (8, 'Descricao Produto 8', 40);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (9, 'Descricao Produto 9', 45);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (10, 'Descricao Produto 10', 50);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (11, 'Descricao Produto 11', 55);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (12, 'Descricao Produto 12', 60);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (13, 'Descricao Produto 13', 65);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (14, 'Descricao Produto 14', 70);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (15, 'Descricao Produto 15', 75);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (16, 'Descricao Produto 16', 80);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (17, 'Descricao Produto 17', 85);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (18, 'Descricao Produto 18', 90);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (19, 'Descricao Produto 19', 95);
INSERT INTO PRODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (20, 'Descricao Produto 20', 100);