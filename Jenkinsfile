pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK17'
    }

  environment {
    SONAR_HOST_URL = 'http://172.23.87.201:9100'
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
            withCredentials([string(credentialsId: 'sonarQube-token', variable: 'SONAR_TOKEN')]) {
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
                    waitForQualityGate abortPipeline: false
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
