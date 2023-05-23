pipeline{
    
    agent any 

    environment {
        
        VERSION = "${env.BUILD_ID}"
    }
    
    stages {
        stage('Sonar quality check'){
                agent{
                    docker{
                        image 'maven'
                        args '-u root'
                    }
                }
                steps{

                    script{
                        
                        withSonarQubeEnv(credentialsId: 'sonar-token') {
                            
                            sh 'mvn clean package sonar:sonar'
                        }
                    }
                }              
        }

        stage('Quality Gate status'){

            steps{

                script{

                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }

        stage('docker build & docker push to Nexus repo'){

            steps{

                script{
                    withCredentials([string(credentialsId: 'nexus_passwd', variable: 'nexus_creds')]) {
                        sh """ 
                            docker build -t 34.207.166.180:8083/springapp:${VERSION} .

                            docker login -u admin -p $nexus_creds 34.207.166.180:8083

                            docker push 34.207.166.180:8083/springapp:${VERSION}

                            docker rmi 34.207.166.180:8083/springapp:${VERSION}
                        """
                    }
                    
                }
            }
        }
        // stage('Identifying misconfigs using datree in helm charts'){

        //     steps{ 
        //         script{
        //             dir('kubernetes/myapp'){
        //                 withEnv(['DATREE_TOKEN=d5a46d29-d3e1-4148-a3a9-e0e2bd13c42b']){
        //                     sh 'helm datree test .' 
        //                 }
        //             }
        //         }
        //     }
        // }

        stage('Pushing the helm charts to nexus repo'){
            steps{
                script{
                    withCredentials([string(credentialsId: 'nexus_passwd', variable: 'nexus_creds')]) {
                        dir('kubernetes/'){
                            sh """
                            helmversion=$(helm show chart myapp | grep version | cut -d: -f 2 | tr -d ' ')
                            tar -czvf myapp-${helmversion}.tgz myapp/
                            curl -u admin:$nexus_creds http://34.207.166.180:8081/repository/helm-hosted/ --upload-file myapp-${helmversion}.tgz -v'
                            """
                        }
                    }
                }
            }
        }


    }
    post{
        always{
            mail bcc: '', body:"<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc:'', charset: "UTF-8", from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "mohamedrhimi103@gmail.com";
        }
    }
}