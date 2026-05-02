pipeline {
    agent any

    environment {
        IMAGE_NAME = "virtualrcoder/python-ci-app"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/VirtualRcoder/jenkins-cicd-learning.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:latest .
                '''
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                docker push $IMAGE_NAME:latest
                '''
            }
        }

        stage('Deploy (Run Container)') {
            steps {
                sh '''
                docker stop python-ci-container || true
                docker rm python-ci-container || true

                docker run -d \
                  --name python-ci-container \
                  -p 5000:5000 \
                  $IMAGE_NAME:latest
                '''
            }
        }
    }

    post {
        success {
            echo '🚀 Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
