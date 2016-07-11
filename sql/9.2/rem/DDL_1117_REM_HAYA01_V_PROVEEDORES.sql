--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20160323
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_PROVEEDORES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_PROVEEDORES...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_PROVEEDORES';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_PROVEEDORES... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_PROVEEDORES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_PROVEEDORES...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_PROVEEDORES';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_PROVEEDORES... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_PROVEEDORES...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_PROVEEDORES 
	AS
		SELECT 
			  PVE.PVE_ID,
			  PVE.PVE_NOMBRE,
			  PVE.PVE_NOMBRE_COMERCIAL,
			  TPR.DD_TPR_CODIGO,
			  TPR.DD_TPR_DESCRIPCION,
			  CRA.DD_CRA_ID,
			  CRA.DD_CRA_DESCRIPCION,
			  PVC.PVC_NOMBRE,
			  PVC.PVC_TELF1,
			  PVC.PVC_EMAIL
			  
		FROM ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVE
		INNER JOIN ' || V_ESQUEMA || '.ACT_ETP_ENTIDAD_PROVEEDOR ETP ON PVE.PVE_ID = ETP.PVE_ID
		INNER JOIN ' || V_ESQUEMA || '.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID AND TPR.BORRADO = 0
		INNER JOIN ' || V_ESQUEMA || '.ACT_PVC_PROVEEDOR_CONTACTO PVC ON PVC.PVE_ID = PVE.PVE_ID AND PVC.BORRADO = 0
		INNER JOIN ' || V_ESQUEMA || '.DD_CRA_CARTERA CRA ON ETP.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
		WHERE PVE.BORRADO = 0';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_PROVEEDORES...Creada OK');
  
END;
/

EXIT;