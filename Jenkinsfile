pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME_HTTPD = "dd/httpd"
        DOCKER_IMAGE_NAME_PC = "dd/pc"
        DOCKER_IMAGE_NAME_WP = "dd/wp"
        CANARY_REPLICAS = 0
    }
    stages {
        stage('httpd Build') {
            steps {
                echo 'Running HTTPD build automation'
            }
        }
        stage('Build HTTPD Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    dockerImage = docker.build(DOCKER_IMAGE_NAME_HTTPD)
                }
            }
        }
        stage('Push HTTPD Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://dd-dockerreg.academy.grads.al-labs.co.uk:5000') {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('HTTPD CanaryDeploy') {
            when {
                branch 'master'
            }
            environment {
                CANARY_REPLICAS = 1
            }
            steps {
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: '/httpd/Deploy-canary.yml',
                    enableConfigSubstitution: true
                )
            }
        }
        stage('HTTPD SmokeTest') {
            when {
                branch 'master'
            }
            steps {
                script {
                    sleep (time: 5)
                    def response = httpRequest (
                        url: "http://$KUBE_MASTER_IP:8081/",
                        timeout: 30
                    )
                    if (response.status != 200) {
                        error("Smoke test against canary deployment failed.")
                    }
                }
            }
        }
        stage('HTTPD DeployToProduction') {
            when {
                branch 'master'
            }
            steps {
                milestone(1)
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: '/httpd/Deploy.yml',
                    enableConfigSubstitution: true
                )
            }
        }
    }
    stages {
        stage('PC Build') {
            steps {
                echo 'Running PC build automation'
            }
        }
        stage('Build PC Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    dockerImage = docker.build(DOCKER_IMAGE_NAME_PC)
                }
            }
        }
        stage('Push PC Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://dd-dockerreg.academy.grads.al-labs.co.uk:5000') {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('PC CanaryDeploy') {
            when {
                branch 'master'
            }
            environment {
                CANARY_REPLICAS = 1
            }
            steps {
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: '/pc/Deploy-canary.yml',
                    enableConfigSubstitution: true
                )
            }
        }
        stage('PC SmokeTest') {
            when {
                branch 'master'
            }
            steps {
                script {
                    sleep (time: 5)
                    def response = httpRequest (
                        url: "http://$KUBE_MASTER_IP:8081/",
                        timeout: 30
                    )
                    if (response.status != 200) {
                        error("Smoke test against canary deployment failed.")
                    }
                }
            }
        }
        stage('PC DeployToProduction') {
            when {
                branch 'master'
            }
            steps {
                milestone(1)
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: '/pc/Deploy.yml',
                    enableConfigSubstitution: true
                )
            }
        }
    }
    stages {
        stage('WP Build') {
            steps {
                echo 'Running HTTPD build automation'
            }
        }
        stage('Build WP Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    dockerImage = docker.build(DOCKER_IMAGE_NAME_WP)
                }
            }
        }
        stage('Push WP Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://dd-dockerreg.academy.grads.al-labs.co.uk:5000') {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('WP CanaryDeploy') {
            when {
                branch 'master'
            }
            environment {
                CANARY_REPLICAS = 1
            }
            steps {
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: '/wp/Deploy-canary.yml',
                    enableConfigSubstitution: true
                )
            }
        }
        stage('WP SmokeTest') {
            when {
                branch 'master'
            }
            steps {
                script {
                    sleep (time: 5)
                    def response = httpRequest (
                        url: "http://$KUBE_MASTER_IP:8081/",
                        timeout: 30
                    )
                    if (response.status != 200) {
                        error("Smoke test against canary deployment failed.")
                    }
                }
            }
        }
        stage('WP DeployToProduction') {
            when {
                branch 'master'
            }
            steps {
                milestone(1)
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: '/wp/Deploy.yml',
                    enableConfigSubstitution: true
                )
            }
        }
    }

  post {
      cleanup {
          kubernetesDeploy (
              kubeconfigId: 'kubeconfig',
              configs: '/httpd/Deploy-canary.yml',
              enableConfigSubstitution: true
          )
      }
      cleanup {
          kubernetesDeploy (
              kubeconfigId: 'kubeconfig',
              configs: '/pc/Deploy-canary.yml',
              enableConfigSubstitution: true
          )
      }
      cleanup {
          kubernetesDeploy (
              kubeconfigId: 'kubeconfig',
              configs: '/wp/Deploy-canary.yml',
              enableConfigSubstitution: true
          )
      }
  }
}
