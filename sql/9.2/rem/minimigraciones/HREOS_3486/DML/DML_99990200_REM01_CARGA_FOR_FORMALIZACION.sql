--/*
--#########################################
--## AUTOR=Vicente Martinez
--## FECHA_CREACION=20171219
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.10
--## INCIDENCIA_LINK=HREOS-3486
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración ''||V_TABLA_MIG||'' -> 'FOR_FORMALIZACION'
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

    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-3486';
    V_TABLA VARCHAR2(40 CHAR) := 'FOR_FORMALIZACION';
    V_TABLA_MIG VARCHAR2(40 CHAR) := 'AUX_FOR_FORMALIZACION';
    V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE VOLCADO SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
    
    EXECUTE IMMEDIATE 'MERGE INTO FOR_FORMALIZACION T1
			USING (SELECT ECO.ECO_ID, TRC.DD_TRC_ID, AUX.FOR_NUMEXPEDIENTE, AUX.FOR_CAPITALCONCEDIDO
			    FROM REM01.AUX_FOR_FORMALIZACION AUX 
			    INNER JOIN REM01.OFR_OFERTAS OFR ON AUX.OFR_NUM_OFERTA = OFR.OFR_NUM_OFERTA
			    INNER JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID
			    JOIN REM01.DD_TRC_TIPO_RIESGO_CLASE TRC ON TRC.DD_TRC_CODIGO = AUX.DD_TRC_ID) T2
			ON (T1.ECO_ID = T2.ECO_ID AND T1.DD_TRC_ID = T2.DD_TRC_ID AND T1.FOR_NUMEXPEDIENTE = TO_CHAR(T2.FOR_NUMEXPEDIENTE))
			WHEN MATCHED THEN UPDATE SET
			    T1.FOR_CAPITALCONCEDIDO = T2.FOR_CAPITALCONCEDIDO, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
			WHERE T1.FOR_CAPITALCONCEDIDO <> T2.FOR_CAPITALCONCEDIDO
			WHEN NOT MATCHED THEN INSERT (FOR_ID,ECO_ID,USUARIOCREAR,FECHACREAR,DD_TRC_ID,FOR_NUMEXPEDIENTE,FOR_CAPITALCONCEDIDO)
			VALUES (REM01.S_FOR_FORMALIZACION.NEXTVAL, T2.ECO_ID, '''||V_USUARIO||''', SYSDATE, T2.DD_TRC_ID, T2.FOR_NUMEXPEDIENTE, T2.FOR_CAPITALCONCEDIDO)';

    DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS FUSIONADOS: ' ||SQL%ROWCOUNT);

    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
