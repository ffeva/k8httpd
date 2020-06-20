pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "dd-dockerreg.academy.grads.al-labs.co.uk:5000/httpd"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh 'sudo service docker stop'
                sh 'sudo service docker start'
            }
        }
        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.inside {
                        sh 'echo Hello, World!'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://dd-dockerreg.academy.grads.al-labs.co.uk:5000') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToProduction') {
            when {
                branch 'master'
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'Deploy.yml',
                    enableConfigSubstitution: true
                )
            }
        }
    }
}
