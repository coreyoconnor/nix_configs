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
                dir('nixpkgs') {
                    git(url: 'https://github.com/NixOS/nixpkgs-channels.git',
                        branch: 'nixos-unstable',
                        poll: true)
                }
                dir('nix_configs') {
                    git(url: 'git@github.com:coreyoconnor/nix_configs.git',
                        branch: 'master',
                        credentials: 'c3424ba9-afc5-4ed8-a707-2dce64c87a9a',
                        poll: true)
                }
            }
        }
    }
}
