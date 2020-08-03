--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7871
--## PRODUCTO=NO
--## 
--## Finalidad: Script que actualizar fecha alta ofertas
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_SPS_SIT_POSESORIA';
    V_TABLA2 VARCHAR2(25 CHAR):= 'ACT_VAL_VALORACIONES';
    V_TABLA3 VARCHAR2(25 CHAR):= 'ACT_ICO_INFO_COMERCIAL';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    ACT_ID NUMBER(16);
    ACT_NUM_ACTIVO NUMBER(16);

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7871';    

    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
/*
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACTUALIZAR DATOS DE POSESION**');


	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING 
			(SELECT SPS.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_7871 AUX ON ACT.ACT_ID = AUX.ACT_ID
			INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON AUX.ACT_ID = SPS.ACT_ID) T2
			ON (T1.ACT_ID = T2.ACT_ID)
			WHEN MATCHED THEN UPDATE SET 
			T1.SPS_FECHA_TOMA_POSESION = TO_DATE(''01/01/2100'',''DD/MM/YYYY''),
			T1.SPS_FECHA_ULT_CAMBIO_POS = TO_DATE(''01/01/2100'',''DD/MM/YYYY''),
			T1.USUARIOMODIFICAR = ''REMVIP-7871'',
			T1.FECHAMODIFICAR = SYSDATE';

		EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   
*/
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACTUALIZAR DATOS DE VALORACIONES**');
/*
	DBMS_OUTPUT.PUT_LINE('[INFO] APROBADO VENTA');

	--APROBADO VENTA --ACTUALIZAR E INSERTAR--
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA2||' T1 USING 
			(SELECT VAL.VAL_ID, ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_7871 AUX ON ACT.ACT_ID = AUX.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON AUX.ACT_ID = VAL.ACT_ID AND VAL.DD_TPC_ID = 2 AND VAL.BORRADO = 0) T2
			ON (T1.VAL_ID = T2.VAL_ID)
			WHEN MATCHED THEN UPDATE SET 
				T1.VAL_FECHA_APROBACION = TO_DATE(''01/01/2100'',''DD/MM/YYYY''),
				T1.VAL_IMPORTE = 1,
				T1.USUARIOMODIFICAR = ''REMVIP-7871'',
				T1.FECHAMODIFICAR = SYSDATE 
			WHEN NOT MATCHED THEN INSERT
			 (VAL_ID,ACT_ID,DD_TPC_ID,FECHACREAR,USUARIOCREAR,BORRADO,VERSION,VAL_FECHA_APROBACION,VAL_IMPORTE )
    			  VALUES
			 ('||V_ESQUEMA||'.S_ACT_VAL_VALORACIONES.NEXTVAL, T2.ACT_ID, 2, SYSDATE, ''REMVIP-7871'', 0, 0, TO_DATE(''01/01/2100'',''DD/MM/YYYY''), 1)';

		EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   

	DBMS_OUTPUT.PUT_LINE('[INFO] APROBADO RENTA');

	--APROBADO RENTA --ACTUALIZAR E INSERTAR--
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA2||' T1 USING 
			(SELECT VAL.VAL_ID, ACT.ACT_ID  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_7871 AUX ON ACT.ACT_ID = AUX.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON AUX.ACT_ID = VAL.ACT_ID AND VAL.DD_TPC_ID = 3 AND VAL.BORRADO = 0) T2
			ON (T1.VAL_ID = T2.VAL_ID)
			WHEN MATCHED THEN UPDATE SET 
				T1.VAL_FECHA_APROBACION = TO_DATE(''01/01/2100'',''DD/MM/YYYY''),
				T1.VAL_IMPORTE = 1,
				T1.USUARIOMODIFICAR = ''REMVIP-7871'',
				T1.FECHAMODIFICAR = SYSDATE 
			WHEN NOT MATCHED THEN INSERT
			 (VAL_ID,ACT_ID,DD_TPC_ID,FECHACREAR,USUARIOCREAR,BORRADO,VERSION,VAL_FECHA_APROBACION,VAL_IMPORTE )
    			  VALUES
			 ('||V_ESQUEMA||'.S_ACT_VAL_VALORACIONES.NEXTVAL, T2.ACT_ID, 3, SYSDATE, ''REMVIP-7871'', 0, 0, TO_DATE(''01/01/2100'',''DD/MM/YYYY''), 1)';

		EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');  
*/
	DBMS_OUTPUT.PUT_LINE('[INFO] ESTIMADO VENTA'); 	

	--ESTIMADO VENTA --ACTUALIZAR E INSERTAR--
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA2||' T1 USING 
			(SELECT VAL.VAL_ID, ACT.ACT_ID  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_7871 AUX ON ACT.ACT_ID = AUX.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON AUX.ACT_ID = VAL.ACT_ID AND VAL.DD_TPC_ID = 11 AND VAL.BORRADO = 0) T2
			ON (T1.VAL_ID = T2.VAL_ID)
			WHEN MATCHED THEN UPDATE SET 
				T1.VAL_FECHA_VENTA = TO_DATE(''01/01/2100'',''DD/MM/YYYY''),
				T1.VAL_IMPORTE = 1,
				T1.USUARIOMODIFICAR = ''REMVIP-7871'',
				T1.FECHAMODIFICAR = SYSDATE 
			WHEN NOT MATCHED THEN INSERT
			 (VAL_ID,ACT_ID,DD_TPC_ID,FECHACREAR,USUARIOCREAR,BORRADO,VERSION,VAL_FECHA_VENTA,VAL_IMPORTE )
    			  VALUES
			 ('||V_ESQUEMA||'.S_ACT_VAL_VALORACIONES.NEXTVAL, T2.ACT_ID, 11, SYSDATE, ''REMVIP-7871'', 0, 0, TO_DATE(''01/01/2100'',''DD/MM/YYYY''), 1)';

		EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   

	DBMS_OUTPUT.PUT_LINE('[INFO] ESTIMADO VENTA'); 	

	--ESTIMADO RENTA --ACTUALIZAR E INSERTAR--
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA2||' T1 USING 
			(SELECT VAL.VAL_ID, ACT.ACT_ID  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_7871 AUX ON ACT.ACT_ID = AUX.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON AUX.ACT_ID = VAL.ACT_ID AND VAL.DD_TPC_ID = 12 AND VAL.BORRADO = 0) T2
			ON (T1.VAL_ID = T2.VAL_ID)
			WHEN MATCHED THEN UPDATE SET 
				T1.VAL_FECHA_VENTA = TO_DATE(''01/01/2100'',''DD/MM/YYYY''),
				T1.VAL_IMPORTE = 1,
				T1.USUARIOMODIFICAR = ''REMVIP-7871'',
				T1.FECHAMODIFICAR = SYSDATE 
			WHEN NOT MATCHED THEN INSERT
			 (VAL_ID,ACT_ID,DD_TPC_ID,FECHACREAR,USUARIOCREAR,BORRADO,VERSION,VAL_FECHA_VENTA,VAL_IMPORTE )
    			  VALUES
			 ('||V_ESQUEMA||'.S_ACT_VAL_VALORACIONES.NEXTVAL, T2.ACT_ID, 12, SYSDATE, ''REMVIP-7871'', 0, 0, TO_DATE(''01/01/2100'',''DD/MM/YYYY''), 1)';

		EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros'); 	

	DBMS_OUTPUT.PUT_LINE('[INFO] FECHA ULTIMA VISITA'); 

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA3||' T1 USING 
			(SELECT ICO.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_7871 AUX ON ACT.ACT_ID = AUX.ACT_ID
			INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON AUX.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0) T2
			ON (T1.ACT_ID = T2.ACT_ID)
			WHEN MATCHED THEN UPDATE SET 
				T1.ICO_FECHA_ULTIMA_VISITA = TO_DATE(''01/01/2100'',''DD/MM/YYYY''),
				T1.USUARIOMODIFICAR = ''REMVIP-7871'',
				T1.FECHAMODIFICAR = SYSDATE ';

		EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros'); 	

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
