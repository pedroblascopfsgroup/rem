def notifyEmail(boolean error) {
    def recipientProviders = (error) ? [[$class: 'DevelopersRecipientProvider'], [$class: 'UpstreamComitterRecipientProvider']] : [];
    def toStr = (error) ? env.EMAILS_DESARROLLO_KO : env.EMAILS_DESARROLLO_OK;
    recipientProviders=[]
    if (env.debugEmail?.trim()) {
        toStr=env.debugEmail
    }
    
    def errorAsuntoStr = (error) ? "[ERROR] " : ""
    def asunto="${errorAsuntoStr}Análisis código fuente - ${entorno.toUpperCase()} $proyecto [${env.BUILD_NUMBER}]"
    def cabecera = (error)
     ? """<h3 style="color:red">Ha fallado el análisis sonar ${entorno.toUpperCase()} $proyecto</h3>"""
     : """<h3 style="color:green">Se ha desplegado el entorno ${entorno.toUpperCase()} $proyecto de forma correcta.</h3>"""
    def cuerpo = (error) 
        ? """
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

                script {
                    env.GIT_COMMIT = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%H'").trim()
                    echo "Posicionados en commit: ${GIT_COMMIT}"
                }

            }
        }

        stage('Build') {
            steps {

                withMaven(
                    mavenSettingsConfig: 'pfs-recovery-settings.xml'
                    , globalMavenSettingsConfig: 'pfs-nexus-settings.xml'
                    ) {
                     sh "mvn install:install-file -Dpackaging=pom -Dfile=pom.xml -DpomFile=pom.xml"
                     sh "mvn clean package -Prem -Dmaven.test.skip=true -Dversion=\"${entorno} - ${version} (${GIT_COMMIT})\" surefire-report:report -Daggregate=true"
                    }

            }
        }

        stage('SonarQube analysis') {
             tools {
                jdk 'Java 8'
            }
           steps {
                script {
                    // requires SonarQube Scanner 2.8+
                    def scannerHome = tool 'SonarQube Scanner 2.9.0.6';
                    withSonarQubeEnv('Sonar PFS') {
                        sh "${scannerHome}/bin/sonar-scanner -Dproject.settings=dev-ops/qa/sonar.properties -Dsonar.projectVersion=${hito}"
                    }
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