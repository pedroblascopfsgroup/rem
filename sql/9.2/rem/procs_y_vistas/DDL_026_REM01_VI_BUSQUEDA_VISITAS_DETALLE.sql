--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160810
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_VISITAS_DETALLE' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_VISITAS_DETALLE...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_VISITAS_DETALLE';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_VISITAS_DETALLE... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_VISITAS_DETALLE' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_VISITAS_DETALLE...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_VISITAS_DETALLE';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_VISITAS_DETALLE... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_VISITAS_DETALLE...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_VISITAS_DETALLE 
	AS
		SELECT
				VIS.VIS_ID,
				VIS.VIS_NUM_VISITA,
				ACT.ACT_ID,
				ACT.ACT_NUM_ACTIVO,
				VIS.VIS_FECHA_VISITA,
				VIS.VIS_FECHA_SOLICTUD,
				VIS.VIS_FECHA_CONCERTACION,
				VIS.VIS_FECHA_CONTACTO,
				VIS.VIS_OBSERVACIONES,
				SVI.DD_SVI_CODIGO,
				SVI.DD_SVI_DESCRIPCION,
				EVI.DD_EVI_CODIGO,
				EVI.DD_EVI_DESCRIPCION,
				CLC.CLC_ID,
				NVL2(CLC.CLC_RAZON_SOCIAL,CLC.CLC_RAZON_SOCIAL, CLC.CLC_NOMBRE || NVL2(CLC.CLC_APELLIDOS, '' '' || CLC.CLC_APELLIDOS, '''')) AS OFERTANTE,
				CLC.CLC_DOCUMENTO,
				CLC.CLC_DOCUMENTO_REPRESENTANTE,
				CLC.CLC_TELEFONO1,
				CLC.CLC_TELEFONO2,
				CLC.CLC_EMAIL,
				PVEC.PVE_ID AS ID_CUSTODIO_REM,
				PVEC.PVE_COD_REM AS CODIGO_CUSTODIO_REM,
				TPRC.DD_TPR_DESCRIPCION AS SUBTIPO_CUSTODIO_DESC,
				TPRC.DD_TPR_CODIGO AS SUBTIPO_CUSTODIO_COD,
				PVEP.PVE_ID AS ID_PRESCRIPTOR_REM,
				PVEP.PVE_COD_REM AS CODIGO_PRESCRIPTOR_REM,
				TPRP.DD_TPR_DESCRIPCION AS SUBTIPO_PRESCRIPTOR_DESC,
				TPRP.DD_TPR_CODIGO AS SUBTIPO_PRESCRIPTOR_COD

		FROM ' || V_ESQUEMA || '.VIS_VISITAS VIS
		LEFT JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT on ACT.ACT_ID = VIS.ACT_ID and ACT.BORRADO = 0
    	LEFT JOIN ' || V_ESQUEMA || '.DD_EVI_ESTADOS_VISITA EVI on EVI.DD_EVI_ID = VIS.DD_EVI_ID
    	LEFT JOIN ' || V_ESQUEMA || '.DD_SVI_SUBESTADOS_VISITA SVI on SVI.DD_SVI_ID = VIS.DD_SVI_ID
    	LEFT JOIN ' || V_ESQUEMA || '.CLC_CLIENTE_COMERCIAL CLC on CLC.CLC_ID = VIS.CLC_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVEC on PVEC.PVE_ID = VIS.PVE_ID_API_CUSTODIO
		LEFT JOIN ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVEP on PVEP.PVE_ID = VIS.PVE_ID_PRESCRIPTOR
		LEFT JOIN ' || V_ESQUEMA || '.DD_TPR_TIPO_PROVEEDOR TPRC on TPRC.DD_TPR_ID = PVEC.DD_TPR_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TPR_TIPO_PROVEEDOR TPRP on TPRP.DD_TPR_ID = PVEP.DD_TPR_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_VISITAS_DETALLE...Creada OK');
  
  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_VISITAS_DETALLE IS ''VISTA PARA RECOGER LAS VISITAS Y SU DETALLE''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.VIS_ID IS ''Id de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.VIS_NUM_VISITA IS ''Número de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.ACT_ID IS ''Id del activo relacionado con la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.ACT_NUM_ACTIVO IS ''Número del activo relacionado con la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.VIS_FECHA_VISITA IS ''Fecha en la que se produce la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.VIS_FECHA_SOLICTUD IS ''Fecha de solicitud de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.VIS_FECHA_CONCERTACION IS ''Fecha de concertación de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.VIS_FECHA_CONTACTO IS ''Fecha del contacto de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.VIS_OBSERVACIONES IS ''Observaciones de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.DD_SVI_CODIGO IS ''Código de Subtipo estado de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.DD_SVI_DESCRIPCION IS ''Descripción de Subtipo estado de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.DD_EVI_CODIGO IS ''Código del estado de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.DD_EVI_DESCRIPCION IS ''Descripción del estado de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.CLC_ID IS ''Id del cliente relacionado con la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.OFERTANTE IS ''Nombre completo del cliente de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.CLC_DOCUMENTO IS ''Documento del cliente de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.CLC_DOCUMENTO_REPRESENTANTE IS ''Documento del representante del cliente de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.CLC_TELEFONO1 IS ''Teléfono 1 del cliente de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.CLC_TELEFONO2 IS ''Teléfono 2 del cliente de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.CLC_EMAIL IS ''Email del cliente de la visita''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.CODIGO_CUSTODIO_REM IS ''Código de proveedor custodio REM''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.CODIGO_PRESCRIPTOR_REM IS ''Código de proveedor prescriptor REM''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.SUBTIPO_CUSTODIO_DESC IS ''Descripción subtipo proveedor custodio REM''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.SUBTIPO_CUSTODIO_COD IS ''Código subtipo proveedor custodio REM''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.SUBTIPO_PRESCRIPTOR_DESC IS ''Descripción subtipo proveedor prescriptor REM''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_VISITAS_DETALLE.SUBTIPO_PRESCRIPTOR_COD IS ''Código subtipo proveedor prescriptor REM''';
  
  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_VISITAS_DETALLE...Creada OK');
  
END;
/

EXIT;