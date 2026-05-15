-- ==========================================================
-- PROJETO 1 - BANCO DE DADOS (SISTEMAS DE INFORMAÇÃO)
-- MEMBRO DO GRUPO: PEDRO HENRIQUE GOUVEIA
-- TAREFAS: VIEWS, PROCEDURES, FUNCTIONS E TRIGGERS [cite: 208]
-- ==========================================================

-- 1. View para ver o rendimento das turmas [cite: 34-35, 208]
CREATE VIEW vw_DesempenhoTurma AS
SELECT 
    d.NomeDisciplina, 
    p.Nome AS Nome_Professor, 
    AVG(m.NotaFinal) AS Media_Notas,
    SUM(CASE WHEN m.Status = 'Aprovado' THEN 1 ELSE 0 END) AS Qtd_Aprovados,
    SUM(CASE WHEN m.Status = 'Reprovado' THEN 1 ELSE 0 END) AS Qtd_Reprovados
FROM Turmas t
JOIN Disciplinas d ON t.ID_Disciplina = d.ID_Disciplina
JOIN Professores p ON t.ID_Professor = p.ID_Professor
JOIN Matriculas m ON t.ID_Turma = m.ID_Turma
GROUP BY t.ID_Turma;

-- 2. Procedure para o Histórico do Aluno [cite: 57-61, 208]
DELIMITER //
CREATE PROCEDURE sp_GerarHistoricoAluno(IN p_ID_Aluno INT)
BEGIN
    INSERT INTO HistoricoAluno (ID_Aluno, ID_Disciplina, NotaFinal, Status, DataConclusao)
    SELECT m.ID_Aluno, t.ID_Disciplina, m.NotaFinal, m.Status, CURDATE()
    FROM Matriculas m
    JOIN Turmas t ON m.ID_Turma = t.ID_Turma
    WHERE m.ID_Aluno = p_ID_Aluno 
      AND m.Status = 'Aprovado'
      AND t.ID_Disciplina NOT IN (
          SELECT ID_Disciplina FROM HistoricoAluno WHERE ID_Aluno = p_ID_Aluno
      );
END //
DELIMITER ;

-- 3. Função para contar matérias que faltam [cite: 67, 208]
DELIMITER //
CREATE FUNCTION fn_ContarDisciplinasPendentes(p_ID_Aluno INT, p_ID_Curso INT) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE v_pendentes INT;
    SELECT COUNT(*) INTO v_pendentes
    FROM Disciplinas_Curriculo dc
    JOIN Curriculos c ON dc.ID_Curriculo = c.ID_Curriculo
    WHERE c.ID_Curso = p_ID_Curso
      AND dc.ID_Disciplina NOT IN (
          SELECT ID_Disciplina FROM HistoricoAluno WHERE ID_Aluno = p_ID_Aluno AND Status = 'Aprovado'
      );
    RETURN v_pendentes;
END //
DELIMITER ;

-- 4. Trigger de Auditoria de E-mail [cite: 82-85, 208]
DELIMITER //
CREATE TRIGGER trg_AuditoriaAluno
AFTER UPDATE ON Alunos
FOR EACH ROW
BEGIN
    IF OLD.Email <> NEW.Email THEN
        INSERT INTO LogsSistema (Usuario, Acao, TabelaAfetada, DataHora, Descricao)
        VALUES (USER(), 'UPDATE', 'Alunos', NOW(), 
                CONCAT('E-mail alterado. De: ', OLD.Email, ' para: ', NEW.Email));
    END IF;
END //
DELIMITER ;