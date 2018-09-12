--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180912
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-1740
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva: Comisiones LBK.
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'GEX_GASTOS_EXPEDIENTE';
V_SQL VARCHAR2(12000 CHAR);
V_SENTENCIA VARCHAR2(32000 CHAR);
PL_OUTPUT VARCHAR2(32000 CHAR);
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1740';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);
	
	V_SQL := '  INSERT INTO REM01.GEX_GASTOS_EXPEDIENTE GEX
				(
					GEX_ID, ECO_ID, DD_ACC_ID, GEX_CODIGO, GEX_NOMBRE, 
					DD_TCC_ID, GEX_IMPORTE_CALCULO, GEX_IMPORTE_FINAL, 
					GEX_PAGADOR, USUARIOCREAR, BORRADO, FECHACREAR, 
					GEX_PROVEEDOR, GEX_APROBADO, DD_DEG_ID, ACT_ID 
				)
				SELECT REM01.S_GEX_GASTOS_EXPEDIENTE.NEXTVAL                    AS GEX_ID,
					   ECO.ECO_ID                                               AS ECO_ID,
					   ACC.DD_ACC_ID                                            AS DD_ACC_ID,
					   ACC.DD_ACC_DESCRIPCION                                   AS GEX_CODIGO,
					   ACC.DD_ACC_DESCRIPCION                                   AS GEX_NOMBRE,
					   CASE WHEN REPLACE(COMISION_CUSTODIO,''-'','''') IS NOT NULL    THEN (SELECT DD_TCC_ID FROM REM01.DD_TCC_TIPO_CALCULO TCC WHERE TCC.DD_TCC_CODIGO = ''02'')          
																				  ELSE (SELECT DD_TCC_ID FROM REM01.DD_TCC_TIPO_CALCULO TCC WHERE TCC.DD_TCC_CODIGO = ''01'') END
																				AS DD_TCC_ID, 
					   CASE WHEN REPLACE(COMISION_CUSTODIO,''-'','''') IS NOT NULL                                                                                  THEN TO_NUMBER(REPLACE(COMISION_CUSTODIO,''.'',''''))        
							WHEN REPLACE(COMISION_CUSTODIO,''-'','''') IS NULL AND (REPLACE(IMPORTE,''-'','''') IS NOT NULL) AND (COMISION_CUSTODIO_POR IS NOT NULL) THEN TO_NUMBER(REPLACE(COMISION_CUSTODIO_POR,''%'',''''))                                                  
							WHEN REPLACE(COMISION_CUSTODIO,''-'','''') IS NULL AND (REPLACE(IMPORTE,''-'','''') IS NULL) AND (COMISION_CUSTODIO_POR IS NOT NULL)     THEN TO_NUMBER(REPLACE(COMISION_CUSTODIO_POR,''%'',''''))                                                                                                                                                                
																																								   ELSE 0.75 
																																								   END 
																				AS GEX_IMPORTE_CALCULO,                                                       
					   CASE WHEN REPLACE(COMISION_CUSTODIO,''-'','''') IS NOT NULL                                                                                  THEN TO_NUMBER(REPLACE(COMISION_CUSTODIO,''.'',''''))        
							WHEN REPLACE(COMISION_CUSTODIO,''-'','''') IS NULL AND (REPLACE(IMPORTE,''-'','''') IS NOT NULL) AND (COMISION_CUSTODIO_POR IS NOT NULL) THEN TO_NUMBER(REPLACE(COMISION_CUSTODIO_POR,''%'','''')) * TO_NUMBER(REPLACE(IMPORTE,''.'','''')) / 100                                                   
							WHEN REPLACE(COMISION_CUSTODIO,''-'','''') IS NULL AND (REPLACE(IMPORTE,''-'','''') IS NULL) AND (COMISION_CUSTODIO_POR IS NOT NULL)     THEN TO_NUMBER(REPLACE(COMISION_CUSTODIO_POR,''%'','''')) * TO_NUMBER(REPLACE(OFR.OFR_IMPORTE,''.'','''')) / 100                                                                                                                                                                 
																																								   ELSE TO_NUMBER(REPLACE(OFR.OFR_IMPORTE,''.'','''')) * 0.0075 
																																								   END                                                            
																				AS GEX_IMPORTE_FINAL, 
					   0                                                        AS GEX_PAGADOR,  
					   ''REMVIP-1740''                                          AS USUARIOCREAR,
					   0                                                        AS BORRADO,
					   SYSDATE                                                  AS FECHACREAR,
					   PVE.PVE_ID                                               AS GEX_PROVEEDOR,
					   1                                                        AS GEX_APROBADO,
					   DEG.DD_DEG_ID                                            AS DD_DEG_ID,
					   ACT.ACT_ID                                               AS ACT_ID
				FROM REM01.AUX_MMC_COMISIONES_CRUCES   AUX1
				JOIN REM01.AUX_MMC_COMISIONES_LIBER    AUX2
				  ON AUX1.ID_INMUEBLE = AUX2.CODIGO_PRINEX 
				JOIN REM01.ACT_ACTIVO                  ACT
				  ON AUX1.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
				JOIN REM01.ACT_ICO_INFO_COMERCIAL      ICO
				  ON ACT.ACT_ID = ICO.ACT_ID
				JOIN REM01.ACT_OFR                     AOF
				  ON AOF.ACT_ID = ACT.ACT_ID
				JOIN REM01.OFR_OFERTAS                 OFR
				  ON OFR.OFR_ID = AOF.OFR_ID
				JOIN REM01.ECO_EXPEDIENTE_COMERCIAL    ECO
				  ON ECO.OFR_ID = OFR.OFR_ID
				JOIN REM01.ACT_PVE_PROVEEDOR      PVE
				  ON PVE.PVE_ID = ICO.ICO_MEDIADOR_ID
				JOIN REM01.DD_ACC_ACCION_GASTOS        ACC
				  ON ACC.DD_ACC_CODIGO = ''05''
				JOIN REM01.DD_DEG_DESTINATARIOS_GASTO  DEG
				  ON DEG.DD_DEG_CODIGO = ''03''
	';
	EXECUTE IMMEDIATE V_SQL;		
	PL_OUTPUT := PL_OUTPUT || '[INFO] Se han insertado '||SQL%ROWCOUNT||' Comisiones de mediadores en la '|| V_TABLA || ' ' || CHR(10);
	
	
	V_SQL := '  INSERT INTO REM01.GEX_GASTOS_EXPEDIENTE GEX
				(
					GEX_ID, ECO_ID, DD_ACC_ID, GEX_CODIGO, GEX_NOMBRE, 
					DD_TCC_ID, GEX_IMPORTE_CALCULO, GEX_IMPORTE_FINAL, 
					GEX_PAGADOR, USUARIOCREAR, BORRADO, FECHACREAR, 
					GEX_PROVEEDOR, GEX_APROBADO, DD_DEG_ID, ACT_ID 
				)
				SELECT REM01.S_GEX_GASTOS_EXPEDIENTE.NEXTVAL                    AS GEX_ID,
					   ECO.ECO_ID                                               AS ECO_ID,
					   ACC.DD_ACC_ID                                            AS DD_ACC_ID,
					   ACC.DD_ACC_DESCRIPCION                                   AS GEX_CODIGO,
					   ACC.DD_ACC_DESCRIPCION                                   AS GEX_NOMBRE,
					   CASE WHEN REPLACE(COMISION_PRESCRIPTOR,''-'','''') IS NOT NULL THEN (SELECT DD_TCC_ID FROM REM01.DD_TCC_TIPO_CALCULO TCC WHERE TCC.DD_TCC_CODIGO = ''02'')          
																				  ELSE (SELECT DD_TCC_ID FROM REM01.DD_TCC_TIPO_CALCULO TCC WHERE TCC.DD_TCC_CODIGO = ''01'') END
																				AS DD_TCC_ID, 
					   CASE WHEN REPLACE(COMISION_PRESCRIPTOR,''-'','''') IS NOT NULL                                                                                  THEN TO_NUMBER(REPLACE(COMISION_PRESCRIPTOR,''.'',''''))        
							WHEN REPLACE(COMISION_PRESCRIPTOR,''-'','''') IS NULL AND (REPLACE(IMPORTE,''-'','''') IS NOT NULL) AND (COMISION_PRESCRIPTOR_POR IS NOT NULL) THEN TO_NUMBER(REPLACE(COMISION_PRESCRIPTOR_POR,''%'',''''))                                                  
							WHEN REPLACE(COMISION_PRESCRIPTOR,''-'','''') IS NULL AND (REPLACE(IMPORTE,''-'','''') IS NULL) AND (COMISION_PRESCRIPTOR_POR IS NOT NULL)     THEN TO_NUMBER(REPLACE(COMISION_PRESCRIPTOR_POR,''%'',''''))                                                                                                                                                                
																																								   ELSE 2.25 
																																								   END 
																				AS GEX_IMPORTE_CALCULO,                                                       
					   CASE WHEN REPLACE(COMISION_PRESCRIPTOR,''-'','''') IS NOT NULL                                                                                  THEN TO_NUMBER(REPLACE(COMISION_PRESCRIPTOR,''.'',''''))        
							WHEN REPLACE(COMISION_PRESCRIPTOR,''-'','''') IS NULL AND (REPLACE(IMPORTE,''-'','''') IS NOT NULL) AND (COMISION_PRESCRIPTOR_POR IS NOT NULL) THEN TO_NUMBER(REPLACE(COMISION_PRESCRIPTOR_POR,''%'','''')) * TO_NUMBER(REPLACE(IMPORTE,''.'','''')) / 100                                                   
							WHEN REPLACE(COMISION_PRESCRIPTOR,''-'','''') IS NULL AND (REPLACE(IMPORTE,''-'','''') IS NULL) AND (COMISION_PRESCRIPTOR_POR IS NOT NULL)     THEN TO_NUMBER(REPLACE(COMISION_PRESCRIPTOR_POR,''%'','''')) * TO_NUMBER(REPLACE(OFR.OFR_IMPORTE,''.'','''')) / 100                                                                                                                                                                 
																																								   ELSE TO_NUMBER(REPLACE(OFR.OFR_IMPORTE,''.'','''')) * 0.0225 
																																								   END                                                            
																				AS GEX_IMPORTE_FINAL, 
					   0                                                        AS GEX_PAGADOR,  
					   ''REMVIP-1740''                                          AS USUARIOCREAR,
					   0                                                        AS BORRADO,
					   SYSDATE                                                  AS FECHACREAR,
					   PVE.PVE_ID                                               AS GEX_PROVEEDOR,
					   1                                                        AS GEX_APROBADO,
					   DEG.DD_DEG_ID                                            AS DD_DEG_ID,
					   ACT.ACT_ID                                               AS ACT_ID
				FROM REM01.AUX_MMC_COMISIONES_CRUCES   AUX1
				JOIN REM01.AUX_MMC_COMISIONES_LIBER    AUX2
				  ON AUX1.ID_INMUEBLE = AUX2.CODIGO_PRINEX 
				JOIN REM01.ACT_ACTIVO                  ACT
				  ON AUX1.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
				JOIN REM01.ACT_OFR                     AOF
				  ON AOF.ACT_ID = ACT.ACT_ID
				JOIN REM01.OFR_OFERTAS                 OFR
				  ON OFR.OFR_ID = AOF.OFR_ID
				JOIN REM01.ECO_EXPEDIENTE_COMERCIAL    ECO
				  ON ECO.OFR_ID = OFR.OFR_ID
				JOIN REM01.ACT_PVE_PROVEEDOR      PVE
				  ON PVE.PVE_ID = OFR.PVE_ID_PRESCRIPTOR
				JOIN REM01.DD_ACC_ACCION_GASTOS        ACC
				  ON ACC.DD_ACC_CODIGO = ''04''
				JOIN REM01.DD_DEG_DESTINATARIOS_GASTO  DEG
				  ON DEG.DD_DEG_CODIGO = ''03''
	';
	EXECUTE IMMEDIATE V_SQL;		
	PL_OUTPUT := PL_OUTPUT || '[INFO] Se han insertado '||SQL%ROWCOUNT||' Comisiones de prescriptores en la '|| V_TABLA || ' ' || CHR(10);

    COMMIT;

	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

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
