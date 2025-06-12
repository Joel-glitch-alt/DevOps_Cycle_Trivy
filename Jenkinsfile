pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Hello from Jenkins Pipeline!'
                // If you have a repo, uncomment the next line
                // checkout scm
            }
        }
        
        stage('Create Hello Project') {
            steps {
                script {
                    // Create a simple source file
                    writeFile file: 'hello.js', text: '''
// Simple Hello World function for SonarQube
function sayHello() {
    console.log("Hello from SonarQube via Jenkins!");
    return "Hello World";
}

function greetUser(name) {
    if (name) {
        console.log("Hello, " + name + "!");
    } else {
        console.log("Hello, World!");
    }
}

// Example of code that might have quality issues for SonarQube to detect
function exampleFunction() {
    var unused = "This variable is unused"; // Code smell
    console.log("Hello SonarQube - analyzing code quality!");
}

// Call the functions
sayHello();
greetUser("SonarQube");
exampleFunction();
'''
                    
                    // Create sonar-project.properties
                    writeFile file: 'sonar-project.properties', text: '''
# Required metadata
sonar.projectKey=jenkins-hello-world
sonar.projectName=Jenkins Hello World Project
sonar.projectVersion=1.0

# Source code location
sonar.sources=.
sonar.sourceEncoding=UTF-8

# Language settings
sonar.javascript.file.suffixes=.js

# Exclude Jenkins and SonarQube files
sonar.exclusions=**/*.xml,**/*.log,**/sonar-scanner/**
'''
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                script {
                    echo 'Hello! Starting SonarQube Analysis...'
                    
                    // Use Jenkins configured SonarQube server
                    withSonarQubeEnv('sonar-server') {
                        def sonarScannerHome = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                        sh """
                            ${sonarScannerHome}/bin/sonar-scanner \\
                                -Dsonar.projectKey=jenkins-hello-world \\
                                -Dsonar.projectName='Jenkins Hello World Project' \\
                                -Dsonar.projectVersion=1.0 \\
                                -Dsonar.sources=.
                        """
                    }
                    
                    echo 'Hello! SonarQube Analysis completed!'
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                script {
                    echo 'Hello! Waiting for Quality Gate results...'
                    
                    // Wait for SonarQube to process the analysis and return Quality Gate status
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        
                        echo "Hello! Quality Gate Status: ${qg.status}"
                        
                        if (qg.status != 'OK') {
                            echo "Hello! Quality Gate failed with status: ${qg.status}"
                            echo "Check the SonarQube dashboard for detailed issues:"
                            echo "http://68.154.50.4:9500/dashboard?id=jenkins-hello-world"
                            
                            // You can choose to fail the pipeline or just warn
                            // Option 1: Fail the pipeline (uncomment next line)
                            // error "Pipeline aborted due to quality gate failure: ${qg.status}"
                            
                            // Option 2: Just warn but continue (current behavior)
                            echo "Warning: Quality Gate failed, but continuing pipeline..."
                        } else {
                            echo "Hello! Quality Gate passed successfully! ✅"
                        }
                    }
                }
            }
        }
        
        stage('Display Results') {
            steps {
                script {
                    echo 'Hello! Analysis has been sent to SonarQube!'
                    echo "Check your SonarQube dashboard at: http://68.154.50.4:9500"
                    echo 'Project: Jenkins Hello World Project'
                    echo "Direct project link: http://68.154.50.4:9500/dashboard?id=jenkins-hello-world"
                    echo 'Look for the Hello World JavaScript code in the analysis!'
                }
            }
        }
    }
    
    post {
        always {
            echo 'Hello! Pipeline completed.'
            echo "Check your SonarQube dashboard at: http://68.154.50.4:9500"
            echo "Direct project link: http://68.154.50.4:9500/dashboard?id=jenkins-hello-world"
            echo 'Your Hello World project should now be visible in SonarQube!'
        }
        success {
            echo 'Hello! Pipeline succeeded! 🎉'
            echo 'Quality Gate check completed successfully!'
        }
        failure {
            echo 'Hello! Pipeline failed, but we tried our best! 😊'
            echo 'Check the Quality Gate results in SonarQube for details.'
        }
    }
}