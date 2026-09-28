-- ============================================================
-- BANCO DE DADOS: ESCOLA
-- Demonstração de FOREIGN KEY e regras de integridade
-- ============================================================


-- ============================================================
-- 1. CRIANDO O BANCO DE DADOS
-- ============================================================

DROP DATABASE IF EXISTS escola;

CREATE DATABASE escola;

USE escola;


-- ============================================================
-- 2. CRIANDO A TABELA CURSOS
-- ============================================================

CREATE TABLE cursos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);


-- Inserindo cursos
INSERT INTO cursos (nome)
VALUES
('Informática'),
('Administração'),
('Contabilidade');


-- Visualizando os cursos
SELECT * FROM cursos;


-- ============================================================
-- 3. CRIANDO A TABELA ALUNOS
-- ============================================================

CREATE TABLE alunos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    curso_id INT
);


-- ============================================================
-- 4. CRIANDO A FOREIGN KEY
-- ============================================================

ALTER TABLE alunos
ADD CONSTRAINT fk_aluno_curso
FOREIGN KEY (curso_id)
REFERENCES cursos(id);


-- ============================================================
-- 5. INSERINDO ALUNOS
-- ============================================================

INSERT INTO alunos (nome, curso_id)
VALUES
('Ana', 1),
('Bruno', 1),
('Carlos', 2),
('Daniela', 3);


-- Visualizando os alunos
SELECT * FROM alunos;


-- ============================================================
-- 6. TESTANDO A FOREIGN KEY
-- ============================================================

-- ATENÇÃO:
-- Este comando deve gerar um ERRO, pois o curso 99 não existe.

-- INSERT INTO alunos (nome, curso_id)
-- VALUES ('Eduardo', 99);


-- ============================================================
-- 7. TESTANDO ON DELETE RESTRICT
-- ============================================================

-- Removendo a tabela alunos para recriar a FOREIGN KEY
DROP TABLE alunos;


CREATE TABLE alunos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    curso_id INT,

    CONSTRAINT fk_aluno_curso
        FOREIGN KEY (curso_id)
        REFERENCES cursos(id)
        ON DELETE RESTRICT
);


-- Inserindo novamente os alunos
INSERT INTO alunos (nome, curso_id)
VALUES
('Ana', 1),
('Bruno', 1),
('Carlos', 2),
('Daniela', 3);


-- ============================================================
-- TESTE DO RESTRICT
-- ============================================================

-- Este comando deve gerar um ERRO,
-- pois existem alunos vinculados ao curso 1.

-- DELETE FROM cursos
-- WHERE id = 1;


-- ============================================================
-- 8. TESTANDO ON DELETE CASCADE
-- ============================================================

DROP TABLE alunos;


CREATE TABLE alunos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    curso_id INT,

    CONSTRAINT fk_aluno_curso
        FOREIGN KEY (curso_id)
        REFERENCES cursos(id)
        ON DELETE CASCADE
);


-- Inserindo novamente os alunos
INSERT INTO alunos (nome, curso_id)
VALUES
('Ana', 1),
('Bruno', 1),
('Carlos', 2),
('Daniela', 3);


-- Visualizando antes da exclusão
SELECT * FROM alunos;


-- Excluindo o curso 1
DELETE FROM cursos
WHERE id = 1;


-- Os alunos Ana e Bruno também serão excluídos
SELECT * FROM alunos;


-- Visualizando os cursos
SELECT * FROM cursos;


-- ============================================================
-- 9. TESTANDO ON DELETE SET NULL
-- ============================================================

-- Precisamos recriar o curso 1,
-- pois ele foi excluído no teste anterior.

INSERT INTO cursos (id, nome)
VALUES
(1, 'Informática');


-- Recriando a tabela alunos
DROP TABLE alunos;


CREATE TABLE alunos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    curso_id INT NULL,

    CONSTRAINT fk_aluno_curso
        FOREIGN KEY (curso_id)
        REFERENCES cursos(id)
        ON DELETE SET NULL
);


-- Inserindo alunos
INSERT INTO alunos (nome, curso_id)
VALUES
('Ana', 1),
('Bruno', 1),
('Carlos', 2);


-- Visualizando antes da exclusão
SELECT * FROM alunos;


-- Excluindo o curso 1
DELETE FROM cursos
WHERE id = 1;


-- Ana e Bruno continuam cadastrados,
-- mas curso_id passa a ser NULL
SELECT * FROM alunos;


-- ============================================================
-- 10. TESTANDO ON UPDATE CASCADE
-- ============================================================

-- Recriando o curso 1
INSERT INTO cursos (id, nome)
VALUES
(1, 'Informática');


-- Como estamos usando SET NULL + ON UPDATE CASCADE,
-- vamos manter a mesma estrutura e adicionar ON UPDATE.

DROP TABLE alunos;


CREATE TABLE alunos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    curso_id INT NULL,

    CONSTRAINT fk_aluno_curso
        FOREIGN KEY (curso_id)
        REFERENCES cursos(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


-- Inserindo alunos
INSERT INTO alunos (nome, curso_id)
VALUES
('Ana', 1),
('Bruno', 1),
('Carlos', 2);


-- Visualizando antes da alteração
SELECT * FROM alunos;


-- Alterando o ID do curso 1 para 10
UPDATE cursos
SET id = 10
WHERE id = 1;


-- O curso_id dos alunos também será alterado para 10
SELECT * FROM alunos;

SELECT * FROM cursos;


-- ============================================================
-- 11. CONSULTANDO COM INNER JOIN
-- ============================================================

SELECT
    alunos.nome AS aluno,
    cursos.nome AS curso
FROM alunos
JOIN cursos
    ON alunos.curso_id = cursos.id;


-- Consulta incluindo os IDs
SELECT
    alunos.id,
    alunos.nome AS aluno,
    cursos.id AS curso_id,
    cursos.nome AS curso
FROM alunos
JOIN cursos
    ON alunos.curso_id = cursos.id;


-- ============================================================
-- 12. RELACIONAMENTO MUITOS PARA MUITOS (N:N)
-- ============================================================

-- Criando disciplinas
CREATE TABLE disciplinas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);


-- Inserindo disciplinas
INSERT INTO disciplinas (nome)
VALUES
('Banco de Dados'),
('Programação'),
('Redes de Computadores');


-- ============================================================
-- CRIANDO A TABELA INTERMEDIÁRIA
-- ============================================================

CREATE TABLE matriculas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    aluno_id INT NOT NULL,
    disciplina_id INT NOT NULL,

    CONSTRAINT fk_matricula_aluno
        FOREIGN KEY (aluno_id)
        REFERENCES alunos(id),

    CONSTRAINT fk_matricula_disciplina
        FOREIGN KEY (disciplina_id)
        REFERENCES disciplinas(id)
);


-- ============================================================
-- INSERINDO MATRÍCULAS
-- ============================================================

INSERT INTO matriculas (aluno_id, disciplina_id)
VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 1);


-- ============================================================
-- CONSULTANDO ALUNOS E DISCIPLINAS
-- ============================================================

SELECT
    alunos.nome AS aluno,
    disciplinas.nome AS disciplina
FROM matriculas
JOIN alunos
    ON matriculas.aluno_id = alunos.id
JOIN disciplinas
    ON matriculas.disciplina_id = disciplinas.id;


-- ============================================================
-- CONSULTA COMPLETA
-- ALUNO + CURSO + DISCIPLINA
-- ============================================================

SELECT
    alunos.id AS aluno_id,
    alunos.nome AS aluno,
    cursos.nome AS curso,
    disciplinas.nome AS disciplina
FROM matriculas

JOIN alunos
    ON matriculas.aluno_id = alunos.id

LEFT JOIN cursos
    ON alunos.curso_id = cursos.id

JOIN disciplinas
    ON matriculas.disciplina_id = disciplinas.id;
    