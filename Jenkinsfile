pipeline {
    agent any
    
    tools {
        nodejs 'NodeJS18' // Make sure NodeJS is configured in Jenkins Global Tools
    }
    
    environment {
        //SONAR_SERVER = 'sonar-server'
        //SONAR_SCANNER = 'sonar-scanner'
        //SONAR_TOKEN = credentials('sonar-token')
        SONAR_QUALITY_GATE = 'sonar-quality-gate'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    // Check if package.json exists, if not create a basic one
                    if (!fileExists('package.json')) {
                        writeFile file: 'package.json', text: '''
                        {
                            "name": "devops-project",
                            "version": "1.0.0",
                            "description": "DevOps project with SonarQube analysis, Docker, Kubernetes, and Trivia",
                            "main": "script.js",
                            "scripts": {
                                "test": "echo \\"No tests specified\\"",
                                "lint": "echo \\"No linting configured\\""
                            },
                            "devDependencies": {}
                        }
                        '''
                    }
                }
                sh 'npm install'
            }
        }
        
        stage('Code Quality Check') {
            steps {
                script {
                    // Optional: Run ESLint if configured
                    sh 'npm run lint || echo "No linting configured"'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    // Run tests if they exist
                    sh 'npm test || echo "No tests configured"'
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                script {
                    // Create sonar-project.properties if it doesn't exist
                    if (!fileExists('sonar-project.properties')) {
                        writeFile file: 'sonar-project.properties', text: '''
                        sonar.projectKey=javascript-project
                        sonar.projectName=JavaScript Project
                        sonar.projectVersion=1.0
                        sonar.sources=.
                        sonar.exclusions=node_modules/**,**/*.min.js,dist/**,build/**
                        sonar.javascript.file.suffixes=.js,.jsx
                        sonar.sourceEncoding=UTF-8
                        '''
                    }
                }
                
                withSonarQubeEnv("${SONAR_SERVER}") {
                    sh """
                        ${SONAR_SCANNER}/bin/sonar-scanner \\
                        -Dsonar.login=${SONAR_TOKEN} \\
                        -Dsonar.projectKey=javascript-project \\
                        -Dsonar.sources=. \\
                        -Dsonar.exclusions=node_modules/**,**/*.min.js,dist/**,build/**
                    """
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    script {
                        def qualityGate = waitForQualityGate()
                        if (qualityGate.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qualityGate.status}"
                        }
                    }
                }
            }
        }
        
        stage('Build/Package') {
            steps {
                script {
                    // Create a simple build directory with your JavaScript files
                    sh 'mkdir -p dist'
                    sh 'cp *.js dist/ || echo "No JS files to copy"'
                    sh 'cp *.html dist/ || echo "No HTML files to copy"'
                    sh 'cp *.css dist/ || echo "No CSS files to copy"'
                }
                
                // Archive artifacts
                archiveArtifacts artifacts: 'dist/**', allowEmptyArchive: true
            }
        }
        
        // stage('Deploy to Staging') {
        //     when {
        //         branch 'master'
        //     }
        //     steps {
        //         script {
        //             echo 'Deploying to staging environment...'
        //             // Add your staging deployment commands here
        //             // Example: scp, rsync, or container deployment
        //         }
        //     }
        // }
        
        stage('Deploy to Production') {
            when {
                branch 'master'
            }
            steps {
                script {
                    echo 'Deploying to production environment...'
                    // Add your production deployment commands here
                    // Consider adding approval steps for production deployments
                }
            }
        }
    }
    
    post {
        always {
            // Clean workspace
            cleanWs()
        }
        
        success {
            echo 'Pipeline completed successfully!'
            // Optional: Send success notifications
        }
        
        failure {
            echo 'Pipeline failed!'
            // Optional: Send failure notifications
            // mail to: 'team@company.com',
            //      subject: "Pipeline Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
            //      body: "Pipeline failed. Check Jenkins for details: ${env.BUILD_URL}"
        }
        
        unstable {
            echo 'Pipeline is unstable!'
        }
    }
}