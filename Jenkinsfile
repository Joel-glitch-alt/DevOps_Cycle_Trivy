pipeline {
  agent any

  environment {
    NODE_ENV = 'test'
    SONARQUBE = 'sonar-server' // Update this to match your Jenkins SonarQube config
  }

  tools {
    nodejs 'NodeJs' // Ensure this matches your configured Node.js installation
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        // Option 1: Strict install (fails on conflict)
        // sh 'npm ci'

        // Option 2: Lenient install (ignores peer conflicts)
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
        sh 'npm test -- --coverage'
      }
      post {
        always {
          junit 'coverage/**/*.xml' // Ensure the coverage tool outputs XML in this path
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
