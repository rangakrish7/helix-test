pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK17'
    }

  environment {
    SONAR_HOST_URL = 'http://localhost:9000/'
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

     stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv('SonarQube') {
            withCredentials([string(credentialsId: 'sonarqube-token2', variable: 'SONAR_TOKEN')]) {
                sh '''
                    mvn sonar:sonar \
                    -Dsonar.projectKey=my-helix-project \
                    -Dsonar.host.url=$SONAR_HOST_URL  \
                '''
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
