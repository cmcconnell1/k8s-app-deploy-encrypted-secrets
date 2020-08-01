pipeline {
    agent any
    environment {
        CI = 'true'
    }
    stages {

        // if you are using git-crypt you must unlock the repo with the key
        stage('git-crypt unlock repo') {
            steps {
                script {
                    sh("[ -f $WORKSPACE/bin/git-crypt ] || mkdir -p $WORKSPACE/bin && cp /usr/local/bin/git-crypt $WORKSPACE/bin/git-crypt")
                    sh("[ -f $WORKSPACE/.git-crypt/keys/myapp-deploy.key ] || mkdir -p $WORKSPACE/.git-crypt/keys && cp /var/lib/jenkins/.git-crypt-keys/myapp-deploy.key $WORKSPACE/.git-crypt/keys/myapp-deploy.key")
                    sh("$WORKSPACE/bin/git-crypt unlock $WORKSPACE/.git-crypt/keys/myapp-deploy.key")
                }
            }
        }

        stage('Deploy to DEV using kubeconfig-myapp') {
            when { 
                branch 'development' 
            }
            steps {
                script {
                    withAWS(region:'us-west-2') {
                        sh """
			                ./build-development-myapp-manifests
                            export KUBECONFIG=/var/lib/jenkins/.kube/dev-usw2/kubeconfig-myapp
                            ./secrets/development/myapp.secrets && true
                            for i in `seq 1 10`; do \
                            kubectl -n myapp apply --recursive -f ./manifests/development && break || \
                            sleep 10; \
                            done; \
                        """
                    }    
                }
            }
        }
    }
}

// NOTE: use the same logic for above development branch/env and substitute requisite vars/paths for stage and production branches/environments

//        stage('Deploy to STAGE') {
//            when {
//                branch 'staging'  
//            }
//            steps {
//                script {
//                    withAWS(region:'us-west-2') {
//                        sh """
//                            for i in `seq 1 10`; do \
//                            kubectl -n myapp-stage --kubeconfig=/var/lib/jenkins/.kube/kubeconfig-ci apply --recursive -f ./manifests/staging && break || \
//                            sleep 10; \
//                            done; \
//                        """
//                    }    
//                }
//            }
//        }
//        stage('Deploy to PROD') {
//            when {
//                branch 'production'  
//            }
//            steps {
//                script {
//                    withAWS(region:'us-west-2') {
//                        sh """
//                            for i in `seq 1 10`; do \
//                            kubectl -n myapp-prod --kubeconfig=/var/lib/jenkins/.kube/kubeconfig-ci apply --recursive -f ./manifests/production && break || \
//                            sleep 10; \
//                            done; \
//                        """
//                    }    
//                }
//            }
//        }
//   }
//}
