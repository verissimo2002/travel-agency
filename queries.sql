-- Queries Úteis para Gerenciar o Banco de Dados
-- Travel Agency Document Processor

-- =============================================
-- CONSULTAS BÁSICAS
-- =============================================

-- Ver todos os downloads
SELECT * FROM clientes_downloads;

-- Contar total de downloads
SELECT COUNT(*) as total_downloads FROM clientes_downloads;

-- Ver downloads recentes (últimas 24 horas)
SELECT * FROM clientes_downloads 
WHERE datetime(data_hora) >= datetime('now', '-1 day')
ORDER BY data_hora DESC;

-- Ver downloads por data
SELECT DATE(data_hora) as data, COUNT(*) as total 
FROM clientes_downloads 
GROUP BY DATE(data_hora)
ORDER BY data DESC;

-- Ver downloads por hora
SELECT HOUR(data_hora) as hora, COUNT(*) as total 
FROM clientes_downloads 
GROUP BY HOUR(data_hora)
ORDER BY hora DESC;

-- =============================================
-- ANÁLISES
-- =============================================

-- Passaportes mais processados
SELECT numero_passaporte, COUNT(*) as tentativas 
FROM clientes_downloads 
GROUP BY numero_passaporte
HAVING COUNT(*) > 1
ORDER BY tentativas DESC;

-- Estatísticas gerais
SELECT 
    COUNT(*) as total_downloads,
    COUNT(DISTINCT numero_passaporte) as passaportes_unicos,
    MIN(data_hora) as primeiro_download,
    MAX(data_hora) as ultimo_download
FROM clientes_downloads;

-- Downloads por IP (se coletado)
SELECT ip_cliente, COUNT(*) as total 
FROM clientes_downloads 
WHERE ip_cliente IS NOT NULL
GROUP BY ip_cliente
ORDER BY total DESC
LIMIT 10;

-- =============================================
-- LIMPEZA DE DADOS
-- =============================================

-- Deletar downloads antigos (mais de 30 dias)
DELETE FROM clientes_downloads 
WHERE datetime(data_hora) < datetime('now', '-30 days');

-- Deletar downloads de um passaporte específico
DELETE FROM clientes_downloads 
WHERE numero_passaporte = 'N16E7272';

-- Limpar todos os dados (cuidado!)
DELETE FROM clientes_downloads;

-- =============================================
-- EXPORTAÇÃO
-- =============================================

-- Exportar para CSV (via CLI SQLite)
-- .headers on
-- .mode csv
-- .output relatorio.csv
-- SELECT * FROM clientes_downloads;
-- .output stdout

-- Exportar últimos 7 dias
-- .headers on
-- .mode csv
-- .output relatorio_semana.csv
-- SELECT * FROM clientes_downloads 
-- WHERE datetime(data_hora) >= datetime('now', '-7 days');
-- .output stdout

-- =============================================
-- MANUTENÇÃO
-- =============================================

-- Verificar integridade do banco
PRAGMA integrity_check;

-- Otimizar banco de dados
VACUUM;

-- Ver informações da tabela
PRAGMA table_info(clientes_downloads);

-- Ver índices
SELECT name FROM sqlite_master 
WHERE type='index' AND tbl_name='clientes_downloads';

-- =============================================
-- CÓPIAS DE SEGURANÇA
-- =============================================

-- Criar backup via SQLite (via CLI)
-- .backup backup_2024.db

-- Restaurar backup via SQLite (via CLI)
-- .restore backup_2024.db

-- =============================================
-- RELATÓRIOS
-- =============================================

-- Relatório de atividades diárias
SELECT 
    DATE(data_hora) as data,
    COUNT(*) as total_downloads,
    COUNT(DISTINCT numero_passaporte) as passaportes_unicos,
    MIN(TIME(data_hora)) as primeira_atividade,
    MAX(TIME(data_hora)) as ultima_atividade
FROM clientes_downloads
GROUP BY DATE(data_hora)
ORDER BY data DESC;

-- Relatório de picos de uso (por hora)
SELECT 
    strftime('%H', data_hora) as hora,
    COUNT(*) as downloads,
    COUNT(DISTINCT DATE(data_hora)) as dias
FROM clientes_downloads
GROUP BY strftime('%H', data_hora)
ORDER BY downloads DESC;

-- Relatório de status
SELECT 
    status,
    COUNT(*) as quantidade,
    COUNT(DISTINCT numero_passaporte) as passaportes
FROM clientes_downloads
GROUP BY status;

-- =============================================
-- QUERIES DE MONITORAMENTO
-- =============================================

-- Verificar saúde do sistema (últimas 24h)
SELECT 
    DATE(data_hora) as data,
    COUNT(*) as tentativas,
    COUNT(CASE WHEN status = 'concluido' THEN 1 END) as sucesso,
    COUNT(CASE WHEN status != 'concluido' THEN 1 END) as erro,
    ROUND(100.0 * COUNT(CASE WHEN status = 'concluido' THEN 1 END) / COUNT(*), 2) as taxa_sucesso
FROM clientes_downloads
WHERE datetime(data_hora) >= datetime('now', '-1 day')
GROUP BY DATE(data_hora);

-- Detectar anomalias (downloads duplicados mesmo dia)
SELECT 
    numero_passaporte,
    DATE(data_hora) as data,
    COUNT(*) as tentativas,
    GROUP_CONCAT(TIME(data_hora)) as horarios
FROM clientes_downloads
GROUP BY numero_passaporte, DATE(data_hora)
HAVING COUNT(*) > 1
ORDER BY tentativas DESC;

-- =============================================
-- ALTERAÇÕES E ATUALIZAÇÕES
-- =============================================

-- Adicionar coluna de email (se necessário)
ALTER TABLE clientes_downloads 
ADD COLUMN email TEXT;

-- Adicionar coluna de user_agent
ALTER TABLE clientes_downloads 
ADD COLUMN user_agent TEXT;

-- Atualizar status de um registro
UPDATE clientes_downloads 
SET status = 'verificado'
WHERE id = 1;

-- =============================================
-- NOTAS
-- =============================================
-- 
-- Este arquivo contém exemplos de queries SQLite
-- Para usar com a aplicação:
--
-- 1. Via CLI SQLite:
--    sqlite3 viagens.db < queries.sql
--
-- 2. Copiar uma query individual e rodar:
--    sqlite3 viagens.db "SELECT * FROM clientes_downloads;"
--
-- 3. Via Python:
--    import sqlite3
--    conn = sqlite3.connect('viagens.db')
--    cursor = conn.cursor()
--    cursor.execute('SELECT * FROM clientes_downloads')
--    print(cursor.fetchall())
--
-- =============================================
