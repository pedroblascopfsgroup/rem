--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190906
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5187
--## PRODUCTO=NO
--##
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
    V_EXIST_USU NUMBER(16); -- Vble. para validar la existencia de una usuario.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	        

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
				SET TFI_TIPO = ''numberfield2''
					,USUARIOMODIFICAR = ''REMVIP-5187''
					,FECHAMODIFICAR = SYSDATE
				WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T015_DefinicionOferta'')
				AND TFI_NOMBRE IN (''nMesesFianza'')';
	EXECUTE IMMEDIATE V_MSQL;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL);
          DBMS_OUTPUT.put_line(ERR_MSG);

          ROLLBACK;
          RAISE;
          
END;
/
EXIT