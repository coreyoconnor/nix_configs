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
        stage('checkout nixpkgs') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [
                        [name: 'nixpkgs/integ'],
                        [name: 'nixpkgs/master']
                    ],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [
                        [$class: 'CheckoutOption', timeout: 20],
                        [$class: 'CloneOption',
                         depth: 0,
                         noTags: true,
                         reference: '',
                         shallow: false,
                         timeout: 20],
                        [$class: 'CleanCheckout'],
                        [$class: 'PreBuildMerge',
                         options: [mergeRemote: 'nixpkgs', mergeTarget: 'master']],
                        [$class: 'RelativeTargetDirectory',
                         relativeTargetDir: 'nixpkgs'],
                    ],
                    submoduleCfg: [],
                    userRemoteConfigs: [
                        [credentialsId: 'c3424ba9-afc5-4ed8-a707-2dce64c87a9a',
                         name: 'nixpkgs',
                         url: 'git@github.com:coreyoconnor/nixpkgs.git']
                    ]
                ])
            }
        }
        stage('checkout nix_configs') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [
                        [name: 'nix_configs/dev**'],
                        [name: 'nix_configs/master'],
                    ],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [
                        [$class: 'SubmoduleOption',
                         disableSubmodules: false,
                         parentCredentials: true,
                         recursiveSubmodules: true,
                         reference: "${WORKSPACE}/nixpkgs",
                         trackingSubmodules: false],
                        [$class: 'CleanCheckout'],
                        [$class: 'PreBuildMerge',
                         options: [mergeRemote: 'nix_configs', mergeTarget: 'master']],
                        [$class: 'RelativeTargetDirectory',
                         relativeTargetDir: 'nix_configs']
                    ],
                    submoduleCfg: [],
                    userRemoteConfigs: [
                        [credentialsId: 'c3424ba9-afc5-4ed8-a707-2dce64c87a9a',
                         name: 'nix_configs',
                         url: 'git@github.com:coreyoconnor/nix_configs.git']
                    ]
                ])
            }
        }
        stage('nix_configs/nixpkgs to nixpkgs master merge') {
            steps {
                dir('nixpkgs') {
                    script {
                        NIXPKGS_SHA = sh([
                            script: "git show-ref --head --dereference --hash --verify HEAD",
                            returnStdout: true
                        ]).trim()
                    }
                }
                dir('nix_configs/nixpkgs') {
                    sh "git fetch ../../nixpkgs"
                    sh "git checkout ${NIXPKGS_SHA}"
                }
            }
        }

        stage("nixos builds") {
            steps {
                script {
                    parallel configBuildStages
                }
            }
        }

        stage("push to master") {
            steps {
                dir('nixpkgs') {
                    sh "git commit && git push nixpgs HEAD:master"
                }
                dir('nix_configs') {
                    sh "git add nixpkgs"
                    sh "git commit nixpkgs -m 'integrate nixpkgs' && git push nix_configs HEAD:master"
                }
            }
        }
    }
}
