PRINT '=== SQL Server init starting ===';
GO

/* -------------------------------------------------
   Ensure database exists
------------------------------------------------- */
IF DB_ID('demo') IS NULL
BEGIN
    PRINT 'Creating database [demo]';
    CREATE DATABASE demo;
END
ELSE
BEGIN
    PRINT 'Database [demo] already exists';
END
GO

USE demo;
GO

PRINT 'Using database [demo]';
GO

/* -------------------------------------------------
   Create greetings table if needed
------------------------------------------------- */
IF NOT EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE name = 'greetings'
)
BEGIN
    PRINT 'Creating table [greetings]';

    CREATE TABLE greetings (
        id INT PRIMARY KEY,
        message NVARCHAR(255) NOT NULL
    );
END
ELSE
BEGIN
    PRINT 'Table [greetings] already exists';
END
GO

/* -------------------------------------------------
   Seed data if missing
------------------------------------------------- */
IF NOT EXISTS (
    SELECT 1 FROM greetings WHERE id = 1
)
BEGIN
    PRINT 'Inserting seed greeting';
    INSERT INTO greetings (id, message)
    VALUES (1, 'Hello from Kubernetes + SQL Server!');
END
ELSE
BEGIN
    PRINT 'Seed greeting already exists';
END
GO

/* -------------------------------------------------
   Create or replace slow_greeting function
------------------------------------------------- */
PRINT 'Creating or updating dbo.slow_greeting function';
GO

CREATE OR ALTER FUNCTION dbo.slow_greeting (@seconds INT)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @delay CHAR(8);

    -- Build delay string safely: 00:00:SS
    SET @delay = CONCAT(
        '00:00:',
        RIGHT('0' + CAST(@seconds AS VARCHAR(2)), 2)
    );

    -- Artificial latency INSIDE the query
    WAITFOR DELAY @delay;

    DECLARE @msg NVARCHAR(255);
    SELECT @msg = message FROM greetings WHERE id = 1;

    RETURN @msg;
END;
GO

PRINT 'dbo.slow_greeting function ready';
GO

PRINT '=== SQL Server init completed successfully ===';
GO
