-- Seção: TESTES
USE db_matriculas;

-- TESTE 8
-- Verificar se os logs estão sendo registrados

SELECT *
FROM LogsSistema
ORDER BY DataHora DESC
LIMIT 20;


-- TESTE 10
-- Conferir se as matrículas aprovadas aparecem no histórico

SELECT 
    m.ID_Matricula,
    m.ID_Aluno,
    t.ID_Disciplina,
    m.NotaFinal,
    m.Status,
    h.ID_Historico
FROM Matriculas m
JOIN Turmas t ON m.ID_Turma = t.ID_Turma
LEFT JOIN HistoricoAluno h
    ON h.ID_Aluno = m.ID_Aluno
   AND h.ID_Disciplina = t.ID_Disciplina
WHERE m.Status = 'Aprovado';


-- TESTE 11
-- Testar comportamento das chaves estrangeiras
-- Esse DELETE só vai ser usado apenas na hora do teste
-- Por isso está comentado no momento

-- DELETE FROM Cursos
-- WHERE ID_Curso = 1;

SELECT *
FROM Cursos;

SELECT *
FROM Alunos;
