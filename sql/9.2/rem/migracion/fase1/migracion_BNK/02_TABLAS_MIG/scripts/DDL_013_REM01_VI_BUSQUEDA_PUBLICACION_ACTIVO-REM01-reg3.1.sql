 --/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160823
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL creación de la vista busqueda publicación activo.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
    table_count NUMBER(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count NUMBER(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(4000 CHAR); 
    CUENTA NUMBER(1); -- Vble. existencia de la vista.
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_PUBLICACION_ACTIVO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('Vista materializada: '|| V_ESQUEMA ||'.V_BUSQUEDA_PUBLICACION_ACTIVO existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_PUBLICACION_ACTIVO';  
    DBMS_OUTPUT.PUT_LINE('Vista materializada borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_PUBLICACION_ACTIVO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('Vista: '|| V_ESQUEMA ||'.V_BUSQUEDA_PUBLICACION_ACTIVO existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_PUBLICACION_ACTIVO';  
    DBMS_OUTPUT.PUT_LINE('Vista borrada OK');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Crear nueva vista: '|| V_ESQUEMA ||'.V_BUSQUEDA_PUBLICACION_ACTIVO..');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_PUBLICACION_ACTIVO 
	AS
		SELECT
			ACT.ACT_ID,
			ACT.ACT_NUM_ACTIVO AS ACT_NUM_ACTIVO,
			TPA.DD_TPA_CODIGO AS TIPO_ACTIVO_CODIGO,
			TPA.DD_TPA_DESCRIPCION AS TIPO_ACTIVO_DESCRIPCION,
			SAC.DD_SAC_CODIGO AS SUBTIPO_ACTIVO_CODIGO,
			SAC.DD_SAC_DESCRIPCION AS SUBTIPO_ACTIVO_DESCRIPCION,
		    (TVI.DD_TVI_DESCRIPCION || '' '' || LOC.BIE_LOC_NOMBRE_VIA || '' '' || LOC.BIE_LOC_NUMERO_DOMICILIO || '' '' || LOC.BIE_LOC_PUERTA) AS DIRECCION,
			CRA.DD_CRA_CODIGO AS CARTERA_CODIGO,
			(CASE EPU.DD_EPU_CODIGO WHEN ''04'' THEN 1 ELSE 0 END) AS PRECIO_CONSULTAR,
			(CASE EPU.DD_EPU_CODIGO WHEN ''05'' THEN 1 ELSE 0 END) AS DESPUBLICADO_FORZADO,
 			(CASE EPU.DD_EPU_CODIGO WHEN ''02'' THEN 1 ELSE 0 END) AS PUBLICADO_FORZADO,
			ACT.ACT_ADMISION AS ADMISION,
			ACT.ACT_GESTION AS GESTION,
			(CASE WHEN ICO.ICO_FECHA_ACEPTACION IS NOT NULL THEN 1 ELSE 0 END) AS PUBLICACION,
			(CASE WHEN ACT.ACT_FECHA_IND_PRECIAR IS NULL AND ACT.ACT_FECHA_IND_REPRECIAR IS NULL THEN 1 ELSE 0 END) AS PRECIO	
		FROM ' || V_ESQUEMA || '.ACT_ACTIVO ACT
		LEFT JOIN ' || V_ESQUEMA || '.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
	    LEFT JOIN ' || V_ESQUEMA || '.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
		LEFT JOIN ' || V_ESQUEMA || '.BIE_LOCALIZACION LOC ON ACT.BIE_ID = LOC.BIE_ID
	    LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_TVI_TIPO_VIA TVI ON LOC.DD_TVI_ID = TVI.DD_TVI_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_EPU_ESTADO_PUBLICACION EPU ON ACT.DD_EPU_ID = EPU.DD_EPU_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID=ICO.ACT_ID AND ICO.BORRADO=0';

  DBMS_OUTPUT.PUT_LINE('Vista creada OK');
  
END;
/

EXIT;