-- Create database if it does not exist
IF DB_ID('demo') IS NULL
BEGIN
    CREATE DATABASE demo;
END;
GO

USE demo;
GO

-- Create greetings table if it does not exist
IF OBJECT_ID('dbo.greetings', 'U') IS NULL
BEGIN
    CREATE TABLE greetings (
        id INT PRIMARY KEY,
        message VARCHAR(255)
    );
END;
GO

-- Seed data (idempotent)
IF NOT EXISTS (SELECT 1 FROM greetings WHERE id = 1)
BEGIN
    INSERT INTO greetings (id, message)
    VALUES (1, 'Hello from Kubernetes + SQL Server!');
END;
GO

----------------------------------------------------------------
-- Artificial latency function (Option 2)
-- This keeps the delay INSIDE a single DB query
----------------------------------------------------------------
CREATE OR ALTER FUNCTION dbo.slow_greeting (@seconds INT)
RETURNS NVARCHAR(255)
AS
BEGIN
    -- Artificial latency inside the database query
    WAITFOR DELAY '00:00:' + RIGHT('0' + CAST(@seconds AS VARCHAR(2)), 2);

    DECLARE @msg NVARCHAR(255);

    SELECT @msg = message
    FROM greetings
    WHERE id = 1;

    RETURN @msg;
END;
GO
