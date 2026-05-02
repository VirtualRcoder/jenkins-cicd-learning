pipeline {
    agent any

    stages {

        stage('Setup & Test') {
            steps {
                sh '''
                docker run --rm -v $PWD:/app -w /app python:3.10 sh -c "
                python -m venv venv &&
                . venv/bin/activate &&
                pip install -r requirements.txt &&
                export PYTHONPATH=/app &&
                pytest
                "
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
