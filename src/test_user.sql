
:setvar SQLCMDMAXVARTYPEWIDTH 30
:setvar SQLCMDMAXFIXEDTYPEWIDTH 30

PRINT("Show User AND Auth_Scheme Information");
PRINT("")
SELECT SUSER_NAME() domain_user, net_transport, auth_scheme 
  FROM sys.dm_exec_connections 
 WHERE session_id = @@SPID;
GO

PRINT("Execute SQL - SELECT * FROM test_db1.dbo.test_table1");
PRINT("")
SELECT * FROM test_db1.dbo.test_table1;
GO

PRINT("Execute SQL - UPDATE test_db1.dbo.test_table1 SET val='b' WHERE id=2");
PRINT("")
UPDATE test_db1.dbo.test_table1 SET val='b' WHERE id=2;
GO