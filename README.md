# Relacionamentos e Chaves Estrangeiras — MySQL

Material prático de **Banco de Dados** desenvolvido para estudar relacionamentos entre tabelas, `FOREIGN KEY` e integridade referencial no **MySQL**.

## Conteúdos abordados

O script apresenta, de forma progressiva:

* Criação de banco de dados e tabelas;
* Inserção e consulta de registros;
* Criação de `FOREIGN KEY`;
* Integridade referencial;
* `ON DELETE RESTRICT`;
* `ON DELETE CASCADE`;
* `ON DELETE SET NULL`;
* `ON UPDATE CASCADE`;
* Consultas utilizando `JOIN`;
* Relacionamento **muitos para muitos (N:N)**;
* Criação de tabela intermediária;
* Relacionamento entre alunos, cursos e disciplinas.

## Estrutura do banco

O exemplo utiliza três entidades principais:

```text
CURSOS
   │
   │ 1:N
   │
ALUNOS
   │
   │ N:N
   │
MATRICULAS
   │
   │ N:1
   │
DISCIPLINAS
```

A tabela `matriculas` funciona como **tabela intermediária** para representar o relacionamento muitos para muitos entre `alunos` e `disciplinas`.

## Regras de integridade referencial

O script demonstra diferentes comportamentos para exclusão de registros relacionados.

### ON DELETE RESTRICT

Impede a exclusão de um registro da tabela principal quando existem registros relacionados.

```sql
ON DELETE RESTRICT
```

Exemplo: um curso que possui alunos matriculados não poderá ser excluído.

### ON DELETE CASCADE

Ao excluir um registro da tabela principal, os registros relacionados também são excluídos automaticamente.

```sql
ON DELETE CASCADE
```

Exemplo: ao excluir um curso, os alunos relacionados a ele também serão excluídos.

### ON DELETE SET NULL

Ao excluir o registro da tabela principal, o registro relacionado permanece, mas sua chave estrangeira recebe `NULL`.

```sql
ON DELETE SET NULL
```

Para isso, o campo da chave estrangeira precisa permitir valores nulos:

```sql
curso_id INT NULL
```

### ON UPDATE CASCADE

Quando o valor da chave primária é alterado na tabela principal, a alteração é propagada automaticamente para as chaves estrangeiras relacionadas.

```sql
ON UPDATE CASCADE
```

## Consultas com JOIN

O material também apresenta consultas utilizando `JOIN` para combinar informações de diferentes tabelas.

Exemplo:

```sql
SELECT
    alunos.nome AS aluno,
    cursos.nome AS curso
FROM alunos
JOIN cursos
    ON alunos.curso_id = cursos.id;
```

Também é apresentada uma consulta envolvendo:

* `alunos`;
* `cursos`;
* `matriculas`;
* `disciplinas`.

## Objetivo

O objetivo deste exercício é proporcionar uma compreensão prática de como os **relacionamentos entre tabelas** funcionam em um banco de dados relacional e como as **chaves estrangeiras** ajudam a manter a integridade dos dados.

## Tecnologia

* **MySQL**
* **SQL**
* **MySQL Workbench**

## Público-alvo

Material destinado principalmente a estudantes de **Informática, Desenvolvimento de Sistemas e Banco de Dados**, especialmente para o estudo de relacionamentos e integridade referencial.
