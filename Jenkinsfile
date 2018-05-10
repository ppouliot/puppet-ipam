node {
  deleteDir()
  checkout scm
  echo 'begin puppet-ipam deployment workflow....'

  stage 'puppet run in multiplatform containers'
  echo 'running project build script to launch multiplatform container builds to ensure code execution across linux  distributions...'
  sh './build.sh -d'

  stage 'vagrant ipam1 build'
  echo 'deploying first ipam host'
  sh 'vagrant up ipam1'

  stage 'validate ipam1' 
  echo 'TEST EXECUTION FOR IPAM1 GOES HERE !!!!'
  
  stage 'vagrant ipam2 build'
  sh 'vagrant up ipam1'

  stage 'validate ipam2' 
  echo 'TEST EXECUTION FOR IPAM2 GOES HERE !!!!'

  stage 'deploy'
  echo 'deploy to puppet master'

}  
