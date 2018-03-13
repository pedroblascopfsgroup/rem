--/*
--##########################################
--## AUTOR=Carlos López
--## FECHA_CREACION=20160312
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
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
    err_num NUMBER; -- Número de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_DATOS_PROPUESTA_ENTIDAD03' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_ENTIDAD03...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_DATOS_PROPUESTA_ENTIDAD03';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_ENTIDAD03... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_DATOS_PROPUESTA_ENTIDAD03' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_ENTIDAD03...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_DATOS_PROPUESTA_ENTIDAD03';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_ENTIDAD03... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_ENTIDAD03...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_DATOS_PROPUESTA_ENTIDAD03 
	AS
		SELECT
		  	ACT.ACT_ID,
		  	ACP.PRP_ID,
			CRA.DD_CRA_CODIGO AS CARTERA_CODIGO,
		  	(SELECT AGR.AGR_NUM_AGRUP_REM FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR WHERE AGR.BORRADO = 0 AND AGR.AGR_ID IN (SELECT AGA.AGR_ID FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA WHERE AGA.ACT_ID = ACT.ACT_ID AND AGA.BORRADO = 0) AND
				AGR.AGR_FECHA_BAJA IS NULL AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO=''02'' AND BORRADO = 0)) AS AGR_RESTRINGIDA_NUM,
		  	decode(CRA.DD_CRA_CODIGO, ''01'', ''''||ACT.ACT_NUM_ACTIVO_PRINEX,
		      	''02'', ''''||ACT.ACT_NUM_ACTIVO_SAREB,
		       	''03'', ''''||ACT.ACT_NUM_ACTIVO_UVEM ) ID_CARTERA, 
		  	ACT.ACT_NUM_ACTIVO AS ID_HAYA,
		  	TPVIA.DD_TVI_DESCRIPCION || '' '' || BIE_LOC.BIE_LOC_NOMBRE_VIA || '' ''|| BIE_LOC.BIE_LOC_NUMERO_DOMICILIO AS DIRECCION,
			LOC.DD_LOC_DESCRIPCION AS MUNICIPIO,
			PRV.DD_PRV_DESCRIPCION AS PROVINCIA,
			BIE_LOC.BIE_LOC_COD_POST AS COD_POSTAL,
		  	NVL2(AJD.AJD_ID,AJD.AJD_FECHA_ADJUDICACION,ADN.ADN_FECHA_TITULO) AS FECHA_ENTRADA,
		  	tasacion.TAS_IMPORTE_TAS_FIN AS VALOR_TASACION,
		  	tasacion.BIE_FECHA_VALOR_TASACION AS FECHA_TASACION,
		  	V.VALOR_ESTIMADO_VENTA,
		  	V.VALOR_ESTIMADO_VENTA_F_INI AS FECHA_ESTIMADO_VENTA,
		  	V.FSV_VENTA,
		  	V.FSV_VENTA_F_INI,
		  	V.VALOR_ASESORADO_LIQ,
		  	V.VALOR_ASESORADO_LIQ_F_INI,
		  	V.VNC,
		  	V.APROBADO_VENTA_WEB,
		  	PRO.PRO_NOMBRE  || '' '' || PRO.PRO_APELLIDO1 || '' '' || PRO.PRO_APELLIDO2 	AS SOCIEDAD_PROPIETARIA,
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
		  	STA.DD_STA_DESCRIPCION 	AS ORIGEN,
		  	TPA.DD_TPA_CODIGO AS TIPO_CODIGO,
		  	TPA.DD_TPA_DESCRIPCION AS TIPO_DESCRIPCION,
		  	tasacion.DD_TTS_CODIGO AS TASACION_CODIGO,
		  	tasacion.DD_TTS_DESCRIPCION AS TASACION_DESCRIPCION,
		  	GREATEST(NVL2(tasacion.TAS_IMPORTE_TAS_FIN,tasacion.TAS_IMPORTE_TAS_FIN,0),NVL2(V.VALOR_ESTIMADO_VENTA,V.VALOR_ESTIMADO_VENTA,0),NVL2(V.FSV_VENTA,V.FSV_VENTA,0)) AS MAYOR_VALORACION
		  
		FROM '||V_ESQUEMA||'.ACT_PRP ACP
			JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACP.ACT_ID=ACT.ACT_ID AND ACT.BORRADO = 0
			JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID  AND CRA.BORRADO = 0
		    LEFT JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BIE_DAT ON ACT.BIE_ID = BIE_DAT.BIE_ID AND BIE_DAT.BORRADO = 0
		    LEFT JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA TPVIA ON TPVIA.DD_TVI_ID = BIE_LOC.DD_TVI_ID AND TPVIA.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = BIE_LOC.DD_PRV_ID AND PRV.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = BIE_DAT.DD_LOC_ID AND LOC.BORRADO = 0
		    LEFT JOIN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID=ACT.ACT_ID AND AJD.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID=ACT.ACT_ID AND ADN.BORRADO = 0
		    LEFT JOIN (select act_id, BIE_FECHA_VALOR_TASACION, TAS_IMPORTE_TAS_FIN,DD_TTS_CODIGO,DD_TTS_DESCRIPCION FROM (
				select tasacion.act_id,
			    	tasacion.BIE_FECHA_VALOR_TASACION,
					tasacion.TAS_IMPORTE_TAS_FIN,
		         	tasacion.DD_TTS_CODIGO,
		            tasacion.DD_TTS_DESCRIPCION,
					max(tasacion.BIE_FECHA_VALOR_TASACION) over (partition by tasacion.act_id) max_date
				from (select tas.act_id, bie_val.BIE_FECHA_VALOR_TASACION, TAS.TAS_IMPORTE_TAS_FIN, TTS.DD_TTS_CODIGO, TTS.DD_TTS_DESCRIPCION 
						from '||V_ESQUEMA||'.ACT_TAS_TASACION TAS 
						JOIN '||V_ESQUEMA||'.BIE_VALORACIONES BIE_VAL ON BIE_VAL.BIE_VAL_ID = TAS.BIE_VAL_ID AND BIE_VAL.BORRADO = 0
						JOIN '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION TTS ON TAS.DD_TTS_ID = TTS.DD_TTS_ID AND TTS.BORRADO = 0
					   WHERE TAS.BORRADO = 0
					 ) tasacion)
				where BIE_FECHA_VALOR_TASACION = max_date) tasacion on tasacion.act_id = act.act_id
		    LEFT JOIN '||V_ESQUEMA||'.V_PIVOT_PRECIOS_ACTIVOS V ON V.ACT_ID = ACT.ACT_ID
		    LEFT JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = PAC.PRO_ID
		    LEFT JOIN '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA ON STA.DD_STA_ID = ACT.DD_STA_ID
		    LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
		    where ACP.borrado = 0
		';
		    

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_DATOS_PROPUESTA_ENTIDAD03...Creada OK');
  
END;
/

EXIT;
