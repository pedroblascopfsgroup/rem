/*
--##########################################
--## AUTOR=Jin Li Hu
--## FECHA_CREACION=20180614
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4160
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Trámite de...
--## INSTRUCCIONES:  Ejecutar y definir las variables.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
SET TIMING ON;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_NUM_ID NUMBER(16);  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16);
    V_NUM_MAXID NUMBER(16);

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

BEGIN
    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
       
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T013'') and TAP_CODIGO = ''T013_PosicionamientoYFirma''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN        
      V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||
                 ' SET TAP_SCRIPT_VALIDACION_JBPM = ''checkExpedienteFechaChequeLiberbank() ? (checkExpedienteBloqueado() ? (valores[''''T013_PosicionamientoYFirma''''][''''comboFirma''''] == DDSiNo.SI ? (checkPosicionamiento()'||
                 ' ? existeAdjuntoUGValidacion("15,E") : ''''El expediente debe tener algún posicionamiento'''') : null) : ''''El expediente no está bloqueado'''') : ''''Debe rellenar la fecha de ingreso de cheque mediante el fichero de Reservas-Ventas'''' '''||
                 ', USUARIOMODIFICAR = ''HREOS-4160'' , FECHAMODIFICAR = SYSDATE'||
                 ' WHERE TAP_CODIGO = ''T013_PosicionamientoYFirma'' AND BORRADO = 0';
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL;
    END IF;
         
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');
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
