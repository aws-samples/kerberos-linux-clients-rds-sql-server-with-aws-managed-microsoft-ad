## Configure Kerberos authentication in Linux clients for Amazon RDS for SQL Server with AWS Managed Microsoft AD

Amazon Relational Database Service (Amazon RDS) is a managed database service that simplifies the setup, operation and scaling of popular database engines, including Microsoft SQL Server. In on-premises environments, Microsoft SQL Server is typically configured to work with Microsoft Active Directory for NTLM / Kerberos authentication. AWS offer managed services for both components, making it straightforward to migrate these workloads to the cloud while maintaining compatibility with your existing infrastructure. In this post, we present a solution that utilizes Amazon Relational Database Service (Amazon RDS) for SQL Server in conjunction with AWS Directory Service for Microsoft Active Directory to enable client authentication via the Kerberos protocol.

In this repo, scripts are used for configuring Amazon RDS for SQL Server using AWS Directory Service for Microsoft AD, showcasing Kerberos authentication on Linux client machines.
Refer to the blog post for detailed guide.


## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

