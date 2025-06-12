# ⚙️ DevOps CI/CD Pipeline for Node.js Web App

This project demonstrates a full CI/CD pipeline for a Node.js web application using **Jenkins**, **SonarQube**, **Trivy**, **Docker**, and **Kubernetes**. It includes automated testing, code coverage, security scanning, containerization, and deployment.

---

## 🛠️ Tech Stack

- **Frontend**: HTML, CSS
- **Backend**: Node.js (Express)
- **CI/CD**: Jenkins
- **Quality Gate**: SonarQube
- **Security**: Trivy
- **Containerization**: Docker
- **Deployment**: Kubernetes (K8s)

---

## 🚀 Pipeline Overview

1. **Code Checkout**  
   Jenkins pulls the code from GitHub/GitLab.

2. **Install Dependencies**  
   ```bash
   npm install


npm test -- --coverage

sonar-scanner

trivy fs . --format html -o trivy-report.html

docker build -t addition1905:tag .

docker push addition1905/devops:tag

kubectl apply -f k8s/deployment.yaml

Post-build Actions

Archive HTML reports from Trivy

📊 Reports
Test Coverage: coverage/lcov-report/index.html

SonarQube: View on SonarQube dashboard

Trivy Report: trivy-report.html archived in Jenkins

✅ Requirements
Jenkins with required plugins (Pipeline, HTML Publisher, SonarQube Scanner)

SonarQube Server running and integrated with Jenkins

Docker installed on Jenkins agents

Trivy installed (either globally or within pipeline)

Kubernetes cluster (minikube, kind, AKS, etc.)

🔐 Security
Trivy scans source code and/or Docker images for vulnerabilities.

SonarQube enforces code quality and security rules.

Secret detection and quality gates prevent unsafe deployments.


📬 Author
DevOps Engineer – Node.js | Docker | Jenkins | K8s
Project by: [Your Name]
Contact: joeladdition@gmail.com


