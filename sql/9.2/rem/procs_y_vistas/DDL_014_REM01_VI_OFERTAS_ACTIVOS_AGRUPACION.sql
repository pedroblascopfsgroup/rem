--/*
--##########################################
--## AUTOR=pier gotta
--## FECHA_CREACION=20181126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4912
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		HREOS-2030: Nuevos filtros en buscador de ofertas.
--##        HREOS-2236: Nuevos filtros en buscador de ofertas.
--##		REMVIP-1645: Optimización de la vista.
--##		HREOS-4912: (20181204 - Alberto Checa) GENCAT - Aviso al crear un expediente comercial
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
    V_MSQL VARCHAR2(32000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_OFERTAS_ACTIVOS_AGRUPACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_OFERTAS_ACTIVOS_AGRUPACION...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_OFERTAS_ACTIVOS_AGRUPACION... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_OFERTAS_ACTIVOS_AGRUPACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_OFERTAS_ACTIVOS_AGRUPACION...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_OFERTAS_ACTIVOS_AGRUPACION... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_OFERTAS_ACTIVOS_AGRUPACION...');
  V_MSQL := 'CREATE VIEW ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION 
	AS
		WITH GENCAT AS (SELECT 
    		CASE 
		        WHEN (CRA.DD_CRA_CODIGO = ''03'' AND (SCR.DD_SCR_CODIGO = ''08'' OR SCR.DD_SCR_CODIGO = ''06'' OR SCR.DD_SCR_CODIGO = ''09'' OR SCR.DD_SCR_CODIGO = ''07'')) THEN 1 
		        WHEN (CRA.DD_CRA_CODIGO = ''02'' AND SCR.DD_SCR_CODIGO = ''04'') THEN 1 
		        WHEN (CRA.DD_CRA_CODIGO = ''01'' AND SCR.DD_SCR_CODIGO = ''02'') THEN 1
		        WHEN (CRA.DD_CRA_CODIGO = ''08'' AND SCR.DD_SCR_CODIGO = ''18'') THEN 1
		        WHEN (CRA.DD_CRA_CODIGO = ''06'' AND SCR.DD_SCR_CODIGO = ''16'') THEN 1
		        ELSE 0
    		END GENCAT, ACT.ACT_ID
		FROM ACT_ACTIVO ACT
		    INNER JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIE ON ACT.BIE_ID = BIE.BIE_ID
		    INNER JOIN '|| V_ESQUEMA ||'.CMU_CONFIG_MUNICIPIOS CMU ON CMU.DD_LOC_ID = BIE.DD_LOC_ID
		    INNER JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND DD_TPA_CODIGO = ''02''
		    INNER JOIN '|| V_ESQUEMA ||'.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID = ACT.ACT_ID AND TRUNC(AJD.AJD_FECHA_ADJUDICACION) > TO_DATE (''07/04/2018'', ''dd/mm/yyyy'') 
		    INNER JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		    INNER JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
    	)
		SELECT 
				OFR.OFR_ID AS ID,
		    OFR.OFR_NUM_OFERTA,
		    OFR.OFR_FECHA_ACCION,
				OFR.OFR_FECHA_ALTA,
		    TOF.DD_TOF_DESCRIPCION,
				TOF.DD_TOF_CODIGO,
				NVL2(AGR.AGR_NUM_AGRUP_REM, AGR.AGR_NUM_AGRUP_REM, ACT.ACT_NUM_ACTIVO) AS NUM_ACTIVO_AGRUPACION,
		    NVL2(CLC.CLC_RAZON_SOCIAL,CLC.CLC_RAZON_SOCIAL, CLC.CLC_NOMBRE || NVL2(CLC.CLC_APELLIDOS, '' '' || CLC.CLC_APELLIDOS, '''')) AS OFERTANTE,
				CLC.CLC_TELEFONO1 ||''@''|| CLC.CLC_TELEFONO2 ||''@'' AS TELEFONO_OFERTANTE,
				CLC.CLC_EMAIL AS EMAIL_OFERTANTE,
				CLC.CLC_DOCUMENTO AS DOCUMENTO_OFERTANTE,
        /*(CASE TOF.DD_TOF_CODIGO WHEN ''01'' THEN OFRVAL02.PRECIO_PUBLICADO WHEN ''02'' THEN OFRVAL03.PRECIO_PUBLICADO END) AS PRECIO_PUBLICADO,*/
        LCO.LCO_GESTOR_COMERCIAL AS GESTOR_LOTE,
		    OFR.OFR_IMPORTE,
		    EOF.DD_EOF_DESCRIPCION,
				EOF.DD_EOF_CODIGO,
        TRO.DD_TRO_CODIGO,
        MRO.DD_MRO_CODIGO,
		    ECO.ECO_NUM_EXPEDIENTE,
				ECO.ECO_ID,
		    EEC.DD_EEC_DESCRIPCION,
				EEC.DD_EEC_CODIGO,
				CAP.DD_CAP_CODIGO,
				CAP.DD_CAP_DESCRIPCION,
				AGR.AGR_ID,
		    OFR.OFR_ID,
				VAO.ACT_ID,
				OFR.FECHAMODIFICAR,
				RES.RES_FECHA_FIRMA,
				VIS.VIS_ID,
				VIS.VIS_NUM_VISITA,
				PVEPRES.PVE_NOMBRE AS NOMBRE_CANAL,
				TPR.DD_TPR_CODIGO AS CANAL,
				TPR.DD_TPR_DESCRIPCION AS CANAL_DESCRIPCION,
				CRA.DD_CRA_CODIGO AS CARTERA_CODIGO,
        		ACT.DD_TCR_ID AS TIPO_COMERCIALIZACION,
       			ABA.DD_CLA_ID AS CLASE_ACTIVO,
				ACT.ACT_NUM_ACTIVO_UVEM AS NUM_ACTIVO_UVEM,
				ACT.ACT_NUM_ACTIVO_SAREB AS NUM_ACTIVO_SAREB,
				ACT.ACT_NUM_ACTIVO_PRINEX AS NUM_ACTIVO_PRINEX,
				OFR.OFR_OFERTA_EXPRESS AS OFERTA_EXPRESS,
				OFR.OFR_NECESITA_FINANCIACION AS NECESITA_FINANCIACION,
                OFR.OFR_OBSERVACIONES AS OBSERVACIONES,
				NVL(GEN.GENCAT, 0) AS GENCAT
		FROM '|| V_ESQUEMA ||'.OFR_OFERTAS OFR
		JOIN '|| V_ESQUEMA ||'.V_FIRST_ACTIVO_OFERTA VAO ON VAO.OFR_ID = OFR.OFR_ID
		INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = VAO.ACT_ID and act.borrado = 0
		LEFT JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA  ON ACT.DD_CRA_ID = CRA.DD_CRA_ID
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_ABA_ACTIVO_BANCARIO ABA ON ACT.ACT_ID = ABA.ACT_ID 
		   INNER JOIN '|| V_ESQUEMA ||'.DD_TOF_TIPOS_OFERTA TOF on TOF.DD_TOF_ID = OFR.DD_TOF_ID
		INNER JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF on EOF.DD_EOF_ID = OFR.DD_EOF_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_MRO_MOTIVO_RECHAZO_OFERTA MRO on OFR.DD_MRO_ID = MRO.DD_MRO_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_TRO_TIPO_RECHAZO_OFERTA TRO on MRO.DD_TRO_ID = TRO.DD_TRO_ID
		LEFT JOIN '|| V_ESQUEMA ||'.VIS_VISITAS VIS on VIS.VIS_ID = OFR.VIS_ID
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVEPRES on PVEPRES.PVE_ID = OFR.PVE_ID_PRESCRIPTOR
			LEFT JOIN '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR on TPR.DD_TPR_ID = PVEPRES.DD_TPR_ID
		LEFT JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO on ECO.OFR_ID = OFR.OFR_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_EEC_EST_EXP_COMERCIAL EEC on EEC.DD_EEC_ID = ECO.DD_EEC_ID
		LEFT JOIN '|| V_ESQUEMA ||'.RES_RESERVAS RES on RES.ECO_ID = ECO.ECO_ID
			/*LEFT JOIN (SELECT OFR2.OFR_ID, TPC.DD_TPC_CODIGO, SUM(VAL.VAL_IMPORTE) AS PRECIO_PUBLICADO 
							FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL 
							INNER JOIN '|| V_ESQUEMA ||'.ACT_OFR OFR2 ON VAL.ACT_ID = OFR2.ACT_ID 
							INNER JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID 
							WHERE TPC.DD_TPC_CODIGO=''02'' 
							GROUP BY OFR2.OFR_ID, TPC.DD_TPC_CODIGO) OFRVAL02 ON OFRVAL02.OFR_ID = OFR.OFR_ID
			LEFT JOIN (SELECT OFR3.OFR_ID, TPC.DD_TPC_CODIGO, SUM(VAL.VAL_IMPORTE) AS PRECIO_PUBLICADO 
							FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL 
							INNER JOIN '|| V_ESQUEMA ||'.ACT_OFR OFR3 ON VAL.ACT_ID = OFR3.ACT_ID 
							INNER JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID 
							WHERE TPC.DD_TPC_CODIGO=''03'' GROUP BY OFR3.OFR_ID, TPC.DD_TPC_CODIGO) OFRVAL03 ON OFRVAL03.OFR_ID = OFR.OFR_ID*/
		INNER JOIN '|| V_ESQUEMA ||'.CLC_CLIENTE_COMERCIAL CLC on CLC.CLC_ID = OFR.CLC_ID
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR on AGR.AGR_ID = OFR.AGR_ID and agr.borrado = 0
			LEFT JOIN '|| V_ESQUEMA ||'.DD_CAP_CANAL_PRESCRIPCION CAP ON CAP.DD_CAP_ID = OFR.DD_CAP_ID
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_LCO_LOTE_COMERCIAL LCO ON OFR.AGR_ID = LCO.AGR_ID
        LEFT JOIN GENCAT GEN ON GEN.ACT_ID = ACT.ACT_ID
		WHERE OFR.BORRADO  = 0 ';
        
  EXECUTE IMMEDIATE	V_MSQL;
    
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_OFERTAS_ACTIVOS_AGRUPACION...Creada OK');
  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION IS ''VISTA PARA RECOGER LAS OFERTAS DE ACTIVOS Y AGRUPACIONES''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.OFR_NUM_OFERTA IS ''Número de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.OFR_FECHA_ALTA IS ''Fecha de creación de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_TOF_DESCRIPCION IS ''Descripción del tipo de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_TOF_CODIGO IS ''Código del tipo de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.NUM_ACTIVO_AGRUPACION IS ''Número de agrupación o activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.OFERTANTE IS ''Nombre y apellidos del Cliente comercial que realiza la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.GESTOR_LOTE IS ''Gestor comercial del lote''';
  /*EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.PRECIO_PUBLICADO IS ''Precio publicado en la valoración del/los activos''';*/
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.OFR_IMPORTE IS ''Importe ofertado''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_EOF_DESCRIPCION IS ''Estado de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_TRO_CODIGO IS ''Codigo tipo rechazo de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_MRO_CODIGO IS ''Codigo motivo rechazo de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_EOF_CODIGO IS ''Código del estado de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.ECO_NUM_EXPEDIENTE IS ''Número del expediente comercial relacionado con la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.ECO_ID IS ''Código identificador único del expediente comercial relacionado con la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_EEC_DESCRIPCION IS ''Estado del expediente comercial relacionado con la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.AGR_ID IS ''Código identificador único de la agrupación.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.OFR_ID IS ''Código identificador único de la oferta.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_CAP_DESCRIPCION IS ''Descripción canal prescripción.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_CAP_CODIGO IS ''Código canal prescripción.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.FECHAMODIFICAR IS ''Fecha modificación de la oferta.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.CARTERA_CODIGO IS ''Cartera de la Oferta.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.GENCAT IS ''Activos que pertenecen a GENCAT.''';

  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_OFERTAS_ACTIVOS_AGRUPACION...Creada OK');
  
END;
/

EXIT;
