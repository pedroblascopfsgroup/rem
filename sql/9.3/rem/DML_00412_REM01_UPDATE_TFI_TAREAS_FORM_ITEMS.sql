--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8645
--## PRODUCTO=NO
--##
--## Finalidad: Modificar instrucciones en tareas que contengan informe juridico (eliminada)
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(25);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8645'; -- USUARIO CREAR/MODIFICAR

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS T1 USING (
                    SELECT TFI.TFI_ID, TFI.TFI_LABEL FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI
                        INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TFI.TAP_ID
                        INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID
                        AND TAP.TAP_CODIGO = ''T013_ResolucionComite'') T2
                ON (T1.TFI_ID = T2.TFI_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.TFI_LABEL = REPLACE(T2.TFI_LABEL,''La siguiente tarea se le lanzará a la gestoría para la realización del informe jurídico.''),
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO INSTRUCCIONES DE TAREA T013_ResolucionComite');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS T1 USING (
                    SELECT TFI.TFI_ID, TFI.TFI_LABEL FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI
                        INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TFI.TAP_ID
                        INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID
                        AND TAP.TAP_CODIGO = ''T017_ResolucionPROManzana'') T2
                ON (T1.TFI_ID = T2.TFI_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.TFI_LABEL = REPLACE(T2.TFI_LABEL,'' y el informe jurídico''),
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO INSTRUCCIONES DE TAREA T017_ResolucionPROManzana');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS T1 USING (
                    SELECT TFI.TFI_ID, TFI.TFI_LABEL FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI
                        INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TFI.TAP_ID
                        INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID
                        AND TAP.TAP_CODIGO = ''T017_ResolucionCES'') T2
                ON (T1.TFI_ID = T2.TFI_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.TFI_LABEL = REPLACE(T2.TFI_LABEL,'' informe jurídico;''),
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO INSTRUCCIONES DE TAREA T017_ResolucionCES');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT