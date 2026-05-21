-- Seção: VIEW e STORED PROCEDURE
USE db_matriculas;

-- VIEW: vw_LogAuditoria / Exibir as 20 operações mais recentes registradas em LogsSistema
DROP VIEW IF EXISTS vw_LogAuditoria;
 
CREATE VIEW vw_LogAuditoria AS
    SELECT
        ID_Log,
        DataHora,
        Usuario,
        Acao,
        TabelaAfetada,
        Descricao
    FROM LogsSistema
    ORDER BY DataHora DESC
    LIMIT 20;
    
-- STORED PROCEDURE: sp_ReabrirPeriodoMatricula / Reabre o período de matrícula de um semestre especificado. 
-- Parâmetros: p_ID_Semestre  INT — ID do semestre a ser reaberto / p_Mensagem OUT — retorna o resultado da operação

DROP PROCEDURE IF EXISTS sp_ReabrirPeriodoMatricula;
 
DELIMITER $$
 
CREATE PROCEDURE sp_ReabrirPeriodoMatricula (
    IN  p_ID_Semestre   INT,
    OUT p_Mensagem      VARCHAR(200)
)
BEGIN
    -- Semestre não existe
    IF NOT EXISTS (
        SELECT 1 FROM Semestres WHERE ID_Semestre = p_ID_Semestre
    ) THEN
        SET p_Mensagem = CONCAT('Erro: semestre ID ', p_ID_Semestre, ' não encontrado.');
 
    -- Semestre já está aberto
    ELSEIF (
        SELECT AbertoParaMatricula FROM Semestres WHERE ID_Semestre = p_ID_Semestre
    ) = 1 THEN
        SET p_Mensagem = CONCAT('Aviso: semestre ID ', p_ID_Semestre, ' já está aberto para matrícula.');
 
    -- Reabre e registra no log
    ELSE
        UPDATE Semestres
           SET AbertoParaMatricula = 1
         WHERE ID_Semestre = p_ID_Semestre;
 
        INSERT INTO LogsSistema (Usuario, Acao, TabelaAfetada, Descricao)
        VALUES (
            'sistema',
            'UPDATE',
            'Semestres',
            CONCAT('Período de matrícula reaberto para o semestre ID ', p_ID_Semestre)
        );
 
        SET p_Mensagem = CONCAT('Sucesso: período de matrícula reaberto para o semestre ID ', p_ID_Semestre, '.');
    END IF;
END$$
 
DELIMITER ;



