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

    stage('Docker Login, Build & Push') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-credentials',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          script {
            // Docker login
            sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'

            // Determine repo name
            def repo = (env.BRANCH_NAME == "dev") ? "dev" : "prod"
            def versionTag = "${DOCKER_USER}/${repo}:${env.BUILD_NUMBER}"
            def latestTag = "${DOCKER_USER}/${repo}:latest"

            echo "🔧 Building Docker Image: $versionTag"
            sh "BUILD_NUMBER=${env.BUILD_NUMBER} DOCKER_USER=${DOCKER_USER} ./build.sh ${env.BRANCH_NAME}"

            echo "🏷️ Tagging image as latest"
            sh "docker tag ${versionTag} ${latestTag}"

            echo "📤 Pushing Docker Images: $versionTag and $latestTag"
            sh "docker push ${versionTag}"
            sh "docker push ${latestTag}"
          }
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
