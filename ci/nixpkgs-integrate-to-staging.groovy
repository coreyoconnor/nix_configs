pipeline {
  agent any

  options {
    disableConcurrentBuilds()
    timeout(time: 12, unit: 'HOURS')
    buildDiscarder logRotator(daysToKeepStr: '60', numToKeepStr: '100')
  }
}
