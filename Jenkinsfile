pipeline {
    agent any

    tools {
        maven 'Maven'       // Ensure 'Maven' is configured in Jenkins Global Tools
        jdk 'JDK17'         // Ensure 'JDK17' is configured in Jenkins Global Tools
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
                        sh '''
                            mvn sonar:sonar \
                              -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                              -Dsonar.exclusions=**/node_modules/**,**/venv/**,**/tests/**,**/proc/** \
                              -Dsonar.host.url=${SONAR_HOST_URL} \
                              -Dsonar.login=${SONAR_TOKEN} \
                              -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml
                        '''
                    }
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    sh '''
                        echo "📦 Deploying Jenkins with Helm..."

                        cd ${WORKSPACE}/helix-test/hello-world-chart/helm-charts-main/charts/jenkins

                        helm upgrade --install jenkins . \
                          --namespace default \
                          --values values.yaml

                        echo "✅ Jenkins deployment completed."
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build, SonarQube analysis, and deployment completed successfully!'
        }
        failure {
            echo '❌ Build failed or Quality Gate not passed.'
        }
    }
}
