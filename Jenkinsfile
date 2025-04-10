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
                bat "chcp 65001\n vrunner init-dev --dt C:\\jenkins\\template\\dev.dt --db-user Teacher --src C:\\repo\\edt_jenkins\\src"
            }
        }
    }
}
