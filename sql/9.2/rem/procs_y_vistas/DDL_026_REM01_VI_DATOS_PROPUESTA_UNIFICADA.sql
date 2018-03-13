--/*
--##########################################
--## AUTOR=DANIEL ALGABA
--## FECHA_CREACION=20180312
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3890
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_DATOS_PROPUESTA_UNIFICADA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_UNIFICADA...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_DATOS_PROPUESTA_UNIFICADA';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_UNIFICADA... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_DATOS_PROPUESTA_UNIFICADA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_UNIFICADA...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_DATOS_PROPUESTA_UNIFICADA';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_UNIFICADA... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_UNIFICADA...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_DATOS_PROPUESTA_UNIFICADA 
	AS
		SELECT
	  		ACT.ACT_ID,
			ACP.PRP_ID,
			CRA.DD_CRA_CODIGO AS CARTERA_CODIGO,
			(SELECT DD_SCR_CODIGO FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_ID = ACT.DD_SCR_ID) AS SUBCARTERA_CODIGO,
	-- PROPIETARIO
			PRO.PRO_NOMBRE  || '' '' || PRO.PRO_APELLIDO1 || '' '' || PRO.PRO_APELLIDO2 	AS SOCIEDAD_PROPIETARIA,
	-- ACTIVO
			STA.DD_STA_DESCRIPCION 	AS ORIGEN,
			NVL2(AJD.AJD_ID,AJD.AJD_FECHA_ADJUDICACION,ADN.ADN_FECHA_TITULO) AS FECHA_ENTRADA,
			decode(CRA.DD_CRA_CODIGO, ''01'', ''''||ACT.ACT_NUM_ACTIVO_PRINEX,
                     ''02'', ''''||ACT.ACT_NUM_ACTIVO_SAREB,
                     ''03'', ''''||ACT.ACT_NUM_ACTIVO_UVEM
                    ) ID_CARTERA, 
			ACT.ACT_NUM_ACTIVO AS ID_HAYA,
			CATASTRO.CAT_REF_CATASTRAL 	AS REF_CATASTRAL,
			BIE_DAT.BIE_DREG_NUM_FINCA 	AS FINCA_REGISTRAL,
			(SELECT AGR.AGR_NUM_AGRUP_REM FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_ID IN (SELECT AGA.AGR_ID FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA WHERE AGA.ACT_ID = ACT.ACT_ID) AND
		        AGR.AGR_FECHA_BAJA IS NULL AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO=''01'')) AS AGR_NUEVA_NUM,
		    (SELECT AGR.AGR_NUM_AGRUP_REM FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_ID IN (SELECT AGA.AGR_ID FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA WHERE AGA.ACT_ID = ACT.ACT_ID) AND
				AGR.AGR_FECHA_BAJA IS NULL AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO=''02'')) AS AGR_RESTRINGIDA_NUM,
			TPA.DD_TPA_CODIGO AS TIPO_CODIGO,
			TPA.DD_TPA_DESCRIPCION AS TIPO_DESCRIPCION,
			SAC.DD_SAC_DESCRIPCION AS SUBTIPO_DESCRIPCION,
			TPVIA.DD_TVI_DESCRIPCION || '' '' || BIE_LOC.BIE_LOC_NOMBRE_VIA || '' ''|| BIE_LOC.BIE_LOC_NUMERO_DOMICILIO AS DIRECCION,
			LOC.DD_LOC_DESCRIPCION AS MUNICIPIO,
	        PRV.DD_PRV_DESCRIPCION AS PROVINCIA,
			BIE_LOC.BIE_LOC_COD_POST AS COD_POSTAL,
			-- AS PROPUESTA_FORZADA,
	-- ESTADO POR DPTOS.
			EDI.EDI_ASCENSOR AS ASCENSOR,
			(SELECT SUM(DIS.DIS_CANTIDAD) FROM '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS, '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO TPH 
				WHERE  DIS.DD_TPH_ID = TPH.DD_TPH_ID AND ICO.ICO_ID = DIS.ICO_ID AND TPH.DD_TPH_CODIGO = ''01'') AS NUM_DORMITORIOS,
			--BIE_DAT.BIE_DREG_SUPERFICIE AS SUPERFICIE_TOTAL,
			(SELECT REG_SUPERFICIE_ELEM_COMUN FROM ACT_REG_INFO_REGISTRAL WHERE ACT_ID = ACT.ACT_ID) AS SUPERFICIE_TOTAL,
			-- AS SUPERFICIE_DEPURADA,
			ICO.ICO_ANO_CONSTRUCCION AS ANO_CONSTRUCCION,
			ECT.DD_ECT_DESCRIPCION AS ESTADO_CONSTRUCCION,
			(SELECT DD_SCM_DESCRIPCION FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_ID = ACT.DD_SCM_ID) AS ESTADO_COMERCIAL,
			(SELECT COUNT(VIS_ID) FROM '||V_ESQUEMA||'.VIS_VISITAS VIS WHERE VIS.ACT_ID = ACT.ACT_ID) AS NUM_VISITAS,
			(SELECT COUNT(OFR_ID) FROM '||V_ESQUEMA||'.ACT_OFR AFR WHERE AFR.ACT_ID = ACT.ACT_ID) AS NUM_OFERTAS,
			(SELECT TIT_FECHA_INSC_REG FROM '||V_ESQUEMA||'.ACT_TIT_TITULO WHERE ACT_ID = ACT.ACT_ID) AS FECHA_INSCRIPCION,
			ACT.ACT_FECHA_REV_CARGAS AS FECHA_REV_CARGAS,
			SPS.SPS_FECHA_TOMA_POSESION AS FECHA_TOMA_POSESION,
			(CASE SPS.SPS_OCUPADO WHEN 0 THEN ''NO'' WHEN 1 THEN (CASE WHEN SPS.SPS_CON_TITULO = 1 THEN ''Ocupado con título'' ELSE ''Ocupado sin título'' END) END) AS OCUPADO,
			(SELECT APU.APU_FECHA_INI_ALQUILER 
				 FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
				WHERE APU.ACT_ID = ACT.ACT_ID 
				  AND EXISTS (SELECT 1 
								FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER DDEPA
							   WHERE DDEPA.DD_EPA_CODIGO = ''03'' /*PUBLICADO*/
								 AND DDEPA.BORRADO = 0
								 AND DDEPA.DD_EPA_ID = APU.DD_EPA_ID
									)
				  AND APU.BORRADO = 0
			  )	AS FECHA_PUBLICACION_A,
			(SELECT APU.APU_FECHA_INI_VENTA 
				 FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
				WHERE APU.ACT_ID = ACT.ACT_ID 
				  AND EXISTS (SELECT 1 
								FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA DDEPV
							   WHERE DDEPV.DD_EPV_CODIGO = ''03'' /*PUBLICADO*/
								 AND DDEPV.BORRADO = 0
								 AND DDEPV.DD_EPV_ID = APU.DD_EPV_ID
									)
				  AND APU.BORRADO = 0
			  )	AS FECHA_PUBLICACION_V, 
	-- VALORES
			V.VALOR_ESTIMADO_VENTA,
			V.VALOR_ESTIMADO_VENTA_F_INI AS FECHA_ESTIMADO_VENTA,
			tasacion.TAS_IMPORTE_TAS_FIN AS VALOR_TASACION,
            tasacion.BIE_FECHA_VALOR_TASACION AS FECHA_TASACION,
			V.FSV_VENTA,
			V.FSV_VENTA_F_INI,
			GREATEST(NVL2(tasacion.TAS_IMPORTE_TAS_FIN,tasacion.TAS_IMPORTE_TAS_FIN,0),NVL2(V.VALOR_ESTIMADO_VENTA,V.VALOR_ESTIMADO_VENTA,0),NVL2(V.FSV_VENTA,V.FSV_VENTA,0)) AS MAYOR_VALORACION,
	-- PRECIOS ACTUALES		
			V.APROBADO_VENTA_WEB,
			V.APROBADO_VENTA_WEB_F_INI,
			V.APROBADO_RENTA_WEB,
			V.APROBADO_RENTA_WEB_F_INI, 
			V.VNC,
			V.COSTE_ADIQUISICION,
			V.COSTE_ADIQUISICION_F_INI,
			V.VALOR_ASESORADO_LIQ,
			V.VALOR_ASESORADO_LIQ_F_INI

		FROM '|| V_ESQUEMA ||'.ACT_PRP ACP
			JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACP.ACT_ID=ACT.ACT_ID AND ACT.BORRADO = 0
			JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0 
			LEFT JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
			LEFT JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = PAC.PRO_ID AND PRO.BORRADO = 0
			LEFT JOIN '|| V_ESQUEMA ||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA ON STA.DD_STA_ID = ACT.DD_STA_ID AND STA.BORRADO = 0
			LEFT JOIN '|| V_ESQUEMA ||'.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID=ACT.ACT_ID AND AJD.BORRADO = 0
			LEFT JOIN '|| V_ESQUEMA ||'.ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID=ACT.ACT_ID AND ADN.BORRADO = 0
			LEFT JOIN (SELECT CAT.ACT_ID, LISTAGG(CAT.CAT_REF_CATASTRAL,'','') WITHIN GROUP (ORDER BY ACT_ID) AS CAT_REF_CATASTRAL FROM ' || V_ESQUEMA || '.ACT_CAT_CATASTRO CAT WHERE CAT.BORRADO = 0
				GROUP BY CAT.ACT_ID) CATASTRO ON CATASTRO.ACT_ID = ACT.ACT_ID
			LEFT JOIN ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES BIE_DAT ON ACT.BIE_ID = BIE_DAT.BIE_ID AND BIE_DAT.BORRADO = 0
			
			LEFT JOIN ' || V_ESQUEMA || '.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
			LEFT JOIN ' || V_ESQUEMA || '.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID AND SAC.BORRADO = 0
			LEFT JOIN ' || V_ESQUEMA || '.BIE_LOCALIZACION BIE_LOC ON ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_TVI_TIPO_VIA TPVIA ON TPVIA.DD_TVI_ID = BIE_LOC.DD_TVI_ID AND TPVIA.BORRADO = 0
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = BIE_LOC.DD_PRV_ID AND PRV.BORRADO = 0
	    	LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = BIE_DAT.DD_LOC_ID AND LOC.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID AND ICO.BORRADO = 0		
			LEFT JOIN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI ON EDI.ICO_ID = ICO.ICO_ID AND EDI.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.DD_ECT_ESTADO_CONSTRUCCION ECT ON ECT.DD_ECT_ID = ICO.DD_ECT_ID AND ECT.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID AND SPS.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.V_PIVOT_PRECIOS_ACTIVOS V ON V.ACT_ID = ACT.ACT_ID
			LEFT JOIN (select act_id, BIE_FECHA_VALOR_TASACION, TAS_IMPORTE_TAS_FIN FROM (
					select tasacion.act_id,
				       tasacion.BIE_FECHA_VALOR_TASACION,
				       tasacion.TAS_IMPORTE_TAS_FIN,
				       max(tasacion.BIE_FECHA_VALOR_TASACION) over (partition by tasacion.act_id) max_date
					from (select tas.act_id, bie_val.BIE_FECHA_VALOR_TASACION, tas.TAS_IMPORTE_TAS_FIN from '||V_ESQUEMA||'.ACT_TAS_TASACION TAS JOIN '||V_ESQUEMA||'.BIE_VALORACIONES BIE_VAL ON BIE_VAL.BIE_VAL_ID = TAS.BIE_VAL_ID AND BIE_VAL.BORRADO = 0 WHERE TAS.BORRADO = 0) tasacion)
				where BIE_FECHA_VALOR_TASACION = max_date) tasacion on tasacion.act_id = act.act_id';
		    

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_UNIFICADA...Creada OK');
  
END;
/

EXIT;
