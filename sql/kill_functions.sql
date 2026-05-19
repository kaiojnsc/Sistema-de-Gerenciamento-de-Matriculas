-- Seção: FUNCTION
USE db_matriculas;

-- FUNCTION: fn_TotalHorasConcluidas
-- Soma a carga horária das disciplinas aprovadas por um aluno

DROP FUNCTION IF EXISTS fn_TotalHorasConcluidas;

DELIMITER $$

CREATE FUNCTION fn_TotalHorasConcluidas(p_ID_Aluno INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT IFNULL(SUM(d.CargaHoraria), 0)
    INTO total
    FROM HistoricoAluno h
    JOIN Disciplinas d ON h.ID_Disciplina = d.ID_Disciplina
    WHERE h.ID_Aluno = p_ID_Aluno
      AND h.Status = 'Aprovado';

    RETURN total;
END$$

DELIMITER ;
