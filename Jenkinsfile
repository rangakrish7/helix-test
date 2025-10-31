stages {
    stage('Checkout') {
        steps {
            checkout scm
        }
    }

    stage('Inspect Workspace') {
        steps {
            sh 'ls -R /var/jenkins_home/workspace/multibranch-deploy_feature_HEL-7'
        }
    }

    stage('Build') {
        steps {
            sh 'mvn clean install'
        }
    }

    ...
}
