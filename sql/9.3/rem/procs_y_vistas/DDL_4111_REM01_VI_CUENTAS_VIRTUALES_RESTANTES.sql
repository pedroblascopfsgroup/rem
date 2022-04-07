--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220407
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17566
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
    err_num NUMBER; -- Número de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_CUENTAS_VIRTUALES_RESTANTES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_CUENTAS_VIRTUALES_RESTANTES...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_CUENTAS_VIRTUALES_RESTANTES';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_CUENTAS_VIRTUALES_RESTANTES... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_CUENTAS_VIRTUALES_RESTANTES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_CUENTAS_VIRTUALES_RESTANTES...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_CUENTAS_VIRTUALES_RESTANTES';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_CUENTAS_VIRTUALES_RESTANTES... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.VI_CUENTAS_VIRTUALES_RESTANTES...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_CUENTAS_VIRTUALES_RESTANTES 
	AS
		SELECT
			  CVC.DD_SCR_ID DD_SCR_ID
			, COUNT(*) NUM_CUENTAS
		FROM '||V_ESQUEMA||'.CVC_CUENTAS_VIRTUALES CVC
		WHERE CVC.BORRADO = 0
		AND CVC.CVC_FECHA_INICIO IS NULL
		GROUP BY CVC.DD_SCR_ID
		';
		    

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_CUENTAS_VIRTUALES_RESTANTES...Creada OK');
  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_CUENTAS_VIRTUALES_RESTANTES IS ''VISTA PARA RECOGER LAS CUENTAS VIRTUALES RESTANTES POR SUBCARTERAS''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_CUENTAS_VIRTUALES_RESTANTES.DD_SCR_ID IS ''Subcartera''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_CUENTAS_VIRTUALES_RESTANTES.NUM_CUENTAS IS ''Numero de cuentas virtuales sin fecha inicio de la subcartera''';
  
 EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;
		  
END;
/

EXIT;
