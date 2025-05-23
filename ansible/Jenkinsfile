pipeline {
    agent any
    environment {
        TF_DIR = 'terraform'
        ANSIBLE_DIR = 'ansible'
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
        stage('Fetch EC2 IP') {
            steps {
                script {
                    def output = sh(script: "cd ${TF_DIR} && terraform output -raw public_ip", returnStdout: true).trim()
                    env.EC2_IP = output
                }
            }
        }
        stage('Create Inventory') {
            steps {
                writeFile file: "${ANSIBLE_DIR}/inventory.ini", text: "[ec2]\n${env.EC2_IP} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/terraform.pem"
            }
        }
        stage('Run Ansible') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sh 'ansible-playbook -i inventory.ini playbook.yml'
                }
            }
        }
    }
}
