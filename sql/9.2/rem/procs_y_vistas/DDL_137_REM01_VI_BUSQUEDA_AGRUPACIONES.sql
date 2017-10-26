--/*
--##########################################
--## AUTOR=CARLOS PONS
--## FECHA_CREACION=20170814
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
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_AGRUPACIONES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_AGRUPACIONES...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_AGRUPACIONES';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_AGRUPACIONES... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_AGRUPACIONES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_AGRUPACIONES...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_AGRUPACIONES';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_AGRUPACIONES... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_AGRUPACIONES...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_AGRUPACIONES 
	AS

SELECT DISTINCT AGR.AGR_ID,
                AGR.DD_TAG_ID,
                AGR.AGR_NUM_AGRUP_REM,
                AGR.AGR_NOMBRE,
                AGR.AGR_DESCRIPCION,
                AGR.AGR_FECHA_ALTA,
                AGR.AGR_FECHA_BAJA,
                AGR.AGR_INI_VIGENCIA,
                AGR.AGR_FIN_VIGENCIA,
                AGR.AGR_PUBLICADO,

  (SELECT COUNT(AGA.ACT_ID)
   FROM ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO AGA
   WHERE AGA.AGR_ID = AGR.AGR_ID
     AND AGR.BORRADO = 0 AND ACT.BORRADO = 0) AS ACTIVOS,

  (SELECT COUNT(AGA.ACT_ID)
   FROM ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO AGA
   INNER JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID
   INNER JOIN ' || V_ESQUEMA || '.DD_EPU_ESTADO_PUBLICACION DD_EPU ON ACT.DD_EPU_ID = DD_EPU.DD_EPU_ID
   WHERE AGA.AGR_ID = AGR.AGR_ID
     AND ACT.DD_EPU_ID IS NOT NULL
     AND DD_EPU.DD_EPU_CODIGO NOT IN (''03'',''05'',''06'')
     AND DD_EPU.BORRADO = 0
     AND AGA.BORRADO = 0 ) AS PUBLICADOS,

                COALESCE(OBR.DD_PRV_ID, RES.DD_PRV_ID, LCO.DD_PRV_ID, ASI.DD_PRV_ID) AS PROVINCIA,
                COALESCE(OBR.DD_LOC_ID, RES.DD_LOC_ID, LCO.DD_LOC_ID, ASI.DD_LOC_ID) AS LOCALIDAD,
                COALESCE(OBR.ONV_DIRECCION, RES.RES_DIRECCION, LCO.LCO_DIRECCION, ASI.ASI_DIRECCION) AS DIRECCION,
                CRA.DD_CRA_CODIGO CARTERA,
                AGR.AGR_IS_FORMALIZACION

FROM ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR
JOIN ' || V_ESQUEMA || '.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
LEFT JOIN ' || V_ESQUEMA || '.ACT_ONV_OBRA_NUEVA OBR ON (AGR.AGR_ID=OBR.AGR_ID)
LEFT JOIN ' || V_ESQUEMA || '.ACT_RES_RESTRINGIDA RES ON (AGR.AGR_ID=RES.AGR_ID)
LEFT JOIN ' || V_ESQUEMA || '.ACT_LCO_LOTE_COMERCIAL LCO ON (AGR.AGR_ID=LCO.AGR_ID)
LEFT JOIN ' || V_ESQUEMA || '.ACT_ASI_ASISTIDA ASI ON (AGR.AGR_ID=ASI.AGR_ID)
LEFT JOIN ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID
LEFT JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID
LEFT JOIN ' || V_ESQUEMA || '.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID

WHERE AGR.BORRADO = 0
  AND TAG.BORRADO = 0';
SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'ACT_AGA_IDX1' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='INDEX';  
  IF CUENTA>0 THEN
  	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.ACT_AGA_IDX1';  
  END IF;
  	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.ACT_AGA_IDX1 ON ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO
		(AGA_ID, AGR_ID, ACT_ID, BORRADO)
		LOGGING
		NOPARALLEL';
SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'ACT_ACTIVO_IDX3' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='INDEX';  
  IF CUENTA>0 THEN
  	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.ACT_ACTIVO_IDX3';  
  END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.ACT_ACTIVO_IDX3 ON ' || V_ESQUEMA || '.ACT_ACTIVO
		(ACT_ID, DD_CRA_ID, DD_EPU_ID, BORRADO)
		LOGGING
		NOPARALLEL';
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_AGRUPACIONES...Creada OK');
  
END;
/

EXIT;