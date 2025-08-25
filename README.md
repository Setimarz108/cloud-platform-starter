# Cloud Platform Starter

> A cloud-native platform starter demonstrating infrastructure automation, containerization, and SRE practices on Azure using Terraform and Docker.

## � What This Project Demonstrates

This project demonstrates the core competencies expected in a Cloud Platform Engineer role:

- **Infrastructure as Code** with Terraform
- **Containerization** with Docker
- **Cloud Platform** deployment on Azure
- **Automation** scripts for deployment and monitoring
- **SRE Practices** including health checks and observability
- **Cost Optimization** within Azure free tier

## �️ Architecture

```
Internet → Container Instance → Node.js App
    ↓
Azure Container Registry
    ↓
Virtual Network + Security Groups
```

## � Quick Start

```bash
# Clone and setup
git clone <your-repo-url>
cd cloud-platform-starter

# Deploy infrastructure
cd terraform
terraform init
terraform apply

# Deploy application
cd ../scripts
./deploy.sh
```

## � Project Structure

- `app/` - Node.js application with health checks
- `terraform/` - Infrastructure as Code definitions
- `scripts/` - Deployment and operational automation
- `docs/` - Architecture and operational documentation

## � Cost Estimation

Designed to stay within Azure free tier limits:
- Container Instances: ~$5-10/month
- Container Registry: ~$5/month
- Virtual Network: Free

## � Learning Outcomes

This project teaches practical cloud platform engineering skills:
- Terraform state management and resource planning
- Docker containerization best practices
- Azure networking and security configuration
- Automated deployment workflows
- SRE monitoring and troubleshooting

---

**Status**: � In Development

**Next Steps**: Building the application foundation
