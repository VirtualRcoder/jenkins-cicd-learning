pipeline {
    agent {
        docker {
            image 'python:3.10'
        }
    }

    stages {

        stage('Setup Environment') {
            steps {
                sh '''
                python -m venv venv
                . venv/bin/activate
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                . venv/bin/activate
                export PYTHONPATH=$PWD
                pytest
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t python-ci-app .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run --rm python-ci-app'
            }
        }
    }
}
