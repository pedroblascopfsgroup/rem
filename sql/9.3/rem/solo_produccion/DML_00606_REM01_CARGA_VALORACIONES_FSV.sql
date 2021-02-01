--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20201231
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8526
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_VAL_VALORACIONES';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    ACT_ID NUMBER(16);
    ACT_NUM_ACTIVO NUMBER(16);

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8526';    

    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	DBMS_OUTPUT.PUT_LINE('[INFO] ESTIMADO VENTA'); 	

	--ESTIMADO VENTA --ACTUALIZAR E INSERTAR--
	V_SQL := 'MERGE INTO REM01.ACT_VAL_VALORACIONES T1 USING 
			(SELECT ACT.ACT_NUM_ACTIVO, ACT.ACT_ID, VAL.VAL_ID, AUX.VALOR_VENTA_HAYA, AUX.VALOR_RENTA_HAYA, AUX.FECHA_VALOR_VENTA, AUX.VALOR_VENTA_HET, AUX.LIQUIDEZ
           		 FROM REM01.ACT_ACTIVO ACT 
           		 INNER JOIN REM01.AUX_REMVIP_8526 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
           		 LEFT JOIN REM01.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.DD_TPC_ID = 27 AND VAL.BORRADO = 0
           		 WHERE AUX.VALOR_VENTA_HAYA <> 0 AND NOT EXISTS  ( SELECT 1 FROM REM01.AUX_REMVIP_8526 AUX2 WHERE aux.act_num_activo = aux2.act_num_activo and AUX2.valor_renta_haya > AUX2.valor_venta_haya and AUX2.valor_venta_haya <> 0)) T2
		ON (T1.VAL_ID = T2.VAL_ID)
		WHEN MATCHED THEN UPDATE SET 
			T1.VAL_IMPORTE = T2.VALOR_VENTA_HAYA,
		        T1.VAL_FECHA_VENTA = TO_DATE(T2.FECHA_VALOR_VENTA,''DD/MM/YYYY''),
		        T1.VAL_FECHA_INICIO = SYSDATE,
		        T1.VAL_FECHA_CARGA = SYSDATE,
			T1.VAL_LIQUIDEZ = T2.LIQUIDEZ,
			T1.USUARIOMODIFICAR = ''REMVIP-8526'',
			T1.FECHAMODIFICAR = SYSDATE 
		WHEN NOT MATCHED THEN INSERT
			 (VAL_ID,ACT_ID,DD_TPC_ID,FECHACREAR,USUARIOCREAR,BORRADO,VERSION,VAL_IMPORTE,VAL_FECHA_VENTA,VAL_FECHA_INICIO,VAL_FECHA_CARGA,VAL_LIQUIDEZ   )
    			  VALUES
			 (REM01.S_ACT_VAL_VALORACIONES.NEXTVAL, T2.ACT_ID, 27, SYSDATE, ''REMVIP-8526'', 0, 0, T2.VALOR_VENTA_HAYA, TO_DATE(T2.FECHA_VALOR_VENTA,''DD/MM/YYYY''), SYSDATE, SYSDATE,T2.LIQUIDEZ )';

		EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   
	
		--HISTORICO ESTIMADO VENTA --INSERTAR--
	V_SQL := ' MERGE INTO REM01.act_hva_hist_valoraciones T1 USING 
			(SELECT 0 as id_hva, ACT.ACT_NUM_ACTIVO, ACT.ACT_ID, VAL.VAL_ID, AUX.VALOR_VENTA_HAYA, AUX.VALOR_RENTA_HAYA, AUX.FECHA_VALOR_VENTA, AUX.VALOR_VENTA_HET, AUX.LIQUIDEZ
           		 FROM REM01.ACT_ACTIVO ACT 
           		 INNER JOIN REM01.AUX_REMVIP_8526 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
           		 LEFT JOIN REM01.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.DD_TPC_ID = 27 AND VAL.BORRADO = 0
           		 WHERE AUX.VALOR_VENTA_HAYA <> 0 AND NOT EXISTS  ( SELECT 1 FROM REM01.AUX_REMVIP_8526 AUX2 WHERE aux.act_num_activo = aux2.act_num_activo and AUX2.valor_renta_haya > AUX2.valor_venta_haya and AUX2.valor_venta_haya <> 0)) T2
		ON (T1.HVA_ID = T2.id_hva)
		WHEN NOT MATCHED THEN INSERT
			 (HVA_ID,ACT_ID,DD_TPC_ID,HVA_IMPORTE, HVA_FECHA_INICIO, HVA_FECHA_CARGA,FECHACREAR,USUARIOCREAR,BORRADO,VERSION)
    			  VALUES
			 (rem01.s_act_hva_hist_valoraciones.nextval, T2.ACT_ID, 27, T2.VALOR_VENTA_HAYA,  SYSDATE,  SYSDATE,  SYSDATE, ''REMVIP-8526'', 0, 0)';

		EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');  

	DBMS_OUTPUT.PUT_LINE('[INFO] ESTIMADO RENTA'); 	

	--ESTIMADO RENTA --ACTUALIZAR E INSERTAR--
	V_SQL := 'MERGE INTO REM01.ACT_VAL_VALORACIONES T1 USING 
			(SELECT ACT.ACT_NUM_ACTIVO, ACT.ACT_ID, VAL.VAL_ID, AUX.VALOR_VENTA_HAYA, AUX.VALOR_RENTA_HAYA, AUX.FECHA_VALOR_VENTA, AUX.VALOR_VENTA_HET, AUX.LIQUIDEZ
			    FROM REM01.ACT_ACTIVO ACT 
			    INNER JOIN REM01.AUX_REMVIP_8526 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
			    LEFT JOIN REM01.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.DD_TPC_ID = 28 AND VAL.BORRADO = 0
			    WHERE AUX.VALOR_RENTA_HAYA <> 0 AND NOT EXISTS  ( SELECT 1 FROM REM01.AUX_REMVIP_8526 AUX2 WHERE aux.act_num_activo = aux2.act_num_activo and AUX2.valor_renta_haya > AUX2.valor_venta_haya and AUX2.valor_venta_haya <> 0)) T2
		ON (T1.VAL_ID = T2.VAL_ID)
		WHEN MATCHED THEN UPDATE SET 
				T1.VAL_IMPORTE = T2.VALOR_RENTA_HAYA,
				T1.VAL_FECHA_VENTA = CASE WHEN T2.FECHA_VALOR_VENTA IS NULL THEN T1.VAL_FECHA_VENTA ELSE TO_DATE(T2.FECHA_VALOR_VENTA,''DD/MM/YYYY'') END,
				T1.VAL_FECHA_INICIO = SYSDATE,
				T1.VAL_FECHA_CARGA = SYSDATE,
				T1.VAL_LIQUIDEZ = T2.LIQUIDEZ,
				T1.USUARIOMODIFICAR = ''REMVIP-8526'',
				T1.FECHAMODIFICAR = SYSDATE 
		WHEN NOT MATCHED THEN INSERT
			(VAL_ID,ACT_ID,DD_TPC_ID,FECHACREAR,USUARIOCREAR,BORRADO,VERSION,VAL_IMPORTE,VAL_FECHA_VENTA,VAL_FECHA_INICIO,VAL_FECHA_CARGA,VAL_LIQUIDEZ   )
    			 VALUES
			(REM01.S_ACT_VAL_VALORACIONES.NEXTVAL, T2.ACT_ID, 28, SYSDATE, ''REMVIP-8526'', 0, 0, T2.VALOR_RENTA_HAYA,CASE WHEN T2.FECHA_VALOR_VENTA IS NULL THEN NULL ELSE TO_DATE(T2.FECHA_VALOR_VENTA,''DD/MM/YYYY'') END, SYSDATE, SYSDATE,T2.LIQUIDEZ)';

		EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros'); 
	
		--HISTORICO ESTIMADO RENTA --INSERTAR--
	V_SQL := ' MERGE INTO REM01.act_hva_hist_valoraciones T1 USING 
			(SELECT 0 as id_hva, ACT.ACT_NUM_ACTIVO, ACT.ACT_ID, VAL.VAL_ID, AUX.VALOR_VENTA_HAYA, AUX.VALOR_RENTA_HAYA, AUX.FECHA_VALOR_VENTA, AUX.VALOR_VENTA_HET, AUX.LIQUIDEZ
           		 FROM REM01.ACT_ACTIVO ACT 
           		 INNER JOIN REM01.AUX_REMVIP_8526 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
           		 LEFT JOIN REM01.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.DD_TPC_ID = 28 AND VAL.BORRADO = 0
           		 WHERE AUX.VALOR_RENTA_HAYA <> 0 AND NOT EXISTS  ( SELECT 1 FROM REM01.AUX_REMVIP_8526 AUX2 WHERE aux.act_num_activo = aux2.act_num_activo and AUX2.valor_renta_haya > AUX2.valor_venta_haya and AUX2.valor_venta_haya <> 0)) T2
		ON (T1.HVA_ID = T2.id_hva)
		WHEN NOT MATCHED THEN INSERT
			 (HVA_ID,ACT_ID,DD_TPC_ID,HVA_IMPORTE, HVA_FECHA_INICIO, HVA_FECHA_CARGA,FECHACREAR,USUARIOCREAR,BORRADO,VERSION)
    			  VALUES
			 (rem01.s_act_hva_hist_valoraciones.nextval, T2.ACT_ID, 28, T2.VALOR_RENTA_HAYA,  SYSDATE,  SYSDATE,  SYSDATE, ''REMVIP-8526'', 0, 0)';

		EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');  
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ESTIMADO HET'); 		
	
	--ESTIMADO RENTA --ACTUALIZAR E INSERTAR--
	V_SQL := 'MERGE INTO REM01.ACT_VAL_VALORACIONES T1 USING 
			(SELECT ACT.ACT_NUM_ACTIVO, ACT.ACT_ID, VAL.VAL_ID, AUX.VALOR_VENTA_HAYA, AUX.VALOR_RENTA_HAYA, AUX.FECHA_VALOR_VENTA, AUX.VALOR_VENTA_HET, AUX.LIQUIDEZ
			    FROM REM01.ACT_ACTIVO ACT 
			    INNER JOIN REM01.AUX_REMVIP_8526 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
			    LEFT JOIN REM01.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.DD_TPC_ID = 81 AND VAL.BORRADO = 0
			    WHERE AUX.VALOR_VENTA_HET <> 0 AND NOT EXISTS  ( SELECT 1 FROM REM01.AUX_REMVIP_8526 AUX2 WHERE aux.act_num_activo = aux2.act_num_activo and AUX2.valor_renta_haya > AUX2.valor_venta_haya and AUX2.valor_venta_haya <> 0)) T2
		ON (T1.VAL_ID = T2.VAL_ID)
		WHEN MATCHED THEN UPDATE SET 
			T1.VAL_IMPORTE = T2.VALOR_VENTA_HET,
		        T1.VAL_FECHA_VENTA = CASE WHEN T2.FECHA_VALOR_VENTA IS NULL THEN T1.VAL_FECHA_VENTA ELSE TO_DATE(T2.FECHA_VALOR_VENTA,''DD/MM/YYYY'') END,
		        T1.VAL_FECHA_INICIO = SYSDATE,
		        T1.VAL_FECHA_CARGA = SYSDATE,
			T1.VAL_LIQUIDEZ = T2.LIQUIDEZ,
			T1.USUARIOMODIFICAR = ''REMVIP-8526'',
			T1.FECHAMODIFICAR = SYSDATE 
		WHEN NOT MATCHED THEN INSERT
			(VAL_ID,ACT_ID,DD_TPC_ID,FECHACREAR,USUARIOCREAR,BORRADO,VERSION,VAL_IMPORTE,VAL_FECHA_VENTA,VAL_FECHA_INICIO,VAL_FECHA_CARGA,VAL_LIQUIDEZ   )
    			VALUES
			(REM01.S_ACT_VAL_VALORACIONES.NEXTVAL, T2.ACT_ID, 81, SYSDATE, ''REMVIP-8526'', 0, 0, T2.VALOR_VENTA_HET,CASE WHEN T2.FECHA_VALOR_VENTA IS NULL THEN NULL ELSE TO_DATE(T2.FECHA_VALOR_VENTA,''DD/MM/YYYY'') END, SYSDATE, SYSDATE,T2.LIQUIDEZ)';

		EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');  
		
			--HISTORICO ESTIMADO VENTA --INSERTAR--
	V_SQL := ' MERGE INTO REM01.act_hva_hist_valoraciones T1 USING 
			(SELECT 0 as id_hva, ACT.ACT_NUM_ACTIVO, ACT.ACT_ID, VAL.VAL_ID, AUX.VALOR_VENTA_HAYA, AUX.VALOR_RENTA_HAYA, AUX.FECHA_VALOR_VENTA, AUX.VALOR_VENTA_HET, AUX.LIQUIDEZ
           		 FROM REM01.ACT_ACTIVO ACT 
           		 INNER JOIN REM01.AUX_REMVIP_8526 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
           		 LEFT JOIN REM01.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.DD_TPC_ID = 81 AND VAL.BORRADO = 0
           		 WHERE AUX.VALOR_VENTA_HET <> 0 AND NOT EXISTS  ( SELECT 1 FROM REM01.AUX_REMVIP_8526 AUX2 WHERE aux.act_num_activo = aux2.act_num_activo and AUX2.valor_renta_haya > AUX2.valor_venta_haya and AUX2.valor_venta_haya <> 0)) T2
		ON (T1.HVA_ID = T2.id_hva)
		WHEN NOT MATCHED THEN INSERT
			 (HVA_ID,ACT_ID,DD_TPC_ID,HVA_IMPORTE, HVA_FECHA_INICIO, HVA_FECHA_CARGA,FECHACREAR,USUARIOCREAR,BORRADO,VERSION)
    			  VALUES
			 (rem01.s_act_hva_hist_valoraciones.nextval, T2.ACT_ID, 81, T2.VALOR_VENTA_HET,  SYSDATE,  SYSDATE,  SYSDATE, ''REMVIP-8526'', 0, 0)';

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
