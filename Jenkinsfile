pipeline {
    agent { label 'deploy-node' }
 
    parameters {
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Docker image tag to deploy')
    }
 
    environment {
        DOCKERHUB_USER = 'abhinshyam'
        IMAGE_NAME = 'kanbanboard'
        NAMESPACE = 'default'
        HELM_RELEASE = 'kanbanboard'
        CHART_PATH = './kanbanboard-chart' // path to your Helm chart in repo
    }
 
    stages {
        stage('Checkout Helm Chart') {
            steps {
                git branch: 'Release-minikube',
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
