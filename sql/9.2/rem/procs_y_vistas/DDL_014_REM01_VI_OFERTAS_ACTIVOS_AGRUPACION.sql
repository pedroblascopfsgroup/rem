--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20162309
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
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
    V_MSQL VARCHAR2(4000 CHAR); 

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
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION 
	AS
		SELECT
				ROWNUM AS ID,
			    OFR.OFR_NUM_OFERTA,
		        OFR.OFR_FECHA_ACCION,
				OFR.OFR_FECHA_ALTA,
		        TOF.DD_TOF_DESCRIPCION,
				TOF.DD_TOF_CODIGO,
				NVL2(AGR.AGR_NUM_AGRUP_REM, AGR.AGR_NUM_AGRUP_REM, ACT.ACT_NUM_ACTIVO) AS NUM_ACTIVO_AGRUPACION,
		        NVL2(CLC.CLC_RAZON_SOCIAL,CLC.CLC_RAZON_SOCIAL, CLC.CLC_NOMBRE || NVL2(CLC.CLC_APELLIDOS, '' '' || CLC.CLC_APELLIDOS, '''')) AS OFERTANTE,
				(CASE TOF.DD_TOF_CODIGO WHEN ''01'' THEN OFRVAL02.PRECIO_PUBLICADO WHEN ''02'' THEN OFRVAL03.PRECIO_PUBLICADO END) AS PRECIO_PUBLICADO,
		        OFR.OFR_IMPORTE,
		        EOF.DD_EOF_DESCRIPCION,
				EOF.DD_EOF_CODIGO,
		        ECO.ECO_NUM_EXPEDIENTE,
				ECO.ECO_ID,
		        EEC.DD_EEC_DESCRIPCION,
				AGR.AGR_ID,
		        OFR.OFR_ID,
				OFRACT.ACTIVOS,
				VAO.ACT_ID							
		FROM ' || V_ESQUEMA || '.OFR_OFERTAS OFR
		JOIN ' || V_ESQUEMA || '.V_FIRST_ACTIVO_OFERTA VAO ON VAO.OFR_ID = OFR.OFR_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = VAO.ACT_ID  
    	INNER JOIN ' || V_ESQUEMA || '.DD_TOF_TIPOS_OFERTA TOF on TOF.DD_TOF_ID = OFR.DD_TOF_ID
    	INNER JOIN ' || V_ESQUEMA || '.DD_EOF_ESTADOS_OFERTA EOF on EOF.DD_EOF_ID = OFR.DD_EOF_ID
    	LEFT JOIN ' || V_ESQUEMA || '.ECO_EXPEDIENTE_COMERCIAL ECO on ECO.OFR_ID = OFR.OFR_ID
    	LEFT JOIN ' || V_ESQUEMA || '.DD_EEC_EST_EXP_COMERCIAL EEC on EEC.DD_EEC_ID = ECO.DD_EEC_ID
		LEFT JOIN (SELECT OFR2.OFR_ID, TPC.DD_TPC_CODIGO, SUM(VAL.VAL_IMPORTE) AS PRECIO_PUBLICADO FROM ACT_VAL_VALORACIONES VAL INNER JOIN ACT_OFR OFR2 ON VAL.ACT_ID = OFR2.ACT_ID INNER JOIN DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID WHERE TPC.DD_TPC_CODIGO=''02'' GROUP BY OFR2.OFR_ID, TPC.DD_TPC_CODIGO) OFRVAL02 ON OFRVAL02.OFR_ID = OFR.OFR_ID
		LEFT JOIN (SELECT OFR3.OFR_ID, TPC.DD_TPC_CODIGO, SUM(VAL.VAL_IMPORTE) AS PRECIO_PUBLICADO FROM ACT_VAL_VALORACIONES VAL INNER JOIN ACT_OFR OFR3 ON VAL.ACT_ID = OFR3.ACT_ID INNER JOIN DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID WHERE TPC.DD_TPC_CODIGO=''03'' GROUP BY OFR3.OFR_ID, TPC.DD_TPC_CODIGO) OFRVAL03 ON OFRVAL03.OFR_ID = OFR.OFR_ID
    	INNER JOIN ' || V_ESQUEMA || '.CLC_CLIENTE_COMERCIAL CLC on CLC.CLC_ID = OFR.CLC_ID
    	LEFT JOIN ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR on AGR.AGR_ID = OFR.AGR_ID
		LEFT JOIN (SELECT ACTOFR.OFR_ID, LISTAGG(''''''''||ACT.ACT_NUM_ACTIVO||'''''''','','') WITHIN GROUP (ORDER BY OFR_ID) AS ACTIVOS FROM REM01.ACT_OFR ACTOFR JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = ACTOFR.ACT_ID GROUP BY ACTOFR.OFR_ID) OFRACT ON OFRACT.OFR_ID = OFR.OFR_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_OFERTAS_ACTIVOS_AGRUPACION...Creada OK');
  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION IS ''VISTA PARA RECOGER LAS OFERTAS DE ACTIVOS Y AGRUPACIONES''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.OFR_NUM_OFERTA IS ''Número de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.OFR_FECHA_ALTA IS ''Fecha de creación de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_TOF_DESCRIPCION IS ''Descripción del tipo de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_TOF_CODIGO IS ''Código del tipo de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.NUM_ACTIVO_AGRUPACION IS ''Número de agrupación o activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.OFERTANTE IS ''Nombre y apellidos del Cliente comercial que realiza la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.PRECIO_PUBLICADO IS ''Precio publicado en la valoración del/los activos''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.OFR_IMPORTE IS ''Importe ofertado''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_EOF_DESCRIPCION IS ''Estado de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_EOF_CODIGO IS ''Código del estado de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.ECO_NUM_EXPEDIENTE IS ''Número del expediente comercial relacionado con la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.ECO_ID IS ''Código identificador único del expediente comercial relacionado con la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.DD_EEC_DESCRIPCION IS ''Estado del expediente comercial relacionado con la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.AGR_ID IS ''Código identificador único de la agrupación.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.OFR_ID IS ''Código identificador único de la oferta.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_OFERTAS_ACTIVOS_AGRUPACION.ACTIVOS IS ''Lista de los activos pertenecientes a la oferta.''';
  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_OFERTAS_ACTIVOS_AGRUPACION...Creada OK');
  
END;
/

EXIT;