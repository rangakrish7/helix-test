pipeline {
    agent {
        docker {
            image 'rangakrish/jenkins-agent:latest'
            args '-u root:root'
        }
    }
    environment {
        SONARQUBE_ENV = credentials('sonar-token') // Jenkins credential ID
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'feature/HEL-7', url: 'https://github.com/rangakrish7/helix-test.git'
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
                    sh 'mvn sonar:sonar -Dsonar.projectKey=helix-test -Dsonar.host.url=http://<your-sonarqube-server>:9000 -Dsonar.login=$SONARQUBE_ENV'
                }
            }
        }
    }
    post {
        success {
            echo '✅ Build and Sonar scan completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}
