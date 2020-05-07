--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200502
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7777
--## PRODUCTO=SI
--##
--## Finalidad: ACTUALIZA COMUNICACIONES GENCAT MIGRADAS MAL DE DIVARIAN, RESOLUCION COMITE
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
	
	  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAMOS COMUNICACION EN OFERTA GENCAT');
  
    	V_MSQL := 'MERGE INTO REM01.ACT_OFG_OFERTA_GENCAT T1
	    USING (select ofg.ofg_id, cmg.cmg_id, ofg.ofr_id,  actofr.act_id from REM01.ACT_OFG_OFERTA_GENCAT ofg
                inner join rem01.act_ofr actofr on actofr.ofr_id = ofg.ofr_id
                inner join REM01.ACT_CMG_COMUNICACION_GENCAT cmg on cmg.act_id = actofr.act_id
                where ofr_id_ant in (554321,
                554498,
                557322,
                553660,
                557116,
                557420,
                557511,
                557609,
                553499,
                553726,
                557337,
                554175,
                557544,
                554313,
                554438,
                554494,
                554167,
                557031,
                557552,
                553927,
                554540)
                ) T2
	    ON (T1.OFG_ID = T2.OFG_ID)
	  WHEN MATCHED THEN
	    UPDATE 
	       SET T1.USUARIOMODIFICAR = ''REMVIP-7777'',
		       T1.FECHAMODIFICAR = SYSDATE,
			   T1.CMG_ID = T2.CMG_ID';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');  

	 DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAMOS COMUNICACION *COMUNICADO*');					
  
    	V_MSQL := '
	UPDATE REM01.ACT_CMG_COMUNICACION_GENCAT SET USUARIOMODIFICAR = ''REMVIP-7777'', FECHAMODIFICAR = SYSDATE, DD_ECG_ID = 4 
	WHERE ACT_ID IN (448715,
	466121,
	473105,
	477642,
	482443,
	489906) AND USUARIOCREAR = ''MIG_DIVARIAN'' AND DD_ECG_ID IS NULL';
		
	EXECUTE IMMEDIATE V_MSQL;  

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_ICO_INFO_COMERCIAL. Deberian ser 56.324 ');  

	 DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAMOS COMUNICACION *SANCIONADO*, *NO EJERCE*');

	V_MSQL := '
	UPDATE REM01.ACT_CMG_COMUNICACION_GENCAT SET USUARIOMODIFICAR = ''REMVIP-7777'', FECHAMODIFICAR = SYSDATE, DD_ECG_ID = 3, DD_SAN_ID = 2
	WHERE ACT_ID IN (446863,
	459768,
	464619,
	470052,
	470765,
	470801,
	477179,
	483963,
	484251,
	484361,
	484707,
	484709,
	484893,
	485032,
	495903) AND USUARIOCREAR = ''MIG_DIVARIAN'' AND DD_ECG_ID IS NULL';
		
	EXECUTE IMMEDIATE V_MSQL;  

						
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros');  
	
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
