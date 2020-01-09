--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200109
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6999
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva de aprobación del informe comercial
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6152'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_6152';
    V_COUNT NUMBER(16);		


BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO] INSERT FASE Y SUBFAS EPUBLICACION ');	

	V_MSQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB T1
		    USING( 
				SELECT ACT.ACT_NUM_ACTIVO, ACT.ACT_ID, FSP.DD_FSP_ID, SFP.DD_SFP_ID
				FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
				INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_6152 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO 
				INNER JOIN '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION FSP ON AUX.COD_FASE = FSP.DD_FSP_CODIGO
				LEFT JOIN '||V_ESQUEMA||'.DD_SFP_SUBFASE_PUBLICACION SFP ON AUX.COD_SUBFASE = SFP.DD_SFP_CODIGO
			) T2
		    ON ( T1.ACT_ID = T2.ACT_ID )
		   WHEN NOT MATCHED THEN INSERT (T1.ACT_ID,
		                                T1.DD_FSP_ID,
		                                T1.DD_SFP_ID,
		                                T1.USU_ID,
		                                T1.HFP_FECHA_INI,
		                                T1.VERSION,
		                                T1.USUARIOCREAR,
		                                T1.FECHACREAR,
		                                T1.BORRADO)
		                        VALUES (
		                                T2.ACT_ID,
		                                T2.COD_FASE,
		                                T2.COD_SUBFASE,
		                                29468,
		                                SYSDATE,
		                                1,
		                                ''REMVIP-6999'',
		                                SYSDATE,
		                                0 
		                                )';	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se INSERTAN '||SQL%ROWCOUNT||' registros de ACT_HFP_HIST_FASES_PUB'); 	

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
