USE db_matriculas;

DROP VIEW IF EXISTS vw_BoletimAluno;

CREATE VIEW vw_BoletimAluno AS
SELECT
    a.ID_Aluno,
    a.Nome                                      AS NomeAluno,
    CONCAT(s.Ano, '/', s.Periodo)               AS Semestre,
    s.Ano,
    s.Periodo,
    d.Nome                                      AS Disciplina,
    d.CargaHoraria,
    CONCAT(p.Nome, ' ', p.Sobrenome)            AS Professor,
    m.NotaFinal,
    m.Status                                    AS StatusMatricula
FROM  Matriculas   m
JOIN  Alunos       a  ON  a.ID_Aluno       = m.ID_Aluno
JOIN  Turmas       t  ON  t.ID_Turma       = m.ID_Turma
JOIN  Disciplinas  d  ON  d.ID_Disciplina  = t.ID_Disciplina
JOIN  Professores  p  ON  p.ID_Professor   = t.ID_Professor
JOIN  Semestres    s  ON  s.ID_Semestre    = t.ID_Semestre
ORDER BY
    a.Nome     ASC,
    s.Ano      DESC,
    s.Periodo  DESC,
    d.Nome     ASC;


DROP VIEW IF EXISTS vw_TurmasDisponiveis;

CREATE VIEW vw_TurmasDisponiveis AS
SELECT
    t.ID_Turma,
    CONCAT(s.Ano, '/', s.Periodo)               AS Semestre,
    s.Ano,
    s.Periodo,
    d.ID_Disciplina,
    d.Nome                                      AS Disciplina,
    d.CargaHoraria,
    CONCAT(p.Nome, ' ', p.Sobrenome)            AS Professor,
    t.DiaSemana,
    t.HorarioInicio,
    t.HorarioFim,
    t.MaxVagas,
    t.VagasOcupadas,
    (t.MaxVagas - t.VagasOcupadas)              AS VagasDisponiveis
FROM  Turmas       t
JOIN  Semestres    s  ON  s.ID_Semestre    = t.ID_Semestre
JOIN  Disciplinas  d  ON  d.ID_Disciplina  = t.ID_Disciplina
JOIN  Professores  p  ON  p.ID_Professor   = t.ID_Professor
WHERE
      s.AbertoParaMatricula = 1
  AND t.VagasOcupadas       < t.MaxVagas
ORDER BY
    d.Nome          ASC,
    t.HorarioInicio ASC;


DROP PROCEDURE IF EXISTS sp_LancarNotas;

DELIMITER $$

CREATE PROCEDURE sp_LancarNotas(
    IN  p_ID_Matricula  INT,
    IN  p_NotaFinal     DECIMAL(4,2),
    OUT p_Mensagem      VARCHAR(255)
)
bloco: BEGIN

    DECLARE v_StatusAtual  VARCHAR(20) DEFAULT NULL;
    DECLARE v_NovoStatus   VARCHAR(20);
    DECLARE v_ID_Aluno     INT;
    DECLARE v_ID_Turma     INT;

    IF p_NotaFinal < 0.00 OR p_NotaFinal > 10.00 THEN
        SET p_Mensagem = CONCAT('Erro: nota ', p_NotaFinal, ' invalida. Informe um valor entre 0.00 e 10.00.');
        LEAVE bloco;
    END IF;

    SELECT Status, ID_Aluno, ID_Turma
    INTO   v_StatusAtual, v_ID_Aluno, v_ID_Turma
    FROM   Matriculas
    WHERE  ID_Matricula = p_ID_Matricula
    LIMIT  1;

    IF v_StatusAtual IS NULL THEN
        SET p_Mensagem = CONCAT('Erro: matricula ID ', p_ID_Matricula, ' nao encontrada.');
        LEAVE bloco;
    END IF;

    IF v_StatusAtual != 'Cursando' THEN
        SET p_Mensagem = CONCAT('Erro: matricula com status "', v_StatusAtual, '" nao aceita lancamento de nota.');
        LEAVE bloco;
    END IF;

    IF p_NotaFinal >= 7.00 THEN
        SET v_NovoStatus = 'Aprovado';
    ELSE
        SET v_NovoStatus = 'Reprovado';
    END IF;

    UPDATE Matriculas
    SET    NotaFinal = p_NotaFinal,
           Status    = v_NovoStatus
    WHERE  ID_Matricula = p_ID_Matricula;

    SET p_Mensagem = CONCAT('Sucesso: nota ', p_NotaFinal, ' lancada para matricula ID ', p_ID_Matricula, '. Status atualizado para "', v_NovoStatus, '".');

END$$

DELIMITER ;


DROP FUNCTION IF EXISTS fn_ListarDisciplinasAprovadas;

DELIMITER $$

CREATE FUNCTION fn_ListarDisciplinasAprovadas(p_ID_Aluno INT)
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_Total INT DEFAULT 0;

    SELECT COUNT(*)
    INTO   v_Total
    FROM   HistoricoAluno
    WHERE  ID_Aluno = p_ID_Aluno;

    RETURN v_Total;
END$$

DELIMITER ;


SET @msg_1a = '';
CALL sp_RegistrarMatricula(2, 2, @msg_1a);
SELECT @msg_1a AS Resultado_1A;

SELECT COUNT(*) AS Deve_ser_0
FROM   Matriculas
WHERE  ID_Aluno = 2 AND ID_Turma = 2 AND Status = 'Cursando';

SET @msg_1b = '';
CALL sp_RegistrarMatricula(2, 1, @msg_1b);
SELECT @msg_1b AS Resultado_1B;

SELECT m.ID_Matricula, m.ID_Turma, d.Nome AS Disciplina, m.Status
FROM   Matriculas   m
JOIN   Turmas       t  ON t.ID_Turma      = m.ID_Turma
JOIN   Disciplinas  d  ON d.ID_Disciplina = t.ID_Disciplina
WHERE  m.ID_Aluno = 2
ORDER  BY m.ID_Matricula;


SET @msg_4a = '';
CALL sp_LancarNotas(5, 8.50, @msg_4a);
SELECT @msg_4a AS Resultado_4A;

SET @msg_4b = '';
CALL sp_LancarNotas(6, 4.00, @msg_4b);
SELECT @msg_4b AS Resultado_4B;

SET @msg_4c = '';
CALL sp_LancarNotas(5, 11.00, @msg_4c);
SELECT @msg_4c AS Resultado_4C;

SELECT m.ID_Matricula, a.Nome AS Aluno, d.Nome AS Disciplina, m.NotaFinal, m.Status
FROM   Matriculas   m
JOIN   Alunos       a  ON a.ID_Aluno      = m.ID_Aluno
JOIN   Turmas       t  ON t.ID_Turma      = m.ID_Turma
JOIN   Disciplinas  d  ON d.ID_Disciplina = t.ID_Disciplina
WHERE  m.ID_Matricula IN (5, 6)
ORDER  BY m.ID_Matricula;

SELECT * FROM vw_BoletimAluno WHERE ID_Aluno = 1;
SELECT * FROM vw_TurmasDisponiveis LIMIT 10;
SELECT fn_ListarDisciplinasAprovadas(1) AS TotalAprovadas;