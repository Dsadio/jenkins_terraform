pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-west-3'
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
                sh """
                echo "⚙️ Configuration du serveur avec Ansible..."
                cat > inventory.ini << EOF
[web]
${EC2_IP} ansible_user=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF
                ansible-playbook -i inventory.ini ansible/apache.yml
                """
            }
        }

        stage('Test') {
            steps {
                sh """
                echo "🧪 Test du serveur web..."
                curl -I http://${EC2_IP} | head -n 1
                curl -s http://${EC2_IP} | grep "DevOps Projet"
                echo "✅ Test réussi !"
                """
            }
        }
    }

    post {
        success {
            echo "🎉 PIPELINE RÉUSSI !"
            echo "🌍 Serveur accessible sur : http://${env.EC2_IP}"
        }
        failure {
            echo "❌ PIPELINE ÉCHOUÉ !"
            error "Le pipeline a échoué. Vérifie les logs."
        }
        always {
            echo "🏁 Fin du pipeline"
        }
    }
}
