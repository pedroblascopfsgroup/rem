--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20180731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4335
--## PRODUCTO=NO
--##
--## Finalidad: Script que MODIFICA a 1 el DD_TTR_FILTRO_TRAMITE en la tabla DD_TTR_TIPO_TRABAJO para Actuacion tecnica
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar DD_TTR_FILTRO_TRAMITE...');
      
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO' ||
		  ' SET DD_TTR_FILTRO_TRAMITE = 1'||	  
		  ' WHERE DD_TTR_CODIGO = 03 ';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado DD_TTR_FILTRO_TRAMITE .......');
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