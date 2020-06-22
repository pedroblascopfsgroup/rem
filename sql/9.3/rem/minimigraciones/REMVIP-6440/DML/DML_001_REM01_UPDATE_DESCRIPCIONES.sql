--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6440
--## PRODUCTO=SI
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

BEGIN
	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  

	    	V_MSQL := 'MERGE INTO REM01.ACT_HFP_HIST_FASES_PUB T1
	   		 USING ( SELECT HFP.HFP_ID, HFP.ACT_ID, AUX.DESCRIPCION 
				FROM REM01.ACT_HFP_HIST_FASES_PUB HFP 
				INNER JOIN REM01.AUX_REMVIP_6440 AUX ON AUX.ACT_ID = HFP.ACT_ID AND HFP_FECHA_FIN IS NULL AND BORRADO = 0
				WHERE HFP_FECHA_FIN IS NULL AND BORRADO = 0) T2
	   		 ON (T1.HFP_ID = T2.HFP_ID)
	  		WHEN MATCHED THEN
			    UPDATE SET T1.COMENTARIO = T2.DESCRIPCION,
			   		USUARIOMODIFICAR = ''REMVIP_6440_COMENT'',
				        FECHAMODIFICAR = SYSDATE
			 ';
		
	EXECUTE IMMEDIATE V_MSQL;  

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||SQL%ROWCOUNT||' registros');
   
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
