pipeline {
    agent {
        docker {
            image 'python:3.10'
        }
    }

    stages {

        stage('Install Dependencies') {
            steps {
                sh 'pip install --user -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                sh '~/.local/bin/pytest'
            }
        }
    }
}

