--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20221024
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18888
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'TFI_TAREAS_FORM_ITEMS';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-18888'; -- USUARIOBORRAR
    
BEGIN	

		DBMS_OUTPUT.PUT_LINE('[INFO] Se van a recuperar registros de la tabla '||V_TABLA||'.');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                    SET TFI_TIPO = ''combobox'',
					TFI_NOMBRE = ''motivoReagendacion'',
					TFI_LABEL = ''Motivo reagendación'',
					TFI_BUSINESS_OPERATION = ''DDMotivoReagendacion'',
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE 
					WHERE TFI_NOMBRE = ''justificacion'' 
                    AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T015_AgendarFechaFirma'')';
                    
              DBMS_OUTPUT.PUT_LINE(V_MSQL);      

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] registros recuperados correctamente.');
        
        COMMIT;
  
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT