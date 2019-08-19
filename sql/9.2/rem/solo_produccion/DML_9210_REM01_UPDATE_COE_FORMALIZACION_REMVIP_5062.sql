--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190819
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.14
--## INCIDENCIA_LINK=REMVIP-5062
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
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; 			--REM01
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; 	--REMMASTER
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-5062';
    V_TABLA_MIG VARCHAR2(40 CHAR) := 'AUX_REMVIP_5062';
    V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    EXECUTE IMMEDIATE 'MERGE INTO REM01.COE_CONDICIONANTES_EXPEDIENTE T1
                       USING (SELECT DISTINCT COE.COE_ID  
                               FROM REM01.OFR_OFERTAS OFR
                               INNER JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO      ON OFR.OFR_ID = ECO.OFR_ID
                               INNER JOIN REM01.COE_CONDICIONANTES_EXPEDIENTE COE ON ECO.ECO_ID = COE.ECO_ID
                               INNER JOIN REM01.AUX_REMVIP_5062 AUX       ON AUX.ID_OFERTA_REM = OFR.OFR_NUM_OFERTA
                       ) T2
		ON (T1.COE_ID = T2.COE_ID)
		WHEN MATCHED THEN UPDATE SET
		      T1.COE_SOLICITA_FINANCIACION = 1
		    , T1.COE_ENTIDAD_FINANCIACION_AJENA = ''BANKIA''
		    , T1.DD_ETF_ID = 1
		    , T1.USUARIOMODIFICAR = ''REMVIP-5062''
		    , T1.FECHAMODIFICAR = SYSDATE';
		      
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' registros de COE_CONDICIONANTES_EXPEDIENTES actualizados.');


    EXECUTE IMMEDIATE 'MERGE INTO REM01.FOR_FORMALIZACION T1
                       USING (SELECT FFOR.FOR_ID
                                   , ECO.ECO_ID
                                   , AUX.NUM_EXPEDIENTE AS FOR_NUMEXPEDIENTE
                                   , AUX.IMP_FINANCIACION_VENTA AS FOR_CAPITALCONCEDIDO
                              FROM REM01.OFR_OFERTAS OFR
                              INNER JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID
                              LEFT JOIN REM01.FOR_FORMALIZACION FFOR       ON ECO.ECO_ID = FFOR.ECO_ID
                              INNER JOIN REM01.AUX_REMVIP_5062 AUX  ON AUX.ID_OFERTA_REM = OFR.OFR_NUM_OFERTA
                              GROUP BY FFOR.FOR_ID
                                   , ECO.ECO_ID                              
                                   , AUX.NUM_EXPEDIENTE
                                   , AUX.IMP_FINANCIACION_VENTA
                       ) T2
                ON (T1.FOR_ID = T2.FOR_ID)
                WHEN MATCHED THEN UPDATE SET
                        T1.FOR_NUMEXPEDIENTE = T2.FOR_NUMEXPEDIENTE
                      , T1.FOR_CAPITALCONCEDIDO = TO_NUMBER(T2.FOR_CAPITALCONCEDIDO) 
                      , T1.DD_TRC_ID = 39
                      , T1.USUARIOMODIFICAR = ''REMVIP-5062''
                      , T1.FECHAMODIFICAR = SYSDATE
                WHEN NOT MATCHED THEN INSERT (FOR_ID, ECO_ID, VERSION, USUARIOCREAR, FECHACREAR, FOR_NUMEXPEDIENTE, FOR_CAPITALCONCEDIDO, DD_TRC_ID)
                       VALUES ( REM01.S_FOR_FORMALIZACION.NEXTVAL
                               , T2.ECO_ID
                               , 0 
                               , ''REMVIP-5062''
                               , SYSDATE
                               , T2.FOR_NUMEXPEDIENTE
                               , T2.FOR_CAPITALCONCEDIDO
                               , 39)'
                      ;
                      
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' registros de FOR_FORMALIZACION actualizados.');
    
    
        
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

