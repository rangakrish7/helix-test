pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sq1') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=my-helix-project -Dsonar.host.url=http://localhost:9000 -Dsonar.login=<TOKEN>'
                }
            }
        }
    }
}
