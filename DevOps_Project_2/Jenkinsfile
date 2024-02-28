
pipeline {
    agent any

    parameters {
        choice(name: 'TERRAFORM_ACTION', choices: ['apply', 'destroy'], description: 'Select Terraform Action')
        string(name: 'SERVER_NAME', defaultValue: 'your_server_name_here', description: 'Enter Server Name')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[url: 'https://github.com/Gangulaprathapreddy/DevOps_Project.git']]])
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    dir('DevOps_Project_2/Terraform') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Apply/Destroy') {
            steps {
                script {
                    dir('DevOps_Project_2/Terraform') {
                        sh """
                            export TF_VAR_name=${params.SERVER_NAME}
                            terraform init
                            if [ "${params.TERRAFORM_ACTION}" = "apply" ]; then
                                terraform apply -auto-approve
                            elif [ "${params.TERRAFORM_ACTION}" = "destroy" ]; then
                                terraform destroy -auto-approve
                            else
                                echo "Invalid action provided. Use 'apply' or 'destroy'."
                            fi
                        """
                    }
                }
            }
        }
    }
}
