def SUFFIX = ''

pipeline {
    agent any

    parameters {
        string (name: 'VERSION_PREFIX', defaultValue: '0.0.0', description: 'puppet-ipam version')
    }
    environment {
        BUILD_TAG = "${env.BUILD_TAG}".replaceAll('%2F','_')
        BRANCH = "${env.BRANCH_NAME}".replaceAll('/','_')
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '30'))
    }
    stages {
        stage ('Use the Puppet Development Kit Validation to Check for Linting Errors') {
            steps {
                sh ''
            }
        }
        stage ('Checkout and build puppet-ipam in Docker to validate code as well as changes across OSes.') {
            steps {
                dir('build_puppet_module_puppet-ipam') {
                    sh './build -d'
                }
            } 
        }
        stage ('Checkout and build puppet-ipam in Vagrant to assemble a functional IPAM cluster') {
            steps {
                dir('build_menu') {

                    sh './build.sh -v'
                }
            } 
        }
        
        stage ('Cleanup vagrant after successful build.') {
            steps {
                sh 'vagrant destroy -f'
            }
        }

    } 
}
