pipeline {
    agent { label 'built-in'}  // Ensure this agent has Docker + Node + sonar-scanner installed

    environment {
        DOCKERHUB_USER = 'abhinshyam'
        IMAGE_NAME = 'kanbanboard'
        VERSION = "0.01-${BUILD_NUMBER}"
        SONAR_PROJECT_KEY = 'kanbanboard'
        SONARQUBE_TOKEN = credentials('SonarQube')
        SONAR_HOST_URL = 'http://13.217.101.78:9000/'
        
    }
 
    stages {
        stage('Checkout Helm Chart') {
            steps {
                git branch: 'main',
                 url: 'https://github.com/abhin-shyam/Kanbanboard.git'
            }
    }

 
        stage('Deploy to Minikube') {
            steps {
                echo "🚀 Deploying $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG to Minikube"
                sh '''
                helm upgrade --install $HELM_RELEASE $CHART_PATH \
                --namespace $NAMESPACE \
                --set image.repository=$DOCKERHUB_USER/$IMAGE_NAME \
                --set image.tag=$IMAGE_TAG
            '''
        }
    }
 
        stage('Verify Deployment') {
            steps {
                sh '''
                kubectl get pods -n $NAMESPACE
                kubectl get svc -n $NAMESPACE
            '''
            }
        }    
    }
}
