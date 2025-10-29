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
        IMAGE_FULL = "${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
        CHART_FULL = ".\\charts\\${DOCKER_IMAGE_NAME}"
        
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
                powershell 'mvn clean compile -s local-settings.xml'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                powershell 'mvn test -s local-settings.xml'
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
                powershell 'mvn package -DskipTests -s local-settings.xml'
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
                    powershell "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ."
                    powershell "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${DOCKER_IMAGE_NAME}:${DOCKER_LATEST_TAG}"
                    
                    // Check if the Docker image was built successfully
                    echo 'Verifying Docker image was built...'
                    powershell """
                        \$imageExists = docker images ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} -q
                        if (-not \$imageExists) {
                            Write-Host "ERROR: Docker image '${DOCKER_IMAGE_NAME}:${DOCKER_TAG}' was not built successfully" -ForegroundColor Red
                            exit 1
                        }
                        Write-Host "Docker image built and verified successfully!" -ForegroundColor Green
                    """
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                script {
                    echo 'Testing Docker image...'
                    // Run a quick test of the Docker container
                    powershell "docker run --rm ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying application locally...'
                    // Check for existing pod and stop/remove if it exists
                    echo "APP_NAME: $APP_NAME"
                    powershell """
                        \$existingPod = kubectl get pods | Select-String -Pattern "\$env:$APP_NAME" -Quiet
                        if (\$existingPod) {
                            kubectl delete pod \$env:$APP_NAME
                        }
                    """
                    echo 'Deploy the pod using Helm...'
                    // Deploy the pod using Helm
                    powershell """
                        & 'C:\\Program Files\\helm\\windows-amd64\\helm.exe' upgrade --install `
                            \"\$APP_NAME\" `
                            --set image=\"\$IMAGE_FULL\" `
                            \"\$CHART_FULL\"
                    """

                    // Verify pod deployment by showing container logs live
                    powershell """
                        kubectl logs -f \$env:$APP_NAME
                    """
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
            // Clean up Docker images to save space
            powershell "docker image prune -f"
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