pipeline {
  agent any

  environment {
    NODE_ENV = 'test'
    SONARQUBE = 'sonar-server' // Name of your SonarQube server in Jenkins > Manage Jenkins > Configure System
  }

  tools {
    nodejs 'NodeJs' // Adjust to your installed NodeJS version in Jenkins
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        sh 'npm ci'
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
        sh 'npm test -- --coverage'
      }
      post {
        always {
          junit 'coverage/**/*.xml' // Optional: convert coverage to JUnit XML with a tool
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
