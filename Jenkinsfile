pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/VirtualRcoder/jenkins-cicd-learning.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip3 install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'pytest'
            }
        }
    }
}

