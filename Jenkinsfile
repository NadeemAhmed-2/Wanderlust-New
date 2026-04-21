pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = "nadeemahmed07"
        IMAGE_NAME = "wanderlust"
        REGISTRY_ID = "dockerhub-id" 
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${env.BUILD_NUMBER} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_ID}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // IMPORTANT: This replaces the image tag in your YAML with the current build number
                sh "sed -i 's|image:.*|image: ${DOCKER_HUB_USER}/${IMAGE_NAME}:${env.BUILD_NUMBER}|' deployment.yaml"
                
                sh "kubectl apply -f deployment.yaml"
                sh "kubectl apply -f service.yaml"
                sh "kubectl apply -f secret.yaml"
            }
        }
    }
}
