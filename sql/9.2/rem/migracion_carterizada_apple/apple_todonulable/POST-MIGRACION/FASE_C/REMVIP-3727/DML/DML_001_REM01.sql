--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190323
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-3727
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
	V_SQL VARCHAR2(20000 CHAR);
    TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...'); 
    
    V_SQL :=  'MERGE INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES T1 
				USING (
				SELECT REG.BIE_DREG_ID,
					   BIE.BIE_ID,
					   ACT.ACT_ID,
					   (SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = LPAD(AUX.MUNICIPIO_REGISTRO,5,''0''))               AS DD_LOC_ID,
					   AUX.REG_NUM_REGISTRO                                                                                                                AS BIE_DREG_NUM_REGISTRO,
					   AUX.REG_TOMO                                                                                                                        AS BIE_DREG_TOMO, 
					   AUX.REG_LIBRO                                                                                                                       AS BIE_DREG_LIBRO, 
					   AUX.REG_FOLIO                                                                                                                       AS BIE_DREG_FOLIO,
					   AUX.REG_NUM_FINCA                                                                                                                   AS BIE_DREG_NUM_FINCA, 
					   AUX.REG_SUPERFICIE_CONSTRUIDA                                                                                                       AS BIE_DREG_SUPERFICIE_CONSTRUIDA,
					   (SELECT UPPER(DD_LOC_DESCRIPCION) FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = LPAD(AUX.BIE_DREG_MUNICIPIO_LIBRO,5,''0'')) AS BIE_DREG_MUNICIPIO_LIBRO
				FROM '||V_ESQUEMA||'.AUX_MMC_REMVIP_3727       AUX
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO                ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUMERO_ACTIVO
				JOIN '||V_ESQUEMA||'.BIE_BIEN                  BIE ON BIE.BIE_ID = ACT.BIE_ID
				JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES     REG ON REG.BIE_ID = BIE.BIE_ID
				WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
				) T2
				ON (T1.BIE_DREG_ID = T2.BIE_DREG_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.DD_LOC_ID = T2.DD_LOC_ID, 
					T1.BIE_DREG_NUM_REGISTRO = T2.BIE_DREG_NUM_REGISTRO, 
					T1.BIE_DREG_TOMO = T2.BIE_DREG_TOMO, 
					T1.BIE_DREG_LIBRO = T2.BIE_DREG_LIBRO, 
					T1.BIE_DREG_FOLIO = T2.BIE_DREG_FOLIO, 
					T1.BIE_DREG_NUM_FINCA = T2.BIE_DREG_NUM_FINCA, 
					T1.BIE_DREG_SUPERFICIE_CONSTRUIDA = T2.BIE_DREG_SUPERFICIE_CONSTRUIDA, 
					T1.BIE_DREG_MUNICIPIO_LIBRO = T2.BIE_DREG_MUNICIPIO_LIBRO,
					T1.USUARIOMODIFICAR = ''REMVIP-3727'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. En la BIE_DATOS_REGISTRALES.'); 
	
	V_SQL :=   'MERGE INTO '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL T1 
				USING (
				SELECT REGIN.REG_ID,
					   REG.BIE_DREG_ID,
					   BIE.BIE_ID,
					   ACT.ACT_ID,
					   AUX.REG_IDUFIR                       AS REG_IDUFIR,
					   AUX.REG_SUPERFICIE_UTIL				AS REG_SUPERFICIE_UTIL
				FROM '||V_ESQUEMA||'.AUX_MMC_REMVIP_3727       AUX
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO                ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUMERO_ACTIVO
				JOIN '||V_ESQUEMA||'.BIE_BIEN                  BIE ON BIE.BIE_ID = ACT.BIE_ID
				JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES     REG ON REG.BIE_ID = BIE.BIE_ID
				JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL    REGIN ON REGIN.ACT_ID = ACT.ACT_ID AND REGIN.BIE_DREG_ID = REG.BIE_DREG_ID
				WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
				) T2
				ON (T1.BIE_DREG_ID = T2.BIE_DREG_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.REG_IDUFIR = T2.REG_IDUFIR, 
					T1.REG_SUPERFICIE_UTIL = T2.REG_SUPERFICIE_UTIL,
					T1.USUARIOMODIFICAR = ''REMVIP-3727'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. En la ACT_REG_INFO_REGISTRAL.'); 

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
