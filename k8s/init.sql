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
      Create or replace slow_greeting function
   --------------------------------------------------------- */
   RAISERROR ('Creating or updating dbo.slow_greeting function', 10, 1) WITH NOWAIT;
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
   
   RAISERROR ('dbo.slow_greeting function ready', 10, 1) WITH NOWAIT;
   GO
   
   /* ---------------------------------------------------------
      Final validation
   --------------------------------------------------------- */
   IF OBJECT_ID('dbo.slow_greeting') IS NULL
   BEGIN
       RAISERROR ('ERROR: dbo.slow_greeting was not created!', 16, 1);
   END
   ELSE
   BEGIN
       RAISERROR ('Validation successful: dbo.slow_greeting exists', 10, 1) WITH NOWAIT;
   END
   GO
   
   RAISERROR ('=== SQL Server init completed successfully ===', 10, 1) WITH NOWAIT;
   GO
