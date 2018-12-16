def canaries = [
    'hello',
    'rustc',
    'godot',
    'kdenlive',
    'qgis'
]

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
                        [name: 'refs/remotes/upstream/nixos-unstable'],
                        [name: 'refs/remotes/origin/master'],
                        [name: 'refs/remotes/origin/dev**'],
                        [name: 'refs/remotes/origin/integ']
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
                         options: [mergeRemote: 'origin', mergeTarget: 'integ']],
                        [$class: 'RelativeTargetDirectory',
                         relativeTargetDir: 'nixpkgs'],
                    ],
                    submoduleCfg: [],
                    userRemoteConfigs: [
                        [credentialsId: 'c3424ba9-afc5-4ed8-a707-2dce64c87a9a',
                         name: 'origin',
                         url: 'git@github.com:coreyoconnor/nixpkgs.git'],
                        [name: 'upstream',
                         url: 'https://github.com/NixOS/nixpkgs-channels.git']
                    ]
                ])
            }
        }
        stage('checkout nix_configs') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/dev']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [
                        [$class: 'SubmoduleOption',
                         disableSubmodules: false,
                         parentCredentials: false,
                         recursiveSubmodules: false,
                         reference: "${WORKSPACE}/nixpkgs",
                         trackingSubmodules: false],
                        [$class: 'CleanCheckout'],
                        [$class: 'PathRestriction',
                         excludedRegions: '',
                         includedRegions: """overlays/
                                            |ci/""".stripMargin()],
                        [$class: 'RelativeTargetDirectory',
                         relativeTargetDir: 'nix_configs']
                    ],
                    submoduleCfg: [],
                    userRemoteConfigs: [
                        [credentialsId: 'c3424ba9-afc5-4ed8-a707-2dce64c87a9a',
                         name: 'nix_configs-origin',
                         url: 'git@github.com:coreyoconnor/nix_configs.git']
                    ]
                ])
            }
        }

        stage("build canary nixpkgs derivations") {
            steps {
                  sh "./nix_configs/ci/build-with-overlays ${WORKSPACE}/nixpkgs hello"
            }
        }
    }
}
