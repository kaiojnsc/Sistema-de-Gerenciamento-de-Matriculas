-- Seção: DML — Dados de exemplo
USE db_matriculas;

-- 1. CURSOS
INSERT INTO Cursos (NomeCurso, Coordenador, CargaHorariaTotal) VALUES
    ('Sistemas de Informação', 'Prof. Dr. Carlos Eduardo Lima',    3200),
    ('Ciência da Computação', 'Prof. Dr. João Batista Ferreira',  3400),
    ('Análise e Desenv. de Sistemas', 'Prof. Me. Rafael Henrique Oliveira',2400),
    ('Sistemas de Informação', 'Prof. Me. Ana Maria Dias', 2600),
    ('Inteligência Artificial', 'Prof. Me. Carolina Matias', 3000);
    
-- 2. PROFESSORES
INSERT INTO Professores (Nome, Titulacao, Email) VALUES
    ('Carlos Eduardo Lima',      'Doutor',      'carlos.lima@unifacisa.edu.br'),
    ('Ana Paula Rodrigues',      'Mestre',      'ana.rodrigues@unifacisa.edu.br'),
    ('João Batista Ferreira',    'Doutor',      'joao.ferreira@unifacisa.edu.br'),
    ('Maria das Graças Sousa',   'Especialista','maria.sousa@unifacisa.edu.br'),
    ('Rafael Henrique Oliveira', 'Mestre',      'rafael.oliveira@unifacisa.edu.br');
    
-- 3. ALUNOS
INSERT INTO Alunos (Nome, CPF, Email, DataNascimento, ID_Curso) VALUES
    ('Erik Silva Oliveira Farias',           '99988877766','erik.silva@aluno.unifacisa.edu.br',   '2002-03-15', 1),
    ('Kaio Jeffeerson do Nascimento Pereira','88877766655','kaio.pereira@aluno.unifacisa.edu.br', '2000-04-25', 1),
    ('Killandio Araújo Dantas',              '77766655544','kill.dantas@aluno.unifacisa.edu.br',  '2002-11-05', 1),
    ('Luis Felipe Alves Dantas',             '66655544433','luis.dantas@aluno.unifacisa.edu.br',  '2001-04-18', 1),
    ('Pedro Henrique Gouveia Dias de Araújo','55544433322','pedro.araujo@aluno.unifacisa.edu.br', '2003-01-30', 1),
    ('Fernanda Castro Melo',                 '44433322211','fernanda.melo@aluno.unifacisa.edu.br','2002-09-12', 2),
    ('Bruno Nascimento Teixeira',            '33322211100','bruno.teixeira@aluno.unifacisa.edu.br','2001-06-08', 2);
    
-- 4. CURRICULOS
INSERT INTO Curriculos (ID_Curso, AnoInicio, Versao) VALUES
    (1, 2023, 1),
    (2, 2023, 1),
    (3, 2024, 1),
	(4, 2022, 1),
    (5, 2024, 1);

-- 5. DISCIPLINAS
INSERT INTO Disciplinas (NomeDisciplina, CargaHoraria) VALUES
    ('Algoritmos e Lógica de Programação', 60),   -- ID 1
    ('Banco de Dados I', 60),   -- ID 2
    ('Engenharia de Software I', 60),   -- ID 3
    ('Estruturas de Dados', 60),   -- ID 4
    ('Programação Orientada a Objetos', 60),   -- ID 5
    ('Redes de Computadores', 60),   -- ID 6
    ('Sistemas Operacionais', 60),   -- ID 7
    ('Cálculo I', 60),   -- ID 8
    ('Projeto de Software', 60);   -- ID 9
    
-- 6. DISCIPLINAS_CURRICULO (currículo 1 = Sistemas de Informação)
INSERT INTO Disciplinas_Curriculo (ID_Curriculo, ID_Disciplina, PeriodoIdeal) VALUES
    (1, 1, 1),   -- Algoritmos          — 1º período
    (1, 8, 1),   -- Cálculo I           — 1º período
    (1, 2, 2),   -- Banco de Dados I    — 2º período
    (1, 5, 2),   -- POO                 — 2º período
    (1, 3, 3),   -- Eng. de Software I  — 3º período
    (1, 4, 3),   -- Estruturas de Dados — 3º período
    (1, 6, 4),   -- Redes               — 4º período
    (1, 7, 4),   -- Sistemas Operacionais — 4º período
    (1, 9, 5);   -- Projeto de Software — 5º período
 
-- 7. PRE_REQUISITOS
INSERT INTO PreRequisitos (ID_Disciplina_Principal, ID_Disciplina_PreRequisito) VALUES
    (2, 1),   -- Banco de Dados I    exige Algoritmos
    (4, 1),   -- Estruturas de Dados exige Algoritmos
    (5, 1),   -- POO                 exige Algoritmos
    (3, 5),   -- Eng. de Software I  exige POO
    (9, 3),   -- Projeto de Software exige Eng. de Software I
    (7, 6);   -- Sistemas Operacionais exige Redes

-- 8. SEMESTRES
INSERT INTO Semestres (CodigoSemestre, AbertoParaMatricula) VALUES
    ('2024.1', 0),   -- semestre passado, fechado
    ('2024.2', 0),   -- semestre passado, fechado
    ('2025.1', 0),   -- semestre passado, fechado
    ('2025.2', 0),   -- semestre passado, fechado
    ('2026.1', 1);   -- semestre atual, aberto
    
-- 9. TURMAS
INSERT INTO Turmas (ID_Disciplina, ID_Professor, ID_Semestre, MaxVagas, VagasOcupadas) VALUES
    (1, 1, 5, 40,  0),   -- Algoritmos       — 2026.1
	(2, 2, 5, 35,  0),   -- Banco de Dados   — 2026.1
	(3, 3, 5, 30,  0),   -- Eng. de Software — 2026.1
	(4, 1, 5, 30,  0),   -- Est. de Dados    — 2026.1
	(5, 4, 5, 35,  0),   -- POO              — 2026.1
	(1, 2, 2, 40, 40),   -- Algoritmos       — 2024.2 (concluída)
	(8, 3, 5,  5,  5);   -- Cálculo I        — 2026.1 (lotada)
    
-- 10. USUARIOS
INSERT INTO Usuarios (Nome, Email, TipoUsuario, SenhaHash) VALUES
    ('Administrador', 'admin@unifacisa.edu.br', 'Admin', 'hash_admin_001'),
    ('Secretaria Acadêmica', 'secretaria@unifacisa.edu.br', 'Secretaria', 'hash_sec_002'),
    ('Carlos Eduardo Lima', 'carlos.lima@unifacisa.edu.br', 'Professor', 'hash_prof_003'),
    ('Erik Silva Oliveira Farias', 'erik.silva@aluno.unifacisa.edu.br', 'Aluno', 'hash_aluno_004'),
    ('Kaio Jeffeerson N. Pereira', 'kaio.pereira@aluno.unifacisa.edu.br', 'Aluno', 'hash_aluno_005');
 
 -- 11. MATRICULAS
-- Semestre 2024.2: turma 6 (Algoritmos) — concluídas
-- Semestre 2026.1: turmas 1–5 — em andamento (Status Cursando, NotaFinal NULL)
INSERT INTO Matriculas (ID_Aluno, ID_Turma, Status, NotaFinal) VALUES
	-- 2024.2 — concluídas
    (1, 6, 'Aprovado', 8.5),
    (2, 6, 'Aprovado', 9.0),
    (3, 6, 'Aprovado', 7.5),
    (4, 6, 'Aprovado', 8.0),
    (5, 6, 'Reprovado', 4.5),   -- Pedro reprovado (viabiliza teste de pré-req)
    -- 2026.1 — em andamento
    (1, 3, 'Cursando', NULL),  -- Erik    — Eng. de Software
    (2, 1, 'Cursando', NULL),  -- Kaio    — Algoritmos
    (3, 2, 'Cursando', NULL),  -- Kill    — Banco de Dados
    (4, 3, 'Cursando', NULL),  -- Luis    — Eng. de Software
    (5, 1, 'Cursando', NULL);  -- Pedro   — Algoritmos (2ª tentativa)
 
 -- 12. HISTORICO_ALUNO (apenas disciplinas com Aprovado no 2024.2)
 INSERT INTO HistoricoAluno (ID_Aluno, ID_Disciplina, NotaFinal, Status, DataConclusao) VALUES
    (1, 1, 8.5, 'Aprovado', '2024-12-15'),
    (2, 1, 9.0, 'Aprovado', '2024-12-15'),
    (3, 1, 7.5, 'Aprovado', '2024-12-15'),
    (4, 1, 8.0, 'Aprovado', '2024-12-15');
    
-- 13. LOGS_SISTEMA (registros iniciais para alimentar a view)
INSERT INTO LogsSistema (Usuario, Acao, TabelaAfetada, Descricao) VALUES
    ('admin', 'INSERT', 'Alunos', 'Cadastro do aluno Erik Silva'),
    ('admin', 'INSERT', 'Alunos', 'Cadastro do aluno Kaio Pereira'),
    ('admin', 'INSERT', 'Alunos', 'Cadastro do aluno Killandio Dantas'),
    ('secretaria', 'INSERT', 'Matriculas','Matrícula de Erik na turma de Eng. de Software'),
    ('secretaria', 'INSERT', 'Matriculas','Matrícula de Kaio na turma de Algoritmos'),
    ('secretaria', 'UPDATE', 'Semestres', 'Semestre 2025.2 encerrado — AbertoParaMatricula = 0'),
    ('secretaria', 'UPDATE', 'Semestres', 'Semestre 2026.1 aberto — AbertoParaMatricula = 1'),
    ('admin', 'INSERT', 'Turmas', 'Turma de Cálculo I criada para 2026.1'),
    ('secretaria', 'UPDATE', 'Matriculas','Nota lançada: Erik — Algoritmos 2024.2 = 8.5'),
    ('secretaria', 'UPDATE', 'Matriculas','Nota lançada: Pedro — Algoritmos 2024.2 = 4.5 (Reprovado)');
