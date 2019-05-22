--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190314
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3555
--## PRODUCTO=NO
--## 
--## Finalidad: Igualar el estado de publicación actual AHP con el de la APU
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-3555'; -- Usuario modificar
    V_COUNT NUMBER(16);
    
BEGIN
    
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''AUX_APU_AHP'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
    
    IF V_COUNT > 0 THEN
        V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.AUX_APU_AHP';
        EXECUTE IMMEDIATE V_MSQL;
    END IF;
    
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.AUX_APU_AHP AS(
                    SELECT ACT.ACT_ID, ACT.ACT_NUM_ACTIVO, AHP.AHP_ID, APU.APU_ID, 
                    CASE
                        WHEN (AHP.AHP_FECHA_INI_VENTA IS NOT NULL AND AHP.AHP_FECHA_FIN_VENTA IS NULL) AND APU.DD_TCO_ID IN (1,2) AND APU.DD_EPV_ID <> AHP.DD_EPV_ID THEN 1
                        ELSE 0
                    END VENTA_MAL,
                    CASE
                        WHEN (AHP.AHP_FECHA_INI_ALQUILER IS NOT NULL AND AHP.AHP_FECHA_FIN_ALQUILER IS NULL) AND APU.DD_TCO_ID IN (2,3) AND APU.DD_EPA_ID <> AHP.DD_EPA_ID THEN 1
                        ELSE 0
                    END ALQUILER_MAL
                    FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                    JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP ON AHP.ACT_ID = APU.ACT_ID
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID
                    WHERE AHP.BORRADO = 0
                    AND (((AHP.AHP_FECHA_INI_VENTA IS NOT NULL AND AHP.AHP_FECHA_FIN_VENTA IS NULL) 
                        AND APU.DD_TCO_ID IN (1,2)
                        AND APU.DD_EPV_ID <> AHP.DD_EPV_ID)
                    OR ((AHP.AHP_FECHA_INI_ALQUILER IS NOT NULL AND AHP.AHP_FECHA_FIN_ALQUILER IS NULL)
                        AND APU.DD_TCO_ID IN (2,3)
                        AND APU.DD_EPA_ID <> AHP.DD_EPA_ID))
                )';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    SELECT AUX.AHP_ID, APU.APU_FECHA_INI_VENTA 
                    FROM '||V_ESQUEMA||'.AUX_APU_AHP AUX
                    JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON AUX.APU_ID = APU.APU_ID
                    WHERE AUX.VENTA_MAL = 1
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.AHP_FECHA_FIN_VENTA = T2.APU_FECHA_INI_VENTA
                    ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    SELECT AUX.AHP_ID, APU.APU_FECHA_INI_ALQUILER 
                    FROM '||V_ESQUEMA||'.AUX_APU_AHP AUX
                    JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON AUX.APU_ID = APU.APU_ID
                    WHERE AUX.ALQUILER_MAL = 1
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.AHP_FECHA_FIN_ALQUILER = T2.APU_FECHA_INI_ALQUILER
                    ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;    
        
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION (
                    AHP_ID,
                    ACT_ID,
                    DD_TPU_ID,
                    DD_EPV_ID,
                    DD_EPA_ID,
                    DD_TCO_ID,
                    DD_MTO_V_ID,
                    AHP_MOT_OCULTACION_MANUAL_V,
                    AHP_CHECK_PUBLICAR_V,
                    AHP_CHECK_OCULTAR_V,
                    AHP_CHECK_OCULTAR_PRECIO_V,
                    AHP_CHECK_PUB_SIN_PRECIO_V,
                    DD_MTO_A_ID,
                    AHP_MOT_OCULTACION_MANUAL_A,
                    AHP_CHECK_PUBLICAR_A,
                    AHP_CHECK_OCULTAR_A,
                    AHP_CHECK_OCULTAR_PRECIO_A,
                    AHP_CHECK_PUB_SIN_PRECIO_A,
                    AHP_FECHA_INI_VENTA,
                    VERSION,
                    USUARIOCREAR,
                    FECHACREAR,
                    BORRADO,
                    ES_CONDICONADO_ANTERIOR,
                    DD_TPU_V_ID,
                    DD_TPU_A_ID
                ) 
                SELECT '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL,
                    APU.ACT_ID,
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
                    VERSION,
                    '''||V_USUARIO||''',
                    SYSDATE,
                    0,
                    ES_CONDICONADO_ANTERIOR,
                    DD_TPU_V_ID,
                    DD_TPU_A_ID
                FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                JOIN '||V_ESQUEMA||'.AUX_APU_AHP AUX ON AUX.APU_ID = APU.APU_ID 
                AND AUX.VENTA_MAL = 1';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION (
                    AHP_ID,
                    ACT_ID,
                    DD_TPU_ID,
                    DD_EPV_ID,
                    DD_EPA_ID,
                    DD_TCO_ID,
                    DD_MTO_V_ID,
                    AHP_MOT_OCULTACION_MANUAL_V,
                    AHP_CHECK_PUBLICAR_V,
                    AHP_CHECK_OCULTAR_V,
                    AHP_CHECK_OCULTAR_PRECIO_V,
                    AHP_CHECK_PUB_SIN_PRECIO_V,
                    DD_MTO_A_ID,
                    AHP_MOT_OCULTACION_MANUAL_A,
                    AHP_CHECK_PUBLICAR_A,
                    AHP_CHECK_OCULTAR_A,
                    AHP_CHECK_OCULTAR_PRECIO_A,
                    AHP_CHECK_PUB_SIN_PRECIO_A,
                    AHP_FECHA_INI_ALQUILER,
                    VERSION,
                    USUARIOCREAR,
                    FECHACREAR,
                    BORRADO,
                    ES_CONDICONADO_ANTERIOR,
                    DD_TPU_V_ID,
                    DD_TPU_A_ID
                ) 
                SELECT '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL,
                    APU.ACT_ID,
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
                    APU_FECHA_INI_ALQUILER,
                    VERSION,
                    '''||V_USUARIO||''',
                    SYSDATE,
                    0,
                    ES_CONDICONADO_ANTERIOR,
                    DD_TPU_V_ID,
                    DD_TPU_A_ID
                FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                JOIN '||V_ESQUEMA||'.AUX_APU_AHP AUX ON AUX.APU_ID = APU.APU_ID 
                AND AUX.ALQUILER_MAL = 1';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.AUX_APU_AHP';
    EXECUTE IMMEDIATE V_MSQL;
    
	COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;

/
EXIT;