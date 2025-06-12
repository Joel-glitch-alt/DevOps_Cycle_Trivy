pipeline {
  agent any

  environment {
    NODE_ENV = 'test'
    SONARQUBE = 'sonar-server' // Ensure this matches your Jenkins SonarQube config name
  }

  tools {
    nodejs 'NodeJs' // Ensure this matches your Node.js tool config in Jenkins
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        sh 'npm ci --legacy-peer-deps'
      }
    }

    stage('Lint') {
      steps {
        sh 'npm run lint'
        sh 'npm run validate:html'
        sh 'npm run validate:css'
      }
    }

    stage('Test') {
      steps {
        sh 'npm test'
      }
      post {
        always {
          junit 'junit.xml' // MATCH this to your jest-junit config
        }
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv("${env.SONARQUBE}") {
          sh 'sonar-scanner'
        }
      }
    }

    stage('Quality Gate') {
      steps {
        timeout(time: 10, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }
  }

  post {
    always {
      echo 'Pipeline completed.'
    }
    success {
      echo 'Build passed!'
    }
    failure {
      echo 'Build failed!'
    }
  }
}
