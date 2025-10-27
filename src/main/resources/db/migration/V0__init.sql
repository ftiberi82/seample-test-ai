
/* ------------------ ORGANIZATION_TYPE ------------------ */
IF NOT EXISTS (SELECT 1
FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE t.name = N'ORGANIZATION_TYPE' AND s.name = N'${schema}')
BEGIN
    EXEC(N'
    CREATE TABLE ${schema}.[ORGANIZATION_TYPE] (
        id UNIQUEIDENTIFIER NOT NULL    CONSTRAINT PK_ORGANIZATION_TYPE PRIMARY KEY DEFAULT NEWID(),
        [order] INT NOT NULL UNIQUE,
        name VARCHAR(255) NOT NULL,
        description VARCHAR(1024),

        /* Auditing */
        sys_created_by NVARCHAR(128) NOT NULL
            CONSTRAINT DF_ORG_TYPE_sys_created_by DEFAULT COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME()),
        sys_created_on DATETIME2(7) NOT NULL
            CONSTRAINT DF_ORG_TYPE_sys_created_on DEFAULT SYSUTCDATETIME(),
        sys_updated_by NVARCHAR(128) NULL,
        sys_updated_on DATETIME2(7) NULL,
        sys_rowversion ROWVERSION,
        sys_valid_from DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
        sys_valid_to   DATETIME2(7) GENERATED ALWAYS AS ROW END   NOT NULL,
        PERIOD FOR SYSTEM_TIME (sys_valid_from, sys_valid_to)
    )
    WITH
    (
        SYSTEM_VERSIONING = ON (
            HISTORY_TABLE = ${schema}.[ORGANIZATION_TYPE_HISTORY],
            DATA_CONSISTENCY_CHECK = ON
        )
    );
    ');
END
GO
IF NOT EXISTS (SELECT 1
FROM sys.triggers
WHERE name = N'TR_ORGANIZATION_TYPE_SetUpdated' AND parent_id = OBJECT_ID(N'${schema}.[ORGANIZATION_TYPE]'))
BEGIN
    EXEC(N'
    CREATE TRIGGER ${schema}.TR_ORGANIZATION_TYPE_SetUpdated
    ON ${schema}.[ORGANIZATION_TYPE]
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        IF TRIGGER_NESTLEVEL() > 1 RETURN;

        UPDATE t
        SET
            sys_updated_on = SYSUTCDATETIME(),
            sys_updated_by = COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME())
        FROM ${schema}.[ORGANIZATION_TYPE] t
        INNER JOIN inserted i ON i.id = t.id;
    END
    ');
END
GO

/* ------------------ ORGANIZATION ------------------ */
IF NOT EXISTS (SELECT 1
FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE t.name = N'ORGANIZATION' AND s.name = N'${schema}')
BEGIN
    EXEC(N'
    CREATE TABLE ${schema}.[ORGANIZATION] (
        id UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_ORGANIZATION PRIMARY KEY DEFAULT NEWID(),
        name VARCHAR(255) NOT NULL      CONSTRAINT UQ_ORGANIZATION_name UNIQUE,
        description VARCHAR(1024),
        level_id UNIQUEIDENTIFIER NOT NULL,
        pid UNIQUEIDENTIFIER NULL,

        CONSTRAINT FK_ORGANIZATION_LEVEL FOREIGN KEY (level_id)
            REFERENCES ${schema}.[ORGANIZATION_TYPE] ON DELETE NO ACTION,
        CONSTRAINT FK_ORGANIZATION_PARENT FOREIGN KEY (pid)
            REFERENCES ${schema}.[ORGANIZATION] ON DELETE NO ACTION,

        /* Auditing */
        sys_created_by NVARCHAR(128) NOT NULL
            CONSTRAINT DF_ORGANIZATION_sys_created_by DEFAULT COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME()),
        sys_created_on DATETIME2(7) NOT NULL
            CONSTRAINT DF_ORGANIZATION_sys_created_on DEFAULT SYSUTCDATETIME(),
        sys_updated_by NVARCHAR(128) NULL,
        sys_updated_on DATETIME2(7) NULL,
        sys_rowversion ROWVERSION,
        sys_valid_from DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
        sys_valid_to   DATETIME2(7) GENERATED ALWAYS AS ROW END   NOT NULL,
        PERIOD FOR SYSTEM_TIME (sys_valid_from, sys_valid_to)
    )
    WITH
    (
        SYSTEM_VERSIONING = ON (
            HISTORY_TABLE = ${schema}.[ORGANIZATION_HISTORY],
            DATA_CONSISTENCY_CHECK = ON
        )
    );
    ');
END
GO

IF NOT EXISTS (SELECT 1
FROM sys.triggers
WHERE name = N'TR_ORGANIZATION_SetUpdated' AND parent_id = OBJECT_ID(N'${schema}.[ORGANIZATION]'))
BEGIN
    EXEC(N'
    CREATE TRIGGER ${schema}.TR_ORGANIZATION_SetUpdated
    ON ${schema}.[ORGANIZATION]
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        IF TRIGGER_NESTLEVEL() > 1 RETURN;

        UPDATE t
        SET
            sys_updated_on = SYSUTCDATETIME(),
            sys_updated_by = COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME())
        FROM ${schema}.[ORGANIZATION] t
        INNER JOIN inserted i ON i.id = t.id;
    END
    ');
END
GO

-- OFFICE entity removed in new model

/* ------------------ ACCOUNT ------------------ */
IF NOT EXISTS (SELECT 1
FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE t.name = N'ACCOUNT' AND s.name = N'${schema}')
BEGIN
    EXEC(N'
    CREATE TABLE ${schema}.[ACCOUNT] (
        id UNIQUEIDENTIFIER NOT NULL    CONSTRAINT PK_ACCOUNT PRIMARY KEY DEFAULT NEWID(),
        username VARCHAR(255) NOT NULL  CONSTRAINT UQ_ACCOUNT_username UNIQUE,
        active BIT NOT NULL             CONSTRAINT DF_ACCOUNT_active DEFAULT (1),

        /* Auditing */
        sys_created_by NVARCHAR(128) NOT NULL
            CONSTRAINT DF_ACCOUNT_sys_created_by DEFAULT COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME()),
        sys_created_on DATETIME2(7) NOT NULL
            CONSTRAINT DF_ACCOUNT_sys_created_on DEFAULT SYSUTCDATETIME(),
        sys_updated_by NVARCHAR(128) NULL,
        sys_updated_on DATETIME2(7) NULL,
        sys_rowversion ROWVERSION,
        sys_valid_from DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
        sys_valid_to   DATETIME2(7) GENERATED ALWAYS AS ROW END   NOT NULL,
        PERIOD FOR SYSTEM_TIME (sys_valid_from, sys_valid_to)
    )
    WITH
    (
        SYSTEM_VERSIONING = ON (
            HISTORY_TABLE = ${schema}.[ACCOUNT_HISTORY],
            DATA_CONSISTENCY_CHECK = ON
        )
    );
    ');
END
GO

IF NOT EXISTS (SELECT 1
FROM sys.triggers
WHERE name = N'TR_ACCOUNT_SetUpdated' AND parent_id = OBJECT_ID(N'${schema}.[ACCOUNT]'))
BEGIN
    EXEC(N'
    CREATE TRIGGER ${schema}.TR_ACCOUNT_SetUpdated
    ON ${schema}.[ACCOUNT]
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        IF TRIGGER_NESTLEVEL() > 1 RETURN;

        UPDATE t
        SET
            sys_updated_on = SYSUTCDATETIME(),
            sys_updated_by = COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME())
        FROM ${schema}.[ACCOUNT] t
        INNER JOIN inserted i ON i.id = t.id;
    END
    ');
END
GO

/* ------------------ ROLE ------------------ */
IF NOT EXISTS (SELECT 1
FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE t.name = N'ROLE' AND s.name = N'${schema}')
BEGIN
    EXEC(N'
    CREATE TABLE ${schema}.[ROLE] (
        id UNIQUEIDENTIFIER NOT NULL    CONSTRAINT PK_ROLE PRIMARY KEY DEFAULT NEWID(),
        name VARCHAR(255) NOT NULL      CONSTRAINT UQ_ROLE_name UNIQUE,
        description VARCHAR(1024),

        /* Auditing */
        sys_created_by NVARCHAR(128) NOT NULL
            CONSTRAINT DF_ROLE_sys_created_by DEFAULT COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME()),
        sys_created_on DATETIME2(7) NOT NULL
            CONSTRAINT DF_ROLE_sys_created_on DEFAULT SYSUTCDATETIME(),
        sys_updated_by NVARCHAR(128) NULL,
        sys_updated_on DATETIME2(7) NULL,
        sys_rowversion ROWVERSION,
        sys_valid_from DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
        sys_valid_to   DATETIME2(7) GENERATED ALWAYS AS ROW END   NOT NULL,
        PERIOD FOR SYSTEM_TIME (sys_valid_from, sys_valid_to)
    )
    WITH
    (
        SYSTEM_VERSIONING = ON (
            HISTORY_TABLE = ${schema}.[ROLE_HISTORY],
            DATA_CONSISTENCY_CHECK = ON
        )
    );
    ');
END
GO

IF NOT EXISTS (SELECT 1
FROM sys.triggers
WHERE name = N'TR_ROLE_SetUpdated' AND parent_id = OBJECT_ID(N'${schema}.[ROLE]'))
BEGIN
    EXEC(N'
    CREATE TRIGGER ${schema}.TR_ROLE_SetUpdated
    ON ${schema}.[ROLE]
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        IF TRIGGER_NESTLEVEL() > 1 RETURN;

        UPDATE t
        SET
            sys_updated_on = SYSUTCDATETIME(),
            sys_updated_by = COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME())
        FROM ${schema}.[ROLE] t
        INNER JOIN inserted i ON i.id = t.id;
    END
    ');
END
GO

/* ------------------ PERMISSION ------------------ */
IF NOT EXISTS (SELECT 1
FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE t.name = N'PERMISSION' AND s.name = N'${schema}')
BEGIN
    EXEC(N'
    CREATE TABLE ${schema}.[PERMISSION] (
        id UNIQUEIDENTIFIER NOT NULL    CONSTRAINT PK_PERMISSION PRIMARY KEY DEFAULT NEWID(),
        name VARCHAR(255) NOT NULL      CONSTRAINT UQ_PERMISSION_name UNIQUE,
        description VARCHAR(1024),

        /* Auditing */
        sys_created_by NVARCHAR(128) NOT NULL
            CONSTRAINT DF_PERMISSION_sys_created_by DEFAULT COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME()),
        sys_created_on DATETIME2(7) NOT NULL
            CONSTRAINT DF_PERMISSION_sys_created_on DEFAULT SYSUTCDATETIME(),
        sys_updated_by NVARCHAR(128) NULL,
        sys_updated_on DATETIME2(7) NULL,
        sys_rowversion ROWVERSION,
        sys_valid_from DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
        sys_valid_to   DATETIME2(7) GENERATED ALWAYS AS ROW END   NOT NULL,
        PERIOD FOR SYSTEM_TIME (sys_valid_from, sys_valid_to)
    )
    WITH
    (
        SYSTEM_VERSIONING = ON (
            HISTORY_TABLE = ${schema}.[PERMISSION_HISTORY],
            DATA_CONSISTENCY_CHECK = ON
        )
    );
    ');
END
GO

IF NOT EXISTS (SELECT 1
FROM sys.triggers
WHERE name = N'TR_PERMISSION_SetUpdated' AND parent_id = OBJECT_ID(N'${schema}.[PERMISSION]'))
BEGIN
    EXEC(N'
    CREATE TRIGGER ${schema}.TR_PERMISSION_SetUpdated
    ON ${schema}.[PERMISSION]
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        IF TRIGGER_NESTLEVEL() > 1 RETURN;

        UPDATE t
        SET
            sys_updated_on = SYSUTCDATETIME(),
            sys_updated_by = COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME())
        FROM ${schema}.[PERMISSION] t
        INNER JOIN inserted i ON i.id = t.id;
    END
    ');
END
GO

/* ------------------ ROLE_PERMISSION ------------------ */
IF NOT EXISTS (SELECT 1
FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE t.name = N'ROLE_PERMISSION' AND s.name = N'${schema}')
BEGIN
    EXEC(N'
    CREATE TABLE ${schema}.[ROLE_PERMISSION] (
        role_id UNIQUEIDENTIFIER NOT NULL,
        permission_id UNIQUEIDENTIFIER NOT NULL,

        CONSTRAINT PK_ROLE_PERMISSION PRIMARY KEY (role_id, permission_id),

        CONSTRAINT FK_ROLE_PERMISSION_ROLE FOREIGN KEY (role_id)
            REFERENCES ${schema}.[ROLE] ON DELETE CASCADE,
        CONSTRAINT FK_ROLE_PERMISSION_PERMISSION FOREIGN KEY (permission_id)
            REFERENCES ${schema}.[PERMISSION] ON DELETE CASCADE,

        /* Auditing */
        sys_created_by NVARCHAR(128) NOT NULL
            CONSTRAINT DF_ROLE_PERMISSION_sys_created_by DEFAULT COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME()),
        sys_created_on DATETIME2(7) NOT NULL
            CONSTRAINT DF_ROLE_PERMISSION_sys_created_on DEFAULT SYSUTCDATETIME(),
        sys_updated_by NVARCHAR(128) NULL,
        sys_updated_on DATETIME2(7) NULL,
        sys_rowversion ROWVERSION,
        sys_valid_from DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
        sys_valid_to   DATETIME2(7) GENERATED ALWAYS AS ROW END   NOT NULL,
        PERIOD FOR SYSTEM_TIME (sys_valid_from, sys_valid_to)
    )
    WITH
    (
        SYSTEM_VERSIONING = ON (
            HISTORY_TABLE = ${schema}.[ROLE_PERMISSION_HISTORY],
            DATA_CONSISTENCY_CHECK = ON
        )
    );
    ');
END
GO

IF NOT EXISTS (SELECT 1
FROM sys.triggers
WHERE name = N'TR_ROLE_PERMISSION_SetUpdated' AND parent_id = OBJECT_ID(N'${schema}.[ROLE_PERMISSION]'))
BEGIN
    EXEC(N'
    CREATE TRIGGER ${schema}.TR_ROLE_PERMISSION_SetUpdated
    ON ${schema}.[ROLE_PERMISSION]
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        IF TRIGGER_NESTLEVEL() > 1 RETURN;

        UPDATE t
        SET
            sys_updated_on = SYSUTCDATETIME(),
            sys_updated_by = COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME())
        FROM ${schema}.[ROLE_PERMISSION] t
        INNER JOIN inserted i
            ON i.role_id = t.role_id
           AND i.permission_id = t.permission_id;
    END
    ');
END
GO

/* ------------------ ACCOUNT_ROLE_ASSIGNMENT ------------------ */
IF NOT EXISTS (SELECT 1
FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE t.name = N'ACCOUNT_ROLE_ASSIGNMENT' AND s.name = N'${schema}')
BEGIN
    EXEC(N'
    CREATE TABLE ${schema}.[ACCOUNT_ROLE_ASSIGNMENT] (
        id UNIQUEIDENTIFIER NOT NULL            CONSTRAINT PK_ARA PRIMARY KEY DEFAULT NEWID(),
        account_id UNIQUEIDENTIFIER NOT NULL,
        role_id UNIQUEIDENTIFIER NOT NULL,
        organization_id UNIQUEIDENTIFIER NULL,
        active BIT NOT NULL                     CONSTRAINT DF_ARA_active DEFAULT (1),
        last_login DATETIME2(7) NULL,

        CONSTRAINT FK_ARA_ACCOUNT FOREIGN KEY (account_id)
            REFERENCES ${schema}.[ACCOUNT] ON DELETE NO ACTION,
        CONSTRAINT FK_ARA_ROLE FOREIGN KEY (role_id)
            REFERENCES ${schema}.[ROLE] ON DELETE NO ACTION,
        CONSTRAINT FK_ARA_ORGANIZATION FOREIGN KEY (organization_id)
            REFERENCES ${schema}.[ORGANIZATION] ON DELETE NO ACTION,

        /* Auditing */
        sys_created_by NVARCHAR(128) NOT NULL
            CONSTRAINT DF_ARA_sys_created_by DEFAULT COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME()),
        sys_created_on DATETIME2(7) NOT NULL
            CONSTRAINT DF_ARA_sys_created_on DEFAULT SYSUTCDATETIME(),
        sys_updated_by NVARCHAR(128) NULL,
        sys_updated_on DATETIME2(7) NULL,
        sys_rowversion ROWVERSION,
        sys_valid_from DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
        sys_valid_to   DATETIME2(7) GENERATED ALWAYS AS ROW END   NOT NULL,
        PERIOD FOR SYSTEM_TIME (sys_valid_from, sys_valid_to)
    )
    WITH
    (
        SYSTEM_VERSIONING = ON (
            HISTORY_TABLE = ${schema}.[ACCOUNT_ROLE_ASSIGNMENT_HISTORY],
            DATA_CONSISTENCY_CHECK = ON
        )
    );
    ');
END
GO

IF NOT EXISTS (SELECT 1
FROM sys.triggers
WHERE name = N'TR_ARA_SetUpdated' AND parent_id = OBJECT_ID(N'${schema}.[ACCOUNT_ROLE_ASSIGNMENT]'))
BEGIN
    EXEC(N'
    CREATE TRIGGER ${schema}.TR_ARA_SetUpdated
    ON ${schema}.[ACCOUNT_ROLE_ASSIGNMENT]
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        IF TRIGGER_NESTLEVEL() > 1 RETURN;

        UPDATE t
        SET
            sys_updated_on = SYSUTCDATETIME(),
            sys_updated_by = COALESCE(CONVERT(NVARCHAR(128), SESSION_CONTEXT(N''app_user'')), SUSER_SNAME())
        FROM ${schema}.[ACCOUNT_ROLE_ASSIGNMENT] t
        INNER JOIN inserted i ON i.id = t.id;
    END
    ');
END
GO