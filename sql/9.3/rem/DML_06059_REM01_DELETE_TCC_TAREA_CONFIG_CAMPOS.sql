--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20211222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10972
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_SQL := 'DELETE REM01.TCC_TAREA_CONFIG_CAMPOS
                  WHERE TAP_ID = (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T017_FirmaContrato'')
                  AND TFI_ID = (SELECT TFI_ID FROM REM01.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T017_FirmaContrato'')
                                      AND TFI_NOMBRE = ''comboFirma'')
                  AND TCC_INSTANCIA = 1';

    EXECUTE IMMEDIATE V_SQL;		
      		
	  COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
