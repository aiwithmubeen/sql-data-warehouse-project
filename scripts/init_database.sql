/*
===============================================================================
Create Database and Schemas
===============================================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking
    if it already exists.

    If the database exists, it is dropped and recreated. Additionally,
    the script sets up three schemas within the database:
    'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWarehouse' database
    if it exists.

    All existing data in the database will be permanently deleted.
    Proceed with caution and ensure you have proper backups before
    running this script.
===============================================================================
*/

USE master;
GO

-- Drop the database if it already exists
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse'
)
BEGIN
    -- Disconnect active users and roll back uncommitted transactions
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    -- Delete the existing database
    DROP DATABASE DataWarehouse;
END
GO

-- Create a new DataWarehouse database
CREATE DATABASE DataWarehouse;
GO

-- Switch to the DataWarehouse database
USE DataWarehouse;
GO

-- Create schemas for the Medallion Architecture

-- Bronze Layer: Raw data from source systems
CREATE SCHEMA bronze;
GO

-- Silver Layer: Cleaned and transformed data
CREATE SCHEMA silver;
GO

-- Gold Layer: Business-ready data for reporting and analytics
CREATE SCHEMA gold;
GO
