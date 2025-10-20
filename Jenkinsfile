pipeline {
    agent any

    tools {
        maven 'Maven-3.9.9' // Matches the name you configured in Global Tool Configuration
        jdk 'jdk17'         // Optional: If you have JDK configured in Jenkins
    }

    environment {
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_PROJECT_KEY = 'my-helix-project'
        SONAR_TOKEN = credentials('sonar-token') // Store token in Jenkins credentials
    }

    options {
        // Keep build logs and artifacts clean
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
                // Cache Maven dependencies for faster builds
                sh '''
                    mkdir -p ~/.m2/repository
                    mvn clean install -Dmaven.repo.local=~/.m2/repository
                '''
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
                        -Dmaven.repo.local=~/.m2/repository
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
            echo 'Build and SonarQube analysis completed successfully!'
        }
        failure {
            echo 'Build failed or Quality Gate not passed.'
        }
    }
}
