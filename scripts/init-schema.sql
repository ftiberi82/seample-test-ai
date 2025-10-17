-- Script di inizializzazione per creare schema top-secret
-- Questo script viene eseguito all'avvio del container

USE master;
GO

-- Attende che SQL Server sia completamente avviato
WAITFOR DELAY '00:00:10';
GO

-- Crea lo schema top-secret
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'top-secret')
BEGIN
    EXEC('CREATE SCHEMA [top-secret]');
    PRINT 'Schema top-secret creato con successo';
END
ELSE
BEGIN
    PRINT 'Schema top-secret già esistente';
END
GO

-- Concede tutti i permessi allo schema top-secret per l'utente sa
-- L'utente sa ha già tutti i privilegi, ma aggiungiamo esplicitamente i permessi dello schema
EXEC sp_addrolemember 'db_owner', 'sa';
GO

-- Verifica che l'utente sa esista e imposta lo schema predefinito
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'sa')
BEGIN
    ALTER USER sa WITH DEFAULT_SCHEMA = [top-secret];
    PRINT 'Schema predefinito impostato per sa';
END
ELSE
BEGIN
    PRINT 'Utente sa non trovato, utilizzo configurazione alternativa';
END
GO

-- Verifica la configurazione
SELECT 
    name AS Username,
    default_schema_name AS DefaultSchema
FROM sys.database_principals 
WHERE name = 'sa';
GO

-- Verifica che lo schema esista
SELECT name AS SchemaName 
FROM sys.schemas 
WHERE name = 'top-secret';
GO

PRINT 'Configurazione completata:';
PRINT '- Schema top-secret creato';
PRINT '- Permessi verificati per utente sa';
PRINT '- Schema top-secret impostato come predefinito per sa';
GO