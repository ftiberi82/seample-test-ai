-- Ensure schema [top-secret] exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'top-secret')
BEGIN
    EXEC('CREATE SCHEMA [top-secret] AUTHORIZATION [dbo]');
END;