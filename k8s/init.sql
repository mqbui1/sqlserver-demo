/* =========================================================
   SQL Server Kubernetes Init Script (Idempotent)
   Visible logging via RAISERROR ... WITH NOWAIT
   ========================================================= */

RAISERROR ('=== SQL Server init starting ===', 10, 1) WITH NOWAIT;
GO

/* ---------------------------------------------------------
   Ensure database exists
--------------------------------------------------------- */
IF DB_ID('demo') IS NULL
BEGIN
    RAISERROR ('Creating database [demo]', 10, 1) WITH NOWAIT;
    CREATE DATABASE demo;
END
ELSE
BEGIN
    RAISERROR ('Database [demo] already exists', 10, 1) WITH NOWAIT;
END
GO

USE demo;
GO

RAISERROR ('Using database [demo]', 10, 1) WITH NOWAIT;
GO

/* ---------------------------------------------------------
   Create greetings table if needed
--------------------------------------------------------- */
IF NOT EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE name = 'greetings'
)
BEGIN
    RAISERROR ('Creating table [greetings]', 10, 1) WITH NOWAIT;

    CREATE TABLE greetings (
        id INT PRIMARY KEY,
        message NVARCHAR(255) NOT NULL
    );
END
ELSE
BEGIN
    RAISERROR ('Table [greetings] already exists', 10, 1) WITH NOWAIT;
END
GO

/* ---------------------------------------------------------
   Seed data if missing
--------------------------------------------------------- */
IF NOT EXISTS (
    SELECT 1 FROM greetings WHERE id = 1
)
BEGIN
    RAISERROR ('Inserting seed greeting', 10, 1) WITH NOWAIT;

    INSERT INTO greetings (id, message)
    VALUES (1, 'Hello from Kubernetes + SQL Server!');
END
ELSE
BEGIN
    RAISERROR ('Seed greeting already exists', 10, 1) WITH NOWAIT;
END
GO

/* ---------------------------------------------------------
   Create or replace slow_greeting stored procedure
--------------------------------------------------------- */
RAISERROR ('Creating or updating dbo.slow_greeting stored procedure', 10, 1) WITH NOWAIT;
GO

-- Drop if exists (safe for reruns)
IF OBJECT_ID('dbo.slow_greeting', 'P') IS NOT NULL
    DROP PROCEDURE dbo.slow_greeting;
GO

CREATE PROCEDURE dbo.slow_greeting
    @seconds INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @delay CHAR(8);
    SET @delay = RIGHT('00' + CAST(@seconds / 3600 AS VARCHAR(2)), 2) + ':' +
                 RIGHT('00' + CAST((@seconds % 3600) / 60 AS VARCHAR(2)), 2) + ':' +
                 RIGHT('00' + CAST(@seconds % 60 AS VARCHAR(2)), 2);

    WAITFOR DELAY @delay;

    SELECT 'Hello after ' + CAST(@seconds AS VARCHAR) + ' seconds' AS message;
END;
GO

-- Verification (fail job if missing)
IF OBJECT_ID('dbo.slow_greeting', 'P') IS NULL
BEGIN
    RAISERROR('ERROR: dbo.slow_greeting was not created!', 16, 1);
END;
GO
