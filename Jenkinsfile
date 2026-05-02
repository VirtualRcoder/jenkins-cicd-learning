pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup & Test') {
            steps {
                sh '''
                docker run --rm \
                -v ${WORKSPACE}:/app \
                -w /app \
                python:3.10 \
                /bin/bash -c "
                ls -l &&
                python3 -m venv venv &&
                source venv/bin/activate &&
                python3 -m pip install -r requirements.txt &&
                export PYTHONPATH=/app &&
                python3 -m pytest
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
