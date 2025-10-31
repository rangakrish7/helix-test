pipeline {
    agent any

    tools {
        maven 'Maven 3.9.6'
        jdk 'jdk-21'
        helm 'Helm 3.14.0'
    }

    environment {
        SONARQUBE_ENV = 'SonarQube'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    withCredentials([usernamePassword(credentialsId: 'sonar-creds', usernameVariable: 'SONAR_USER', passwordVariable: 'SONAR_PASS')]) {
                        sh 'mvn clean verify sonar:sonar -Dsonar.login=$SONAR_USER -Dsonar.password=$SONAR_PASS'
                    }
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    echo "📦 Deploying Jenkins with Helm..."

                    // Debug: Show current directory structure
                    sh 'echo "Current workspace:" && pwd && ls -R'

                    def chartPath = 'helix-test/hello-world-chart/helm-charts-main/charts/jenkins'
                    def fullPath = "${env.WORKSPACE}/${chartPath}"

                    // Check if directory exists before cd
                    sh """
                        if [ -d "${fullPath}" ]; then
                          cd "${fullPath}"
                          helm upgrade --install jenkins . --namespace default
                        else
                          echo "❌ Directory not found: ${fullPath}"
                          exit 1
                        fi
                    """
                }
            }
        }
    }

    post {
        failure {
            echo '❌ Build failed or Quality Gate not passed.'
        }
    }
}
