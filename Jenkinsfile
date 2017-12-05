#!/usr/bin/env groovy
@Library('github.com/msrb/cicd-pipeline-helpers')

def commitId

node {
    def image = docker.image('anmolbabu/supervisor')
    stage('Checkout') {
        checkout scm
        commitId = sh(
            returnStdout: true,
            script: 'git rev-parse --short HEAD'
        ).trim()
    }
    stage('Run UTs') {
        sh 'npm install'
        sh 'nohup npm start & > /dev/null'
        sh 'npm test'
    }
    stage('Build and tag docker image') {
        docker.build(image.id, '--pull --no-cache .')
        sh "docker tag ${image.id} hub.docker.com/${image.id}"
        docker.build('supervisor-tests', '-f Dockerfile.tests .')
    }
    stage('Push image') {
        docker.withRegistry(
            'https://registry.hub.docker.com', 
            'docker-credentials'
        ) {
            image.push('latest')
            image.push(commitId)
        }
    }
}