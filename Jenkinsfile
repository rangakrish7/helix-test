pipeline {
    agent any

    tools {
        maven 'Maven'    // Matches Global Tool Configuration
        jdk 'JDK17'      // Matches Global Tool Configuration
    }

    environment {
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_PROJECT_KEY = 'my-helix-project'
        SONAR_TOKEN = credentials('sonar-token') // Jenkins credentials ID for SonarQube token
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-org/your-repo.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install -Dmaven.repo.local=.m2/repository'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sq1') {
                    sh '''
                        mvn sonar:sonar \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.host.url=${SONAR_HOST_URL} \
                        -Dsonar.login=${SONAR_TOKEN} \
                        -Dmaven.repo.local=.m2/repository
                    '''
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
