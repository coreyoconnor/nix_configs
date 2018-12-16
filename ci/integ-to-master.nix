def canaries = [
    'simple'
    'docker'
    'gnome3'
    'firefox'
    'jenkins'
    'transmission'
    'plasma5'
    'postgis'
]

def generateTestStage(name) {
    return {
        stage("test ${name}") {
            sh "./nix_configs/ci/test-with-overlays ${WORKSPACE}/nixpkgs/nixos ${name}"
        }
    }
}

def testStages = canaries.collectEntries {
    ["${it}" : generateTestStage(it) ]
}

pipeline {
    agent any

    triggers {
        pollSCM('*/2 * * * *')
    }

    options {
        disableConcurrentBuilds()
        timeout(time: 12, unit: 'HOURS')
        buildDiscarder logRotator(daysToKeepStr: '60', numToKeepStr: '100')
    }

    stages {
    }
}
