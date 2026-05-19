-- Procedure de Matricular Aluno

DELIMITER $$

CREATE PROCEDURE sp_RegistrarMatricula(
    IN p_ID_Aluno INT,
    IN p_ID_Turma INT
)
BEGIN
    -- Verifivação para saber se o aluno já está matriculado na turma
    IF EXISTS (SELECT 1 FROM Matriculas WHERE ID_Aluno = p_ID_Aluno AND ID_Turma = p_ID_Turma) THEN
        SELECT 'Aluno já matriculado nesta turma.' AS Mensagem;
    ELSE
        -- Faz a matrícula do aluno na turma
        INSERT INTO Matriculas (ID_Aluno, ID_Turma, Data_Matricula, Status)
        VALUES (p_ID_Aluno, p_ID_Turma, NOW(), 'Ativa');

        SELECT 'Matrícula realizada com sucesso.' AS Mensagem;
    END IF;
END$$

DELIMITER ;

-- Procedure de Trancar Matricula

DELIMITER $$

CREATE PROCEDURE sp_TrancarMatricula(
    IN p_ID_Aluno INT,
    IN p_ID_Turma INT
)
BEGIN
    -- Verificação para saber se o aluno está matriculado na turma
    IF EXISTS (SELECT 1 FROM Matriculas WHERE ID_Aluno = p_ID_Aluno AND ID_Turma = p_ID_Turma AND Status = 'Ativa') THEN
        -- Tranca a matrícula do aluno na turma
        UPDATE Matriculas
        SET Status = 'Trancada', Data_Trancamento = NOW()
        WHERE ID_Aluno = p_ID_Aluno AND ID_Turma = p_ID_Turma;

        -- Liberar vagas na turma
        UPDATE turmas
        SET VagasOcupadas = VagasOcupadas - 1
        WHERE ID_Turma = p_ID_Turma;

        SELECT 'Matrícula trancada com sucesso.' AS Mensagem;
    ELSE
        SELECT 'Aluno não está matriculado nesta turma ou já está trancado.' AS Mensagem;
    END IF;
END$$

-- Trigger para limitar materías de aluno com maximo de 6 materias / AtualizarStatusAutomaticamente AFTER UPDATE em Matriculas: bloqueia nova matrícula se aluno já tem 6 disciplinas 'Cursando'; registra tentativa em LogsSistema   

DELIMITER $$
CREATE TRIGGER trg_AtualizarStatusAutomaticamente
BEFORE INSERT ON Matriculas
FOR EACH ROW
BEGIN
    DECLARE v_Count INT;

    SELECT COUNT(*) INTO v_Count
    FROM Matriculas
    WHERE ID_Aluno = NEW.ID_Aluno AND Status = 'Cursando';

    IF v_Count >= 6 THEN
        -- Registra no Log a tentativa de matrícula bloqueada por limite de disciplinas
        INSERT INTO LogsSistema (ID_Aluno, Acao, Data_Hora)
        VALUES (NEW.ID_Aluno, 'Tentativa de matrícula bloqueada por limite de disciplinas', NOW());

        -- Bloqueia a nova matrícula
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Limite de 6 disciplinas cursando atingido. Nova matrícula bloqueada.';
    END IF;
END$$
DELIMITER ;

-- Função para calcular média de notas do aluno (peso = carga horária da disciplina)

DELIMITER $$
CREATE FUNCTION fn_CalcularMediaPonderada(
    p_ID_Aluno INT
) RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE v_SomaNotas DECIMAL(10,2);
    DECLARE v_SomaPesos INT;

    SELECT 
        SUM(n.Nota * d.Carga_Horaria),
        SUM(d.Carga_Horaria)
    INTO v_SomaNotas, v_SomaPesos 
    FROM Notas n
    JOIN Disciplinas d ON n.ID_Disciplina = d.ID_Disciplina
    WHERE n.ID_Aluno = p_ID_Aluno;

    IF v_SomaPesos = 0 OR v_SomaPesos IS NULL THEN
        RETURN 0;
    END IF;

    RETURN ROUND(v_SomaNotas / v_SomaPesos, 2);
END$$
DELIMITER ;

--Teste 2: Matricula em turma cheia + Rollback com mensagem de erro
CALL sp_RegistrarMatricula(1, 102); -- Exemplo de chamada para matricular aluno 1 na turma 102 (supondo que esteja cheia)
SELECT * FROM Matriculas WHERE ID_Aluno = 1 AND ID_Turma = 102; -- Confirmar que matrícula não foi realizada

-- Trancar matricula e verificar se foi decrementado vagas ocupadas
CALL sp_TrancarMatricula(1, 101); -- Exemplo de chamada para trancar matrícula do aluno 1 na turma 101
SELECT VagasOcupadas FROM Turmas WHERE ID_Turma = 101; -- Verificar se vagas ocupadas foram decrementadas

-- Rollback forçado em sp_RegistrarMatricula Forçar falha interna e confirmar ausência de alteração parcial no banco   

CALL sp_RegistrarMatricula(9999, 101); -- ID_Aluno inexistente para forçar falha
SELECT * FROM Matriculas WHERE ID_Aluno = 9999; -- Confirmar que nenhuma matrícula foi criada para o ID_Aluno inexistente