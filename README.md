# trabalho-IaC

Infraestrutura como Código (IaC) com **Terraform** para provisionar uma instância **AWS EC2**, par de chaves, **Security Group** (SSH/HTTP) e _user data_ que prepara o host (Docker, chrony, utilitários, etc.).

## Visão geral
- **Provider:** AWS (`us-east-1`, ajustável)
- **Recursos:**
  - `aws_ami` (AMI Ubuntu dinâmica via filtros)
  - `aws_key_pair` (usa sua *public key*)
  - `aws_security_group` (abre portas 22 e 80)
  - `aws_instance` (EC2 com _user data_)
- **User data:** instala Docker e configurações básicas automaticamente.

## Estrutura
```
ami.tf
files/userdata.sh.tpl
instance.tf
key_pair.tf
outputs.tf
providers.tf
security_group.tf
templates.tf
variables.tf
version.tf
```

## Pré‑requisitos
- Conta AWS, **credenciais configuradas** (variáveis de ambiente, `~/.aws/credentials` ou outro método suportado pelo Terraform)
- **Terraform** >= 1.5
- **Chave pública SSH** acessível (ex.: `~/.ssh/id_rsa.pub`)

## Configuração de variáveis
As variáveis possuem _defaults_ pensados para testes. Ajuste conforme seu ambiente criando um arquivo `terraform.tfvars` (ou usando `-var`/`-var-file`). Exemplos:

```hcl
aws_region         = "us-east-1"
vpc_id             = "vpc-xxxxxxxxxxxxxxxxx"   # VPC onde o SG será criado
instance_type      = "t2.micro"
instance_name      = "vini-server"
key_name           = "vini-key"
public_key_path    = "~/.ssh/id_rsa.pub"

# AMI dinâmica (Ubuntu 22.04 LTS via Canonical)
ami_owners         = ["099720109477"]
ami_name_pattern   = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
```

> Dica: mantenha dados sensíveis fora do Git. Use `*.tfvars` no `.gitignore`.

## Como executar
```bash
# 1) Inicializa
terraform init

# 2) Visualiza plano
terraform plan

# 3) Aplica
terraform apply

# 4) Saída útil
terraform output
```

## _User data_ (resumo)
O script `files/userdata.sh.tpl`:
- instala pacotes básicos (jq, lvm2, pip, etc.);
- adiciona repositório oficial do Docker e instala o engine;
- coloca usuário `ubuntu` no grupo `docker`;
- escreve um `daemon.json` padrão e habilita serviços (`docker`, `chrony`).

## Limpeza
```bash
terraform destroy
```

## Boas práticas
- Utilize **módulos** quando o projeto crescer (VPC, sub-redes, EBS, etc.).
- Considere **backend remoto** (S3+DynamoDB) para `state` compartilhado.
- Aplique **tags** padronizadas e **políticas de segurança**/CIS.