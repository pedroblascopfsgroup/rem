--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211207
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16608
--## PRODUCTO=NO
--##
--## Finalidad: MIGRACION ACT_ICO_INFO_COMERCIAL
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
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-16608'; -- Usuario modificar

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
                WITH 
                DORMITORIOS AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''01''
                GROUP BY ICO.ICO_ID),
                BANYOS AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''02''
                GROUP BY ICO.ICO_ID),
                TRASTERO AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''11''
                GROUP BY ICO.ICO_ID),
                GARAJE AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''12''
                GROUP BY ICO.ICO_ID),
                ASEOS AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''04''
                GROUP BY ICO.ICO_ID),
                SALONES AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''03''
                GROUP BY ICO.ICO_ID),
                TERRAZA AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD, SUM(DIS.DIS_SUPERFICIE) AS SUPERFICIE
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO IN (''15'',''16'')
                GROUP BY ICO.ICO_ID),
                PATIO AS (
                SELECT ICO.ICO_ID, SUM(DIS.DIS_CANTIDAD) AS CANTIDAD, SUM(DIS.DIS_SUPERFICIE) AS SUPERFICIE
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID
                WHERE ICO.BORRADO = 0 AND DIS.DIS_CANTIDAD IS NOT NULL AND DDTPH.DD_TPH_CODIGO = ''09''
                GROUP BY ICO.ICO_ID)

                SELECT DISTINCT ICO.ICO_ID AS ICO_ID,


                DDTPO.DD_TPO_DESCRIPCION AS ICO_ORIENTACION,
                VIV.VIV_NUM_PLANTAS_INTERIOR AS ICO_NUM_PLANTAS,
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
                END  ICO_PATIO,  
                PAT.SUPERFICIE AS ICO_SUP_PATIO, 
                CASE WHEN TER.CANTIDAD > 0
                    THEN ''01''                
                    ELSE ''02''
                END  ICO_TERRAZA,  
                TER.SUPERFICIE AS ICO_SUP_TERRAZA,
                CASE WHEN EDI.EDI_ASCENSOR = 1
                    THEN ''01''                
                    ELSE ''02''
                END ICO_ASCENSOR,
                EDI.EDI_NUM_PLANTAS AS ICO_NUM_PLANTAS_EDI,
                CASE WHEN DDECV.DD_ECV_CODIGO IN (''01'', ''02'')
                    THEN ''01''
                    WHEN DDECV.DD_ECV_CODIGO IN (''03'', ''04'')
                    THEN ''02''
                    WHEN DDECV.DD_ECV_CODIGO = ''05''
                    THEN ''03''
                    ELSE ''04''
                END DD_ESC_CODIGO,
                CASE WHEN INS.INS_CALEF = 1 AND INS.INS_CALEF_CENTRAL = 1
                    THEN ''Central''
                    WHEN INS.INS_CALEF = 1 AND INS.INS_CALEF_CENTRAL = 0
                    THEN ''Individual''
                    ELSE ''No dispone''
                END ICO_CALEFACCION,
                CASE WHEN INS.INS_CALEF = 1 AND INS.INS_CALEF_GAS_NATURAL = 1
                    THEN ''01''
                    WHEN INS.INS_CALEF = 1 AND INS.INS_CALEF_RADIADORES_ALU = 0
                    THEN ''03''
                    ELSE NULL
                END DD_TCA_CODIGO,
                CASE WHEN INS.INS_AIRE = 1 
                    THEN ''01''
                    ELSE NULL
                END DD_TCL_CODIGO,
                CASE WHEN LCO.LCO_SALIDA_HUMOS = 1 
                    THEN ''01''
                    ELSE ''02''
                END ICO_SALIDA_HUMOS,
                CASE WHEN LCO.LCO_ACCESO_MINUSVALIDOS = 1 
                    THEN ''01''
                    ELSE ''02''
                END ICO_ACC_MINUSVALIDO,
                LCO.LCO_NUMERO_ESTANCIAS AS ICO_NUM_ESTANCIAS,
                LCO.LCO_MTS_FACHADA_PPAL AS ICO_MTRS_FACHADA,
                LCO.LCO_MTS_ALTURA_LIBRE AS ICO_ALTURA_LIBRE,
                CASE WHEN COC.COC_AMUEBLADA = 1 
                    THEN ''01''
                    ELSE ''02''
                END ICO_COCINA_AMUEBLADA,
                CASE WHEN ZCO.ZCO_CONSERJE_VIGILANCIA = 1 
                    THEN ''01''
                    ELSE ''02''
                END ICO_CONSERJE,
                CASE WHEN ZCO.ZCO_INST_DEP = 1 
                    THEN ''01''
                    ELSE ''02''
                END ICO_INST_DEPORTIVAS,
                CASE WHEN ZCO.ZCO_JARDINES = 1 
                    THEN ''02''
                    ELSE ''01''
                END ICO_ZONAS_VERDES,
                CASE WHEN ZCO.ZCO_PISCINA = 1 
                    THEN ''02''
                    ELSE ''01''
                END ICO_PISCINA,
                CASE WHEN ZCO.ZCO_GIMNASIO = 1 
                    THEN ''02''
                    ELSE ''01''
                END ICO_GIMNASIO,
                CASE WHEN CRI.CRI_ARMARIOS_EMPOTRADOS = 1 
                    THEN ''02''
                    ELSE ''01''
                END ICO_ARM_EMPOTRADOS,
                CASE WHEN CRI.CRI_PTA_ENT_ACORAZADA = 1
                    THEN ''01''
                    WHEN CRI.CRI_PTA_ENT_NORMAL = 1
                    THEN ''02''
                    ELSE ''03''
                END DD_TPU_CODIGO,
                CASE WHEN VIV.VIV_REFORMA_CARP_INT = 1
                    THEN ''02''
                    WHEN VIV.VIV_REFORMA_CARP_INT = 0
                    THEN ''01''
                    ELSE ''03''
                END ICO_PUERTAS_INT,
                CASE WHEN VIV.VIV_REFORMA_CARP_EXT = 1
                    THEN ''02''
                    WHEN VIV.VIV_REFORMA_CARP_EXT = 0
                    THEN ''01''
                    ELSE ''03''
                END ICO_VENTANAS,
                CASE WHEN VIV.VIV_REFORMA_PINTURA = 1
                    THEN ''02''
                    WHEN VIV.VIV_REFORMA_PINTURA = 0
                    THEN ''01''
                    ELSE ''03''
                END ICO_PINTURA,
                CASE WHEN VIV.VIV_REFORMA_BANYO = 1
                    THEN ''02''
                    WHEN VIV.VIV_REFORMA_BANYO = 0
                    THEN ''01''
                    ELSE ''03''
                END ICO_BANYOS,
                CASE WHEN TRAS.CANTIDAD > 0
                    THEN ''01''                
                    ELSE ''02''
                END  ICO_ANEJO_TRASTERO,  
                CASE WHEN GAR.CANTIDAD > 0
                    THEN ''01''                
                    ELSE ''02''
                END  ICO_ANEJO_GARAJE

                FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO

                LEFT JOIN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV ON ICO.ICO_ID = VIV.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
                LEFT JOIN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI ON EDI.ICO_ID = ICO.ICO_ID AND EDI.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_INS_INSTALACION INS ON INS.ICO_ID = ICO.ICO_ID AND EDI.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL LCO ON LCO.ICO_ID = ICO.ICO_ID 
                LEFT JOIN '||V_ESQUEMA||'.ACT_COC_COCINA COC ON COC.ICO_ID = ICO.ICO_ID AND COC.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN ZCO ON ZCO.ICO_ID = ICO.ICO_ID AND ZCO.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT CRI ON CRI.ICO_ID = ICO.ICO_ID AND CRI.BORRADO = 0

                LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_ORIENTACION DDTPO ON DDTPO.DD_TPO_ID = VIV.DD_TPO_ID AND DDTPO.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO DDTPH ON DDTPH.DD_TPH_ID = DIS.DD_TPH_ID AND DDTPH.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION DDECV ON DDECV.DD_ECV_ID = EDI.DD_ECV_ID AND DDECV.BORRADO = 0

                LEFT JOIN DORMITORIOS DORM ON DORM.ICO_ID = ICO.ICO_ID
                LEFT JOIN BANYOS BAN ON BAN.ICO_ID = ICO.ICO_ID
                LEFT JOIN TRASTERO TRAS ON TRAS.ICO_ID = ICO.ICO_ID
                LEFT JOIN GARAJE GAR ON GAR.ICO_ID = ICO.ICO_ID
                LEFT JOIN ASEOS ASE ON ASE.ICO_ID = ICO.ICO_ID
                LEFT JOIN SALONES SALO ON SALO.ICO_ID = ICO.ICO_ID
                LEFT JOIN PATIO PAT ON PAT.ICO_ID = ICO.ICO_ID
                LEFT JOIN TERRAZA TER ON TER.ICO_ID = ICO.ICO_ID
                WHERE ICO.BORRADO = 0)T2
                ON (T1.ICO_ID = T2.ICO_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.ICO_ORIENTACION = T2.ICO_ORIENTACION,
                T1.ICO_NUM_PLANTAS = T2.ICO_NUM_PLANTAS,
                T1.ICO_NUM_DORMITORIOS = T2.ICO_NUM_DORMITORIOS,  
                T1.ICO_NUM_BANYOS = T2.ICO_NUM_BANYOS,  
                T1.ICO_NUM_GARAJE = T2.ICO_NUM_GARAJE,    
                T1.ICO_NUM_ASEOS = T2.ICO_NUM_ASEOS, 
                T1.ICO_NUM_SALONES = T2.ICO_NUM_SALONES,
                T1.ICO_PATIO = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_PATIO AND BORRADO = 0),  
                T1.ICO_SUP_PATIO = T2.ICO_SUP_PATIO, 
                T1.ICO_TERRAZA = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_TERRAZA AND BORRADO = 0),  
                T1.ICO_SUP_TERRAZA = T2.ICO_SUP_TERRAZA,
                T1.ICO_ASCENSOR = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_ASCENSOR AND BORRADO = 0),  
                T1.ICO_NUM_PLANTAS_EDI = T2.ICO_NUM_PLANTAS_EDI,
                T1.DD_ESC_ID = (SELECT DD_ESC_ID FROM '||V_ESQUEMA||'.DD_ESC_ESTADO_CONSERVACION_EDIFICIO WHERE DD_ESC_CODIGO = T2.DD_ESC_CODIGO AND BORRADO = 0),
                T1.ICO_CALEFACCION = T2.ICO_CALEFACCION,
                T1.DD_TCA_ID = (SELECT DD_TCA_ID FROM '||V_ESQUEMA||'.DD_TCA_TIPO_CALEFACCION WHERE DD_TCA_CODIGO = T2.DD_TCA_CODIGO AND BORRADO = 0),
                T1.DD_TCL_ID = (SELECT DD_TCL_ID FROM '||V_ESQUEMA||'.DD_TCL_TIPO_CLIMATIZACION WHERE DD_TCL_CODIGO = T2.DD_TCL_CODIGO AND BORRADO = 0),
                T1.ICO_SALIDA_HUMOS = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_SALIDA_HUMOS AND BORRADO = 0),  
                T1.ICO_ACC_MINUSVALIDO = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_ACC_MINUSVALIDO AND BORRADO = 0),  
                T1.ICO_NUM_ESTANCIAS = T2.ICO_NUM_ESTANCIAS,
                T1.ICO_MTRS_FACHADA = T2.ICO_MTRS_FACHADA,
                T1.ICO_ALTURA_LIBRE = T2.ICO_ALTURA_LIBRE,
                T1.ICO_COCINA_AMUEBLADA = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_COCINA_AMUEBLADA AND BORRADO = 0),  
                T1.ICO_CONSERJE = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_CONSERJE AND BORRADO = 0),  
                T1.ICO_INST_DEPORTIVAS = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_INST_DEPORTIVAS AND BORRADO = 0),  
                T1.ICO_ZONAS_VERDES = (SELECT DD_DIS_ID FROM '||V_ESQUEMA||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = T2.ICO_ZONAS_VERDES AND BORRADO = 0),
                T1.ICO_PISCINA = (SELECT DD_DIS_ID FROM '||V_ESQUEMA||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = T2.ICO_PISCINA AND BORRADO = 0),
                T1.ICO_GIMNASIO = (SELECT DD_DIS_ID FROM '||V_ESQUEMA||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = T2.ICO_GIMNASIO AND BORRADO = 0),
                T1.ICO_ARM_EMPOTRADOS = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_ARM_EMPOTRADOS AND BORRADO = 0),
                T1.DD_TPU_ID = (SELECT DD_TPU_ID FROM '||V_ESQUEMA||'.DD_TPU_TIPO_PUERTA WHERE DD_TPU_CODIGO = T2.DD_TPU_CODIGO AND BORRADO = 0),
                T1.ICO_PUERTAS_INT = (SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADO_MOBILIARIO WHERE DD_ESM_CODIGO = T2.ICO_PUERTAS_INT AND BORRADO = 0),
                T1.ICO_VENTANAS = (SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADO_MOBILIARIO WHERE DD_ESM_CODIGO = T2.ICO_VENTANAS AND BORRADO = 0),
                T1.ICO_PINTURA = (SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADO_MOBILIARIO WHERE DD_ESM_CODIGO = T2.ICO_PINTURA AND BORRADO = 0),
                T1.ICO_BANYOS = (SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADO_MOBILIARIO WHERE DD_ESM_CODIGO = T2.ICO_BANYOS AND BORRADO = 0),
                T1.ICO_ANEJO_TRASTERO = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_ANEJO_TRASTERO AND BORRADO = 0),    
                T1.ICO_ANEJO_GARAJE = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = T2.ICO_ANEJO_GARAJE AND BORRADO = 0),  
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
  	
	EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] MIGRADOS '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA);
	
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
