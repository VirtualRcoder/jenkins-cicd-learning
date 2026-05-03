pipeline {
    agent any

    environment {
        IMAGE_NAME = "virtualrcoder/python-ci-app"
        IMAGE_TAG = "v${BUILD_NUMBER}"
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
                docker build -t $IMAGE_NAME:$IMAGE_TAG .
                docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest
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
                docker push $IMAGE_NAME:$IMAGE_TAG
                docker push $IMAGE_NAME:latest
                '''
            }
        }

        // stage('Deploy') {
        //     steps {
        //         sh '''
        //         docker stop python-ci-container || true
        //         docker rm python-ci-container || true

        //         docker run -d \
        //           --name python-ci-container \
        //           -p 5000:5000 \
        //           $IMAGE_NAME:$IMAGE_TAG
        //         '''
        //     }
        // }
        // stage('Zero Downtime Deploy') {
        //     steps {
        //         sh '''
        //         docker rm -f python-ci-container-new || true
                
        //         docker run -d \
        //         --name python-ci-container-new \
        //         -p 5001:5000 \
        //         $IMAGE_NAME:$IMAGE_TAG

        //         echo "Waiting for container..."

        //         for i in {1..10}; do
        //         if curl -s http://localhost:5001; then
        //             echo "App is up!"
        //             break
        //         fi
        //         sleep 2
        //         done

        //         # Stop old container
        //         docker stop python-ci-container || true
        //         docker rm python-ci-container || true

        //         # Switch ports (IMPORTANT)
        //         docker stop python-ci-container-new
        //         docker rm python-ci-container-new

        //         docker run -d \
        //         --name python-ci-container \
        //         -p 5000:5000 \
        //         $IMAGE_NAME:$IMAGE_TAG
        //         '''
        //     }
        // }
        stage('Blue-Green Deploy') {
            steps {
                sh '''
                CURRENT=$(docker ps --format '{{.Names}}' | grep app-blue || true)

                if [ "$CURRENT" = "app-blue" ]; then
                    NEW="app-green"
                    OLD="app-blue"
                    PORT=5001
                else
                    NEW="app-blue"
                    OLD="app-green"
                    PORT=5000
                fi

                echo "Deploying new container: $NEW"

                # Remove if already exists
                docker rm -f $NEW || true

                # Run new container
                docker run -d \
                --name $NEW \
                -p $PORT:5000 \
                $IMAGE_NAME:$IMAGE_TAG

                echo "Waiting for container..."

                # Health check
                for i in {1..10}; do
                if curl -s http://localhost:$PORT; then
                    echo "App is healthy"
                    break
                fi
                sleep 2
                done

                echo "Switching Nginx to $NEW"

                # Update nginx config
                if [ "$NEW" = "app-blue" ]; then
                    echo "proxy_pass http://app-blue:5000;" > /tmp/nginx_upstream.conf
                else
                    echo "proxy_pass http://app-green:5000;" > /tmp/nginx_upstream.conf
                fi

                # Copy config into nginx container
                docker exec nginx-proxy sh -c "echo 'server { listen 80; location / { $(cat /tmp/nginx_upstream.conf) } }' > /etc/nginx/conf.d/default.conf"

                # Reload nginx
                docker exec nginx-proxy nginx -s reload

                echo "Removing old container: $OLD"

                docker stop $OLD || true
                docker rm $OLD || true
                '''
            }
        }



    }

    post {
        success {
            echo "🚀 Deployed version: ${IMAGE_TAG}"
        }
    }
}
