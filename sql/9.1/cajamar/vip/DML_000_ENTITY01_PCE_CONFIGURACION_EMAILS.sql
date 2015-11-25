--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150824
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=CMREC-415
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar los gestores en las tareas para HRE-BCC
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE

	/*
    * CONFIGURACION: IDENTIDAD SCRIPT
    *---------------------------------------------------------------------
    */
    PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Gestión de emails en los trámites de concurso';   -- [PARAMETRO] Título del trámite
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'Alberto';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'alberto.campos@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2034';                              -- [PARAMETRO] Teléfono del autor

    /*
    * CONFIGURACION: TABLAS
    *---------------------------------------------------------------------
    */    
    PAR_TABLENAME_TARPR VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';     -- [PARAMETRO] TABLA para tareas del procedimiento. Por defecto TAP_TAREA_PROCEDIMIENTO
    
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones
    V_CODIGO1_PCE VARCHAR2(100 CHAR); -- Variable para nombre campo1
    V_CODIGO2_PCE VARCHAR2(100 CHAR); -- Variable para nombre campo2
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
       
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    
    --Insertando valores en dd_PCE_fichero_adjunto
    TYPE T_TIPO_VALOR IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_PCE IS TABLE OF T_TIPO_VALOR;
    V_TIPO_PCE T_ARRAY_PCE := T_ARRAY_PCE(

		T_TIPO_VALOR('H021_AutoDeclarandoConcurso','StaffJuridicoConsultoriayContratacion@cajamar.int,administracioncontab@cajamar.int','AUTO DECLARACION DE CONCURSO','ESTIMADOS COMPAÑEROS OS REMITIMOS AUTO DE DECLARACION DE CONCURSO (O BOE EN SU CASO) PARA VUESTRO CONOCIMIENTO Y PROCEDER','HRE,DCSS')
		,T_TIPO_VALOR('CJ005_RecepcionarComunicacionMediador','StaffJuridicoConsultoriayContratacion@cajamar.int,AnalisisdeRecuperacion@cajamar.int','CORREO ACUERDO EXTRAJUDICIAL DE PAGOS','ESTIMADO COMPAÑEROS OS REMITIMOS ACUERDO EXTRAJUDICIAL DE PAGOS PARA VUESTRO CONOCIMIENTO Y ACTUACION DE CONFORMIDAD CON EL CORREO EXPLICATIVO DE Control de GestiónSEGUIMIENTO Y RECUPERACIÓN DE RIESGOSDEL 9/7/15','')
		,T_TIPO_VALOR('CJ006_AutoReaperturaConcurso','StaffJuridicoConsultoriayContratacion@cajamar.int,administracioncontab@cajamar.int','DECLARACION DE INCUMPLIMIENTO DE CONVENIO','ESTIMADOS COMPAÑEROS, OS REMITIMOS RESOLUCION QUE DECLARA EL INCUMPLIMIENTO DE CONVENIO','')
		,T_TIPO_VALOR('H009_RegistrarPublicacionBOE','StaffJuridicoConsultoriayContratacion@cajamar.int,administracioncontab@cajamar.int','BOE DECLARACION CONCURSO','ESTIMADOS COMPAÑEROS, OS REMITIMOS BOE DECLARANDO EL CONCURSO DEL ACREDITADO DE REFERENCIA','')
		,T_TIPO_VALOR('H027_RegistrarResultadoAcuerdo','ServiciosJuridicosConcursal@bcc.es','RESULTADO ACUERDO HOMOLOGACION','ACUERDO SI/NO','')
		,T_TIPO_VALOR('H043_AutoDeclarandoConcurso','ControldegestionHaya@cajamar.int,StaffJuridicoConsultoriayContratacion@cajamar.int,administracioncontab@cajamar.int','AUTO DECLARANDO LA REAPERTURA DEL CONCURSO','ESTIMADOS COMPAÑEROS OS REMITIMOS AUTO DE DECLARACION LA REAPERTURA DEL CONCURSO PARA VUESTRO CONOCIMIENTO Y PROCEDER','')
		,T_TIPO_VALOR('CJ002_RegistrarAcuerdoAprobado','StaffJuridicoConsultoriayContratacion@cajamar.int,administracioncontab@cajamar.int','RESOLUCION HOMOLOGACION ACUERDO','OS ADJUNTAMOS RESOLUCION HOMOLOGACION PARA VUESTRO CONOCIMIENTO Y PROCEDER','')
		,T_TIPO_VALOR('CJ002_ComunicacionMediador','ControldegestionHaya@cajamar.int,HAYA–PRECONTENCIOSO-CONCURSAL@cajamar.int','CORREO RECIBIDO DEL MEDIADOR PARA VUESTRO CONOCIMIENTO Y CONTACTO CON EL','ESTIMADOS COMPAÑEROS OS REMITIMOS CORREO RECIBIDO DEL MEDIADOR CONCURSAL A LOS EFECTOS DE COMUNICAR DEUDA Y PROCEDER A CONTACTAR CON EL PARA POSICIONAMIENTO EN REUNION A MANTENER','')
		,T_TIPO_VALOR('H041_registrarConvenio','StaffJuridicoConsultoriayContratacion@cajamar.int,administracioncontab@cajamar.int','SENTENCIA APROBANDO CONVENIO','OS ADJUNTAMOS SENTENCIA APROBANDO CONVENIO PARA VUESTRO CONOCIMIENTO Y PROCEDER','')

	); 
    V_TMP_TIPO_PCE T_TIPO_VALOR;
    
BEGIN	
  
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con PCE_CONFIGURACION_EMAILS');  
  /*
    * LOOP ARRAY BLOCK-CODE: PCE_CONFIGURACION_EMAILS
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := 'PCE_CONFIGURACION_EMAILS';
    V_CODIGO1_PCE := 'TAP_CODIGO';
    V_CODIGO2_PCE := 'PCE_DESTINATARIOS';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||V_ESQUEMA||'.PCE_CONFIGURACION_EMAILS......');
    FOR I IN V_TIPO_PCE.FIRST .. V_TIPO_PCE.LAST
      LOOP
        V_TMP_TIPO_PCE := V_TIPO_PCE(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
--        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigos '||V_CODIGO1_PCE||' = '''||V_TMP_TIPO_PCE(1)||''', '||V_CODIGO2_PCE||' = '''||V_TMP_TIPO_PCE(4)||''' Descripcion = '''||V_TMP_TIPO_PCE(5)||'''---------------------------------'); 
--        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO1_PCE||' = '''||V_TMP_TIPO_PCE(1)||''', '||V_CODIGO2_PCE||' = '''||V_TMP_TIPO_PCE(2)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_CODIGO1_PCE||' = '''||V_TMP_TIPO_PCE(1)||''') AND '||V_CODIGO2_PCE||' = '''||V_TMP_TIPO_PCE(2)||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_CURR_TABLE || 
                        '(PCE_ID, TAP_ID, PCE_DESTINATARIOS, PCE_SUBJECT, PCE_CUERPO, PCE_TFA_LIST, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
                        'SELECT ' ||
                        'S_PCE_CONFIGURACION_EMAILS.NEXTVAL, ' ||
                        '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PCE(1)) || '''), ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_PCE(2)),'''','''''') || ''',' || 
                        '''' || REPLACE(TRIM(V_TMP_TIPO_PCE(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_PCE(4)),'''','''''') || ''',' || 
                        '''' || REPLACE(TRIM(V_TMP_TIPO_PCE(5)),'''','''''') || ''',' ||
                        '0, ''DD'', sysdate,0 FROM DUAL';

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PCE(1) ||''','''||TRIM(V_TMP_TIPO_PCE(4))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
EXCEPTION

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                   TRATAMIENTO DE EXCEPCIONES
    *---------------------------------------------------------------------------------------------------------
    */
    WHEN OTHERS THEN
        /*
        * EXCEPTION: WHATEVER ERROR
        *---------------------------------------------------------------------
        */     
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT('[KO]');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          IF (ERR_NUM = -1427 OR ERR_NUM = -1) THEN
            DBMS_OUTPUT.put_line('[INFO] Ya existen los registros de este script insertados en la tabla '||VAR_CURR_TABLE
                              ||'. Encontrada fila num '||VAR_CURR_ROWARRAY||' de su array.');
            DBMS_OUTPUT.put_line('[INFO] Ejecute el script de limpieza del tramite '||PAR_TIT_TRAMITE||' y vuelva a ejecutar.');
          END IF;
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('SQL que ha fallado:');
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ROLLBACK ALL].............................................');
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('Contacto incidencia.....: '||PAR_AUTHOR);
          DBMS_OUTPUT.put_line('Email...................: '||PAR_AUTHOR_EMAIL);
          DBMS_OUTPUT.put_line('Telf....................: '||PAR_AUTHOR_TELF);
          DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');                    
          RAISE;
END;          
/
EXIT;