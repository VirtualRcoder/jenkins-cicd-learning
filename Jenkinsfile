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
                pip install --upgrade pip
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
    }

}

