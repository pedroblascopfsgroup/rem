--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20181220
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2882
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
-- Variables
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2882';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);
V_SENTENCIA VARCHAR2(2000 CHAR);



BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO');

	EXECUTE IMMEDIATE ('
	MERGE INTO REM01.ACT_ADN_ADJNOJUDICIAL ADN
		USING (
		    SELECT ACT.ACT_ID, AUX.ADN_FECHA_TITULO  FROM REM01.ACT_ACTIVO ACT
		    JOIN REM01.AUX_REMVIP_3081 AUX ON AUX.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
		    JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO DD_TTA ON DD_TTA.DD_TTA_ID = ACT.DD_TTA_ID
		    JOIN REM01.ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID = ACT.ACT_ID
		    WHERE DD_TTA.DD_TTA_CODIGO = ''02'' AND DD_CRA_ID = 43 and aux.ADN_FECHA_TITULO <> ''NULL''
		)T2
		ON (ADN.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN
		UPDATE SET
		ADN.ADN_FECHA_TITULO = to_date(T2.ADN_FECHA_TITULO,''yyyy/mm/dd''),
		ADN.USUARIOMODIFICAR = ''REMVIP-3081'',
		ADN.FECHAMODIFICAR = SYSDATE'
	)
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO1]'||SQL%ROWCOUNT||' Filas.');

	EXECUTE IMMEDIATE ('

	MERGE INTO REM01.ACT_ADN_ADJNOJUDICIAL ADN
	USING (
	    SELECT ACT.ACT_ID, AUX.ADN_FECHA_TITULO  FROM REM01.ACT_ACTIVO ACT
	    JOIN REM01.AUX_REMVIP_3081 AUX ON AUX.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
	    JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO DD_TTA ON DD_TTA.DD_TTA_ID = ACT.DD_TTA_ID
	    JOIN REM01.ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID = ACT.ACT_ID
	    WHERE DD_TTA.DD_TTA_CODIGO = ''02'' AND DD_CRA_ID = 43 and aux.ADN_FECHA_TITULO = ''NULL''
	)T2
	ON (ADN.ACT_ID = T2.ACT_ID)
	WHEN MATCHED THEN
	UPDATE SET
	ADN.ADN_FECHA_TITULO = null,
	ADN.USUARIOMODIFICAR = ''REMVIP-3081'',
	ADN.FECHAMODIFICAR = SYSDATE'
	);

  DBMS_OUTPUT.PUT_LINE('[INFO2]'||SQL%ROWCOUNT||' Filas.');




  	EXECUTE IMMEDIATE ('

	MERGE INTO REM01.ACT_SPS_SIT_POSESORIA SPS
	USING (
	    SELECT ACT.ACT_ID, AUX.ADN_FECHA_TITULO FROM REM01.ACT_ACTIVO ACT
	    JOIN REM01.AUX_REMVIP_3081 AUX ON AUX.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
	    JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO DD_TTA ON DD_TTA.DD_TTA_ID = ACT.DD_TTA_ID
	    JOIN REM01.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
	    WHERE DD_TTA.DD_TTA_CODIGO = ''02'' AND DD_CRA_ID = 43 and aux.ADN_FECHA_TITULO <> ''NULL''
	)T2
	ON (SPS.ACT_ID = T2.ACT_ID)
	WHEN MATCHED THEN
	UPDATE SET
	SPS.SPS_FECHA_TOMA_POSESION =  to_date(T2.ADN_FECHA_TITULO,''yyyy/mm/dd''),
	SPS.USUARIOMODIFICAR = ''REMVIP-3081'',
	SPS.FECHAMODIFICAR = SYSDATE'
	);

  DBMS_OUTPUT.PUT_LINE('[INFO3]'||SQL%ROWCOUNT||' Filas.');



  	EXECUTE IMMEDIATE ('

	MERGE INTO REM01.ACT_SPS_SIT_POSESORIA SPS
	USING (
	    SELECT ACT.ACT_ID, AUX.ADN_FECHA_TITULO FROM REM01.ACT_ACTIVO ACT
	    JOIN REM01.AUX_REMVIP_3081 AUX ON AUX.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
	    JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO DD_TTA ON DD_TTA.DD_TTA_ID = ACT.DD_TTA_ID
	    JOIN REM01.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
	    WHERE DD_TTA.DD_TTA_CODIGO = ''02'' AND DD_CRA_ID = 43 and aux.ADN_FECHA_TITULO = ''NULL''
	)T2
	ON (SPS.ACT_ID = T2.ACT_ID)
	WHEN MATCHED THEN
	UPDATE SET
	SPS.SPS_FECHA_TOMA_POSESION = null,
	SPS.USUARIOMODIFICAR = ''REMVIP-3081'',
	SPS.FECHAMODIFICAR = SYSDATE'
	);

  DBMS_OUTPUT.PUT_LINE('[INFO4]'||SQL%ROWCOUNT||' Filas.');




  	EXECUTE IMMEDIATE ('

	MERGE INTO REM01.ACT_AJD_ADJJUDICIAL AJD
	USING (
	   SELECT ACT.ACT_ID, ACT_NUM_ACTIVO, AUX.ADN_FECHA_TITULO FROM REM01.ACT_ACTIVO ACT
	    JOIN REM01.AUX_REMVIP_3081 AUX ON AUX.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
	    JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO DD_TTA ON DD_TTA.DD_TTA_ID = ACT.DD_TTA_ID
	    JOIN REM01.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID = ACT.ACT_ID
	    WHERE DD_TTA.DD_TTA_CODIGO = ''01'' AND DD_CRA_ID = 43 and aux.ADN_FECHA_TITULO <> ''NULL''
	)T2
	ON (AJD.ACT_ID = T2.ACT_ID)
	WHEN MATCHED THEN
	UPDATE SET
	AJD.AJD_FECHA_ADJUDICACION =  to_date(T2.ADN_FECHA_TITULO,''yyyy/mm/dd''),
	AJD.USUARIOMODIFICAR = ''REMVIP-3081'',
	AJD.FECHAMODIFICAR = SYSDATE'
	);

  DBMS_OUTPUT.PUT_LINE('[INFO5]'||SQL%ROWCOUNT||' Filas.');




  	EXECUTE IMMEDIATE ('

		MERGE INTO REM01.ACT_AJD_ADJJUDICIAL AJD
		USING (
		   SELECT ACT.ACT_ID, ACT_NUM_ACTIVO, AUX.ADN_FECHA_TITULO FROM REM01.ACT_ACTIVO ACT
		    JOIN REM01.AUX_REMVIP_3081 AUX ON AUX.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
		    JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO DD_TTA ON DD_TTA.DD_TTA_ID = ACT.DD_TTA_ID
		    JOIN REM01.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID = ACT.ACT_ID
		    WHERE DD_TTA.DD_TTA_CODIGO = ''01'' AND DD_CRA_ID = 43 and aux.ADN_FECHA_TITULO = ''NULL''
		)T2
		ON (AJD.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN
		UPDATE SET
		AJD.AJD_FECHA_ADJUDICACION = null,
		AJD.USUARIOMODIFICAR = ''REMVIP-3081'',
		AJD.FECHAMODIFICAR = SYSDATE'
	);

  DBMS_OUTPUT.PUT_LINE('[INFO6]'||SQL%ROWCOUNT||' Filas.');





  	EXECUTE IMMEDIATE ('

		MERGE INTO REM01.ACT_TIT_TITULO TIT
		USING (
		    SELECT ACT.ACT_ID FROM REM01.ACT_ACTIVO ACT
		    JOIN REM01.AUX_REMVIP_3081 AUX ON AUX.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
		    JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO DD_TTA ON DD_TTA.DD_TTA_ID = ACT.DD_TTA_ID
		    JOIN REM01.ACT_TIT_TITULO TIT ON TIT.ACT_ID = ACT.ACT_ID 
		    WHERE DD_CRA_ID = 43 AND TIT.DD_ETI_ID IS NULL
		)T2
		ON (TIT.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN
		UPDATE SET
		TIT.DD_ETI_ID = 1,
		TIT.USUARIOMODIFICAR = ''REMVIP-3081'',
		TIT.FECHAMODIFICAR = SYSDATE'
	);

  DBMS_OUTPUT.PUT_LINE('[INFO7]'||SQL%ROWCOUNT||' Filas.');
	
  COMMIT;


  
EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;  
