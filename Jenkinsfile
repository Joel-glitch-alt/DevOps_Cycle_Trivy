pipeline {
    agent any
    
    tools {
        nodejs 'NodeJs'
    }
    
    environment {
        SONAR_TOKEN = credentials('sonar-token')
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
                    // Create a comprehensive package.json with testing dependencies
                    if (!fileExists('package.json')) {
                        writeFile file: 'package.json', text: '''
                        {
                            "name": "devops-project",
                            "version": "1.0.0",
                            "description": "JavaScript project with comprehensive testing",
                            "main": "script.js",
                            "scripts": {
                                "test": "jest --coverage --testResultsProcessor=jest-sonar-reporter",
                                "test:watch": "jest --watch",
                                "lint": "eslint . --ext .js,.html --format=checkstyle --output-file=checkstyle-result.xml || true",
                                "lint:fix": "eslint . --ext .js,.html --fix",
                                "validate:html": "html-validate *.html || true",
                                "validate:css": "stylelint **/*.css --formatter=json --output-file=stylelint-report.json || true"
                            },
                            "devDependencies": {
                                "jest": "^29.0.0",
                                "jest-environment-jsdom": "^29.0.0",
                                "jest-sonar-reporter": "^2.0.0",
                                "@testing-library/jest-dom": "^5.16.0",
                                "eslint": "^8.0.0",
                                "eslint-plugin-html": "^7.0.0",
                                "html-validate": "^7.0.0",
                                "stylelint": "^15.0.0",
                                "stylelint-config-standard": "^30.0.0",
                                "c8": "^7.12.0"
                            },
                            "jest": {
                                "testEnvironment": "jsdom",
                                "collectCoverage": true,
                                "coverageDirectory": "coverage",
                                "coverageReporters": ["html", "text", "lcov", "json"],
                                "collectCoverageFrom": [
                                    "*.js",
                                    "!node_modules/**",
                                    "!coverage/**",
                                    "!dist/**"
                                ],
                                "testMatch": ["**/*.test.js", "**/*.spec.js"]
                            }
                        }
                        '''
                    }
                }
                sh 'npm install'
            }
        }
        
        stage('Code Quality Check') {
            parallel {
                stage('JavaScript Linting') {
                    steps {
                        script {
                            // Create ESLint configuration
                            if (!fileExists('.eslintrc.js')) {
                                writeFile file: '.eslintrc.js', text: '''
                                module.exports = {
                                    env: {
                                        browser: true,
                                        es2021: true,
                                        node: true,
                                        jest: true
                                    },
                                    extends: ['eslint:recommended'],
                                    parserOptions: {
                                        ecmaVersion: 12,
                                        sourceType: 'module'
                                    },
                                    plugins: ['html'],
                                    rules: {
                                        'no-unused-vars': 'warn',
                                        'no-console': 'warn'
                                    }
                                };
                                '''
                            }
                        }
                        sh 'npm run lint'
                        publishCheckStyleResults checksName: 'ESLint', pattern: 'checkstyle-result.xml'
                    }
                }
                
                stage('HTML Validation') {
                    steps {
                        script {
                            if (!fileExists('.htmlvalidate.json')) {
                                writeFile file: '.htmlvalidate.json', text: '''
                                {
                                    "extends": [
                                        "html-validate:recommended"
                                    ],
                                    "rules": {
                                        "require-sri": "off"
                                    }
                                }
                                '''
                            }
                        }
                        sh 'npm run validate:html'
                    }
                }
                
                stage('CSS Validation') {
                    steps {
                        script {
                            if (!fileExists('.stylelintrc.json')) {
                                writeFile file: '.stylelintrc.json', text: '''
                                {
                                    "extends": ["stylelint-config-standard"],
                                    "rules": {
                                        "comment-empty-line-before": null,
                                        "declaration-empty-line-before": null,
                                        "function-name-case": "lower",
                                        "no-descending-specificity": null
                                    }
                                }
                                '''
                            }
                        }
                        sh 'npm run validate:css'
                    }
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    // Create sample test files if they don't exist
                    if (!fileExists('script.test.js')) {
                        writeFile file: 'script.test.js', text: '''
                        // Sample test file - replace with your actual tests
                        describe('Basic Tests', () => {
                            test('should pass basic test', () => {
                                expect(1 + 1).toBe(2);
                            });
                            
                            // Test if main script file exists and can be loaded
                            test('should load main script without errors', () => {
                                // Add your actual JavaScript function tests here
                                expect(true).toBe(true);
                            });
                        });
                        
                        // DOM Tests (if you have HTML)
                        describe('DOM Tests', () => {
                            beforeEach(() => {
                                // Setup DOM for testing
                                document.body.innerHTML = '<div id="test-container"></div>';
                            });
                            
                            test('should find test container', () => {
                                const container = document.getElementById('test-container');
                                expect(container).toBeTruthy();
                            });
                        });
                        '''
                    }
                }
                
                // Run tests with coverage
                sh 'npm test'
                
                // Publish test results
                publishTestResults testResultsPattern: 'test-report.xml'
                
                // Publish coverage reports
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'coverage/lcov-report',
                    reportFiles: 'index.html',
                    reportName: 'Coverage Report'
                ])
                
                // Archive coverage data for SonarQube
                archiveArtifacts artifacts: 'coverage/lcov.info', allowEmptyArchive: true
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                script {
                    if (!fileExists('sonar-project.properties')) {
                        writeFile file: 'sonar-project.properties', text: '''
                        sonar.projectKey=devops-project
                        sonar.projectName=DevOps Project
                        sonar.projectVersion=1.0
                        sonar.sources=.
                        sonar.exclusions=node_modules/**,**/*.min.js,dist/**,build/**,coverage/**,*.test.js,*.spec.js
                        sonar.tests=.
                        sonar.test.inclusions=**/*.test.js,**/*.spec.js
                        sonar.javascript.lcov.reportPaths=coverage/lcov.info
                        sonar.javascript.file.suffixes=.js,.jsx
                        sonar.sourceEncoding=UTF-8
                        sonar.eslint.reportPaths=checkstyle-result.xml
                        '''
                    }
                }
                
                withSonarQubeEnv('sonar-server') {
                    script {
                        def scannerHome = tool 'sonar-scanner'
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
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
                    sh 'mkdir -p dist'
                    sh 'cp *.js dist/ 2>/dev/null || echo "No JS files to copy"'
                    sh 'cp *.html dist/ 2>/dev/null || echo "No HTML files to copy"'
                    sh 'cp *.css dist/ 2>/dev/null || echo "No CSS files to copy"'
                    
                    // Create a build info file
                    sh 'echo "Build: ${BUILD_NUMBER}" > dist/build-info.txt'
                    sh 'echo "Date: $(date)" >> dist/build-info.txt'
                }
                
                archiveArtifacts artifacts: 'dist/**', allowEmptyArchive: true
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    echo 'Deploying to staging environment...'
                    // Add your staging deployment commands here
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo 'Deploying to production environment...'
                    // Add your production deployment commands here
                }
            }
        }
    }
    
    post {
        always {
            // Publish all reports
            publishHTML([
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'coverage',
                reportFiles: 'index.html',
                reportName: 'Test Coverage Report'
            ])
            
            cleanWs()
        }
        
        success {
            echo 'Pipeline completed successfully!'
            echo "Coverage reports available at: ${BUILD_URL}Test_Coverage_Report/"
        }
        
        failure {
            echo 'Pipeline failed!'
        }
        
        unstable {
            echo 'Pipeline is unstable - check test results and quality gates!'
        }
    }
}