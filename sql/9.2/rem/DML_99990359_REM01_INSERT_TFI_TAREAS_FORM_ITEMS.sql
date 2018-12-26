--/*
--##########################################
--## AUTOR=Matias Garcia-Argudo
--## FECHA_CREACION=20181202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4962
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el trámite T015 comercial de alquiler TFI_TAREAS_FORM_ITEMS tarea Aceptación cliente insertando un campo hueco al final.
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
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := 'HREOS-4493'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

BEGIN


 DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN TABLA ''TFI_TAREAS_FORM_ITEMS''');

V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
		(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
		SELECT
			S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,
			TAP.TAP_ID, 
			4, 
			''label'', 
			''hueco'', 
			'''', 
			0, 
			'''||V_USU_MODIFICAR||''', 
			SYSDATE, 
			0
		FROM
			'||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
		WHERE
			TAP.TAP_CODIGO = ''T015_AceptacionCliente'''; 
	DBMS_OUTPUT.PUT_LINE(V_MSQL);	
    EXECUTE IMMEDIATE V_MSQL;



DBMS_OUTPUT.PUT_LINE('Inserción completada');

	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ''TFI_TAREAS_FORM_ITEMS'' ACTUALIZADA CORRECTAMENTE ');
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












