--/*
--##########################################
--## AUTOR=Ramon llinares
--## FECHA_CREACION=20190130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3225

--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - REMVIP-1544
--##	    0.2 Optimizacion APR y MINI - REMVIP-2139
--##		0.3 Eliminar duplicados - REMVIP-2235
--##		0.4 Left join a titulo para registros que se perdian - REMVIP-2352

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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN
	
-- Modificación de la vista V_LISTADO_ACT_EXP de Fase1.

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_LISTADO_ACT_EXP' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_LISTADO_ACT_EXP...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_LISTADO_ACT_EXP';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_LISTADO_ACT_EXP... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_LISTADO_ACT_EXP' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_LISTADO_ACT_EXP...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_LISTADO_ACT_EXP';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_LISTADO_ACT_EXP... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_LISTADO_ACT_EXP...');
  EXECUTE IMMEDIATE 'CREATE VIEW V_LISTADO_ACT_EXP AS 
		WITH AUX_CALCULOS_SPS AS (SELECT ECO.ECO_ID, OFR.ACT_ID, SPS.SPS_ID,
		        CASE WHEN SPS.SPS_OCUPADO IS NULL OR SPS.SPS_OCUPADO = 0 THEN ''01''
		             WHEN SPS.SPS_OCUPADO IS NOT NULL AND SPS.SPS_OCUPADO = 1 AND SPS.SPS_CON_TITULO IS NOT NULL AND SPS.SPS_CON_TITULO = 1 THEN ''02''
		             WHEN SPS.SPS_OCUPADO IS NOT NULL AND SPS.SPS_OCUPADO = 1 AND SPS.SPS_CON_TITULO IS NOT NULL AND (SPS.SPS_CON_TITULO = 0 OR SPS.SPS_CON_TITULO IS NULL) THEN ''03''
		             ELSE NULL
		             END AS SITUACION_POS_COD_I,
		        CASE WHEN SPS.SPS_FECHA_TOMA_POSESION IS NOT NULL THEN 1
		             ELSE 0
		             END AS POS_INICIAL_I    
		        FROM '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS
		        JOIN '|| V_ESQUEMA ||'.ACT_OFR OFR ON SPS.ACT_ID = OFR.ACT_ID
		        JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID
		),
		APR AS (
		SELECT DISTINCT OFR.ACT_ID, ECO.ECO_ID,
		CASE WHEN TPC.DD_TPC_CODIGO IS NULL THEN NULL
		     ELSE VAL.VAL_IMPORTE
		     END AS IMPORTE_TPC_APR,
		TPC.DD_TPC_CODIGO AS CODIGO_APR
		FROM '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO
		JOIN '|| V_ESQUEMA ||'.ACT_OFR OFR ON ECO.OFR_ID = OFR.OFR_ID
		INNER JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL ON OFR.ACT_ID = VAL.ACT_ID
		INNER JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''02'' 
		WHERE VAL.BORRADO = 0 
		),
		MINI AS (
		SELECT DISTINCT OFR.ACT_ID, ECO.ECO_ID,
		CASE WHEN TPC2.DD_TPC_CODIGO IS NULL THEN NULL
		     ELSE VAL2.VAL_IMPORTE
		     END AS IMPORTE_TPC_MIN,
		TPC2.DD_TPC_CODIGO AS CODIGO_MIN
		FROM '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO
		JOIN '|| V_ESQUEMA ||'.ACT_OFR OFR ON ECO.OFR_ID = OFR.OFR_ID
		INNER JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL2 ON OFR.ACT_ID = VAL2.ACT_ID
		INNER JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC2 ON VAL2.DD_TPC_ID = TPC2.DD_TPC_ID AND TPC2.DD_TPC_CODIGO = ''04'' 
		WHERE VAL2.BORRADO = 0 
		),
		BEX AS (
		SELECT DISTINCT BEX.ACT_BEX_ECO_ID, BEX.ACT_ID, BEX.USUARIOBORRAR
		FROM '|| V_ESQUEMA ||'.ACT_BEX_BLOQ_EXP_FORMALIZAR BEX
		JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO ON BEX.ACT_BEX_ECO_ID = ECO.ECO_ID
		JOIN '|| V_ESQUEMA ||'.ACT_OFR OFR ON ECO.OFR_ID = OFR.OFR_ID AND BEX.ACT_ID = OFR.ACT_ID
		)
		SELECT ROWNUM AS ID_VISTA, ECO.ECO_ID, OFR.ACT_ID, OFR.OFR_ACT_PORCEN_PARTICIPACION AS PORCENTAJE_PARTICIPACION, OFR.ACT_OFR_IMPORTE AS IMP_ACT_OFERTA,
		APR.CODIGO_APR, APR.IMPORTE_TPC_APR, MINI.CODIGO_MIN, MINI.IMPORTE_TPC_MIN,
		CASE WHEN JUR.ACT_ECO_FECHA_EMISION IS NULL THEN 2 
		     WHEN JUR.ACT_ECO_FECHA_EMISION IS NOT NULL AND BEX.USUARIOBORRAR IS NOT NULL THEN 1
		     ELSE 0
		     END AS BLOQUEO,
		CASE WHEN (SIP.DD_SIP_CODIGO IS NOT NULL AND CAL.SITUACION_POS_COD_I IS NOT NULL AND SIP.DD_SIP_CODIGO = CAL.SITUACION_POS_COD_I)
		     AND (CON.COND_POSESION_INICIAL IS NOT NULL AND CAL.POS_INICIAL_I IS NOT NULL AND CON.COND_POSESION_INICIAL = CAL.SITUACION_POS_COD_I)
		     AND (ETI.DD_ETI_CODIGO IS NOT NULL AND ETI2.DD_ETI_CODIGO IS NOT NULL AND ETI.DD_ETI_CODIGO = ETI2.DD_ETI_CODIGO) THEN 1
		     ELSE 0
		     END AS CONDICIONES,
		ACT.ACT_NUM_ACTIVO, TPA.DD_TPA_DESCRIPCION, SAC.DD_SAC_DESCRIPCION, LOC.DD_LOC_DESCRIPCION, PRV.DD_PRV_DESCRIPCION, BDR.BIE_DREG_NUM_FINCA,
		BIE.BIE_LOC_DIRECCION
		FROM '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO
		JOIN '|| V_ESQUEMA ||'.ACT_OFR OFR ON ECO.OFR_ID = OFR.OFR_ID
		LEFT JOIN APR APR ON APR.ECO_ID = ECO.ECO_ID AND APR.ACT_ID = OFR.ACT_ID
		LEFT JOIN MINI MINI ON MINI.ECO_ID = ECO.ECO_ID AND MINI.ACT_ID = OFR.ACT_ID
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_ECO_INFORME_JURIDICO JUR ON ECO.ECO_ID = JUR.ECO_ID AND OFR.ACT_ID = JUR.ACT_ID
		LEFT JOIN BEX BEX ON ECO.ECO_ID = BEX.ACT_BEX_ECO_ID AND OFR.ACT_ID = BEX.ACT_ID
		LEFT JOIN AUX_CALCULOS_SPS CAL ON ECO.ECO_ID = CAL.ECO_ID AND OFR.ACT_ID = CAL.ACT_ID
		LEFT JOIN '|| V_ESQUEMA ||'.ECO_COND_CONDICIONES_ACTIVO CON ON ECO.ECO_ID = CON.ECO_ID AND OFR.ACT_ID = CON.ACT_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_SIP_SITUACION_POSESORIA SIP ON CON.DD_SIP_ID = SIP.DD_SIP_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_ETI_ESTADO_TITULO ETI ON CON.DD_ETI_ID = ETI.DD_ETI_ID
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_TIT_TITULO TIT ON OFR.ACT_ID = TIT.ACT_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_ETI_ESTADO_TITULO ETI2 ON TIT.DD_ETI_ID = ETI2.DD_ETI_ID
		JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON OFR.ACT_ID = ACT.ACT_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO TPA ON ACT.DD_TPA_ID = TPA.DD_TPA_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO SAC ON ACT.DD_SAC_ID = SAC.DD_SAC_ID
		JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIE ON ACT.BIE_ID = BIE.BIE_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON BIE.DD_LOC_ID = LOC.DD_LOC_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON BIE.BIE_LOC_PROVINCIA = PRV.DD_PRV_CODIGO
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_REG_INFO_REGISTRAL REG ON ACT.ACT_ID = REG.ACT_ID
		LEFT JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BDR ON REG.BIE_DREG_ID = BDR.BIE_DREG_ID
  ';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_LISTADO_ACT_EXP...Creada OK');

  
END;
/

EXIT;
