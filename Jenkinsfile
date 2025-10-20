pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK17'
    }

    environment {
        SONAR_HOST_URL = 'http://<your-sonarqube-host>:9000'
        SONAR_PROJECT_KEY = 'my-helix-project'
        DOCKER_IMAGE = 'your-dockerhub-username/my-helix-app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sq1') {
                    withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                        sh """
                           sonar-scanner \
                            -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                            -Dsonar.host.url=${SONAR_HOST_URL} \
                            -Dsonar.exclusions=**/node_modules/**,**/venv/**,**/tests/**,**/proc/** \
                            -Dsonar.login=${SONAR_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Build & Push') {
            environment {
                DOCKER_CREDS = credentials('dockerhub-credentials')
            }
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                    echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin
                    docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                """
            }
        }

        stage('Deploy to WSL') {
            steps {
                sshagent(['wsl-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no user@<wsl-ip> '
                            docker pull ${DOCKER_IMAGE}:${BUILD_NUMBER} &&
                            docker stop my-helix-app || true &&
                            docker rm my-helix-app || true &&
                            docker run -d --name my-helix-app -p 8080:8080 ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build, SonarQube, Docker, and WSL Deploy completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}
