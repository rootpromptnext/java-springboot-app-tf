### Manual install aws and terraform
Install aws cli
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt update && sudo apt -y install unzip
unzip awscliv2.zip
sudo ./aws/install
```
Install terraform
```
#!/bin/bash
TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

### Manual Bucket Creation (AWS CLI)

Create the bucket immediately via aws cli
```
aws s3 mb s3://aws-iac-19159-tf
```

### Create ssh key pairs
```
ssh-keygen -t rsa
``

### Add github secrets
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```
