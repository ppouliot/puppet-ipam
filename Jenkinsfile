pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile.ubuntu'
    }
    
  }
  stages {
    stage('Build  Compose') {
      steps {
        sh './build.sh'
      }
    }
  }
}