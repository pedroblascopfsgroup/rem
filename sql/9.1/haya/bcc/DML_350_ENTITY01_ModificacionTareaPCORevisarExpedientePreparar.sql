/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20151222
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-547
--## PRODUCTO=NO
--##
--## Finalidad: DML de Modificaciones necesarias para la tarea Revisar Expediente a Preparar (particular de Precontencioso Cajamar)
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_REGS NUMBER(16); -- Vble. para validar la existencia de un dato
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_TABLENAME2 VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_TAR_ID NUMBER(16); -- Id de tarea
    V_TITULO VARCHAR2(4000 CHAR); 
    V_TITULO2 VARCHAR2(4000 CHAR); 

BEGIN

    V_TABLENAME2 := V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO';
    V_SQL := q'[SELECT TAP_ID FROM ]' || V_TABLENAME2 || q'[ WHERE TAP_CODIGO='PCO_RevisarExpedientePreparar' ]';
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_TAR_ID;

    V_TABLENAME := V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS';
    V_SEQUENCENAME := V_ESQUEMA || '.S_TFI_TAREAS_FORM_ITEMS';

    DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado del form item "agencia_externa" '||V_TABLENAME || '.');
    V_MSQL := q'[DELETE FROM ]' || V_TABLENAME || q'[ WHERE TAP_ID=]' || V_TAR_ID || q'[ AND TFI_NOMBRE = 'agencia_externa']';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('---' || V_TABLENAME || '... registros afectados: ' || sql%rowcount);

    V_SQL := q'[SELECT COUNT(1) FROM ]' || V_TABLENAME || ' WHERE TAP_ID=' || V_TAR_ID || q'[ AND TFI_NOMBRE='gestion']';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGS;
    IF V_NUM_REGS > 0 THEN 
      DBMS_OUTPUT.PUT_LINE('[INICIO] Creación del form item "gestion" '||V_TABLENAME || '. Ya existe.');
    ELSE 
      DBMS_OUTPUT.PUT_LINE('[INICIO] Creación del form item "gestion" '||V_TABLENAME || '.');
      V_MSQL := q'[INSERT INTO ]' || V_TABLENAME || q'[ (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,
        TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (]' || 
        V_SEQUENCENAME || q'[.NEXTVAL,]' || V_TAR_ID || q'[,2,'combo','gestion','Gestión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
        'valor != null && valor != '''' ? true : false',null,'DDTipoGestionRevisarExpJudicial',0,'DD',sysdate,null,null,null,null,0)]';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('---' || V_TABLENAME || '... registros afectados: ' || sql%rowcount);
    END IF;

    DBMS_OUTPUT.PUT_LINE('[INICIO] Modificación del form item "titulo" '||V_TABLENAME || '.');
    V_TITULO := q'['<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">]' || 
q'[Antes de dar por terminada esta tarea, deberá realizar un estudio de las operaciones incluidas en el asunto y de la solvencia de los deudores para determinar si la recuperación de la deuda se hará por la vía judicial, a través de una agencia externa o directamente se quiere marcar la no gestión del asunto.<br/>]'||
q'[En el campo “Fecha fin revisión” deberá indicar la fecha en la que finaliza este estudio.<br/>]'||
q'[En caso de que decida asignar el asunto a una agencia externa, deberá indicarlo en el Terminal Financiero de la entidad y seleccionar “Agencia externa” en el campo selector “Gestión”. En caso de indicar Gestión "Judicializar" deberá indicar en el selector de procedimiento el tipo de procedimiento a iniciar una vez termine la preparación del expediente judicial.<br/>]'||
q'[En caso de considerar necesaria la paralización de la preparación del expediente judicial, puede prorrogar esta tarea hasta que estime oportuno a través de la solicitud de una prórroga. De igual modo, en caso de encontrarse en negociación de un acuerdo extrajudicial, regístrelo a través de la pestaña Acuerdos de la ficha del asunto correspondiente.<br/>]'||
q'[En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.<br/>]'||
q'[Una vez rellene esta pantalla y si ha marcado Gestión “Agencia externa” o "Sin gestión" se finalizará el trámite, en caso de haber indicado "Judicializar" se lanzará la tarea “Asignar gestor de liquidación. ]' || 
q'[</p></div>']';
    V_MSQL := 'UPDATE ' || V_TABLENAME || ' SET TFI_LABEL=' || V_TITULO || ' WHERE TAP_ID=' || V_TAR_ID || q'[ AND TFI_NOMBRE = 'titulo']';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('---' || V_TABLENAME || '... registros afectados: ' || sql%rowcount);

    DBMS_OUTPUT.PUT_LINE('[INICIO] Modificación del form item "proc_iniciar" '||V_TABLENAME || '.');
    V_MSQL := 'UPDATE ' || V_TABLENAME || q'[ SET TFI_ERROR_VALIDACION='', TFI_VALIDACION='' WHERE TAP_ID=]' || V_TAR_ID || q'[ AND TFI_NOMBRE = 'proc_iniciar']';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('---' || V_TABLENAME || '... registros afectados: ' || sql%rowcount);

    DBMS_OUTPUT.PUT_LINE('[INICIO] Modificación de la tarea "PCO_RevisarExpedientePreparar" '||V_TABLENAME2 || '.');
    V_TITULO := q'[valores[''PCO_RevisarExpedientePreparar''][''gestion'']==''JUDICIALIZAR'' && noExisteGestorDocumentacionAsignadoAsunto() ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">En caso de indicar en el campo Gesti&oacute;n el valor "Judicializar", para completar la tarea deber&aacute; haber un Gestor de la Documentaci&oacute;n asignado al asunto'' : null ]';
    V_TITULO2 := q'[valores[''PCO_RevisarExpedientePreparar''][''gestion''] != ''JUDICIALIZAR'' ? ''fin'': ''judicializar'']'; 
    V_MSQL := 'UPDATE ' || V_TABLENAME2 || ' SET TAP_SCRIPT_VALIDACION_JBPM=''' || V_TITULO || ''',TAP_SCRIPT_DECISION=''' || V_TITULO2 || ''' WHERE TAP_ID=' || V_TAR_ID;
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('---' || V_TABLENAME2 || '... registros afectados: ' || sql%rowcount);

    COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   

END;
/

EXIT;

