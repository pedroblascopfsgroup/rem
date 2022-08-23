--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20220728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18583
--## PRODUCTO=NO
--## Finalidad: 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial [HREOS-18229]
--##        0.2 Modificaciones [HREOS-18404] Santi Monzó
--##        0.3 Modificaciones [HREOS-18583] Pier Gotta
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_EAS_06_EQUIPAMIENTO (
      PL_OUTPUT       OUT VARCHAR2
)
AS

  V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
  V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  

  V_SQL VARCHAR2(20000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
   	V_SQL := 'TRUNCATE TABLE ' || V_ESQUEMA || '.AUX_APR_EQUIPAMIENTO';
   	
   	EXECUTE IMMEDIATE V_SQL;

        V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.AUX_APR_EQUIPAMIENTO APR USING(
			WITH ACTIVO_MATRIZ AS (SELECT AGR.AGR_ID, ACT.ACT_NUM_ACTIVO,ACT.ACT_NUM_ACTIVO_CAIXA,
			TO_CHAR(EQV2.DD_CODIGO_CAIXA) AS DD_TCL_CODIGO,
			TO_CHAR(EQV21.DD_CODIGO_CAIXA) AS ICO_ASCENSOR,
			TO_CHAR(EQV2.DD_CODIGO_CAIXA) AS ICO_CALEFACCION_1,
			TO_CHAR(EQV.DD_CODIGO_CAIXA) AS DD_ECV_CODIGO,
			TO_CHAR(TCA.DD_TCA_CODIGO) AS DD_TCA_CODIGO,
			TO_CHAR(EQV5.DD_CODIGO_CAIXA) AS ICO_JARDIN,
			TO_CHAR(EQV22.DD_CODIGO_CAIXA) AS ICO_PATIO,
			TO_CHAR(EQV6.DD_CODIGO_CAIXA) AS ICO_PISCINA,
			TO_CHAR(EQV7.DD_CODIGO_CAIXA) AS ICO_TERRAZA,
			TO_CHAR(EQV3.DD_CODIGO_CAIXA) AS DD_TVC_CODIGO,
			CASE
				WHEN TO_CHAR(ICO.ICO_ANO_CONSTRUCCION) = 0 THEN NULL
				ELSE TO_CHAR(ICO.ICO_ANO_CONSTRUCCION)
			END  ICO_ANO_CONSTRUCCION,
			TO_CHAR(EQV8.DD_CODIGO_CAIXA) AS ICO_JARDIN_2,
			TO_CHAR(EQV6.DD_CODIGO_CAIXA) AS ICO_PISCINA_2, 
			TO_CHAR(EQV19.DD_CODIGO_CAIXA) AS ICO_ANEJO_GARAJE,
			TO_CHAR(EQV18.DD_CODIGO_CAIXA) AS ICO_ANEJO_TRASTERO,
			TO_CHAR(EQV9.DD_CODIGO_CAIXA) AS ICO_BALCON,
			TO_CHAR(EQV12.DD_CODIGO_CAIXA) AS DD_AAC_CODIGO,
			TO_CHAR(EQV17.DD_CODIGO_CAIXA) AS ICO_ARM_EMPOTRADOS,
			TO_CHAR(EQV10.DD_CODIGO_CAIXA) AS ICO_COCINA_AMUEBLADA,
			TO_CHAR(EQV13.DD_CODIGO_CAIXA) AS DD_EXI_CODIGO,
			TO_CHAR(EQV20.DD_CODIGO_CAIXA) AS ICO_LIC_APERTURA,
			TO_CHAR(EQV16.DD_CODIGO_CAIXA) AS ICO_INST_DEPORTIVAS,
			TO_CHAR(EQV2.DD_CODIGO_CAIXA) AS ICO_CALEFACCION_2,
			TO_CHAR(EQV14.DD_CODIGO_CAIXA) AS DD_ESC_CODIGO,
			CASE
				WHEN TO_CHAR(ICO.ICO_ANO_CONSTRUCCION) = 0 THEN NULL
				ELSE TO_CHAR(ICO.ICO_ANO_CONSTRUCCION)
			END  ICO_ANO_CONSTRUCCION_2,
			TO_CHAR(EQV4.DD_CODIGO_CAIXA) AS DD_TEC_CODIGO,
			TO_CHAR(EQV15.DD_CODIGO_CAIXA) AS DD_VUB_CODIGO,
			TO_CHAR(EQV15.DD_CODIGO_CAIXA) AS DD_VUB_CODIGO_2,
			TO_CHAR(EQV16.DD_CODIGO_CAIXA) AS ICO_INST_DEPORTIVAS_2,
			TO_CHAR(EQV.DD_CODIGO_CAIXA) AS DD_ECV_CODIGO_2,
			TO_CHAR(EQV23.DD_CODIGO_CAIXA) AS ICO_LIC_OBRA,
			TO_CHAR(EQV11.DD_CODIGO_CAIXA) AS ICO_SALIDA_HUMOS,
			TO_CHAR(EQV14.DD_CODIGO_CAIXA) AS DD_ESC_CODIGO_2
			FROM ' || V_ESQUEMA || '.ACT_ACTIVO ACT
			JOIN ' || V_ESQUEMA || '.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
			JOIN ' || V_ESQUEMA || '.ACT_ACTIVO_CAIXA CAI ON CAI.ACT_ID = ACT.ACT_ID
			LEFT JOIN ' || V_ESQUEMA || '.DD_TCL_TIPO_CLIMATIZACION TCL ON TCL.DD_TCL_ID = ICO.DD_TCL_ID
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV2 ON EQV2.DD_NOMBRE_CAIXA = ''CALEFACCION'' AND EQV2.DD_CODIGO_REM = TCL.DD_TCL_CODIGO
			LEFT JOIN ' || V_ESQUEMA || '.DD_ECV_ESTADO_CONSERVACION ECV ON ECV.DD_ECV_ID = ICO.DD_ECV_ID
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''EST_CONSERVACION'' AND EQV.DD_CODIGO_REM = ECV.DD_ECV_CODIGO
			LEFT JOIN ' || V_ESQUEMA || '.DD_TCA_TIPO_CALEFACCION TCA ON TCA.DD_TCA_ID = ICO.DD_TCA_ID
			LEFT JOIN ' || V_ESQUEMA || '.DD_TVC_TIPO_VIVIENDA_CAIXA TVC ON TVC.DD_TVC_ID = CAI.DD_TVC_ID
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV3 ON EQV3.DD_NOMBRE_CAIXA = ''TIPO_VIVIENDA_INF'' AND EQV3.DD_CODIGO_REM = TVC.DD_TVC_CODIGO
			LEFT JOIN ' || V_ESQUEMA || '.DD_AAC_ACTIVO_ACCESIBILIDAD AAC ON AAC.DD_AAC_ID = ICO.DD_AAC_ID		
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV12 ON EQV12.DD_NOMBRE_CAIXA = ''ACCESIBILIDAD'' AND EQV12.DD_CODIGO_REM = AAC.DD_AAC_CODIGO
			LEFT JOIN ' || V_ESQUEMA || '.DD_EXI_EXTERIOR_INTERIOR EXI ON EXI.DD_EXI_ID = ICO.DD_EXI_ID
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV13 ON EQV13.DD_NOMBRE_CAIXA = ''EXTERIOR_INTERIOR'' AND EQV13.DD_CODIGO_REM = EXI.DD_EXI_CODIGO
			LEFT JOIN ' || V_ESQUEMA || '.DD_ESC_ESTADO_CONSERVACION_EDIFICIO EST ON EST.DD_ESC_ID = ICO.DD_ESC_ID
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV14 ON EQV14.DD_NOMBRE_CAIXA = ''CONSERV_EDIF'' AND EQV14.DD_CODIGO_REM = EST.DD_ESC_CODIGO
			LEFT JOIN ' || V_ESQUEMA || '.DD_DIS_DISPONIBILIDAD DIS ON DIS.DD_DIS_ID = ICO.ICO_JARDIN
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV5 ON EQV5.DD_NOMBRE_CAIXA = ''JARDIN'' AND EQV5.DD_CODIGO_REM = DIS.DD_DIS_CODIGO
			LEFT JOIN ' || V_ESQUEMA || '.DD_DIS_DISPONIBILIDAD DIS2 ON DIS2.DD_DIS_ID = ICO.ICO_PISCINA
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV6 ON EQV6.DD_NOMBRE_CAIXA = ''PISCINA'' AND EQV6.DD_CODIGO_REM = DIS.DD_DIS_CODIGO
			LEFT JOIN ' || V_ESQUEMA || '.DD_DIS_DISPONIBILIDAD DIS4 ON DIS4.DD_DIS_ID = ICO.ICO_JARDIN
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV8 ON EQV8.DD_NOMBRE_CAIXA = ''USO_JARDIN'' AND EQV8.DD_CODIGO_REM = DIS.DD_DIS_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN ON SIN.DD_SIN_ID = ICO.ICO_TERRAZA
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV7 ON EQV7.DD_NOMBRE_CAIXA = ''TERRAZA'' AND EQV7.DD_CODIGO_REM = SIN.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN2 ON SIN2.DD_SIN_ID = ICO.ICO_BALCON
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV9 ON EQV9.DD_NOMBRE_CAIXA = ''BALCON'' AND EQV9.DD_CODIGO_REM = SIN2.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN3 ON SIN3.DD_SIN_ID = ICO.ICO_COCINA_AMUEBLADA
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV10 ON EQV10.DD_NOMBRE_CAIXA = ''COCINA_EQUIPADA'' AND EQV10.DD_CODIGO_REM = SIN3.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN4 ON SIN4.DD_SIN_ID = ICO.ICO_SALIDA_HUMOS
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV11 ON EQV11.DD_NOMBRE_CAIXA = ''SALIDA_HUMOS'' AND EQV11.DD_CODIGO_REM = SIN4.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA || '.DD_TEC_TIPO_EDIFICIO_CAIXA TEC ON TEC.DD_TEC_ID = CAI.DD_TEC_ID
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV4 ON EQV4.DD_NOMBRE_CAIXA = ''TIPOLOGIA_EDIFICIO'' AND EQV4.DD_CODIGO_REM = TEC.DD_TEC_CODIGO
			LEFT JOIN ' || V_ESQUEMA || '.DD_VUB_VALORACION_UBICACION VUB ON VUB.DD_VUB_ID = ICO.DD_VUB_ID
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV15 ON EQV15.DD_NOMBRE_CAIXA = ''UBICACION'' AND EQV15.DD_CODIGO_REM = VUB.DD_VUB_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN5 ON SIN5.DD_SIN_ID = ICO.ICO_INST_DEPORTIVAS
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV16 ON EQV16.DD_NOMBRE_CAIXA = ''INST_DEPORTIVAS'' AND EQV16.DD_CODIGO_REM = SIN5.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN6 ON SIN6.DD_SIN_ID = ICO.ICO_ARM_EMPOTRADOS
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV17 ON EQV17.DD_NOMBRE_CAIXA = ''ARM_EMPOTRADOS'' AND EQV17.DD_CODIGO_REM = SIN6.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN7 ON SIN7.DD_SIN_ID = ICO.ICO_ANEJO_TRASTERO
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV18 ON EQV18.DD_NOMBRE_CAIXA = ''TRASTERO'' AND EQV18.DD_CODIGO_REM = SIN7.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN8 ON SIN8.DD_SIN_ID = ICO.ICO_ANEJO_GARAJE
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV19 ON EQV19.DD_NOMBRE_CAIXA = ''GARAJE'' AND EQV19.DD_CODIGO_REM = SIN8.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN9 ON SIN9.DD_SIN_ID = ICO.ICO_LIC_APERTURA
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV20 ON EQV20.DD_NOMBRE_CAIXA = ''APERTURA'' AND EQV20.DD_CODIGO_REM = SIN9.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN10 ON SIN10.DD_SIN_ID = ICO.ICO_ASCENSOR
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV21 ON EQV21.DD_NOMBRE_CAIXA = ''ASCENSOR'' AND EQV21.DD_CODIGO_REM = SIN10.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN11 ON SIN11.DD_SIN_ID = ICO.ICO_PATIO
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV22 ON EQV22.DD_NOMBRE_CAIXA = ''PATIO'' AND EQV22.DD_CODIGO_REM = SIN11.DD_SIN_CODIGO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_SIN_SINO SIN12 ON SIN12.DD_SIN_ID = ICO.ICO_LIC_OBRA
			LEFT JOIN ' || V_ESQUEMA || '.DD_EQV_CAIXA_REM EQV23 ON EQV23.DD_NOMBRE_CAIXA = ''LIC_OBRA'' AND EQV23.DD_CODIGO_REM = SIN12.DD_SIN_CODIGO


			JOIN ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
			JOIN ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID		
			WHERE AGR.BORRADO = 0 		
			AND AGR.AGR_FECHA_BAJA IS NULL AND 
			AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM ' || V_ESQUEMA || '.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 1
			),

			UA AS (
			SELECT ACT.ACT_NUM_ACTIVO,
			DD_TCL_CODIGO,
			ICO_ASCENSOR,
			ICO_CALEFACCION_1,
			DD_ECV_CODIGO,
			DD_TCA_CODIGO,
			ICO_JARDIN,
			ICO_PATIO,
			ICO_PISCINA,
			ICO_TERRAZA,
			DD_TVC_CODIGO,
			CASE
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION) = 0 THEN ''007901''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION) < 6 THEN ''007902''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION) < 16 THEN ''007903''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION) < 26 THEN ''007904''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION) < 36 THEN ''007905''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION) < 51 THEN ''007906''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION) > 50  THEN ''007907''
            END ICO_ANO_CONSTRUCCION,
			ICO_JARDIN_2,
			ICO_PISCINA_2, 
			ICO_ANEJO_GARAJE,
			ICO_ANEJO_TRASTERO,
			ICO_BALCON,
			DD_AAC_CODIGO,
			ICO_ARM_EMPOTRADOS,
			ICO_COCINA_AMUEBLADA,
			DD_EXI_CODIGO,
			ICO_LIC_APERTURA,
			ICO_INST_DEPORTIVAS,
			ICO_CALEFACCION_2,
			DD_ESC_CODIGO,
			CASE
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION_2) = 0 THEN ''074001''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION_2) < 6 THEN ''074002''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION_2) < 16 THEN ''074003''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION_2) < 26 THEN ''074004''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION_2) < 36 THEN ''074005''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION_2) < 51 THEN ''074006''
                WHEN ((EXTRACT(YEAR FROM sysdate)) - ICO_ANO_CONSTRUCCION_2) > 50  THEN ''074007''
			END ICO_ANO_CONSTRUCCION_2,
			DD_TEC_CODIGO,
			DD_VUB_CODIGO,
			DD_VUB_CODIGO_2,
			ICO_INST_DEPORTIVAS_2,
			DD_ECV_CODIGO_2,
			ICO_LIC_OBRA,
			ICO_SALIDA_HUMOS,
			DD_ESC_CODIGO_2 
			FROM ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR 
			JOIN ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0
			JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.BORRADO = 0 
			JOIN ACTIVO_MATRIZ MAT ON MAT.AGR_ID = AGR.AGR_ID
			JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA cra ON cra.DD_CRA_ID = ACT.DD_CRA_ID  AND cra.BORRADO= 0     
            JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO pac ON pac.ACT_ID = ACT.ACT_ID AND pac.BORRADO = 0 
			WHERE AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL 
			AND cra.DD_CRA_CODIGO = ''03''
            AND pac.PAC_INCLUIDO = 1
			AND MAT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
			AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM ' || V_ESQUEMA || '.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 0
			)

			SELECT DISTINCT ACT_NUM_ACTIVO AS ZZEXTERNALID, FIXFITCHARACT, NULL AS VALIDFROM, NULL AS VALIDTO,QUALITY AS ADDITIONALINFO 
			FROM UA
			UNPIVOT(
			QUALITY
			FOR FIXFITCHARACT IN 
			(DD_TCL_CODIGO AS ''0001''
			, ICO_ASCENSOR AS ''0009''
			, ICO_CALEFACCION_1 AS ''0010''		
			, DD_ECV_CODIGO AS ''0019''		
			, DD_TCA_CODIGO AS ''0020''		
			, ICO_JARDIN AS ''0025''
			, ICO_PATIO AS ''0040''
			, ICO_PISCINA AS ''0042''
			, ICO_TERRAZA AS ''0052''
			, DD_TVC_CODIGO AS ''0058''
			, ICO_ANO_CONSTRUCCION AS ''0079''
			, ICO_JARDIN_2 AS ''0095''
			, ICO_PISCINA_2 AS ''0096''
			, ICO_ANEJO_GARAJE AS ''0150''
			, ICO_ANEJO_TRASTERO AS ''0151''
			, ICO_BALCON AS ''0152''
			, DD_AAC_CODIGO AS ''0701''
			, ICO_ARM_EMPOTRADOS AS ''0703''
			, ICO_COCINA_AMUEBLADA AS ''0709''
			, DD_EXI_CODIGO AS ''0724''			
			, ICO_LIC_APERTURA AS ''0725''
			, ICO_INST_DEPORTIVAS AS ''0728''
			, ICO_CALEFACCION_2 AS ''0733''
			, DD_ESC_CODIGO AS ''0739''
			, ICO_ANO_CONSTRUCCION_2 AS ''0740''
			, DD_TEC_CODIGO AS ''0764''
			, DD_VUB_CODIGO AS ''0765''
			, ICO_INST_DEPORTIVAS_2 AS ''0771''
			, DD_ECV_CODIGO_2 AS ''0791''
			, ICO_LIC_OBRA AS ''0793''
			, ICO_SALIDA_HUMOS AS ''0794''
			, DD_ESC_CODIGO_2 AS ''0798''))



			) AUX ON (AUX.ZZEXTERNALID = APR.ZZEXTERNALID AND AUX.FIXFITCHARACT = APR.FIXFITCHARACT) 
			WHEN NOT MATCHED THEN INSERT
			(
			
			APR.ZZEXTERNALID,
			APR.FIXFITCHARACT,
			APR.VALIDFROM,
			APR.VALIDTO,
			APR.ADDITIONALINFO
			) VALUES(
			
			AUX.ZZEXTERNALID,
			AUX.FIXFITCHARACT,
			AUX.VALIDFROM,
			AUX.VALIDTO,
			AUX.ADDITIONALINFO)';

        EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] FIN UPDATE / INSERT');
    COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END SP_EAS_06_EQUIPAMIENTO;
/
EXIT;
