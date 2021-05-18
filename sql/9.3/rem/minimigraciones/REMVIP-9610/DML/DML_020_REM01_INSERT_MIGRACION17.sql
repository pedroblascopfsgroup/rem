--/*
--#########################################
--## AUTOR=Viorel Remus OVidiu
--## FECHA_CREACION=20210429
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9610
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



	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9610';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
	V_TABLA VARCHAR2 (30 CHAR) := 'ACT_PTO_PRESUPUESTO';
	V_TABLA_2 VARCHAR2 (30 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');

      -------------------------------------------------
      --insercion en ACT_PTO_PRESUPUESTO--
      -------------------------------------------------
     V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
    
            DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_PTO_PRESUPUESTO');
        
    ELSE 
      
      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_PTO_PRESUPUESTO'',''2''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO (PTO_ID, ACT_ID, EJE_ID, PTO_IMPORTE_INICIAL, PTO_FECHA_ASIGNACION, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_PTO_PRESUPUESTO.NEXTVAL
            , ACT2.ACT_ID, PTO.EJE_ID, PTO.PTO_IMPORTE_INICIAL
            , SYSDATE, '''||V_USUARIO||''', SYSDATE
        	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
			JOIN '||V_ESQUEMA||'.'||V_TABLA||' PTO ON PTO.ACT_ID = ACT.ACT_ID';
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO creados. '||SQL%ROWCOUNT||' Filas.');
     
      END IF;

  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_2||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
    
            DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_APU_ACTIVO_PUBLICACION');
        
    ELSE 
      
      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_APU_ACTIVO_PUBLICACION'',''2''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION (APU_ID,
									ACT_ID,
									DD_TPU_ID,
									DD_EPV_ID,
									DD_EPA_ID,
									DD_TCO_ID,
									DD_MTO_V_ID,
									APU_MOT_OCULTACION_MANUAL_V,
									APU_CHECK_PUBLICAR_V,
									APU_CHECK_OCULTAR_V,
									APU_CHECK_OCULTAR_PRECIO_V,
									APU_CHECK_PUB_SIN_PRECIO_V,
									DD_MTO_A_ID,
									APU_MOT_OCULTACION_MANUAL_A,
									APU_CHECK_PUBLICAR_A,
									APU_CHECK_OCULTAR_A,
									APU_CHECK_OCULTAR_PRECIO_A,
									APU_CHECK_PUB_SIN_PRECIO_A,
									APU_FECHA_INI_VENTA,
									APU_FECHA_INI_ALQUILER,
									ES_CONDICONADO_ANTERIOR,
									DD_TPU_V_ID,
									DD_TPU_A_ID,
									APU_MOTIVO_PUBLICACION,
									APU_MOTIVO_PUBLICACION_ALQ,
									APU_FECHA_CAMB_PUBL_VENTA,
									APU_FECHA_CAMB_PUBL_ALQ,
									APU_FECHA_CAMB_PREC_VENTA,
									APU_FECHA_CAMB_PREC_ALQ,
									APU_FECHA_REVISION_PUB_VENTA,
									APU_FECHA_REVISION_PUB_ALQ,
									DD_POR_ID,
									VERSION,
									USUARIOCREAR,
									FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_APU_ACTIVO_PUBLICACION.NEXTVAL
            , ACT2.ACT_ID,
		APU.DD_TPU_ID,
		APU.DD_EPV_ID,
		APU.DD_EPA_ID,
		APU.DD_TCO_ID,
		APU.DD_MTO_V_ID,
		APU.APU_MOT_OCULTACION_MANUAL_V,
		APU.APU_CHECK_PUBLICAR_V,
		APU.APU_CHECK_OCULTAR_V,
		APU.APU_CHECK_OCULTAR_PRECIO_V,
		APU.APU_CHECK_PUB_SIN_PRECIO_V,
		APU.DD_MTO_A_ID,
		APU.APU_MOT_OCULTACION_MANUAL_A,
		APU.APU_CHECK_PUBLICAR_A,
		APU.APU_CHECK_OCULTAR_A,
		APU.APU_CHECK_OCULTAR_PRECIO_A,
		APU.APU_CHECK_PUB_SIN_PRECIO_A,
		APU.APU_FECHA_INI_VENTA,
		APU.APU_FECHA_INI_ALQUILER,
		APU.ES_CONDICONADO_ANTERIOR,
		APU.DD_TPU_V_ID,
		APU.DD_TPU_A_ID,
		APU.APU_MOTIVO_PUBLICACION,
		APU.APU_MOTIVO_PUBLICACION_ALQ,
		APU.APU_FECHA_CAMB_PUBL_VENTA,
		APU.APU_FECHA_CAMB_PUBL_ALQ,
		APU.APU_FECHA_CAMB_PREC_VENTA,
		APU.APU_FECHA_CAMB_PREC_ALQ,
		APU.APU_FECHA_REVISION_PUB_VENTA,
		APU.APU_FECHA_REVISION_PUB_ALQ,
		APU.DD_POR_ID,
                0,'''||V_USUARIO||''', SYSDATE
        	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
			JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' APU ON APU.ACT_ID = ACT.ACT_ID';
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION creados. '||SQL%ROWCOUNT||' Filas.');
     
      END IF;
      
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

EXIT;
