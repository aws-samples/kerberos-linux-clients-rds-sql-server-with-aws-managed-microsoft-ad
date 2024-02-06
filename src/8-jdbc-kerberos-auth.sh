#!/bin/bash

BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}### Download the SQL Server JDBC driver, mssql-jdbc-12.4.1.jre11.jar, from the Microsoft official source."
echo -e "${NC}"

wget "https://go.microsoft.com/fwlink/?linkid=2245438&clcid=0x409" -O /tmp/sqljdbc_12.4.1.0_enu.zip
rm -rf /tmp/sqljdbc_12.4
unzip /tmp/sqljdbc_12.4.1.0_enu.zip -d /tmp
cp /tmp/sqljdbc_12.4/enu/jars/mssql-jdbc-12.4.1.jre11.jar .
echo ""


echo -e "${BLUE}### Download TestJdbc.java from the AWS blogs public artifacts S3 bucket and compile it accordingly."
echo -e "${NC}"

wget -O TestJdbc.java https://aws-blogs-artifacts-public.s3.amazonaws.com/artifacts/DBBLOG-3532/TestJdbc.java
javac -cp mssql-jdbc-12.4.1.jre11.jar TestJdbc.java



echo -e "${BLUE}### Run Java class TestJdbc and provide the JDBC connection string, and specifying the SQL query to execute. Ensure that the Kerberos TGT is present by running klist in the session."
echo -e "${NC}"

# Please note that to enable Kerberos authentication for SQL Server, you have to include "integratedSecurity=true;authenticationScheme=JavaKerberos" in the JDBC connection string.
JDBC_CONN_STRING="jdbc:sqlserver://rds-instance1.rdsktest.awsexample.org;integratedSecurity=true;authenticationScheme=JavaKerberos;trustServerCertificate=true"
SQL="SELECT SUSER_NAME() domain_user, net_transport, auth_scheme FROM sys.dm_exec_connections WHERE session_id = @@SPID"
klist
java -cp .:mssql-jdbc-12.4.1.jre11.jar TestJdbc "$JDBC_CONN_STRING" "$SQL"
