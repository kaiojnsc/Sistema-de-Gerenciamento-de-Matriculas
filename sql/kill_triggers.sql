-- Seção: TRIGGERS
USE db_matriculas;

-- Trigger: atualizar vagas ocupadas

DROP TRIGGER IF EXISTS trg_AtualizarContagemVagas;

DELIMITER $$

CREATE TRIGGER trg_AtualizarContagemVagas
AFTER INSERT ON Matriculas
FOR EACH ROW
BEGIN

    IF NEW.Status = 'Cursando' THEN

        UPDATE Turmas
        SET VagasOcupadas = VagasOcupadas + 1
        WHERE ID_Turma = NEW.ID_Turma;

    END IF;

END$$

DELIMITER ;

-- Trigger: atualizar histórico automaticamente

DROP TRIGGER IF EXISTS trg_AtualizarHistoricoAutomaticamente;

DELIMITER $$

CREATE TRIGGER trg_AtualizarHistoricoAutomaticamente
AFTER UPDATE ON Matriculas
FOR EACH ROW
BEGIN

    IF NEW.Status = 'Aprovado'
       AND OLD.Status <> 'Aprovado' THEN

        INSERT INTO HistoricoAluno (
            ID_Aluno,
            ID_Disciplina,
            NotaFinal,
            Status,
            DataConclusao
        )

        SELECT
            NEW.ID_Aluno,
            t.ID_Disciplina,
            NEW.NotaFinal,
            'Aprovado',
            CURDATE()

        FROM Turmas t

        WHERE t.ID_Turma = NEW.ID_Turma

        AND NOT EXISTS (
            SELECT 1
            FROM HistoricoAluno h
            WHERE h.ID_Aluno = NEW.ID_Aluno
            AND h.ID_Disciplina = t.ID_Disciplina
        );

    END IF;

END$$

DELIMITER ;

-- Trigger: logs de operações

DROP TRIGGER IF EXISTS trg_LogOperacoesGerais;

DELIMITER $$

CREATE TRIGGER trg_LogOperacoesGerais
AFTER INSERT ON Matriculas
FOR EACH ROW
BEGIN

    INSERT INTO LogsSistema (
        Usuario,
        Acao,
        TabelaAfetada,
        Descricao
    )

    VALUES (
        'sistema',
        'INSERT',
        'Matriculas',
        CONCAT('Nova matrícula criada. ID = ', NEW.ID_Matricula)
    );

END$$

DELIMITER ;
