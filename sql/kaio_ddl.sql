-- Seção: DDL — Criação das 13 tabelas

CREATE DATABASE IF NOT EXISTS db_matriculas;

USE db_matriculas;

SET FOREIGN_KEY_CHECKS = 0;

-- Tabela de Cursos
CREATE TABLE Cursos (
    ID_Curso INT NOT NULL AUTO_INCREMENT,
    NomeCurso VARCHAR(100) NOT NULL,
    Coordenador VARCHAR(100) NOT NULL,
    CargaHorariaTotal INT NOT NULL,
    CONSTRAINT pk_Cursos PRIMARY KEY (ID_Curso)
);

-- Tabela de Professores
CREATE TABLE Professores (
    ID_Professor INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Titulacao VARCHAR(30) NOT NULL,
    Email VARCHAR(150) NOT NULL,
    CONSTRAINT pk_Professores PRIMARY KEY (ID_Professor),
    CONSTRAINT uq_Prof_Email UNIQUE (Email)
);

-- Tabela de Alunos
CREATE TABLE IF NOT EXISTS Alunos (
    ID_Aluno INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) NOT NULL,
    Email VARCHAR(150) NOT NULL,
    DataNascimento DATE NOT NULL,
    ID_Curso INT NOT NULL,
    CONSTRAINT pk_Alunos PRIMARY KEY (ID_Aluno),
    CONSTRAINT uq_Aluno_CPF UNIQUE (CPF),
    CONSTRAINT uq_Aluno_Email UNIQUE (Email),
    CONSTRAINT fk_Aluno_Curso FOREIGN KEY (ID_Curso)
	REFERENCES Cursos (ID_Curso)
);

-- Tabela de Currículos
CREATE TABLE Curriculos (
    ID_Curriculo INT NOT NULL AUTO_INCREMENT,
    ID_Curso INT NOT NULL,
    AnoInicio INT NOT NULL,
    Versao INT NOT NULL DEFAULT 1,
    CONSTRAINT pk_Curriculos PRIMARY KEY (ID_Curriculo),
    CONSTRAINT fk_Curriculo_Curso FOREIGN KEY (ID_Curso)
	REFERENCES Cursos (ID_Curso)
);
 
 -- Tabela de Disciplinas
 CREATE TABLE Disciplinas (
    ID_Disciplina INT NOT NULL AUTO_INCREMENT,
    NomeDisciplina VARCHAR(100) NOT NULL,
    CargaHoraria INT NOT NULL,
    CONSTRAINT pk_Disciplinas PRIMARY KEY (ID_Disciplina)
);

-- Tabela de Disciplinas por Curriculo
CREATE TABLE Disciplinas_Curriculo (
    ID_Curriculo INT NOT NULL,
    ID_Disciplina INT NOT NULL,
    PeriodoIdeal INT NOT NULL,
    CONSTRAINT pk_DisciplinasCurriculo PRIMARY KEY (ID_Curriculo, ID_Disciplina),
    CONSTRAINT fk_DC_Curriculo FOREIGN KEY (ID_Curriculo)
	REFERENCES Curriculos (ID_Curriculo),
    CONSTRAINT fk_DC_Disciplina FOREIGN KEY (ID_Disciplina)
	REFERENCES Disciplinas (ID_Disciplina)
);

-- Tabela de Pré Requesitos
CREATE TABLE PreRequisitos (
    ID_Disciplina_Principal INT NOT NULL,
    ID_Disciplina_PreRequisito INT NOT NULL,
    CONSTRAINT pk_PreRequisitos PRIMARY KEY (ID_Disciplina_Principal, ID_Disciplina_PreRequisito),
    CONSTRAINT fk_PR_Principal FOREIGN KEY (ID_Disciplina_Principal)
	REFERENCES Disciplinas (ID_Disciplina),
    CONSTRAINT fk_PR_Prerequisito FOREIGN KEY (ID_Disciplina_PreRequisito)
	REFERENCES Disciplinas (ID_Disciplina)
);

-- Tabela de Semestres
CREATE TABLE Semestres (
    ID_Semestre INT NOT NULL AUTO_INCREMENT,
    CodigoSemestre VARCHAR(10) NOT NULL,
    AbertoParaMatricula INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_Semestres PRIMARY KEY (ID_Semestre),
    CONSTRAINT uq_CodigoSemestre UNIQUE (CodigoSemestre)
);

-- Tabela de Turmas
CREATE TABLE Turmas (
    ID_Turma INT NOT NULL AUTO_INCREMENT,
    ID_Disciplina INT NOT NULL,
    ID_Professor INT NOT NULL,
    ID_Semestre INT NOT NULL,
    MaxVagas INT NOT NULL,
    VagasOcupadas INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_Turmas PRIMARY KEY (ID_Turma),
    CONSTRAINT fk_Turma_Disciplina FOREIGN KEY (ID_Disciplina)
	REFERENCES Disciplinas (ID_Disciplina),
    CONSTRAINT fk_Turma_Professor  FOREIGN KEY (ID_Professor)
	REFERENCES Professores (ID_Professor),
    CONSTRAINT fk_Turma_Semestre   FOREIGN KEY (ID_Semestre)
	REFERENCES Semestres (ID_Semestre)
);

-- Tabela de Matrículas
CREATE TABLE Matriculas (
    ID_Matricula INT NOT NULL AUTO_INCREMENT,
    ID_Aluno INT NOT NULL,
    ID_Turma INT NOT NULL,
    Status  VARCHAR(20)  NOT NULL DEFAULT 'Cursando',
    NotaFinal DECIMAL(4,2) NULL,
    CONSTRAINT pk_Matriculas PRIMARY KEY (ID_Matricula),
    CONSTRAINT uq_Matricula_Aluno UNIQUE (ID_Aluno, ID_Turma),
    CONSTRAINT chk_Mat_Status CHECK (Status IN ('Cursando', 'Aprovado', 'Reprovado', 'Trancado')),
    CONSTRAINT fk_Mat_Aluno FOREIGN KEY (ID_Aluno)
	REFERENCES Alunos (ID_Aluno),
    CONSTRAINT fk_Mat_Turma FOREIGN KEY (ID_Turma)
	REFERENCES Turmas (ID_Turma)
);

-- Tabela de Histórico do Aluno
CREATE TABLE HistoricoAluno (
    ID_Historico INT NOT NULL AUTO_INCREMENT,
    ID_Aluno INT NOT NULL,
    ID_Disciplina  INT NOT NULL,
    NotaFinal DECIMAL(4,2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    DataConclusao DATE NOT NULL,
    CONSTRAINT pk_HistoricoAluno PRIMARY KEY (ID_Historico),
    CONSTRAINT fk_Hist_Aluno FOREIGN KEY (ID_Aluno)
	REFERENCES Alunos (ID_Aluno),
    CONSTRAINT fk_Hist_Disciplina FOREIGN KEY (ID_Disciplina)
	REFERENCES Disciplinas (ID_Disciplina)
);

-- Tabela de Usuários
CREATE TABLE Usuarios (
    ID_Usuario INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL,
    TipoUsuario VARCHAR(20) NOT NULL,
    SenhaHash VARCHAR(255) NOT NULL,
    CONSTRAINT pk_Usuarios PRIMARY KEY (ID_Usuario),
    CONSTRAINT uq_Usuario_Email UNIQUE (Email)
);

-- Tabela de Logs de Sistema
CREATE TABLE IF NOT EXISTS LogsSistema (
    ID_Log INT NOT NULL AUTO_INCREMENT,
    Usuario VARCHAR(100) NOT NULL,
    Acao VARCHAR(50)  NOT NULL,
    TabelaAfetada VARCHAR(60)  NOT NULL,
    DataHora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Descricao TEXT NULL,
    CONSTRAINT pk_LogsSistema PRIMARY KEY (ID_Log)
);
 
SET FOREIGN_KEY_CHECKS = 1;