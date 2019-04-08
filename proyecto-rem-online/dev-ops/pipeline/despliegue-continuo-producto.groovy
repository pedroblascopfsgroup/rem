def notifyEmail(boolean error) {
    def proyecto="REM"

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

def deployFrontal(String host, int port) {
    dir ('.entregable') {
        if (fileExists('online.zip')) {
            echo "Subiendo CONFIGURACION..."
            sh script: "bash ../proyecto-rem-online/dev-ops/common-upload-SSH.sh -host:"+host+" -port:"+port+" -cliente:rem -componente:config"
            echo "Desplegando ONLINE..."
            sh script: "bash ../proyecto-rem-online/dev-ops/common-upload-SSH.sh -host:"+host+" -port:"+port+" -cliente:rem -componente:online -deploy:true"
        }
    }
}

def deploySpringBatch(String host, int port) {
    dir ('.entregable') {
        if (fileExists('spring-batch.zip')) {
            echo "Subiendo CONFIGURACION..."
            sh script: "bash ../proyecto-rem-online/dev-ops/common-upload-SSH.sh -host:"+host+" -port:"+port+" -cliente:rem -componente:config"
            echo "Desplegando SPRING-BATCH..."
            sh script: "bash ../proyecto-rem-online/dev-ops/common-upload-SSH.sh -host:"+host+" -port:"+port+" -cliente:ren -componente:spring-batch -deploy:true"
        }
    }
}

def deployProcesos(String host, int port) {
    dir ('.entregable') {
        if (fileExists('procesos.zip')) {
            echo "Subiendo CONFIGURACION..."
            sh script: "bash ../proyecto-rem-online/dev-ops/common-upload-SSH.sh -host:"+host+" -port:"+port+" -cliente:rem -componente:config"
            echo "Desplegando PROCESOS..."
            sh script: "bash ../proyecto-rem-online/dev-ops/common-upload-SSH.sh -host:"+host+" -port:"+port+" -cliente:rem -componente:procesos -deploy:true"
        }
    }
}

def deployPitertul(String host, int port) {
    dir (".entregable") {
        script {

            if (fileExists('pitertul.zip')) {
                echo "Desplegando PITERTUL..."
                sh script: "bash ../proyecto-rem-online/dev-ops/common-upload-SSH.sh -host:"+host+" -cliente:rem -componente:pitertul -custom-dir:${entorno}"

                withCredentials([string(credentialsId: 'password-BBDD-producto', variable: 'PASSWORD')]) {
                    echo "Running scripts [${entorno}]... DEFECTO - ejecutamos script de todo"
                    sh script: "ssh -o StrictHostKeyChecking=no "+host+" \"cd deploy/rem/${entorno}/pitertul;bash ./deploy-pitertul.sh -entorno:${entorno} -Xapp:si -Xbi:si -Xgrants:si -Pmaster:${PASSWORD} -Pentity01:${PASSWORD} -Pdwh:${PASSWORD} -Psystempfs:${PASSWORD}\""
                }

            }
            
        }
    }
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
                     sh "mvn clean package -Prem,java7 -Dmaven.test.skip=true -Dversion=\"${entorno} - ${version} (${GIT_COMMIT})\" surefire-report:report -Daggregate=true"
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

        stage('Update-DB') {
            steps {
                deployPitertul("ops-bd@iap03", 22)
                build job: 'rem-bd-auxiliares', wait: false
            }
        }

        stage('Deploy') {
            steps {
                timeout (time:10, unit:'MINUTES') {
                    deployFrontal("recovecp@iap01", 2228)
                }
                timeout (time:5, unit:'MINUTES') {
                    deployProcesos("recovecb@iap01", 2228)
                }
            }
            
            post { 
                success { 
                    notifyEmail(false)
                }
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
