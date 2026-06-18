pipeline{
    agent any

    tools {
        jdk 'JDK21'
        maven 'M3'
    }
    environment {
        DOCKERHUB_CRED = credentials('dockerCredentials')
        AWS_CREDENTIAL_NAME = 'awsCredentials'
    }
    stages {
        stage('Git Clone') {
            steps {
                git url: 'https://github.com/zhdl453/spring-petclinic',
                branch: 'main',
                credentialsId: 'gitCredentials'
            }
        }
        // //Maven으로 Build
        //  stage('Maven Build') {
        //      steps{
                 
        //      }
        //  }
        // //Docker 이미지 생성
        // stage('Docker Build && Push'){
        //     steps{
                
        //     }
        // }
        // stage('Upload S3'){
        //     steps{
                
        //     }
        // }
        // stage('Code Deploy'){
        //     steps{
                
        //     }
        // }
        // stage('Docker Image Remove'){
        //     steps{
                
        //     }
        // }
    }
}
