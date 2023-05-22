pipeline{
    
    agent any 
    
    stages {
        
        
        stage('Sonar quality check'){
            
            steps{
                agent{
                    docker{
                        image 'maven'
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
        
}