pipeline {
    agent any

    tools {
        maven 'Maven'       // Ensure Maven tool is configured in Jenkins
        jdk 'JDK17'         // Ensure JDK17 is configured in Jenkins
    }

    environment {
        SONAR_HOST_URL = 'http://172.23.87.201:9000'
        SONAR_PROJECT_KEY = 'my-helix-project'
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

        stage('SonarQube Analysis & Quality Gate') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    withCredentials([string(credentialsId: 'sonarQube-token', variable: 'SONAR_TOKEN')]) {
                        sh """
                         mvn sonar:sonar \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.exclusions=**/node_modules/**,**/venv/**,**/tests/**,**/proc/** \
                        -Dsonar.host.url=${SONAR_HOST_URL} \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                    }
                }
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build and SonarQube analysis completed successfully!'
        }
        failure {
            echo '❌ Build failed or Quality Gate not passed.'
        }
    }
}
