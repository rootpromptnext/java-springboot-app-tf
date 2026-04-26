variable "public_key" {}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"
  public_key = var.public_key
}

# READ YOUR LOCAL SSH PUBLIC KEY
#resource "aws_key_pair" "jenkins_key" {
#  key_name   = "jenkins-key"
#  public_key = file("~/.ssh/id_rsa.pub")
#}

# SECURITY GROUP
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # restrict later
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0ec10929233384c7f" # Ubuntu (us-east-1)
  instance_type = "t3.medium"

  subnet_id = aws_subnet.public_1.id

  key_name               = aws_key_pair.jenkins_key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              set -xe

              # Log everything
              exec > /var/log/user-data.log 2>&1

              echo "Starting Jenkins setup..."

              # Update system
              apt update -y

              # Install base packages
              apt install -y openjdk-21-jdk curl gnupg unzip software-properties-common

              # Install Jenkins
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | tee \
                /usr/share/keyrings/jenkins-keyring.asc > /dev/null

              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                https://pkg.jenkins.io/debian-stable binary/ | tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null

              apt update -y
              apt install -y jenkins

              systemctl enable jenkins
              systemctl start jenkins

              # Install Docker
              apt install -y docker.io
              systemctl enable docker
              systemctl start docker

              usermod -aG docker ubuntu
              usermod -aG docker jenkins

              # Install AWS CLI v2
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install

              # Install kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              chmod +x kubectl
              sudo mv kubectl /usr/local/bin/

              # Permissions fix
              chmod 666 /var/run/docker.sock

              echo "Jenkins setup completed successfully!"
              EOF

  tags = {
    Name = "jenkins-server"
  }
}
