pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/VirtualRcoder/jenkins-cicd-learning.git'
            }
        }

        stage('Verify Files') {
            steps {
                sh '''
                echo "Workspace:"
                pwd
                ls -la
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t python-ci-app .
                '''
            }
        }

        stage('Run Container (Tests)') {
            steps {
                sh '''
                docker run --rm python-ci-app
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
