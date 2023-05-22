pipeline{
    
    agent any 
    
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
    }
}