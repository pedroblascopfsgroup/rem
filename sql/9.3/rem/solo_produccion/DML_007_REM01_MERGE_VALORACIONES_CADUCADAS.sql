--/*
--##########################################
--## AUTOR=Ramon Llinares
--## FECHA_CREACION=20190522
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4279
--## PRODUCTO=SI
--##
--## Finalidad: Script que borra las valoraciones caducadas
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
	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Historificamos los registros');
  
    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_HVA_HIST_VALORACIONES (HVA_ID,ACT_ID,DD_TPC_ID,HVA_IMPORTE,HVA_FECHA_INICIO,HVA_FECHA_FIN,HVA_FECHA_APROBACION,HVA_FECHA_CARGA,USU_ID,HVA_OBSERVACIONES,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)         
                SELECT '||V_ESQUEMA||'.S_ACT_HVA_HIST_VALORACIONES.NEXTVAL,ACT_ID,DD_TPC_ID,VAL_IMPORTE,VAL_FECHA_INICIO,VAL_FECHA_FIN,VAL_FECHA_APROBACION,VAL_FECHA_CARGA,USU_ID,VAL_OBSERVACIONES,0,''REMVIP-4279'',SYSDATE,0
                FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES WHERE BORRADO = 0 and VAL_FECHA_FIN <= SYSDATE';
		
	EXECUTE IMMEDIATE V_MSQL;  
  --DBMS_OUTPUT.put_line(V_MSQL);

    DBMS_OUTPUT.PUT_LINE('[INICIO] Borramos los registros');
  
    	V_MSQL := '
	MERGE INTO '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL 
	    USING (SELECT VAL_ID from '||V_ESQUEMA||'.ACT_VAL_VALORACIONES WHERE BORRADO = 0 and VAL_FECHA_FIN <= SYSDATE) CADUCADAS
	    ON (VAL.VAL_ID = CADUCADAS.VAL_ID)
	  WHEN MATCHED THEN
	    UPDATE 
	       SET USUARIOBORRAR = ''REMVIP-4279'',
		       FECHABORRAR = SYSDATE,
			   BORRADO = 1	 		
         ';
		
	EXECUTE IMMEDIATE V_MSQL;  
   
	
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