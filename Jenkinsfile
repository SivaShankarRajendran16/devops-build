pipeline {
  agent any

  environment {
    APP_NAME = "my-nginx-app"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Login to DockerHub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-credentials',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
        }
      }
    }
  }

    stage('Build Docker Image') {
      steps {
        script {
          def repo = (env.BRANCH_NAME == "dev") ? "dev" : "prod"
          def image = "${DOCKER_USER}/${repo}:${env.BUILD_NUMBER}"
          echo "🔧 Building Docker Image: $image"
          sh "BUILD_NUMBER=${env.BUILD_NUMBER} DOCKER_USER=${DOCKER_USER} ./build.sh ${env.BRANCH_NAME}"
        }
      }
    }

    stage('Push Docker Image') {
      steps {
        script {
          def repo = (env.BRANCH_NAME == "dev") ? "dev" : "prod"
          def image = "${DOCKER_USER}/${repo}:${env.BUILD_NUMBER}"
          echo "📤 Pushing Image: $image"
          sh "docker push $image"
        }
      }
    }

    stage('Deploy the App') {
      when {
        branch 'main'
      }
      steps {
        echo "🚀 Deploying app from main branch..."
        sh './deploy.sh'
      }
    }
  }

  post {
    success {
      echo "✅ Successfully built and pushed for ${env.BRANCH_NAME}"
    }
    failure {
      echo "❌ Build failed for ${env.BRANCH_NAME}"
    }
  }
}
