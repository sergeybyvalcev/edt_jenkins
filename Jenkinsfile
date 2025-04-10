pipeline
{
    agent {
        label '1C'
    }
    post {
            always {
                bat "echo always"
            }

            failure {
                bat "echo failure"
            }

            success {
                bat "echo succes"
            }

        }
    stages {
        stage("Build test base") {
            steps {                
                bat "chcp 1251\n vrunner init-dev --v8version 8.3.23.1912 --dt C:\\jenkins\\template\\dev.dt --db-user Teacher --src C:\\repo\\edt_jenkins\\src --ibconnection /F C:\\repo\\edt_jenkins\\build\\ib"
            }
        }
    }
}
