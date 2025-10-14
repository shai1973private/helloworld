pipeline {
    agent any
    
    tools {
        maven 'Maven-3.9.11'  // Make sure this matches your Jenkins Maven installation name
        jdk 'JDK-11'       // Make sure this matches your Jenkins JDK installation name
    }
    
    environment {
        // Local Development Configuration
        DOCKER_IMAGE_NAME = 'hello-world-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKER_LATEST_TAG = 'latest'
        
        // Application Configuration
        APP_NAME = 'hello-world-app'
        APP_VERSION = '1.0.0'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building the application...'
                bat 'mvn clean compile -s local-settings.xml'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                bat 'mvn test -s local-settings.xml'
            }
            post {
                always {
                    // Publish test results
                    junit testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true
                }
            }
        }
        
        stage('Package') {
            steps {
                echo 'Packaging the application...'
                bat 'mvn package -DskipTests -s local-settings.xml'
            }
            post {
                success {
                    echo 'Archiving artifacts...'
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    // Build the Docker image
                    bat "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ."
                    bat "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${DOCKER_IMAGE_NAME}:${DOCKER_LATEST_TAG}"
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                script {
                    echo 'Testing Docker image...'
                    // Run a quick test of the Docker container
                    bat "docker run --rm ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying application locally...'
                    // Check if container exists and stop/remove it if it does
                    bat """
                        for /f %%i in ('docker ps -aq --filter "name=${APP_NAME}"') do (
                            echo Found existing container, stopping and removing...
                            docker stop ${APP_NAME}
                            docker rm ${APP_NAME}
                        )
                    """
                    echo 'Starting new container...'
                    // Deploy to local environment
                    bat "docker run -d --name ${APP_NAME} ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
                    echo "Container ${APP_NAME} deployed successfully!"
                    echo "To view logs: docker logs ${APP_NAME}"
                    // Verify container is running
                    bat "docker ps --filter \"name=${APP_NAME}\""
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
            // Clean up Docker images to save space
            bat "docker image prune -f"
        }
        success {
            echo 'Pipeline completed successfully!'
            echo "Application deployed as container: ${APP_NAME}"
            echo "To view logs: docker logs ${APP_NAME}"
            echo "To stop container: docker stop ${APP_NAME}"
            // Send success notification (optional - remove if not using email)
            // emailext (
            //     subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            //     body: "Build completed successfully. Check console output at ${env.BUILD_URL}",
            //     to: "team@example.com"
            // )
        }
        failure {
            echo 'Pipeline failed!'
            echo 'Check the console output for error details'
            // Send failure notification (optional - remove if not using email)
            // emailext (
            //     subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            //     body: "Build failed. Check console output at ${env.BUILD_URL}",
            //     to: "team@example.com"
            // )
        }
    }
}