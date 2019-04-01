--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190304
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3504
--## PRODUCTO=NO
--##
--## Finalidad: Borrado de historicas para reenviar por webcom
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
           
BEGIN	
	
       DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.CWH_CABEC_ONV_WEBCOM_HIST WHERE ID_AGRUPACION_REM IN 
			(SELECT DISTINCT SWH.CODIGO_AGRUPACION_OBRA_NUEVA
		 	 FROM '||V_ESQUEMA||'.SWH_STOCK_ACT_WEBCOM_HIST SWH
			 WHERE SWH.CODIGO_AGRUPACION_OBRA_NUEVA IS NOT NULL 
			 AND SWH.CODIGO_CABECERA_OBRA_NUEVA IS NULL)';

	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS BORRADOS DE CWH_CABEC_ONV_WEBCOM_HIST');
         
    
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.SWH_STOCK_ACT_WEBCOM_HIST SWH
		   WHERE SWH.CODIGO_AGRUPACION_OBRA_NUEVA IS NOT NULL 
		   AND SWH.CODIGO_CABECERA_OBRA_NUEVA IS NULL';

	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS BORRADOS DE SWH_STOCK_ACT_WEBCOM_HIST');
          
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
