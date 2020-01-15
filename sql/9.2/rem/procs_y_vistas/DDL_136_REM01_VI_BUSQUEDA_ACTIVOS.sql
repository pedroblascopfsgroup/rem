--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6098
--## PRODUCTO=NO
--## Finalidad:
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##    0.1 Versión inicial
--##    0.2 Añadidos campos necesarios para mostrar las 3 columnas nuevas que se han añadido en el grid de buscador de activos. - JIN LI HU - HREOS-8476 - 20191118
--##		0.3 Añadidos campos necesarios para filtar y mostrar las fases y subfases de publicación del activo.
--##		0.4 Añadidos campos necesarios para filtrar por motivos de ocultacion de alquiler y de venta - Joaquin Bahamonde - HREOS-8518 - 20191204
--##		0.5 Corregir el fallo del CASE de TAS_IMPORTE_TAS_FIN 
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_ACTIVOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_ACTIVOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS... borrada OK');
  END IF;

  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS 
	AS
		SELECT
		  	ACT.ACT_ID,
			ACT.BIE_ID,
			ACT.ACT_NUM_ACTIVO,
		  	ACT.ACT_NUM_ACTIVO_REM,
	        BIE_DAT.BIE_DREG_NUM_FINCA,
			BIE_LOC.DD_UPO_ID,
            BIE_CIC.DD_CIC_DESCRIPCION AS PAISDESCRIPCION,
        	BIE_CIC.DD_CIC_CODIGO AS PAISCODIGO,
          	BIE_LOC_COD_POST,
          	BIE_LOC.BIE_LOC_NOMBRE_VIA,
		  	TPVIA.DD_TVI_DESCRIPCION || '' '' || BIE_LOC.BIE_LOC_NOMBRE_VIA || '' ''|| BIE_LOC.BIE_LOC_NUMERO_DOMICILIO || '' '' || LOC.DD_LOC_DESCRIPCION || '' '' || PRV.DD_PRV_DESCRIPCION AS TOKEN_GMAPS,
			ACT_LOC.LOC_LONGITUD,
			ACT_LOC.LOC_LATITUD,
			ACT.ACT_ADMISION,
			ACT.ACT_GESTION,
			ACT.ACT_SELLO_CALIDAD,
			ACT.ACT_NUM_ACTIVO_UVEM,
			ACT.ACT_RECOVERY_ID,
			ACT.ACT_NUM_ACTIVO_SAREB,
			ACT.ACT_NUM_ACTIVO_PRINEX,
			ACT_REG.REG_IDUFIR,
          	BIE_DAT.BIE_DREG_NUM_REGISTRO,
			ACT_SIT.SPS_OCUPADO,
          	TIT.DD_TPA_CODIGO,
          	ACT_SIT.SPS_FECHA_TOMA_POSESION,
          	ACT_SIT.SPS_ACC_TAPIADO,
			ACT_SIT.SPS_ACC_ANTIOCUPA,
        	RTG.DD_RTG_CODIGO AS FLAG_RATING,
	        STA.DD_SAC_CODIGO AS SUBTIPOACTIVOCODIGO,
	        STA.DD_SAC_DESCRIPCION AS SUBTIPOACTIVODESCRIPCION,
	        EAC.DD_EAC_CODIGO AS ESTADOACTIVOCODIGO,
	        TTA.DD_TTA_CODIGO AS TIPOTITULOACTIVOCODIGO,
	        TTA.DD_TTA_DESCRIPCION AS TIPOTITULOACTIVODESCRIPCION,
	        CRA.DD_CRA_CODIGO AS ENTIDADPROPIETARIACODIGO,
	        CRA.DD_CRA_DESCRIPCION AS ENTIDADPROPIETARIADESCRIPCION,
	        LOC.DD_LOC_CODIGO AS LOCALIDADCODIGO,
	        LOC.DD_LOC_DESCRIPCION AS LOCALIDADDESCRIPCION,
	        PRV.DD_PRV_CODIGO AS PROVINCIACODIGO,
	        PRV.DD_PRV_DESCRIPCION AS PROVINCIADESCRIPCION,
	        TPVIA.DD_TVI_CODIGO AS TIPOVIACODIGO,
	        LOCREG.DD_LOC_DESCRIPCION AS LOCALIDADREGISTRODESCRIPCION,
	        TPA.DD_TPA_CODIGO AS TIPOACTIVOCODIGO,
	        TPA.DD_TPA_DESCRIPCION AS TIPOACTIVODESCRIPCION,
			CATASTRO.CAT_REF_CATASTRAL AS REFERENCIA_CATASTRAL,
			SCM.DD_SCM_DESCRIPCION,
			SCM.DD_SCM_CODIGO,
			SCR.DD_SCR_ID,
			SCR.DD_SCR_CODIGO AS SUBCARTERACODIGO,
			DD_TUD_ID,
			DD_STA_ID,
			ACT_DIVISION_HORIZONTAL,
			ACT.DD_TCO_ID,
			ACT_CON_CARGAS,
			ACT.ACT_COD_PROMOCION_PRINEX,
			TPO.DD_TPO_CODIGO,
			ECG.DD_ECG_CODIGO,
			GPUBL.USU_USERNAME AS GPUBL_USU_USERNAME,
			DRT.DD_DRT_CODIGO,
			ICO.ICO_MEDIADOR_ID,
			TAL.DD_TAL_DESCRIPCION,
			APU.APU_FECHA_INI_VENTA,
			APU.APU_FECHA_INI_ALQUILER,
			TCO.DD_TCO_CODIGO,
		    CASE TCO.DD_TCO_CODIGO
				WHEN ''01''
				THEN VAL_02.VAL_IMPORTE
				WHEN ''02''
				THEN VAL_02.VAL_IMPORTE
				WHEN ''03''
				THEN VAL_03.VAL_IMPORTE
				ELSE NULL
			END TAS_IMPORTE_TAS_FIN,
			EPV.DD_EPV_CODIGO AS ESTADO_PUBLICACION_VENTA,
			EPA.DD_EPA_CODIGO AS ESTADO_PUBLICACION_ALQUILER,
 			FSP.DD_FSP_CODIGO AS FASE_PUBLICACION_CODIGO,
       		FSP.DD_FSP_DESCRIPCION AS FASE_PUBLICACION_DESCRIPCION,
		    SFP.DD_SFP_CODIGO AS SUBFASE_PUBLICACION_CODIGO,
       		SFP.DD_SFP_DESCRIPCION AS SUBFASE_PUBLICACION_DESCRIPCION,
       		MTOV.DD_MTO_CODIGO AS MOTIVO_OCULTACION_VENTA,
			MTOA.DD_MTO_CODIGO AS MOTIVO_OCULTACION_ALQUILER,
			TPU_V.DD_TPU_CODIGO AS DD_TPU_V_CODIGO,
			TPU_A.DD_TPU_CODIGO AS DD_TPU_A_CODIGO
  
		FROM ' || V_ESQUEMA || '.ACT_ACTIVO ACT 
		LEFT JOIN ' || V_ESQUEMA || '.ACT_LOC_LOCALIZACION ACT_LOC ON ACT_LOC.ACT_ID = ACT.ACT_ID
		LEFT JOIN ' || V_ESQUEMA || '.BIE_LOCALIZACION BIE_LOC ON ACT.BIE_ID = BIE_LOC.BIE_ID
		LEFT JOIN ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES BIE_DAT ON ACT.BIE_ID = BIE_DAT.BIE_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_REG_INFO_REGISTRAL ACT_REG ON ACT.ACT_ID = ACT_REG.ACT_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_SPS_SIT_POSESORIA ACT_SIT ON ACT.ACT_ID = ACT_SIT.ACT_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TPA_TIPO_TITULO_ACT TIT ON TIT.DD_TPA_ID = ACT_SIT.DD_TPA_ID
		LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_TVI_TIPO_VIA TPVIA ON TPVIA.DD_TVI_ID = BIE_LOC.DD_TVI_ID
		LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = BIE_LOC.DD_LOC_ID
		LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_CIC_CODIGO_ISO_CIRBE_BKP BIE_CIC ON BIE_LOC.DD_CIC_ID = BIE_CIC.DD_CIC_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_SAC_SUBTIPO_ACTIVO STA ON STA.DD_SAC_ID = ACT.DD_SAC_ID
	    LEFT JOIN ' || V_ESQUEMA || '.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
	    LEFT JOIN ' || V_ESQUEMA || '.DD_EAC_ESTADO_ACTIVO EAC ON EAC.DD_EAC_ID = ACT.DD_EAC_ID
	    LEFT JOIN ' || V_ESQUEMA || '.DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID =  ACT.DD_TTA_ID
	    LEFT JOIN ' || V_ESQUEMA || '.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
	    LEFT JOIN ' || V_ESQUEMA || '.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
	    LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = BIE_LOC.DD_PRV_ID
	    LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_LOC_LOCALIDAD LOCREG ON LOCREG.DD_LOC_ID = BIE_DAT.DD_LOC_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_RTG_RATING_ACTIVO RTG ON RTG.DD_RTG_ID = ACT.DD_RTG_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TPO_TIPO_TITULO_POSESORIO TPO ON TPO.DD_TPO_ID = ACT_SIT.DD_TPO_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_CMG_COMUNICACION_GENCAT CMG ON CMG.ACT_ID = ACT.ACT_ID AND CMG.BORRADO=0
		LEFT JOIN ' || V_ESQUEMA || '.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.BORRADO=0
		LEFT JOIN ' || V_ESQUEMA || '.DD_DRT_DIRECCION_TERRITORIAL DRT ON ACT.DD_DRT_ID = DRT.DD_DRT_ID AND DRT.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_ECG_ESTADO_COM_GENCAT ECG ON CMG.DD_ECG_ID = ECG.DD_ECG_ID 
		LEFT JOIN ' || V_ESQUEMA || '.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID  AND ICO.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_TAL_TIPO_ALQUILER TAL ON TAL.DD_TAL_ID = ACT.DD_TAL_ID  AND TAL.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = ACT.DD_TCO_ID  AND TCO.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID AND EPV.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID AND EPV.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_TPU_TIPO_PUBLICACION TPU_V ON TPU_V.DD_TPU_ID = APU.DD_TPU_V_ID AND TPU_V.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_TPU_TIPO_PUBLICACION TPU_A ON TPU_A.DD_TPU_ID = APU.DD_TPU_A_ID AND TPU_A.BORRADO = 0
 		LEFT JOIN REM01.ACT_HFP_HIST_FASES_PUB HFP ON HFP.ACT_ID = ACT.ACT_ID AND HFP.HFP_FECHA_FIN IS NULL AND HFP.BORRADO = 0
        LEFT JOIN REM01.DD_FSP_FASE_PUBLICACION FSP ON FSP.DD_FSP_ID = HFP.DD_FSP_ID
        LEFT JOIN REM01.DD_SFP_SUBFASE_PUBLICACION SFP ON SFP.DD_SFP_ID = HFP.DD_SFP_ID
        LEFT JOIN REM01.DD_MTO_MOTIVOS_OCULTACION MTOA ON MTOA.DD_MTO_ID = APU.DD_MTO_A_ID
        LEFT JOIN REM01.DD_MTO_MOTIVOS_OCULTACION MTOV ON MTOV.DD_MTO_ID = APU.DD_MTO_V_ID
		LEFT JOIN (SELECT CAT.ACT_ID, LISTAGG(CAT.CAT_REF_CATASTRAL,'','') WITHIN GROUP (ORDER BY ACT_ID) AS CAT_REF_CATASTRAL FROM ' || V_ESQUEMA || '.ACT_CAT_CATASTRO CAT
		GROUP BY CAT.ACT_ID) CATASTRO ON CATASTRO.ACT_ID = ACT.ACT_ID  
		LEFT JOIN (SELECT GAC.ACT_ID, USU.USU_USERNAME
                    FROM ' || V_ESQUEMA_MASTER || '.USU_USUARIOS USU
                    INNER JOIN ' || V_ESQUEMA || '.GEE_GESTOR_ENTIDAD GEE ON GEE.USU_ID = USU.USU_ID AND GEE.BORRADO = 0
                    INNER JOIN ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.BORRADO = 0
                    INNER JOIN ' || V_ESQUEMA || '.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
                    WHERE TGE.DD_TGE_CODIGO = ''GPUBL'') GPUBL ON GPUBL.ACT_ID = ACT.ACT_ID
		LEFT JOIN (SELECT VAL.ACT_ID, VAL.VAL_IMPORTE, ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_FIN DESC) RN
					  	FROM ' || V_ESQUEMA || '.ACT_VAL_VALORACIONES VAL
						JOIN ' || V_ESQUEMA || '.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID
					  	WHERE TPC.DD_TPC_CODIGO IN (''02'') AND SYSDATE BETWEEN VAL.VAL_FECHA_INICIO AND NVL(VAL.VAL_FECHA_FIN,SYSDATE + 1) 
						AND VAL.BORRADO = 0) VAL_02 ON VAL_02.ACT_ID = ACT.ACT_ID AND VAL_02.RN = 1
        LEFT JOIN (SELECT VAL.ACT_ID, VAL.VAL_IMPORTE, ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_FIN DESC) RN
					  	FROM ' || V_ESQUEMA || '.ACT_VAL_VALORACIONES VAL
						JOIN ' || V_ESQUEMA || '.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID
					  	WHERE TPC.DD_TPC_CODIGO IN (''03'') AND SYSDATE BETWEEN VAL.VAL_FECHA_INICIO AND NVL(VAL.VAL_FECHA_FIN,SYSDATE + 1) 
						AND VAL.BORRADO = 0) VAL_03 ON VAL_03.ACT_ID = ACT.ACT_ID AND VAL_03.RN = 1

		WHERE ACT.BORRADO = 0';
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS...Creada OK');
  
EXCEPTION
    WHEN OTHERS THEN
         err_num := SQLCODE;
         err_msg := SQLERRM;

         DBMS_OUTPUT.PUT_LINE('KO no modificada');
         DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
         DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
         DBMS_OUTPUT.put_line(err_msg);

         ROLLBACK;
         RAISE;   
		 
END;
/

EXIT;
