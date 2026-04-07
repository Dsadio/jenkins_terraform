pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "📦 Code récupéré depuis GitHub"
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh '''
                    echo "🔧 Initialisation de Terraform..."
                    terraform init
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh '''
                    echo "📋 Planification des ressources AWS..."
                    terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh '''
                    echo "🚀 Déploiement de l'infrastructure sur AWS..."
                    terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Get EC2 IP') {
            steps {
                dir('terraform') {
                    script {
                        def ip = sh(script: "terraform output -raw public_ip", returnStdout: true).trim()
                        env.EC2_IP = ip
                        echo "🌐 Instance EC2 déployée à l'IP : ${env.EC2_IP}"
                    }
                }
            }
        }

        stage('Ansible Deploy') {
            steps {
                sh '''
                echo "⚙️ Configuration du serveur avec Ansible..."
                cat > inventory.ini << EOF
[web]
${EC2_IP} ansible_user=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
