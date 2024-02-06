#!/bin/bash

BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}### Retrieve the primary user name and password for the RDS for SQL Server instance from Secrets Manager."
echo -e "${NC}"

RDS_SECRET=$(aws secretsmanager get-secret-value --secret-id "rdsktest/rds" | jq -r '.SecretString')
RDS_MASTER_USERNAME=$(echo $RDS_SECRET | jq -r '.username')
RDS_MASTER_PASSWORD=$(echo $RDS_SECRET | jq -r '.password')

echo -e "${BLUE}### Download the SQL file 4-create-db-login-table.sql from the AWS Blogs public artifacts bucket. The SQL file will create the database, database table, and Windows logins."
echo -e "${NC}"

wget -O 4-create-db-login-table.sql https://aws-blogs-artifacts-public.s3.amazonaws.com/artifacts/DBBLOG-3532/4-create-db-login-table.sql

echo -e "${BLUE}### Run the SQL file using sqlcmd with the Amazon RDS primary user name and password."
echo -e "${NC}"

sqlcmd -S rds-instance1.rdsktest.awsexample.org -C -U $RDS_MASTER_USERNAME -P $RDS_MASTER_PASSWORD -i 4-create-db-login-table.sql
