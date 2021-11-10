--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20210806
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14717
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-14717
--##        0.2 Se añade número activo y número gasto - HREOS-14741
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_GRID_TASACIONES_GASTOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_GRID_TASACIONES_GASTOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_GRID_TASACIONES_GASTOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_GRID_TASACIONES_GASTOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_GRID_TASACIONES_GASTOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_GRID_TASACIONES_GASTOS... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_GRID_TASACIONES_GASTOS...');
  V_MSQL := 'CREATE VIEW ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS 
	AS
		SELECT NEX.GPV_TAS_ID AS ID, NEX.GPV_ID, NEX.TAS_ID, TAS.ACT_ID, GPV.GPV_NUM_GASTO_HAYA, ACT.ACT_NUM_ACTIVO,
    TAS.TAS_ID_EXTERNO, TAS.TAS_CODIGO_FIRMA, TAS.TAS_FECHA_RECEPCION_TASACION
    FROM '|| V_ESQUEMA ||'.GPV_TAS NEX
    JOIN '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV ON NEX.GPV_ID = GPV.GPV_ID
    JOIN '|| V_ESQUEMA ||'.ACT_TAS_TASACION TAS ON NEX.TAS_ID = TAS.TAS_ID
    JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON TAS.ACT_ID = ACT.ACT_ID
    WHERE NEX.BORRADO = 0';

  EXECUTE IMMEDIATE	V_MSQL;
    
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_GRID_TASACIONES_GASTOS...Creada OK');
  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS IS ''VISTA PARA RECOGER LAS OFERTAS DE ACTIVOS Y AGRUPACIONES''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS.ID IS ''Id de la relación entre gasto y tasación''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS.TAS_ID IS ''Id de la tasación''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS.ACT_ID IS ''Id del activo de la tasación''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS.GPV_ID IS ''Id del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS.GPV_NUM_GASTO_HAYA IS ''Número de gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS.ACT_NUM_ACTIVO IS ''Número de activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS.TAS_ID_EXTERNO IS ''Id externo de la tasación''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS.TAS_CODIGO_FIRMA IS ''Código de firma de la tasación''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_TASACIONES_GASTOS.TAS_FECHA_RECEPCION_TASACION IS ''Fecha de recepción de la tasación''';
  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_GRID_TASACIONES_GASTOS...Creada OK');
  EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE; 
END;
/

EXIT;
