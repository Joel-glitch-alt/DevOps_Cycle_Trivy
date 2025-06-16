// pipeline {
//   agent any

//   environment {
//     NODE_ENV = 'test'
//     SONARQUBE = 'sonar-server' // This must match your Jenkins SonarQube config name
//     DOCKER_USERNAME = 'addition1905'
//     DOCKER_IMAGE = 'addition1905/devops-trivy:latest'
//   }

//   tools {
//     nodejs 'NodeJs' // This must match your configured Node.js tool in Jenkins
//   }

//   stages {

//     stage('Checkout') {
//       steps {
//         checkout scm
//       }
//     }

//     stage('Install Dependencies') {
//       steps {
//         sh 'npm ci --legacy-peer-deps'
//       }
//     }

//     stage('Lint') {
//       steps {
//         sh 'npm run lint'
//         sh 'npm run validate:html'
//         sh 'npm run validate:css'
//       }
//     }

//     stage('Test') {
//       steps {
//         sh 'npm test'
//       }
//       post {
//         always {
//           junit 'junit.xml'
//         }
//       }
//     }

//     stage('SonarQube Analysis') {
//       steps {
//         script {
//           def scannerHome = tool 'sonar-scanner'
//           withSonarQubeEnv("${env.SONARQUBE}") {
//             sh "${scannerHome}/bin/sonar-scanner"
//           }
//         }
//       }
//     }

//     stage('Quality Gate') {
//       steps {
//         timeout(time: 10, unit: 'MINUTES') {
//           waitForQualityGate abortPipeline: false
//         }
//       }
//     }

//     stage('Trivy FS Scan') {
//       steps {
//         script {
//           // Trivy scan of the working directory
//           sh 'trivy fs --exit-code 1 --severity HIGH,CRITICAL .'
//         }
//       }
//     }

//      stage('Docker Build & Push') {
//             steps {
//                 script {
//                     def img = docker.build("${DOCKER_IMAGE}")
//                     docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
//                         img.push()
//                     }
//                 }
//             }
//         }

//   }

//   post {
//     always {
//       echo 'Pipeline completed.'
//     }
//     success {
//       echo 'Build passed!'
//     }
//     failure {
//       echo 'Build failed!'
//     }
//   }
// }


// pipeline {
//   agent any

//   environment {
//     NODE_ENV = 'test'
//     SONARQUBE = 'sonar-server' // Jenkins SonarQube server name
//     DOCKER_USERNAME = 'addition1905'
//     DOCKER_IMAGE = 'addition1905/devops-trivy:latest'
//   }

//   tools {
//     nodejs 'NodeJs' // Name of Node.js tool in Jenkins configuration
//   }

//   stages {

//     stage('Checkout') {
//       steps {
//         checkout scm
//       }
//     }

//     stage('Install Dependencies') {
//       steps {
//         sh 'npm ci --legacy-peer-deps'
//       }
//     }

//     stage('Lint') {
//       steps {
//         sh 'npm run lint'
//         sh 'npm run validate:html'
//         sh 'npm run validate:css'
//       }
//     }

//     stage('Test') {
//       steps {
//         sh 'npm test'
//       }
//       post {
//         always {
//           junit 'junit.xml'
//         }
//       }
//     }

//     stage('SonarQube Analysis') {
//       steps {
//         script {
//           def scannerHome = tool 'sonar-scanner'
//           withSonarQubeEnv("${env.SONARQUBE}") {
//             sh "${scannerHome}/bin/sonar-scanner"
//           }
//         }
//       }
//     }

//     stage('Quality Gate') {
//       steps {
//         timeout(time: 10, unit: 'MINUTES') {
//           waitForQualityGate abortPipeline: false
//         }
//       }
//     }

  
//           stage('Trivy FS Scan') {
//              steps {
//              script {
//              def scanResult = sh(script: 'trivy fs --severity HIGH,CRITICAL .', returnStatus: true)
//              if (scanResult != 0) {
//              currentBuild.result = 'UNSTABLE'
//              echo "Security vulnerabilities found."
//                      }
//               }
//          }
//       }


//     //

//     stage('Docker Build & Push') {
//       steps {
//         script {
//           def img = docker.build("${DOCKER_IMAGE}")
//           docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
//             img.push()
//           }
//         }
//       }
//     }

//     stage('Trivy Docker Image Scan') {
//       steps {
//         // Scan the built Docker image
//         sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${DOCKER_IMAGE}"
//       }
//     }
//   }

//   post {
//     always {
//       echo 'Pipeline completed.'
//     }
//     success {
//       echo 'Build passed!'
//     }
//     failure {
//       echo 'Build failed!'
//     }
//   }
// }


pipeline {
  agent any

  environment {
    NODE_ENV = 'test'
    SONARQUBE = 'sonar-server' // Jenkins SonarQube server name
    DOCKER_USERNAME = 'addition1905'
    DOCKER_IMAGE = 'addition1905/devops-trivy:latest'
  }

  tools {
    nodejs 'NodeJs' // Name of Node.js tool in Jenkins configuration
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
          junit 'junit.xml'
        }
      }
    }

    stage('SonarQube Analysis') {
      steps {
        script {
          def scannerHome = tool 'sonar-scanner'
          withSonarQubeEnv("${env.SONARQUBE}") {
            sh "${scannerHome}/bin/sonar-scanner"
          }
        }
      }
    }

    stage('Quality Gate') {
      steps {
        timeout(time: 10, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: false
        }
      }
    }

    stage('Trivy FS Scan') {
      steps {
        script {
          def scanResult = sh(script: 'trivy fs --severity HIGH,CRITICAL --format table .', returnStatus: true)
          if (scanResult != 0) {
            currentBuild.result = 'UNSTABLE'
            echo "Security vulnerabilities found in filesystem scan."
            // Generate report for review
            sh 'trivy fs --severity HIGH,CRITICAL --format json --output trivy-fs-report.json .'
          }
        }
      }
      post {
        always {
          // Archive the scan results
          archiveArtifacts artifacts: 'trivy-fs-report.json', allowEmptyArchive: true
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        script {
          def img = docker.build("${DOCKER_IMAGE}")
          docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
            img.push()
          }
        }
      }
    }

    stage('Trivy Docker Image Scan') {
      steps {
        script {
          // Scan without failing the build, but report issues
          def dockerScanResult = sh(script: "trivy image --severity HIGH,CRITICAL --format table ${DOCKER_IMAGE}", returnStatus: true)
          if (dockerScanResult != 0) {
            currentBuild.result = 'UNSTABLE'
            echo "Security vulnerabilities found in Docker image scan."
            // Generate detailed report
            sh "trivy image --severity HIGH,CRITICAL --format json --output trivy-docker-report.json ${DOCKER_IMAGE}"
          }
        }
      }
      post {
        always {
          // Archive the scan results
          archiveArtifacts artifacts: 'trivy-docker-report.json', allowEmptyArchive: true
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
      // Notify on success
      emailext(
        subject: "Build Success: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
        body: "Build completed successfully with no security issues.",
        to: "${env.CHANGE_AUTHOR_EMAIL}"
      )
    }
    unstable {
      echo 'Build completed with security warnings!'
      // Notify on security issues but don't fail
      emailext(
        subject: "Build Unstable: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
        body: "Build completed but security vulnerabilities were found. Please review the Trivy reports.",
        to: "${env.CHANGE_AUTHOR_EMAIL}",
        attachmentsPattern: "trivy-*.json"
      )
    }
    failure {
      echo 'Build failed!'
      // Notify on failure
      emailext(
        subject: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
        body: "Build failed. Please check the console output for details.",
        to: "${env.CHANGE_AUTHOR_EMAIL}"
      )
    }
  }
}