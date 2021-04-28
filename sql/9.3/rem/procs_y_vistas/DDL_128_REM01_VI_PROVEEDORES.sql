--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL          
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 REMVIP-9499 - IVAN REPISO - Se necesita el estado de proveedor y el codigo proveedor
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
      PVE.PVE_COD_REM,
      EPR.DD_EPR_DESCRIPCION,
			TPR.DD_TPR_CODIGO,
			TPR.DD_TPR_DESCRIPCION,
			CRA.DD_CRA_CODIGO,
			CRA.DD_CRA_DESCRIPCION,
			NULL AS DD_PRV_CODIGO,
			NULL AS DD_PRV_DESCRIPCION,
			NVL2(PVE.PVE_FECHA_BAJA, 1 ,0) AS BAJA

			  
		FROM ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVE
		INNER JOIN ' || V_ESQUEMA || '.ACT_ETP_ENTIDAD_PROVEEDOR ETP ON PVE.PVE_ID = ETP.PVE_ID
		INNER JOIN ' || V_ESQUEMA || '.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID AND TPR.BORRADO = 0
		INNER JOIN ' || V_ESQUEMA || '.DD_CRA_CARTERA CRA ON ETP.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
    INNER JOIN ' || V_ESQUEMA || '.DD_EPR_ESTADO_PROVEEDOR EPR ON EPR.DD_EPR_ID = PVE.DD_EPR_ID AND EPR.BORRADO = 0
		WHERE PVE.BORRADO = 0';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_PROVEEDORES...Creada OK');

  COMMIT;
  

  EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;