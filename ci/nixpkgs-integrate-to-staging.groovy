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
        stage('checkout') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/nixos-unstable']],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [[$class: 'CheckoutOption',
                                        timeout: 20],
                                       [$class: 'CloneOption',
                                        depth: 0,
                                        noTags: true,
                                        reference: '',
                                        shallow: false,
                                        timeout: 20],
                                       [$class: 'RelativeTargetDirectory',
                                        relativeTargetDir: 'nixos-unstable'],
                                       [$class: 'CleanCheckout'],
                                       [$class: 'SubmoduleOption',
                                        disableSubmodules: false,
                                        parentCredentials: true,
                                        recursiveSubmodules: true,
                                        reference: '',
                                        timeout: 20,
                                        trackingSubmodules: false]],
                          submoduleCfg: [],
                          userRemoteConfigs: [[url: 'https://github.com/NixOS/nixpkgs-channels.git']]])

                checkout([$class: 'GitSCM',
                          branches: [[name: '*/master']],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [[$class: 'CheckoutOption',
                                        timeout: 20],
                                       [$class: 'CloneOption',
                                        depth: 0,
                                        noTags: true,
                                        reference: '',
                                        shallow: false,
                                        timeout: 20],
                                       [$class: 'RelativeTargetDirectory',
                                        relativeTargetDir: 'nix_configs'],
                                       [$class: 'CleanCheckout'],
                                       [$class: 'SubmoduleOption',
                                        disableSubmodules: false,
                                        parentCredentials: true,
                                        recursiveSubmodules: true,
                                        reference: "${WORKSPACE}/nixos-unstable",
                                        timeout: 20,
                                        trackingSubmodules: false]],
                          submoduleCfg: [],
                          userRemoteConfigs: [[credentialsId: 'c3424ba9-afc5-4ed8-a707-2dce64c87a9a',
                                               url: 'git@github.com:coreyoconnor/nix_configs.git']]])
            }
        }
    }
}
