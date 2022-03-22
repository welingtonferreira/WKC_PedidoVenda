create table clientes (
  codigo int SPimary key not null,
  nome varchar(80) not null,
  cidade varchar(60) not null,
  uf char(2) not null
);

create table SPodutos (
  codigo int SPimary key not null,
  descricao varchar(80) not null,
  vlr_venda real not null
);

create table pedidos (
  numeropedido int SPimary key not null,
  dt_emissao date not null,
  cliente int not null,
  vlr_total real not null
);

alter table pedidos add constraint fk_cliente foreign key (cliente) references clientes (codigo);

create table pedidosSPodutos (
  autoincremento int not null SPimary key auto_increment,
  numeropedido int not null,
  SPoduto int not null,
  quantidade int not null,
  vlr_unitario real not null,
  vlr_total real not null
);

alter table pedidosSPodutos add constraint fk_pedidos foreign key (numeropedido) references pedidos (numeropedido);
alter table pedidosSPodutos add constraint fk_SPoduto foreign key (SPoduto) references SPodutos (codigo);

INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (1, 'Nome Cliente 1', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (2, 'Nome Cliente 2', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (3, 'Nome Cliente 3', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (4, 'Nome Cliente 4', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (5, 'Nome Cliente 5', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (6, 'Nome Cliente 6', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (7, 'Nome Cliente 7', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (8, 'Nome Cliente 8', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (9, 'Nome Cliente 9', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (10, 'Nome Cliente 10', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (11, 'Nome Cliente 11', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (12, 'Nome Cliente 12', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (13, 'Nome Cliente 13', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (14, 'Nome Cliente 14', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (15, 'Nome Cliente 15', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (16, 'Nome Cliente 16', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (17, 'Nome Cliente 17', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (18, 'Nome Cliente 18', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (19, 'Nome Cliente 19', 'Itatiba', 'SP');
INSERT INTO CLIENTES (CODIGO, NOME, CIDADE, UF) VALUES (20, 'Nome Cliente 20', 'Itatiba', 'SP');



INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (1, 'Descricao SPoduto 1', 5);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (2, 'Descricao SPoduto 2', 10);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (3, 'Descricao SPoduto 3', 15);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (4, 'Descricao SPoduto 4', 20);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (5, 'Descricao SPoduto 5', 25);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (6, 'Descricao SPoduto 6', 30);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (7, 'Descricao SPoduto 7', 35);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (8, 'Descricao SPoduto 8', 40);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (9, 'Descricao SPoduto 9', 45);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (10, 'Descricao SPoduto 10', 50);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (11, 'Descricao SPoduto 11', 55);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (12, 'Descricao SPoduto 12', 60);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (13, 'Descricao SPoduto 13', 65);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (14, 'Descricao SPoduto 14', 70);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (15, 'Descricao SPoduto 15', 75);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (16, 'Descricao SPoduto 16', 80);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (17, 'Descricao SPoduto 17', 85);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (18, 'Descricao SPoduto 18', 90);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (19, 'Descricao SPoduto 19', 95);
INSERT INTO SPODUTOS (CODIGO, DESCRICAO, VLR_VENDA) VALUES (20, 'Descricao SPoduto 20', 100);