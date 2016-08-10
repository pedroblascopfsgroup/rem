
--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160810
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_ACTIVOS_PROPUESTA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_PROPUESTA...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_PROPUESTA';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_PROPUESTA... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_ACTIVOS_PROPUESTA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_PROPUESTA...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_PROPUESTA';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_PROPUESTA... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_PROPUESTA...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_PROPUESTA 
	AS
		SELECT
	  		ACT.ACT_ID,
			ACT.ACT_NUM_ACTIVO,
			ACP.PRP_ID,
			TPA.DD_TPA_CODIGO AS TIPO_ACTIVO_CODIGO,
			TPA.DD_TPA_DESCRIPCION AS TIPO_ACTIVO_DESCRIPCION,
			SAC.DD_SAC_CODIGO AS SUBTIPO_ACTIVO_CODIGO,
			SAC.DD_SAC_DESCRIPCION AS SUBTIPO_ACTIVO_DESCRIPCION,
			PRV.DD_PRV_CODIGO AS PROVINCIA_CODIGO,
			PRV.DD_PRV_DESCRIPCION AS PROVINCIA_DESCRIPCION,
			LOC.DD_LOC_CODIGO AS LOCALIDAD_CODIGO,
			LOC.DD_LOC_DESCRIPCION AS LOCALIDAD_DESCRIPCION,
			BIE_LOC.BIE_LOC_COD_POST AS CODIGO_POSTAL,
			TPVIA.DD_TVI_DESCRIPCION || '' '' || BIE_LOC.BIE_LOC_NOMBRE_VIA || '' ''|| BIE_LOC.BIE_LOC_NUMERO_DOMICILIO || '' ''||  BIE_LOC.BIE_LOC_PUERTA AS DIRECCION,
			PRECIO_APROBADO_VENTA.VAL_IMPORTE AS PRECIO_APROBADO_VENTA,
			PRECIO_APROBADO_RENTA.VAL_IMPORTE AS PRECIO_APROBADO_RENTA,
			PRECIO_MINIMO_AUTORIZADO.VAL_IMPORTE AS PRECIO_MINIMO_AUTORIZADO,
			PRECIO_DESCUENTO_APROBADO.VAL_IMPORTE AS PRECIO_DESCUENTO_APROBADO,
			PRECIO_DESCUENTO_PUBLICADO.VAL_IMPORTE AS PRECIO_DESCUENTO_PUBLICADO,
      		EPA.DD_EPA_CODIGO AS ESTADO_CODIGO,
      		EPA.DD_EPA_DESCRIPCION AS ESTADO_DESCRIPCION 
		FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
      		LEFT JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
      		LEFT JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIE_LOC ON ACT.BIE_ID = BIE_LOC.BIE_ID
      		LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_TVI_TIPO_VIA TPVIA ON TPVIA.DD_TVI_ID = BIE_LOC.DD_TVI_ID
      		LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = BIE_LOC.DD_PRV_ID
      		LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = BIE_LOC.DD_LOC_ID
	    	LEFT JOIN (SELECT VAL1.ACT_ID, VAL1.VAL_IMPORTE 
              FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL1
              INNER JOIN DD_TPC_TIPO_PRECIO TPC1 ON VAL1.DD_TPC_ID = TPC1.DD_TPC_ID AND TPC1.DD_TPC_CODIGO = ''02'') PRECIO_APROBADO_VENTA ON ACT.ACT_ID = PRECIO_APROBADO_VENTA.ACT_ID
	    	LEFT JOIN (SELECT VAL2.ACT_ID, VAL2.VAL_IMPORTE 
	                FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL2 
	                INNER JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC2 ON VAL2.DD_TPC_ID = TPC2.DD_TPC_ID AND TPC2.DD_TPC_CODIGO = ''03'') PRECIO_APROBADO_RENTA ON ACT.ACT_ID = PRECIO_APROBADO_RENTA.ACT_ID
	    	LEFT JOIN (SELECT VAL3.ACT_ID, VAL3.VAL_IMPORTE 
	                FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL3 
	                INNER JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC3 ON VAL3.DD_TPC_ID = TPC3.DD_TPC_ID AND TPC3.DD_TPC_CODIGO = ''04'') PRECIO_MINIMO_AUTORIZADO ON ACT.ACT_ID = PRECIO_MINIMO_AUTORIZADO.ACT_ID
	    	LEFT JOIN (SELECT VAL4.ACT_ID, VAL4.VAL_IMPORTE 
	                FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL4
	                INNER JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC4 ON VAL4.DD_TPC_ID = TPC4.DD_TPC_ID AND TPC4.DD_TPC_CODIGO = ''07'') PRECIO_DESCUENTO_APROBADO ON ACT.ACT_ID = PRECIO_DESCUENTO_APROBADO.ACT_ID
	    	LEFT JOIN (SELECT VAL5.ACT_ID, VAL5.VAL_IMPORTE 
	                FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL5
	                INNER JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC5 ON VAL5.DD_TPC_ID = TPC5.DD_TPC_ID AND TPC5.DD_TPC_CODIGO = ''13'') PRECIO_DESCUENTO_PUBLICADO ON ACT.ACT_ID = PRECIO_DESCUENTO_PUBLICADO.ACT_ID
		    RIGHT JOIN '|| V_ESQUEMA ||'.ACT_PRP ACP ON ACP.ACT_ID=ACT.ACT_ID
		    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PROP_ACTIVO EPA ON EPA.DD_EPA_ID=ACP.DD_EPA_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_PROPUESTA...Creada OK');
  
END;
/

EXIT;