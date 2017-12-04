def notifyEmail(boolean error) {
    def recipientProviders = (error) ? [[$class: 'DevelopersRecipientProvider'], [$class: 'UpstreamComitterRecipientProvider']] : [];
    def toStr = (error) ? env.EMAILS_DESARROLLO_KO : env.EMAILS_DESARROLLO_OK;
    recipientProviders=[]
    if (env.debugEmail?.trim()) {
        toStr=env.debugEmail
    }

    def errorAsuntoStr = (error) ? "[ERROR] " : ""
    def asunto="${errorAsuntoStr}Despliegue continuo - ${entorno.toUpperCase()} $proyecto [${env.BUILD_NUMBER}]"
    def cabecera = (error)
     ? """<h3 style="color:red">Ha fallado el despliegue en el entorno ${entorno.toUpperCase()} $proyecto</h3>"""
     : """<h3 style="color:green">Se ha desplegado el entorno ${entorno.toUpperCase()} $proyecto de forma correcta.</h3>"""
    def cuerpo = (error) 
        ? """
        <p><strong>Es muy importante que este problema quede solucionado cuanto antes!!!</strong></p>
        <p>Si tienes alguna duda contacta con tu coordinador.</p>
        <p>Información del error:</p>
        <pre>\${BUILD_LOG, maxLines=400, escapeHtml=false}</pre>
        """
        : ""
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
        <p>Puedes encontrar más información sobre el despliegue en <a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>.</p>
        <p></p>
        <p>A su servicio, <strong>El Mayordomo de PFS</strong></p>
        """
        ,recipientProviders: recipientProviders
        ,to: toStr
        ,replyTo: toStr
    )
}

def deployPitertul(String host, int port) {
    dir (".entregable") {
        script {

            if (fileExists('pitertul.zip')) {
                echo "Desplegando PITERTUL..."
                sh script: "bash ../proyecto-rem-online/dev-ops/common-upload-SSH.sh -host:"+host+" -cliente:rem -componente:pitertul -custom-dir:${entorno}"

                withCredentials([string(credentialsId: 'password-BBDD-producto', variable: 'PASSWORD')]) {
                    echo "Running scripts [${entorno}]... - no lanzamos scripts de BI"
                    sh script: "ssh -o StrictHostKeyChecking=no "+host+" \"cd deploy/rem/${entorno}/pitertul;bash ./deploy-pitertul.sh -entorno:${entorno} -Xapp:si -Xbi:no -Xgrants:si -Pmaster:${PASSWORD} -Pentity01:${PASSWORD} -Pdwh:${PASSWORD} -Psystempfs:${PASSWORD}\""
                }

            }
            
        }
    }
}

pipeline {
    
    agent { 
        label 'JNK02-ACTITUD'
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

            }
        }

        stage('Package') {
            steps {
                sh script: "bash ./proyecto-rem-online/dev-ops/package-pitertul.sh -tagAnterior:${tagReferencia} -out-dir:${DIR_SALIDA} -entornos:${entorno}"
            }
        }

        stage('Update-DB') {
            steps {
                deployPitertul("ops-bd@iap03", 22)
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