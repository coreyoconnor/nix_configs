def configs = [
    'agh',
    'grr'
]

def generateBuildStage(name) {
    return {
        stage("computer config ${name}") {
            sh "./nix_configs/ci/build-computer-config ${name}"
        }
    }
}

def configBuildStages = configs.collectEntries {
    ["${it}" : generateBuildStage(it) ]
}

def NIXPKGS_SHA = null

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
        stage('checkout nix_configs') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [
                        [name: 'origin/master']
                    ],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [
                        [$class: 'SubmoduleOption',
                         disableSubmodules: false,
                         parentCredentials: true,
                         recursiveSubmodules: true,
                         trackingSubmodules: false],
                        [$class: 'CleanCheckout'],
                        [$class: 'PreBuildMerge',
                         options: [mergeRemote: 'origin', mergeTarget: 'dev']],
                        [$class: 'RelativeTargetDirectory',
                         relativeTargetDir: 'nix_configs']
                    ],
                    submoduleCfg: [],
                    userRemoteConfigs: [
                        [credentialsId: 'c3424ba9-afc5-4ed8-a707-2dce64c87a9a',
                         name: 'origin',
                         url: 'git@github.com:coreyoconnor/nix_configs.git']
                    ]
                ])
            }
        }

        stage("nixos builds") {
            steps {
                script {
                    parallel configBuildStages
                }
            }
        }

        stage("push to dev") {
            steps {
                dir('nix_configs') {
                    sh "git push origin HEAD:dev"
                }
            }
        }
    }
}
