pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_REGION            = 'us-east-1'  // update if you're using another region
        TF_DIR                = 'terraform'
        ANSIBLE_DIR           = 'ansible'
    }

    stages {

        stage('Terraform Init & Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Get EC2 Public IP') {
            steps {
                script {
                    def output = sh(script: "cd ${TF_DIR} && terraform output -raw public_ip", returnStdout: true).trim()
                    env.EC2_IP = output
                }
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                writeFile file: "${ANSIBLE_DIR}/inventory.ini", text: "[ec2]\n${env.EC2_IP} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/terraform.pem"
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sh 'ansible-playbook -i inventory.ini playbook.yml'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution complete.'
        }
    }
}
