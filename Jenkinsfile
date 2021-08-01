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
                sleep(5)
                timeout(time: 1, unit: 'MINUTES'){
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Deploy Backend'){
            steps {
                deploy adapters: [tomcat8(credentialsId: 'ID_TOMCAT', path: '', url: 'http://localhost:8081/')], contextPath: 'tasks-backend', war: 'target/tasks-backend.war'
            }
        }
        stage('API Test'){
            steps {
                dir('api-test') {
                    git branch: 'main', url: 'https://github.com/leltonborges/task-api-test.git'
                    sh 'mvn test'
                }
            }
        }
        stage('Deploy FrontEnd'){
            steps {
                dir('tasks-front'){
                    git branch: 'master', url: 'https://github.com/leltonborges/tasks-frontend.git'
                    sh 'mvn clean package'
                    deploy adapters: [tomcat8(credentialsId: 'ID_TOMCAT', path: '', url: 'http://localhost:8081/')], contextPath: 'tasks', war: 'target/tasks.war'

                }
            }
        }
        stage('Functional Test'){
            steps {
                dir('functional-test'){
                    git branch: 'main', url: 'https://github.com/leltonborges/tasks-functional-tests.git'
                    sh 'mvn clean test'
                }
            }
        }
    }
}
