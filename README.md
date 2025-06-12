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
