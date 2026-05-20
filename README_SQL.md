# Projeto 1 — Sistema de Gerenciamento de Matrículas

> Projeto acadêmico desenvolvido para a disciplina **Banco de Dados**  
> UNIFACISA Centro Universitário — Curso: Sistemas de Informação

---

## Integrantes

| Nome | Papel |
|---|---|
| Kaio Jeffeerson do Nascimento Pereira | Product Owner |
| Erik Silva Oliveira Farias | Scrum Master |
| Luis Felipe Alves Dantas | Programador |
| Pedro Henrique Gouveia Dias de Araújo | Testador |
| Killandio Araújo Dantas | Designer |

---

## Descrição do Sistema

O **Sistema de Gerenciamento de Matrículas** modela o ciclo acadêmico completo de uma instituição de ensino superior. O banco de dados cobre desde o cadastro de cursos, disciplinas e currículos até a matrícula de alunos em turmas, o lançamento de notas, a geração automática de histórico e o registro de auditoria de todas as operações realizadas.

O projeto implementa regras de negócio diretamente no banco de dados por meio de procedures, functions e triggers, garantindo integridade e consistência independentemente da aplicação que consuma os dados.

**Principais funcionalidades:**
- Controle de vagas por turma com incremento automático via trigger
- Matrícula transacional com validação de pré-requisitos, vagas e duplicatas
- Limite de 6 disciplinas cursando por aluno por semestre
- Geração automática de histórico ao aprovar uma disciplina
- Auditoria completa de operações nas tabelas principais
- Cálculo de coeficiente de rendimento e horas concluídas

---

## Tecnologias Utilizadas

| Tecnologia | Finalidade |
|---|---|
| MySQL / MariaDB | Sistema gerenciador de banco de dados |
| SQL (DDL / DML) | Criação do esquema e inserção de dados |
| Stored Procedures | Encapsulamento de regras de negócio |
| Functions | Cálculos reutilizáveis e consultas parametrizadas |
| Triggers | Automação e auditoria de eventos |
| Views | Consultas pré-definidas para relatórios |
| Git / GitHub | Versionamento e colaboração em equipe |

---

## Objetos do Banco de Dados

### Views

| View | Descrição |
|---|---|
| `vw_BoletimAluno` | Histórico completo do aluno por semestre, disciplina, professor, nota e status |
| `vw_TurmasDisponiveis` | Turmas abertas com vagas disponíveis no semestre atual |
| `vw_DesempenhoTurma` | Média das notas, aprovados e reprovados por turma |
| `vw_LogAuditoria` | 20 operações mais recentes registradas em LogsSistema |

### Stored Procedures

| Procedure | Descrição |
|---|---|
| `sp_RegistrarMatricula` | Valida e efetua matrícula com controle transacional (COMMIT / ROLLBACK) |
| `sp_TrancarMatricula` | Tranca matrícula ativa e decrementa vaga na turma |
| `sp_LancarNotas` | Lança nota final e define status Aprovado ou Reprovado automaticamente |
| `sp_GerarHistoricoAluno` | Insere disciplinas aprovadas em HistoricoAluno sem duplicatas |
| `sp_ReabrirPeriodoMatricula` | Reabre semestre para matrícula com validação e registro em log |

### Functions

| Function | Retorno |
|---|---|
| `fn_CalcularCoeficienteRendimento(p_ID_Aluno)` | Média ponderada das notas (peso = carga horária) |
| `fn_ContarDisciplinasPendentes(p_ID_Aluno, p_ID_Curso)` | Quantidade de disciplinas do currículo ainda não concluídas |
| `fn_ListarDisciplinasAprovadas(p_ID_Aluno)` | Total de disciplinas com status Aprovado no histórico |
| `fn_TotalHorasConcluidas(p_ID_Aluno)` | Soma da carga horária das disciplinas aprovadas |

### Triggers

| Trigger | Evento | Ação |
|---|---|---|
| `trg_AtualizarContagemVagas` | AFTER INSERT em Matriculas | Incrementa VagasOcupadas na turma |
| `trg_AuditoriaAluno` | AFTER UPDATE em Alunos | Registra alteração de e-mail em LogsSistema |
| `trg_AtualizarHistoricoAutomaticamente` | AFTER UPDATE em Matriculas | Insere em HistoricoAluno ao aprovar |
| `trg_LogOperacoesGerais` | AFTER INSERT/UPDATE/DELETE | Registra operações nas tabelas principais |
| `trg_AtualizarStatusAutomaticamente` | AFTER INSERT em Matriculas | Bloqueia matrícula se aluno já tem 6 disciplinas Cursando |

---

## Organização das Pastas

```
Sistema-de-Gerenciamento-de-Matriculas/
│
├── sql/
│   ├── kaio_ddl.sql           # DDL: criação das 13 tabelas
│   ├── kaio_dml.sql           # DML: dados de exemplo
│   ├── kaio_view_sp.sql       # VIEW vw_LogAuditoria + SP sp_ReabrirPeriodoMatricula
│   ├── kaio_teste12.sql       # Teste 12: reabrir período de matrícula
│   ├── erik_sp_trg_fn.sql     # SP sp_RegistrarMatricula, sp_TrancarMatricula,
│   │                          #   TRG trg_AtualizarStatusAutomaticamente,
│   │                          #   FN fn_CalcularCoeficienteRendimento
│   ├── luis_views_sp_fn.sql   # VIEW vw_BoletimAluno, vw_TurmasDisponiveis,
│   │                          #   SP sp_LancarNotas,
│   │                          #   FN fn_ListarDisciplinasAprovadas
│   ├── pedro_view_sp_fn_trg.sql # VIEW vw_DesempenhoTurma, SP sp_GerarHistoricoAluno,
│   │                            #   FN fn_ContarDisciplinasPendentes,
│   │                            #   TRG trg_AuditoriaAluno
│   ├── kill_trg_fn.sql        # TRG trg_AtualizarContagemVagas,
│   │                          #   trg_AtualizarHistoricoAutomaticamente,
│   │                          #   trg_LogOperacoesGerais,
│   │                          #   FN fn_TotalHorasConcluidas
│   └── projeto_grupo_X.sql    # Arquivo final consolidado (gerado pelo Killandio)
│
├── relatorio_grupo_X.pdf      # Relatório final do projeto
└── README.md
```

---

## Instruções para Rodar o Projeto

### Pré-requisitos

- **MySQL** (versão 8.0 ou superior) ou **MariaDB** — [mysql.com](https://www.mysql.com)
- **MySQL Workbench** (recomendado) ou outro cliente SQL de sua preferência
- **Git** — [git-scm.com](https://git-scm.com)

### Clonando o repositório

```bash
git clone https://github.com/kaiojnsc/Sistema-de-Gerenciamento-de-Matriculas.git
cd Sistema-de-Gerenciamento-de-Matriculas
```

### Executando o projeto

**Opção 1 — Arquivo consolidado (recomendado):**
```bash
mysql -u root -p < sql/projeto_grupo_X.sql
```

**Opção 2 — MySQL Workbench:**
1. Abra o MySQL Workbench e conecte ao servidor local
2. Abra o arquivo `sql/projeto_grupo_X.sql`
3. Execute com `Ctrl + Shift + Enter`

**Opção 3 — Execução por partes (desenvolvimento):**
```sql
-- Execute na seguinte ordem obrigatória:
source sql/kaio_ddl.sql          -- 1. Criação das tabelas
source sql/kaio_dml.sql          -- 2. Dados de exemplo
source sql/kaio_view_sp.sql      -- 3. View e procedure (Kaio)
source sql/luis_views_sp_fn.sql  -- 4. Views, SP e function (Luis)
source sql/pedro_view_sp_fn_trg.sql -- 5. View, SP, function e trigger (Pedro)
source sql/erik_sp_trg_fn.sql    -- 6. SPs, trigger e function (Erik)
source sql/kill_trg_fn.sql       -- 7. Triggers e function (Killandio)
```

### Verificando a instalação

```sql
USE db_matriculas;

-- Listar todas as tabelas criadas
SHOW TABLES;

-- Testar uma view
SELECT * FROM vw_LogAuditoria;

-- Testar uma function
SELECT fn_CalcularCoeficienteRendimento(1) AS CoeficienteRendimento;

-- Testar uma procedure
CALL sp_ReabrirPeriodoMatricula(2, @msg);
SELECT @msg AS Resultado;
```

---

## Regras de Negócio Implementadas

| Regra | Implementação |
|---|---|
| Máximo de 6 disciplinas Cursando por semestre | `trg_AtualizarStatusAutomaticamente` |
| Matrícula exige semestre aberto | `sp_RegistrarMatricula` |
| Matrícula exige vagas disponíveis | `sp_RegistrarMatricula` |
| Matrícula exige pré-requisitos aprovados | `sp_RegistrarMatricula` |
| Nota >= 7 define status Aprovado | `sp_LancarNotas` |
| Aprovação gera registro automático no histórico | `trg_AtualizarHistoricoAutomaticamente` |
| Trancamento decrementa vaga na turma | `sp_TrancarMatricula` |
| Toda operação crítica é registrada em log | `trg_LogOperacoesGerais` |

---

## Status do Projeto

| Fase | Descrição | Status |
|---|---|---|
| DDL | Criação das 13 tabelas com constraints | ✅ Concluído |
| DML | Dados de exemplo para todos os testes | ✅ Concluído |
| Views | 4 views implementadas | ✅ Concluído |
| Stored Procedures | 5 procedures implementadas | ✅ Concluído |
| Functions | 4 functions implementadas | ✅ Concluído |
| Triggers | 5 triggers implementadas | ✅ Concluído |
| Testes | 13 cenários executados e documentados | ✅ Concluído |
| Relatório PDF | Documento final entregue | ✅ Concluído |

---

*UNIFACISA Centro Universitário — Campina Grande, PB — 2026*
