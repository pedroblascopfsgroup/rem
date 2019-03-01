def notifyEmail(boolean error) {
    def recipientProviders = (error) ? [[$class: 'DevelopersRecipientProvider'], [$class: 'UpstreamComitterRecipientProvider']] : [];
    def toStr = (error) ? env.EMAILS_DESARROLLO_KO : env.EMAILS_DESARROLLO_OK;
    recipientProviders=[]
    if (env.debugEmail?.trim()) {
        toStr=env.debugEmail
    }

    def errorAsuntoStr = (error) ? "[ERROR] " : ""
    def asunto="${errorAsuntoStr}Integración continua - ${entorno.toUpperCase()} $proyecto [${env.BUILD_NUMBER}]"
    def cabecera = """<h3 style="color:red">Ha fallado este trabajo en el entorno ${entorno.toUpperCase()} $proyecto</h3>"""
    def cuerpo = """
        <p><strong>Es muy importante que este problema quede solucionado cuanto antes!!!</strong></p>
        <p>Si tienes alguna duda contacta con tu coordinador.</p>
        <p>Información del error:</p>
        <pre>\${BUILD_LOG, maxLines=400, escapeHtml=false}</pre>
        """
    emailext (
        subject: asunto
        , mimeType: 'text/html' 
        , attachLog: error,
        , body: """
        ${cabecera}
        <p>Tag. referencia: <strong>${env.tagReferencia}</strong> Rama: <strong>${env.version}</strong> Hito: <strong>${env.hito}</strong></p>
        <p>Estos son los componentes afectados por este trabajo:</p>
        <ul>
            <li>Pitertul</li>
            <li>On line</li>
            <li>Procesos</li>
            <li>Configuracion</li>
        </ul>
        <p></p>
        ${cuerpo}
        <p></p>
        <p>Puedes encontrar más información sobre este trabajo en <a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>.</p>
        <p></p>
        <p>A su servicio, <strong>El Mayordomo de PFS</strong></p>
        """
        ,recipientProviders: recipientProviders
        ,to: toStr
        ,replyTo: toStr
    )
}


pipeline {
    
    agent { 
        label env.NODO_JNK
    }

    tools {
        maven 'Maven 3.2.5'
        jdk 'Java 1.6'
    }
    
    environment {
        DIR_SALIDA = '.entregable'
     }

    stages {

        stage("Setup") {
            steps {

                echo """PARAMETROS: tagReferencia: ${env.tagReferencia}
                    tag/version/rama: ${env.version}
                    hito Link: ${env.hito}
                    entorno: ${entorno}
                    """
                
                // Esto es necesario porque sino no descarga bien los módulos
                // no se el porqué.
                sh script: "git rm fwk"
                
                echo "Git init Submodules"
                sh script: "bash ./proyecto-rem-online/dev-ops/common-git-submodule-init.sh ${GIT_USER}"
                
                echo "Comprueba formato y codificación ficheros"
                sh script: "bash ./proyecto-rem-online/dev-ops/common-check-file-format.sh ${GIT_USER}"
                script {
                    env.GIT_COMMIT = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%H'").trim()
                    echo "Posicionados en commit: ${GIT_COMMIT}"
                }

                echo "Fusiona versiones de BPMS"
                sh script: "if [[ -f dev-ops/bpms/fusionar-properties-xmls.sh ]] && [[ -f dev-ops/bpms/versiones-bpms.txt ]] ; then bash ./dev-ops/bpms/fusionar-properties-xmls.sh ./dev-ops/bpms/versiones-bpms.txt ; fi"

            }
        }

        stage('Build') {
            steps {

                withMaven(
                    mavenSettingsConfig: 'pfs-recovery-settings.xml'
                    , globalMavenSettingsConfig: 'pfs-nexus-settings.xml'
                    ) {
                     sh "mvn install:install-file -Dpackaging=pom -Dfile=pom.xml -DpomFile=pom.xml"
                     sh "mvn org.codehaus.mojo:versions-maven-plugin:2.4:set -DnewVersion=${version}"
                    }

                sh "bash ./proyecto-rem-online/dev-ops/common-sencha6-build.sh"
                withMaven(
                    mavenSettingsConfig: 'pfs-recovery-settings.xml'
                    , globalMavenSettingsConfig: 'pfs-nexus-settings.xml'
                    ) {
                     sh "mvn clean package -Prem -Dmaven.test.skip=true -Dversion=\"${entorno} - ${version} (${GIT_COMMIT})\" surefire-report:report -Daggregate=true"
                    }

            }
        }

        stage('Package') {
            steps {
                parallel (
                    "package-config" : { 
                        sh script: "bash ./proyecto-rem-online/dev-ops/package-config.sh -out-dir:${DIR_SALIDA} -entorno:${entorno}"
                    }, "package-pitertul" : {
                        sh script: "bash ./proyecto-rem-online/dev-ops/package-pitertul.sh -tagAnterior:${tagReferencia} -out-dir:${DIR_SALIDA} -entornos:${entorno}"
//                    }, "package-springBatch" : {
//                        sh script: "bash ./proyecto-rem-online/dev-ops/package-spring-batch.sh -version:${version} -out-dir:${DIR_SALIDA} -entorno:${entorno}"
                    }, "package-online" : {
                        sh script: "bash ./proyecto-rem-online/dev-ops/package-online.sh -version:${version} -out-dir:${DIR_SALIDA} -entorno:${entorno}"
                    }, "package-procesos" : {
                        withCredentials([usernameColonPassword(credentialsId: 'jenkins@pfsgroup.es', variable: 'USERPASS')]) {
                            sh script: "bash ./proyecto-rem-online/dev-ops/package-procesos.sh -UPnexus:${env.USERPASS} -out-dir:${DIR_SALIDA} -entorno:${entorno}"
                        }
                    }
                );
            }
        }

    }
    post { 
        failure { 
            notifyEmail(true)
        }
        unstable { 
            notifyEmail(true)
        }
    }

}