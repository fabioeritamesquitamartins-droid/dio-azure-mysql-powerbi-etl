create schema if not exists azure_company;
use azure_company;

select * from information_schema.table_constraints
	where constraint_schema = 'azure_company';

-- restrição atribuida a um domínio
-- create domain D_num as int check(D_num > 0 and D_num < 21);

CREATE TABLE funcionario(
	primeiro_nome varchar(15) not null,
    inicial_meio char,
    sobrenome varchar(15) not null,
    cpf char(9) not null, 
    data_nascimento date,
    endereco varchar(30),
    sexo char,
    salario decimal(10,2),
    cpf_supervisor char(9),
    num_departamento int not null,
    constraint chk_salario_funcionario check (salario > 2000.0),
    constraint pk_funcionario primary key (cpf)
);

alter table funcionario 
	add constraint fk_funcionario 
	foreign key(cpf_supervisor) references funcionario(cpf)
    on delete set null
    on update cascade;

alter table funcionario modify num_departamento int not null default 1;

desc funcionario;

create table departamento(
	nome_departamento varchar(15) not null,
    numero_departamento int not null,
    cpf_gerente char(9) not null,
    data_inicio_gerente date, 
    data_criacao_departamento date,
    constraint chk_data_dept check (data_criacao_departamento < data_inicio_gerente),
    constraint pk_dept primary key (numero_departamento),
    constraint unique_nome_dept unique(nome_departamento),
    foreign key (cpf_gerente) references funcionario(cpf)
);

-- 'def', 'company_constraints', 'departament_ibfk_1', 'company_constraints', 'departamento', 'FOREIGN KEY', 'YES'
-- modificar uma constraint: drop e add
alter table departamento drop foreign key departament_ibfk_1;
alter table departamento 
		add constraint fk_dept foreign key(cpf_gerente) references funcionario(cpf)
        on update cascade;

desc departamento;

create table localizacoes_departamento(
	numero_departamento int not null,
	local_departamento varchar(15) not null,
    constraint pk_localizacoes_dept primary key (numero_departamento, local_departamento),
    constraint fk_localizacoes_dept foreign key (numero_departamento) references departamento (numero_departamento)
);

alter table localizacoes_departamento drop foreign key fk_localizacoes_dept;

alter table localizacoes_departamento 
	add constraint fk_localizacoes_dept foreign key (numero_departamento) references departamento(numero_departamento)
	on delete cascade
    on update cascade;

create table projeto(
	nome_projeto varchar(15) not null,
	numero_projeto int not null,
    local_projeto varchar(15),
    num_departamento int not null,
    primary key (numero_projeto),
    constraint unique_projeto unique (nome_projeto),
    constraint fk_projeto foreign key (num_departamento) references departamento(numero_departamento)
);

create table trabalha_em(
	cpf_funcionario char(9) not null,
    num_projeto int not null,
    horas decimal(3,1) not null,
    primary key (cpf_funcionario, num_projeto),
    constraint fk_funcionario_trabalha_em foreign key (cpf_funcionario) references funcionario(cpf),
    constraint fk_projeto_trabalha_em foreign key (num_projeto) references projeto(numero_projeto)
);

drop table if exists dependent;
create table dependente(
	cpf_funcionario char(9) not null,
    nome_dependente varchar(15) not null,
    sexo char,
    data_nascimento date,
    parentesco varchar(8),
    primary key (cpf_funcionario, nome_dependente),
    constraint fk_dependente foreign key (cpf_funcionario) references funcionario(cpf)
);

show tables;
desc dependente;

DROP DATABASE IF EXISTS azure_company;
CREATE SCHEMA azure_company;
USE azure_company;

CREATE TABLE funcionario(
	primeiro_nome varchar(15) not null,
    inicial_meio char,
    sobrenome varchar(15) not null,
    cpf char(9) not null, 
    data_nascimento date,
    endereco varchar(30),
    sexo char,
    salario decimal(10,2),
    cpf_supervisor char(9),
    num_departamento int not null default 1,
    constraint chk_salario_funcionario check (salario > 2000.0),
    constraint pk_funcionario primary key (cpf),
    constraint fk_funcionario foreign key(cpf_supervisor) references funcionario(cpf)
        on delete set null on update cascade
);

create table departamento(
	nome_departamento varchar(15) not null,
    numero_departamento int not null,
    cpf_gerente char(9) not null,
    data_inicio_gerente date, 
    data_criacao_departamento date,
    constraint chk_data_dept check (data_criacao_departamento < data_inicio_gerente),
    constraint pk_dept primary key (numero_departamento),
    constraint unique_nome_dept unique(nome_departamento),
    constraint fk_dept foreign key (cpf_gerente) references funcionario(cpf)
        on update cascade
);

create table localizacoes_departamento(
	numero_departamento int not null,
	local_departamento varchar(15) not null,
    constraint pk_localizacoes_dept primary key (numero_departamento, local_departamento),
    constraint fk_localizacoes_dept foreign key (numero_departamento) references departamento(numero_departamento)
        on delete cascade on update cascade
);

create table projeto(
	nome_projeto varchar(15) not null,
	numero_projeto int not null,
    local_projeto varchar(15),
    num_departamento int not null,
    primary key (numero_projeto),
    constraint unique_projeto unique (nome_projeto),
    constraint fk_projeto foreign key (num_departamento) references departamento(numero_departamento)
);

create table trabalha_em(
	cpf_funcionario char(9) not null,
    num_projeto int not null,
    horas decimal(3,1) not null,
    primary key (cpf_funcionario, num_projeto),
    constraint fk_funcionario_trabalha_em foreign key (cpf_funcionario) references funcionario(cpf),
    constraint fk_projeto_trabalha_em foreign key (num_projeto) references projeto(numero_projeto)
);

create table dependente(
	cpf_funcionario char(9) not null,
    nome_dependente varchar(15) not null,
    sexo char,
    data_nascimento date,
    parentesco varchar(8),
    primary key (cpf_funcionario, nome_dependente),
    constraint fk_dependente foreign key (cpf_funcionario) references funcionario(cpf)
);

show tables;

USE azure_company;

-- Populando FUNCIONARIO
insert into funcionario values 
('John', 'B', 'Smith', 123456789, '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, 333445555, 5),
('Franklin', 'T', 'Wong', 333445555, '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, 888665555, 5),
('Alicia', 'J', 'Zelaya', 999887777, '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, 987654321, 4),
('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, 888665555, 4),
('Ramesh', 'K', 'Narayan', 666884444, '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, 333445555, 5),
('Joyce', 'A', 'English', 453453453, '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, 333445555, 5),
('Ahmad', 'V', 'Jabbar', 987987987, '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, 987654321, 4),
('James', 'E', 'Borg', 888665555, '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1);

-- Populando DEPENDENTE
insert into dependente values 
(333445555, 'Alice', 'F', '1986-04-05', 'Filha'),
(333445555, 'Theodore', 'M', '1983-10-25', 'Filho'),
(333445555, 'Joy', 'F', '1958-05-03', 'Esposa'),
(987654321, 'Abner', 'M', '1942-02-28', 'Esposo'),
(123456789, 'Michael', 'M', '1988-01-04', 'Filho'),
(123456789, 'Alice', 'F', '1988-12-30', 'Filha'),
(123456789, 'Elizabeth', 'F', '1967-05-05', 'Esposa');

-- Populando DEPARTAMENTO
insert into departamento values 
('Pesquisa', 5, 333445555, '1988-05-22','1986-05-22'),
('Administração', 4, 987654321, '1995-01-01','1994-01-01'),
('Matriz', 1, 888665555,'1981-06-19','1980-06-19');

-- Populando LOCALIZACOES_DEPARTAMENTO
insert into localizacoes_departamento values 
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

-- Populando PROJETO
insert into projeto values 
('ProdutoX', 1, 'Bellaire', 5),
('ProdutoY', 2, 'Sugarland', 5),
('ProdutoZ', 3, 'Houston', 5),
('Informatização', 10, 'Stafford', 4),
('Reorganização', 20, 'Houston', 1),
('NovosBeneficios', 30, 'Stafford', 4);

-- Populando TRABALHA_EM
insert into trabalha_em values 
(123456789, 1, 32.5),
(123456789, 2, 7.5),
(666884444, 3, 40.0),
(453453453, 1, 20.0),
(453453453, 2, 20.0),
(333445555, 2, 10.0),
(333445555, 3, 10.0),
(333445555, 10, 10.0),
(333445555, 20, 10.0),
(999887777, 30, 30.0),
(999887777, 10, 10.0),
(987987987, 10, 35.0),
(987987987, 30, 5.0),
(987654321, 30, 20.0),
(987654321, 20, 15.0),
(888665555, 20, 0.0);

-- Consultas SQL traduzidas

select * from funcionario;
select cpf, count(cpf_funcionario) from funcionario f, dependente d where (f.cpf = d.cpf_funcionario) group by cpf;
select * from dependente;

SELECT data_nascimento, endereco FROM funcionario
WHERE primeiro_nome = 'John' AND inicial_meio = 'B' AND sobrenome = 'Smith';

select * from departamento where nome_departamento = 'Pesquisa';

SELECT primeiro_nome, sobrenome, endereco
FROM funcionario, departamento
WHERE nome_departamento = 'Pesquisa' AND numero_departamento = num_departamento;

select * from projeto;

--
-- Expressões e concatenação de strings
--

-- recuperando informações dos departamentos presentes em Stafford
select nome_departamento as Departamento, cpf_gerente as Gerente from departamento d, localizacoes_departamento l
where d.numero_departamento = l.numero_departamento;

-- padrão sql -> || no MySQL usa a função concat()
select nome_departamento as Departamento, concat(primeiro_nome, ' ', sobrenome) as Gerente 
from departamento d, localizacoes_departamento l, funcionario f
where d.numero_departamento = l.numero_departamento and cpf_gerente = f.cpf;

-- recuperando info dos projetos em Stafford
select * from projeto, departamento where num_departamento = numero_departamento and local_projeto = 'Stafford';

-- recuperando info sobre os departamentos e projetos localizados em Stafford
SELECT numero_projeto, num_departamento, sobrenome, endereco, data_nascimento
FROM projeto, departamento, funcionario
WHERE num_departamento = numero_departamento AND cpf_gerente = cpf AND
local_projeto = 'Stafford';

SELECT * FROM funcionario WHERE num_departamento IN (3,6,9);

--
-- Operadores lógicos
--

SELECT data_nascimento, endereco
FROM funcionario
WHERE primeiro_nome = 'John' AND inicial_meio = 'B' AND sobrenome = 'Smith';

SELECT primeiro_nome, sobrenome, endereco
FROM funcionario, departamento
WHERE nome_departamento = 'Pesquisa' AND numero_departamento = num_departamento;

--
-- Expressões e alias
--

-- recolhendo o valor do INSS
select primeiro_nome, sobrenome, salario, salario*0.011 from funcionario;
select primeiro_nome, sobrenome, salario, salario*0.011 as INSS from funcionario;
select primeiro_nome, sobrenome, salario, round(salario*0.011,2) as INSS from funcionario;

-- definir um aumento de salário para os gerentes que trabalham no projeto associado ao ProdutoX
select f.primeiro_nome, f.sobrenome, 1.1*f.salario as salario_aumentado 
from funcionario as f, trabalha_em as t, projeto as p 
where f.cpf = t.cpf_funcionario and t.num_projeto = p.numero_projeto and p.nome_projeto='ProdutoX';

-- concatenando e fornecendo alias
select nome_departamento as Departamento, concat(primeiro_nome, ' ', sobrenome) as Gerente 
from departamento d, localizacoes_departamento l, funcionario f
where d.numero_departamento = l.numero_departamento and cpf_gerente = f.cpf;

-- recuperando dados dos empregados que trabalham para o departamento de pesquisa
select primeiro_nome, sobrenome, endereco from funcionario, departamento
	where nome_departamento = 'Pesquisa' and numero_departamento = num_departamento;

-- definindo alias para legibilidade da consulta
select f.primeiro_nome, f.sobrenome, f.endereco from funcionario f, departamento d
	where d.nome_departamento = 'Pesquisa' and d.numero_departamento = f.num_departamento;
    
    
    
    USE azure_company;

SET FOREIGN_KEY_CHECKS = 0;

-- Cola todos os INSERTs aqui: funcionario, departamento, dependente, etc
insert into funcionario values 
('John', 'B', 'Smith', 123456789, '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, 333445555, 5),
('Franklin', 'T', 'Wong', 333445555, '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, 888665555, 5),
('Alicia', 'J', 'Zelaya', 999887777, '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, 987654321, 4),
('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, 888665555, 4),
('Ramesh', 'K', 'Narayan', 666884444, '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, 333445555, 5),
('Joyce', 'A', 'English', 453453453, '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, 333445555, 5),
('Ahmad', 'V', 'Jabbar', 987987987, '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, 987654321, 4),
('James', 'E', 'Borg', 888665555, '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1);

-- Resto dos INSERTs...

SET FOREIGN_KEY_CHECKS = 1;


SELECT numero_projeto, num_departamento, sobrenome, endereco, data_nascimento
FROM projeto, departamento, funcionario
WHERE num_departamento = numero_departamento AND cpf_gerente = cpf AND
local_projeto = 'Stafford';

USE azure_company;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. DEPARTAMENTO primeiro, pq funcionario e projeto dependem dele
INSERT INTO departamento VALUES 
('Pesquisa', 5, 333445555, '1988-05-22','1986-05-22'),
('Administração', 4, 987654321, '1995-01-01','1994-01-01'),
('Matriz', 1, 888665555,'1981-06-19','1980-06-19');

-- 2. FUNCIONARIO - você já inseriu, mas deixo aqui caso precise rodar de novo
TRUNCATE TABLE funcionario; -- limpa pra não dar erro de duplicado
INSERT INTO funcionario VALUES 
('John', 'B', 'Smith', 123456789, '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, 333445555, 5),
('Franklin', 'T', 'Wong', 333445555, '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, 888665555, 5),
('Alicia', 'J', 'Zelaya', 999887777, '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, 987654321, 4),
('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, 888665555, 4),
('Ramesh', 'K', 'Narayan', 666884444, '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, 333445555, 5),
('Joyce', 'A', 'English', 453453453, '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, 333445555, 5),
('Ahmad', 'V', 'Jabbar', 987987987, '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, 987654321, 4),
('James', 'E', 'Borg', 888665555, '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1);

-- 3. LOCALIZACOES_DEPARTAMENTO
INSERT INTO localizacoes_departamento VALUES 
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

-- 4. PROJETO
INSERT INTO projeto VALUES 
('ProdutoX', 1, 'Bellaire', 5),
('ProdutoY', 2, 'Sugarland', 5),
('ProdutoZ', 3, 'Houston', 5),
('Informatização', 10, 'Stafford', 4),
('Reorganização', 20, 'Houston', 1),
('NovosBeneficios', 30, 'Stafford', 4);

-- 5. DEPENDENTE
INSERT INTO dependente VALUES 
(333445555, 'Alice', 'F', '1986-04-05', 'Filha'),
(333445555, 'Theodore', 'M', '1983-10-25', 'Filho'),
(333445555, 'Joy', 'F', '1958-05-03', 'Esposa'),
(987654321, 'Abner', 'M', '1942-02-28', 'Esposo'),
(123456789, 'Michael', 'M', '1988-01-04', 'Filho'),
(123456789, 'Alice', 'F', '1988-12-30', 'Filha'),
(123456789, 'Elizabeth', 'F', '1967-05-05', 'Esposa');

-- 6. TRABALHA_EM
INSERT INTO trabalha_em VALUES 
(123456789, 1, 32.5), (123456789, 2, 7.5), (666884444, 3, 40.0),
(453453453, 1, 20.0), (453453453, 2, 20.0), (333445555, 2, 10.0),
(333445555, 3, 10.0), (333445555, 10, 10.0), (333445555, 20, 10.0),
(999887777, 30, 30.0), (999887777, 10, 10.0), (987987987, 10, 35.0),
(987987987, 30, 5.0), (987654321, 30, 20.0), (987654321, 20, 15.0),
(888665555, 20, 0.0);

SET FOREIGN_KEY_CHECKS = 1;

-- recuperando info sobre os departamentos e projetos localizados em Stafford
SELECT p.numero_projeto, p.num_departamento, f.sobrenome, f.endereco, f.data_nascimento
FROM projeto p, departamento d, funcionario f
WHERE p.num_departamento = d.numero_departamento 
AND d.cpf_gerente = f.cpf 
AND p.local_projeto = 'Stafford';


-- 1. Tem departamento sem gerente? 
SELECT * FROM departamento WHERE cpf_gerente IS NULL;

-- 2. Tem funcionário sem supervisor? Só o CEO pode
SELECT primeiro_nome, sobrenome, cpf_supervisor FROM funcionario WHERE cpf_supervisor IS NULL;

-- 3. Confere as horas por projeto pra achar anomalia
SELECT num_projeto, SUM(horas) as total_horas FROM trabalha_em GROUP BY num_projeto;

SELECT 
    numero_departamento,
    nome_departamento,
    cpf_gerente,
    data_inicio_gerente,
    data_criacao_departamento
FROM departamento 
WHERE cpf_gerente IS NULL;

SELECT 
    cpf,
    primeiro_nome,
    sobrenome,
    cpf_supervisor,
    num_departamento
FROM funcionario 
WHERE cpf_supervisor IS NULL;

SELECT 
    num_projeto,
    SUM(horas) AS total_horas
FROM trabalha_em 
GROUP BY num_projeto
ORDER BY num_projeto;

SELECT 
    f.primeiro_nome,
    f.sobrenome,
    f.num_departamento,
    d.nome_departamento
FROM funcionario f
JOIN departamento d ON f.num_departamento = d.numero_departamento
ORDER BY f.primeiro_nome;

SELECT 
    f.primeiro_nome AS nome_funcionario,
    f.sobrenome AS sobrenome_funcionario,
    g.primeiro_nome AS nome_gerente,
    g.sobrenome AS sobrenome_gerente
FROM funcionario f
LEFT JOIN funcionario g ON f.cpf_supervisor = g.cpf
ORDER BY f.primeiro_nome;

SELECT 
    g.primeiro_nome AS nome_gerente,
    g.sobrenome AS sobrenome_gerente,
    COUNT(f.cpf) AS total_subordinados
FROM funcionario g
JOIN funcionario f ON f.cpf_supervisor = g.cpf
GROUP BY g.cpf, g.primeiro_nome, g.sobrenome
ORDER BY total_subordinados DESC;

SELECT 
    f.primeiro_nome,
    f.sobrenome,
    SUM(t.horas) AS total_horas_trabalhadas
FROM funcionario f
JOIN trabalha_em t ON f.cpf = t.cpf_funcionario
GROUP BY f.cpf, f.primeiro_nome, f.sobrenome
ORDER BY total_horas_trabalhadas DESC
LIMIT 1;

SELECT 
    d.nome_departamento,
    ROUND(AVG(f.salario), 2) AS media_salarial_depto,
    (SELECT ROUND(AVG(salario), 2) FROM funcionario) AS media_salarial_empresa
FROM departamento d
JOIN funcionario f ON d.numero_departamento = f.num_departamento
GROUP BY d.numero_departamento, d.nome_departamento
HAVING AVG(f.salario) > (SELECT AVG(salario) FROM funcionario)
ORDER BY media_salarial_depto DESC;

SELECT 
    p.nome_projeto,
    ROUND(SUM(t.horas * (f.salario / 160)), 2) AS custo_total_projeto,
    SUM(t.horas) AS total_horas
FROM projeto p
JOIN trabalha_em t ON p.numero_projeto = t.num_projeto
JOIN funcionario f ON t.cpf_funcionario = f.cpf
GROUP BY p.numero_projeto, p.nome_projeto
ORDER BY custo_total_projeto DESC;

WITH horas_por_func AS (
    SELECT 
        p.nome_projeto,
        f.primeiro_nome,
        f.sobrenome,
        t.horas,
        RANK() OVER (PARTITION BY p.numero_projeto ORDER BY t.horas DESC) AS posicao_no_projeto
    FROM projeto p
    JOIN trabalha_em t ON p.numero_projeto = t.num_projeto
    JOIN funcionario f ON t.cpf_funcionario = f.cpf
)
SELECT 
    nome_projeto,
    primeiro_nome,
    sobrenome,
    horas,
    posicao_no_projeto
FROM horas_por_func
WHERE posicao_no_projeto = 1
ORDER BY horas DESC;