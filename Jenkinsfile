pipeline {
    agent {
        label 'ubuntu-latest'
    }

    environment {
        NODE_ENV = 'offline'
        NODE_OPTIONS = '--openssl-legacy-provider'
        NETLIFY_AUTH_TOKEN = credentials('netlify-auth-token') // Assume you have added this secret to Jenkins
        NETLIFY_SITE_ID = credentials('netlify-site-id') // Assume you have added this secret to Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set up Node.js') {
            steps {
                sh 'curl -sL https://deb.nodesource.com/setup_16.x | bash -'
                sh 'sudo apt-get install -y nodejs'
                sh 'node -v'
                sh 'npm -v'
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Build assets') {
            steps {
                sh 'NODE_OPTIONS=--openssl-legacy-provider CI=false npm run build'
            }
        }

        stage('Install Netlify CLI') {
            steps {
                sh 'npm install -g netlify-cli'
            }
        }

        stage('Deploy to Netlify') {
            steps {
                script {
                    def commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                    sh "netlify deploy --prod --dir=./public --message \"Prod deploy ${env.GIT_BRANCH}\" --site ${env.NETLIFY_SITE_ID}"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

