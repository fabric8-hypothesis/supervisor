#!/usr/bin/env groovy
@Library('github.com/msrb/cicd-pipeline-helpers')

def commitId

node {
    def image = docker.image('fabric8-hdd/openshift-hdd-supervisor')
    stage('Checkout') {
        checkout scm
        commitId = sh(
            returnStdout: true,
            script: 'git rev-parse --short HEAD'
        ).trim()
        dir('openshift') {
            stash name: 'template',
            includes: 'template.yaml'
        }
    }
    stage('Run UTs') {
        sh 'npm install'
        sh 'npm test'
    }
    stage('Build and tag docker image') {
        docker.build(image.id, '--pull --no-cache .')
        sh "docker tag ${image.id} registry.devshift.net/${image.id}"
        docker.build('supervisor-tests', '-f Dockerfile.tests .')
    }
    stage('Push image') {
        docker.withRegistry(
            'https://push.registry.devshift.net/',
            'devshift-registry'
        ) {
            image.push('latest')
            image.push(commitId)
        }
    }
}
if (env.BRANCH_NAME == 'master') {
    node {
        stage('Deploy - Stage') {
            unstash 'template'
            sh "oc --context=rh-idev process -v IMAGE_TAG=${commitId} -f template.yaml | oc --context=rh-idev apply -f -"
        }
    }
}
