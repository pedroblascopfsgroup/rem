--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180521
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-815
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
    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-815';
    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(4000 CHAR);

BEGIN

    PL_OUTPUT := '[INICIO]' || CHR(10);

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS WHERE EXISTS (
	    SELECT 1
	    FROM PFSREM.AUX_GIANTS_REL_ACTIVOS AUX
	    JOIN '||V_ESQUEMA||'.ACT_ACTIVO GIA ON GIA.ACT_NUM_ACTIVO = AUX.NEW_ACT_NUM_ACTIVO AND GIA.BORRADO = 0
	    JOIN '||V_ESQUEMA||'.BIE_VALORACIONES BIE ON BIE.BIE_ID = GIA.BIE_ID AND BIE.USUARIOCREAR = ''TRASPASO_GIANTS''
	    WHERE TAS.BIE_VAL_ID = BIE.BIE_VAL_ID
	    )';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros eliminados de la tabla ACT_TAS_TASACION' || CHR(10);
    
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.BIE_VALORACIONES VAL WHERE EXISTS (
	    SELECT 1
	    FROM PFSREM.AUX_GIANTS_REL_ACTIVOS AUX
	    JOIN '||V_ESQUEMA||'.ACT_ACTIVO GIA ON GIA.ACT_NUM_ACTIVO = AUX.NEW_ACT_NUM_ACTIVO AND GIA.BORRADO = 0
	    JOIN '||V_ESQUEMA||'.BIE_VALORACIONES BIE ON BIE.BIE_ID = GIA.BIE_ID AND BIE.USUARIOCREAR = ''TRASPASO_GIANTS''
	    WHERE VAL.BIE_VAL_ID = BIE.BIE_VAL_ID
	    )';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros eliminados de la tabla BIE_VALORACIONES' || CHR(10);
        
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.BIE_VALORACIONES (BIE_VAL_ID,BIE_ID,BIE_FECHA_VALOR_SUBJETIVO,BIE_IMPORTE_VALOR_SUBJETIVO,BIE_FECHA_VALOR_APRECIACION,BIE_IMPORTE_VALOR_APRECIACION
		    ,BIE_FECHA_VALOR_TASACION,BIE_IMPORTE_VALOR_TASACION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,BORRADO,BIE_RESPUESTA_CONSULTA,BIE_VALOR_TASACION_EXT
		    ,BIE_F_TAS_EXTERNA,DD_TRA_ID,BIE_F_SOL_TASACION,BIE_CD_NUITA)
		WITH VAL AS (
		    SELECT BIE.*
		    FROM '||V_ESQUEMA||'.BIE_VALORACIONES BIE
		    )
		SELECT '||V_ESQUEMA||'.S_BIE_VALORACIONES.NEXTVAL, GIA.BIE_ID, VAL.BIE_FECHA_VALOR_SUBJETIVO, VAL.BIE_IMPORTE_VALOR_SUBJETIVO, VAL.BIE_FECHA_VALOR_APRECIACION
		    , VAL.BIE_IMPORTE_VALOR_APRECIACION, VAL.BIE_FECHA_VALOR_TASACION, VAL.BIE_IMPORTE_VALOR_TASACION, VAL.VERSION, '''||V_USUARIO||''', SYSDATE, VAL.BIE_VAL_ID
		    , VAL.BORRADO, VAL.BIE_RESPUESTA_CONSULTA, VAL.BIE_VALOR_TASACION_EXT
		    , VAL.BIE_F_TAS_EXTERNA, VAL.DD_TRA_ID, VAL.BIE_F_SOL_TASACION, VAL.BIE_CD_NUITA
		FROM PFSREM.AUX_GIANTS_REL_ACTIVOS AUX
		JOIN '||V_ESQUEMA||'.ACT_ACTIVO BNK ON BNK.ACT_NUM_ACTIVO = AUX.OLD_ACT_NUM_ACTIVO
		JOIN '||V_ESQUEMA||'.ACT_ACTIVO GIA ON GIA.ACT_NUM_ACTIVO = AUX.NEW_ACT_NUM_ACTIVO AND GIA.BORRADO = 0
		JOIN VAL ON VAL.BIE_ID = BNK.BIE_ID AND VAL.BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros creados en la tabla BIE_VALORACIONES' || CHR(10);
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_TAS_TASACION (TAS_ID, ACT_ID, BIE_VAL_ID, DD_TTS_ID, TAS_FECHA_INI_TASACION, TAS_FECHA_RECEPCION_TASACION, TAS_CODIGO_FIRMA
		    , TAS_NOMBRE_TASADOR, TAS_IMPORTE_TAS_FIN, TAS_COSTE_REPO_NETO_ACTUAL, TAS_COSTE_REPO_NETO_FINALIZADO, TAS_COEF_MERCADO_ESTADO
		    , TAS_COEF_POND_VALOR_ANYADIDO, TAS_VALOR_REPER_SUELO_CONST, TAS_COSTE_CONST_CONST, TAS_INDICE_DEPRE_FISICA, TAS_INDICE_DEPRE_FUNCIONAL
		    , TAS_INDICE_TOTAL_DEPRE, TAS_COSTE_CONST_DEPRE, TAS_COSTE_UNI_REPO_NETO, TAS_COSTE_REPOSICION, TAS_PORCENTAJE_OBRA, TAS_IMPORTE_VALOR_TER
		    , TAS_ID_TEXTO_ASOCIADO, TAS_IMPORTE_VAL_LEGAL_FINCA, TAS_IMPORTE_VAL_SOLAR, TAS_OBSERVACIONES, VERSION, USUARIOCREAR, FECHACREAR
		    , BORRADO, TAS_ID_EXTERNO)
		WITH VAL AS (
		    SELECT BIE.*
		    FROM '||V_ESQUEMA||'.BIE_VALORACIONES BIE
		    )
		, TAS AS (
		    SELECT BIE.BIE_ID, TAS.*
		    FROM '||V_ESQUEMA||'.BIE_VALORACIONES BIE
		    JOIN '||V_ESQUEMA||'.ACT_TAS_TASACION TAS ON TAS.BIE_VAL_ID = BIE.BIE_VAL_ID
		    )
		SELECT '||V_ESQUEMA||'.S_ACT_TAS_TASACION.NEXTVAL, GIA.ACT_ID, VAL.BIE_VAL_ID, TAS.DD_TTS_ID, TAS.TAS_FECHA_INI_TASACION, TAS.TAS_FECHA_RECEPCION_TASACION
		    , TAS.TAS_CODIGO_FIRMA, TAS.TAS_NOMBRE_TASADOR, TAS.TAS_IMPORTE_TAS_FIN, TAS.TAS_COSTE_REPO_NETO_ACTUAL, TAS.TAS_COSTE_REPO_NETO_FINALIZADO
		    , TAS.TAS_COEF_MERCADO_ESTADO, TAS.TAS_COEF_POND_VALOR_ANYADIDO, TAS.TAS_VALOR_REPER_SUELO_CONST, TAS.TAS_COSTE_CONST_CONST
		    , TAS.TAS_INDICE_DEPRE_FISICA, TAS.TAS_INDICE_DEPRE_FUNCIONAL, TAS.TAS_INDICE_TOTAL_DEPRE, TAS.TAS_COSTE_CONST_DEPRE, TAS.TAS_COSTE_UNI_REPO_NETO
		    , TAS.TAS_COSTE_REPOSICION, TAS.TAS_PORCENTAJE_OBRA, TAS.TAS_IMPORTE_VALOR_TER, TAS.TAS_ID_TEXTO_ASOCIADO, TAS.TAS_IMPORTE_VAL_LEGAL_FINCA
		    , TAS.TAS_IMPORTE_VAL_SOLAR, TAS.TAS_OBSERVACIONES, TAS.VERSION, '''||V_USUARIO||''', SYSDATE,  TAS.BORRADO, TAS.TAS_ID_EXTERNO
		FROM PFSREM.AUX_GIANTS_REL_ACTIVOS AUX
		JOIN '||V_ESQUEMA||'.ACT_ACTIVO BNK ON BNK.ACT_NUM_ACTIVO = AUX.OLD_ACT_NUM_ACTIVO
		JOIN '||V_ESQUEMA||'.ACT_ACTIVO GIA ON GIA.ACT_NUM_ACTIVO = AUX.NEW_ACT_NUM_ACTIVO AND GIA.BORRADO = 0
		JOIN VAL ON VAL.BIE_ID = GIA.BIE_ID
		JOIN TAS ON TAS.BIE_ID = BNK.BIE_ID AND TO_CHAR(TAS.BIE_VAL_ID) = VAL.USUARIOMODIFICAR AND TAS.BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros creados en la tabla ACT_TAS_TASACION' || CHR(10);

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_VALORACIONES SET USUARIOMODIFICAR = NULL WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros actualizados en la tabla BIE_VALORACIONES' || CHR(10);

    V_MSQL := 'MERGE INTO REM01.ACT_ACTIVO T1
		USING PFSREM.AUX_GIANTS_REL_ACTIVOS T2
		ON (T1.ACT_NUM_ACTIVO = T2.NEW_ACT_NUM_ACTIVO)
		WHEN MATCHED THEN UPDATE SET
		    T1.DD_TTA_ID = (SELECT DD_TTA_ID FROM REM01.DD_TTA_TIPO_TITULO_ACTIVO WHERE DD_TTA_CODIGO = ''02'')
		    , T1.DD_STA_ID = (SELECT DD_STA_ID FROM REM01.DD_STA_SUBTIPO_TITULO_ACTIVO WHERE DD_STA_CODIGO = ''03'')
		    , T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
		WHERE T1.DD_TTA_ID = (SELECT DD_TTA_ID FROM REM01.DD_TTA_TIPO_TITULO_ACTIVO WHERE DD_TTA_CODIGO = ''01'')';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros actualizados en la tabla ACT_ACTIVO (DD_TTA_ID, DD_STA_ID)' || CHR(10);

    V_MSQL := 'MERGE INTO REM01.ACT_ADN_ADJNOJUDICIAL T1
		USING (
		    SELECT ACT.ACT_ID
		    FROM REM01.ACT_ACTIVO ACT
		    JOIN PFSREM.AUX_GIANTS_REL_ACTIVOS AUX ON AUX.NEW_ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
		    JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID AND TTA.DD_TTA_CODIGO = ''02''
		    JOIN REM01.DD_STA_SUBTIPO_TITULO_ACTIVO STA ON STA.DD_STA_ID = ACT.DD_STA_ID AND STA.DD_TTA_ID = TTA.DD_TTA_ID AND STA.DD_STA_CODIGO = ''03''
		    ) T2
		ON (T1.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN UPDATE SET
		    T1.ADN_FECHA_TITULO = TO_DATE(''23/03/2018'',''DD/MM/YYYY''), T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
		    , T1.FECHAMODIFICAR = SYSDATE
		WHERE NVL(T1.ADN_FECHA_TITULO,SYSDATE) <> TO_DATE(''23/03/2018'',''DD/MM/YYYY'')
		WHEN NOT MATCHED THEN INSERT (T1.ADN_ID, T1.ACT_ID, T1.ADN_FECHA_TITULO, T1.ADN_VALOR_ADQUISICION
		    , T1.USUARIOCREAR, T1.FECHACREAR)
		VALUES (REM01.S_ACT_ADN_ADJNOJUDICIAL.NEXTVAL, T2.ACT_ID, TO_DATE(''23/03/2018'',''DD/MM/YYYY''), 0
		    , '''||V_USUARIO||''', SYSDATE)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros fusionados en la tabla ACT_ADN_AJDNOJUDICIAL' || CHR(10);

    PL_OUTPUT := PL_OUTPUT || '[FIN]' || CHR(10);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
    
EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecución: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL;
        DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
        ROLLBACK;
        RAISE;
END;
/
EXIT;