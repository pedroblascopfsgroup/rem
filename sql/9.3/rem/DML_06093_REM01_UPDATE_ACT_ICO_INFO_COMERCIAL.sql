--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20220405
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11468
--## PRODUCTO=NO
--##
--## Finalidad: MAPEO ACT_ICO_INFO_COMERCIAL
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'ACT_ICO_INFO_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-11468'; -- Usuario modificar
    V_NUM_TABLAS NUMBER(25);

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
                WITH 
                DORMITORIOS AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID AND DIS.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''01''
                GROUP BY ICO.ICO_ID),
                BANYOS AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID AND DIS.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''02''
                GROUP BY ICO.ICO_ID),
                GARAJE AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID AND DIS.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''12''
                GROUP BY ICO.ICO_ID),
                ASEOS AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID AND DIS.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''04''
                GROUP BY ICO.ICO_ID),
                SALONES AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID AND DIS.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''03''
                GROUP BY ICO.ICO_ID),
                TERRAZA AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD, SUM(DIS.DIS_SUPERFICIE) AS SUPERFICIE
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID AND DIS.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO IN (''15'',''16'')
                GROUP BY ICO.ICO_ID),
                PATIO AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD, SUM(DIS.DIS_SUPERFICIE) AS SUPERFICIE
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID AND DIS.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''09''
                GROUP BY ICO.ICO_ID)

                SELECT DISTINCT ICO.ICO_ID AS ICO_ID,
                
                DORM.CANTIDAD AS ICO_NUM_DORMITORIOS,  
                CASE WHEN BAN.CANTIDAD IS NOT NULL
                    THEN BAN.CANTIDAD
                    WHEN LCO.LCO_NUMERO_BANYOS IS NOT NULL
                    THEN LCO.LCO_NUMERO_BANYOS
                    ELSE NULL
                END ICO_NUM_BANYOS,  
                GAR.CANTIDAD AS ICO_NUM_GARAJE,    
                CASE WHEN ASE.CANTIDAD IS NOT NULL
                    THEN ASE.CANTIDAD
                    WHEN LCO.LCO_NUMERO_ASEOS IS NOT NULL
                    THEN LCO.LCO_NUMERO_ASEOS
                    ELSE NULL
                END ICO_NUM_ASEOS, 
                SALO.CANTIDAD AS ICO_NUM_SALONES, 
                CASE WHEN PAT.CANTIDAD > 0
                    THEN ''01''                
                    ELSE ''02''
                END ICO_PATIO,  
                PAT.SUPERFICIE AS ICO_SUP_PATIO, 
                CASE WHEN TER.CANTIDAD > 0
                    THEN ''01''                
                    ELSE ''02''
                END  ICO_TERRAZA,  
                TER.SUPERFICIE AS ICO_SUP_TERRAZA,

                CASE WHEN (TPA.DD_TPA_CODIGO = ''07'')
                    THEN APR.APR_ALTURA
                    ELSE LCO.LCO_MTS_ALTURA_LIBRE	
			    END ICO_ALTURA_LIBRE,

                CASE WHEN ZCO.ZCO_JARDINES = 1 
                    THEN ''01''
                    WHEN ZCO.ZCO_JARDINES = 0
                    THEN ''02''
                    ELSE NULL
                END ICO_ZONAS_VERDES,

                CASE WHEN ZCO.ZCO_JARDINES = 1 AND DD_SAC_CODIGO IN (''05'', ''08'')
                    THEN ''03''
                    WHEN ZCO.ZCO_JARDINES = 1 AND DD_SAC_CODIGO IN (''11'', ''12'', ''09'', ''10'', ''06'', ''07'')
                    THEN ''02''
                    ELSE ''01''
                END ICO_JARDIN,
                CASE WHEN ZCO.ZCO_PISCINA = 1 AND DD_SAC_CODIGO IN (''05'', ''08'')
                    THEN ''03''
                    WHEN ZCO.ZCO_PISCINA = 1 AND DD_SAC_CODIGO IN (''11'', ''12'', ''09'', ''10'', ''06'', ''07'')
                    THEN ''02''
                    ELSE ''01''
                END ICO_PISCINA,
                CASE WHEN ZCO.ZCO_GIMNASIO = 1 AND DD_SAC_CODIGO IN (''05'', ''08'')
                    THEN ''03''
                    WHEN ZCO.ZCO_GIMNASIO = 1 AND DD_SAC_CODIGO IN (''11'', ''12'', ''09'', ''10'', ''06'', ''07'')
                    THEN ''02''
                    ELSE ''01''
                END ICO_GIMNASIO,

                CASE WHEN CRI.CRI_ARMARIOS_EMPOTRADOS = 1
                    THEN ''01''
                    WHEN CRI.CRI_ARMARIOS_EMPOTRADOS = 0
                    ELSE ''02''
                    ELSE NULL
                END ICO_ARM_EMPOTRADOS,

                CASE WHEN SPS.SPS_OCUPADO = 0
                    THEN ''01''
                    WHEN SPS.SPS_OCUPADO = 1 AND TTA.DD_TPA_CODIGO IN (''02'', ''03'')
                    THEN ''02''
                    WHEN SPS.SPS_OCUPADO = 1 AND TTA.DD_TPA_CODIGO = ''01''
                    THEN ''04''
                END DD_ESO_CODIGO
                
                FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO

                LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID AND ACT.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID AND SAC.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID AND REG.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID AND SPS.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_TITULO_ACT TTA ON TTA.DD_TPA_ID = SPS.DD_TPA_ID AND TTA.BORRADO = 0

                LEFT JOIN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV ON ICO.ICO_ID = VIV.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI ON EDI.ICO_ID = ICO.ICO_ID AND EDI.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_INS_INSTALACION INS ON INS.ICO_ID = ICO.ICO_ID AND EDI.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL LCO ON LCO.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.ACT_COC_COCINA COC ON COC.ICO_ID = ICO.ICO_ID AND COC.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN ZCO ON ZCO.ICO_ID = ICO.ICO_ID AND ZCO.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT CRI ON CRI.ICO_ID = ICO.ICO_ID AND CRI.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO APR ON ICO.ICO_ID = APR.ICO_ID

                LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_ORIENTACION DDTPO ON DDTPO.DD_TPO_ID = VIV.DD_TPO_ID AND DDTPO.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID AND DDTPH.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION DDECV ON DDECV.DD_ECV_ID = EDI.DD_ECV_ID AND DDECV.BORRADO = 0

                LEFT JOIN DORMITORIOS DORM ON DORM.ICO_ID = ICO.ICO_ID
                LEFT JOIN BANYOS BAN ON BAN.ICO_ID = ICO.ICO_ID
                LEFT JOIN GARAJE GAR ON GAR.ICO_ID = ICO.ICO_ID
                LEFT JOIN ASEOS ASE ON ASE.ICO_ID = ICO.ICO_ID
                LEFT JOIN SALONES SALO ON SALO.ICO_ID = ICO.ICO_ID
                LEFT JOIN PATIO PAT ON PAT.ICO_ID = ICO.ICO_ID
                LEFT JOIN TERRAZA TER ON TER.ICO_ID = ICO.ICO_ID
                WHERE ICO.BORRADO = 0)T2
                ON (T1.ICO_ID = T2.ICO_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.ICO_NUM_DORMITORIOS = T2.ICO_NUM_DORMITORIOS,  
                T1.ICO_NUM_BANYOS = T2.ICO_NUM_BANYOS,  
                T1.ICO_NUM_GARAJE = T2.ICO_NUM_GARAJE,    
                T1.ICO_NUM_ASEOS = T2.ICO_NUM_ASEOS, 
                T1.ICO_NUM_SALONES = T2.ICO_NUM_SALONES,
                T1.ICO_PATIO = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_PATIO AND BORRADO = 0),  
                T1.ICO_SUP_PATIO = T2.ICO_SUP_PATIO, 
                T1.ICO_TERRAZA = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_TERRAZA AND BORRADO = 0),  
                T1.ICO_SUP_TERRAZA = T2.ICO_SUP_TERRAZA,
                T1.ICO_ALTURA_LIBRE = T2.ICO_ALTURA_LIBRE,
                T1.ICO_ZONAS_VERDES = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_ZONAS_VERDES AND BORRADO = 0),
                T1.ICO_JARDIN = (SELECT DD_DIS_ID FROM '||V_ESQUEMA||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = T2.ICO_JARDIN AND BORRADO = 0),
                T1.ICO_PISCINA = (SELECT DD_DIS_ID FROM '||V_ESQUEMA||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = T2.ICO_PISCINA AND BORRADO = 0),
                T1.ICO_GIMNASIO = (SELECT DD_DIS_ID FROM '||V_ESQUEMA||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = T2.ICO_GIMNASIO AND BORRADO = 0),
                T1.ICO_ARM_EMPOTRADOS = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_ARM_EMPOTRADOS AND BORRADO = 0),
                T1.DD_ESO_ID = (SELECT DD_ESO_ID FROM '||V_ESQUEMA||'.DD_ESO_ESTADO_OCUPACIONAL WHERE DD_ESO_CODIGO = T2.DD_ESO_CODIGO AND BORRADO = 0),
                T1.ICO_OCUPADO = NULL,
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('  [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA);

    V_MSQL := 'UPDATE REM01.ACT_ICO_INFO_COMERCIAL SET DD_ECV_ID = (SELECT DD_ECV_ID FROM REM01.DD_ECV_ESTADO_CONSERVACION WHERE DD_ECV_CODIGO = ''04'')
                WHERE DD_ECV_ID = (SELECT DD_ECV_ID FROM REM01.DD_ECV_ESTADO_CONSERVACION WHERE DD_ECV_CODIGO = ''05'')';
    EXECUTE IMMEDIATE V_MSQL;
	
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
