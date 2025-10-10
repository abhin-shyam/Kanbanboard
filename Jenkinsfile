pipeline {
    agent { label 'deploy-node' }  // Ensure this agent has Docker + Node + sonar-scanner installed

    environment {
        DOCKERHUB_USER = 'abhinshyam'
        IMAGE_NAME = 'kanbanboard'
        VERSION = "0.01-${BUILD_NUMBER}"
        SONAR_PROJECT_KEY = 'kanbanboard'
        SONARQUBE_TOKEN = credentials('SonarQube')  // Define this in Jenkins Global Tool Config
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Scan') {
            steps {
        script {
          // This name must match the *Server name* under "Configure System" > "SonarQube servers"
          withSonarQubeEnv('SonarQube') {
            sh '''
              sonar-scanner \
                -Dsonar.projectKey="$SONAR_PROJECT_KEY" \
                -Dsonar.sources=. \
                -Dsonar.projectVersion="$VERSION" \
                -Dsonar.sourceEncoding=UTF-8
            '''
              }
            }

            }
        }

        stage('Wait for Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true  // Fail pipeline if quality gate fails
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🔧 Building Docker image..."
                sh '''
                    docker build -t $DOCKERHUB_USER/$IMAGE_NAME:$VERSION .
                '''
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                    docker push $DOCKERHUB_USER/$IMAGE_NAME:$VERSION
                '''
            }
        }

        stage('Trigger Deployment Pipeline') {
            steps {
                echo "✅ Image pushed successfully! Triggering deployment..."
                build job: 'kanban-deploy-pipeline', parameters: [
                    string(name: 'IMAGE_TAG', value: "${VERSION}")
                ]
            }
        }
    }

    post {
        failure {
            echo "❌ Build failed. Deployment not triggered."
        }
    }
}
