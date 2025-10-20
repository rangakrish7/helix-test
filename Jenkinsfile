pipeline {
    agent any

    tools {
        maven 'Maven-3.8.8'       // Ensure Maven is configured in Jenkins
        jdk 'JDK-17'              // Ensure JDK is configured in Jenkins
    }

    environment {
        SONARQUBE_ENV = 'SonarQube-Docker' // Name configured in Jenkins for SonarQube
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=my-java-project'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }

    post {
        success {
            echo 'Build and SonarQube analysis completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
