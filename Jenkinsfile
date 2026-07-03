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
         stage('Maven Build') {
             steps{
                 sh 'mvn clean package -DskipTests'
             }
         }
        // //Docker 이미지 생성
        stage('Docker Build && Push'){
            steps{
                sh '''
                docker build -t spring-petclinic:${BUILD_NUMBER} .
                docker tag spring-petclinic:${BUILD_NUMBER} zhdl453/spring-petclinic:latest
                echo ${DOCKERHUB_CRED_PSW} | docker login -u ${DOCKERHUB_CRED_USR} --password-stdin
                docker push zhdl453/spring-petclinic:latest
                '''
            }
        }
        
        stage('Docker Image Remove'){
            steps{
                sh '''
                docker rmi -f zhdl453/spring-petclinic:latest
                docker rmi -f zhdl453/spring-petclinic:${BUILD_NUMBER}
                '''
            }
        }
        stage('Upload S3'){
            steps{
                dir("${env.WORKSPACE}"){
                    sh 'zip -r scripts.zip ./scripts appspec.yml'
                    withAWS(region: "ap-northeast-2", credentials: "${AWS_CREDENTIAL_NAME}"){
                        s3Upload(file: "scripts.zip", bucket: "std05-app-bucket")
                    }
                    sh 'rm -rf scripts.zip'
                }
            }
        }
        stage('Code Deploy'){
            steps{
                withAWS(region: "ap-northeast-2", credentials: "${AWS_CREDENTIAL_NAME}"){
                    sh'''
                    aws deploy create-deployment-group \
                    --application-name std05-exercise \
                    --auto-scaling-groups std05-was-asg \
                    --deployment-group-name std05-exercise-${BUILD_NUMBER} \
                    --deployment-config-name CodeDeployDefault.OneAtATime \
                    --service-role-arn arn:aws:iam::491085389788:role/std05-codedeploy-service-role \
                    '''
                    sh '''
                    aws deploy create-deployment --application-name std05-exercise \
                    --deployment-config-name CodeDeployDefault.OneAtATime \
                    --deployment-group-name std05-exercise-${BUILD_NUMBER} \
                    --s3-location bucket=std05-app-bucket,bundleType=zip,key=scripts.zip
                    '''
                    sleep(10)
                }
            }
        }
    }
}
