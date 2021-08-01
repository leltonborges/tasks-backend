pipeline {
    agent any
    stages{
        stage ('Build BackEnd') {
            steps {
                sh 'mvn clean package -DskipTests=true'
            }
        }
        stage('Unit Tests'){
            steps {
                sh 'mvn test'
            }
        }
        stage('Sonar Analysis'){
            environment{
                scannerHome = tool 'SONAR_QUBE_SCAN'
            }
            steps{
                withSonarQubeEnv('SONAR_LOCAL'){
                    sh "${scannerHome}/bin/sonar-scanner -e -Dsonar.projectKey=DeployBack -Dsonar.host.url=http://localhost:9005 -Dsonar.login=1029de84f04152237fc402eedecf775fb676e4b4 -Dsonar.java.binaries=target -Dsonar.coverage.exclusions=**/.mvn/**,**/src/test/**,**/model/**,**Application.java,**RootController.java"
                }
            }
        }
        stage('Quality Gate'){
            steps {
                timeout(time: 1, unit: 'MINUTES'){
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}

