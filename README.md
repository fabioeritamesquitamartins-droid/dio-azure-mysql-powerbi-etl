# Desafio DIO - Integrando Dados com MySQL Azure e Transformando com Power BI

## 📋 Sobre o Projeto

Este projeto foi desenvolvido como parte do Desafio de Projeto do Módulo 3 do Bootcamp da DIO. O objetivo foi criar um fluxo completo de dados: desde a criação de uma instância MySQL no Azure, modelagem e consultas SQL no Workbench, até a integração e transformação dos dados no Power BI para geração de insights de negócio.

A base de dados utilizada simula o cenário de uma empresa com informações sobre departamentos, funcionários, projetos e horas trabalhadas.

## 🔄 Adaptação do Modelo de Dados

**Importante:** Toda a estrutura do banco foi traduzida e adaptada para português durante a modelagem. As tabelas e colunas originais em inglês foram convertidas para facilitar a leitura e manutenção no contexto brasileiro.

**Exemplos de tradução aplicada:**
| Original (Inglês) | Adaptado (Português) |
| --- | --- |
| `employee` | `funcionario` |
| `department` | `departamento` |
| `project` | `projeto` |
| `works_on` | `trabalha_em` |
| `dependent` | `dependente` |
| `dept_locations` | `localizacoes_departamento` |
| `fname`, `lname` | `primeiro_nome`, `sobrenome` |
| `ssn`, `super_ssn` | `cpf`, `cpf_supervisor` |

Essa padronização em português foi mantida em todas as consultas SQL, views e no modelo do Power BI.

## ✅ Etapas Realizadas

### 1. Criação da Instância MySQL na Azure
Foi provisionado um servidor MySQL Flexible Server no Microsoft Azure para hospedar o banco de dados `azure_company`. As configurações de rede e firewall foram ajustadas para permitir a conexão externa via MySQL Workbench.

### 2. Modelagem e Consultas SQL
Foram desenvolvidas 10 consultas SQL para responder às perguntas de negócio e validar a qualidade dos dados. Todas as queries estão documentadas no arquivo `desafio_dio_azure.sql` e utilizam os nomes traduzidos das tabelas.

**Principais análises realizadas:**
1. Funcionários por departamento
2. Funcionários com dependentes e contagem
3. Gerentes de departamento
4. Horas trabalhadas por projeto
5. Funcionários com nome do gerente
6. Contagem de funcionários por gerente
7. Funcionário que mais trabalhou horas
8. Departamentos com média salarial acima da empresa
9. Custo total por projeto
10. MVP por projeto usando RANK

Além das consultas, foram criadas 10 views `vw_01` a `vw_10` para facilitar o consumo dos dados no Power BI.

### 3. Integração e Transformação com Power BI
O arquivo `DASHBOARD - EMPRESA.pbix` contém todo o processo de ETL e visualização, já conectado às views criadas no MySQL.

**Diretrizes de transformação aplicadas:**
- **Verificação de cabeçalhos e tipos de dados**: Ajustados tipos para `int`, `decimal` e `texto` conforme necessidade
- **Valores monetários**: Coluna `salario` convertida para `decimal(10,2)` com constraint `check (salario > 2000.0)`
- **Tratamento de nulos**: Identificados nulos em `cpf_supervisor`. Conforme regra de negócio, apenas o CEO não possui supervisor
- **Departamentos sem gerente**: Query `vw_01` valida se existe `cpf_gerente IS NULL`
- **Mesclagem de tabelas**: Junção de `funcionario` + `departamento` para associar nome do departamento a cada colaborador
- **Hierarquia de gestão**: Self-join em `funcionario` para trazer o nome do gerente via `cpf_supervisor`
- **Novas colunas**: Criação de `nome_completo_funcionario` com `CONCAT(primeiro_nome, ' ', sobrenome)` nas views
- **Agrupamento**: Contagem de colaboradores por gerente e total de horas por projeto
- **Otimização**: Remoção de colunas desnecessárias e uso de views para simplificar o modelo no Power BI

**Por que "Mesclar" e não "Atribuir"?**  
Para criar chaves únicas como `Departamento-Local`, foi utilizado "Mesclar Colunas" no Power Query. Isso cria uma nova coluna composta `Departamento-Local` que torna cada combinação única, essencial para o modelo estrela. "Atribuir" substituiria o valor original, perdendo a granularidade da informação.

## 🛠️ Tecnologias Utilizadas
- **Microsoft Azure**: MySQL Flexible Server
- **MySQL Workbench**: Modelagem, criação do banco `azure_company` e execução das consultas SQL
- **Microsoft Power BI**: ETL com Power Query, modelagem de dados e criação do dashboard
- **Git/GitHub**: Versionamento do projeto

## 📁 Estrutura do Repositório

| Arquivo | Descrição |
| --- | --- |
| `desafio_dio_azure.sql` | Script completo: DDL das tabelas traduzidas, inserts, 10 queries e 10 views |
| `DASHBOARD - EMPRESA.pbix` | Arquivo Power BI com toda ETL, modelo de dados e dashboard final |
| `01_departamentos_sem_gerente.csv` a `10_ranking_horas_por_projeto.csv` | Resultados exportados de cada consulta SQL executada |
| `# Desafio DIO - Modelagem e Consult.txt` | Enunciado original do desafio |

## 📊 Principais Insights do Dashboard
1. **Distribuição de horas**: Visualização de quais projetos e departamentos consomem mais tempo
2. **Custo por projeto**: Análise financeira baseada nas horas trabalhadas x salário dos funcionários
3. **Estrutura hierárquica**: Relação funcionário-gerente e quantidade de liderados por gestor
4. **Análise departamental**: Média salarial e alocação de horas por departamento

## 🚀 Como Reproduzir o Projeto
1. **Azure**: Crie uma instância MySQL Flexible Server e libere seu IP no Firewall para acesso externo
2. **Workbench**: Execute o script `desafio_dio_azure.sql` para criar o schema `azure_company`, tabelas, inserir dados e criar as views
3. **Power BI**: Abra o `DASHBOARD - EMPRESA.pbix` e atualize a fonte de dados com as credenciais do seu servidor MySQL na Azure. Conecte direto nas views `vw_01` a `vw_10`

## 👨‍💻 Autor
**Fábio Martins**

Projeto desenvolvido para o Bootcamp da [Digital Innovation One](https://www.dio.me/)

