#!/bin/bash

BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}### Print the DNS servers configured for the Linux instance, which should point to the AWS Managed Microsoft AD."
echo -e "${NC}"

systemd-resolve --status | grep -A 3 "DNS Servers"
echo -e "${NC}"


echo -e "${BLUE}### Install the krb5-user package, with a default configuration file at /etc/krb5.conf."
echo -e "${NC}"

sudo DEBIAN_FRONTEND=noninteractive apt install -y krb5-user
echo

echo -e "${BLUE}### Download the sample file krb5.conf.sample from the AWS Blogs public artifacts S3 bucket and override the /etc/krb5.conf file. The sample /etc/krb5.conf file will reference rdsktest.awsexample.org as the KDC."
echo -e "${NC}"

wget -O krb5.conf.sample https://aws-blogs-artifacts-public.s3.amazonaws.com/artifacts/DBBLOG-3532/krb5.conf.sample
sudo mv /etc/krb5.conf /etc/krb5.conf.bak
sudo mv ./krb5.conf.sample /etc/krb5.conf

echo -e "${BLUE}### Install sqlcmd tool, by installing the mssql-tools18 package and its dependent package, unixodbc-dev."
echo -e "${NC}"

curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt update
sudo ACCEPT_EULA=Y apt-get -y install mssql-tools18 unixodbc-dev

sudo ln -s /opt/mssql-tools18/bin/sqlcmd /usr/local/bin/sqlcmd
sudo ln -s /opt/mssql-tools18/bin/bcp /usr/local/bin/bcp