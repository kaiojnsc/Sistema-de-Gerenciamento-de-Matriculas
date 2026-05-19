-- TESTE 12 — sp_ReabrirPeriodoMatricula
USE db_matriculas;

-- Fechar o semestre 2025.1 para simular o cenário
UPDATE Semestres SET AbertoParaMatricula = 0 WHERE ID_Semestre = 3;
 
-- Executar a procedure
CALL sp_ReabrirPeriodoMatricula(3, @msg);
 
-- Verificar a mensagem retornada
SELECT @msg AS Resultado;
 
-- Verificar se o campo foi atualizado
SELECT ID_Semestre, CodigoSemestre, AbertoParaMatricula
FROM Semestres
WHERE ID_Semestre = 3;
 
-- Verificar se o log foi registrado
SELECT * FROM vw_LogAuditoria LIMIT 5;