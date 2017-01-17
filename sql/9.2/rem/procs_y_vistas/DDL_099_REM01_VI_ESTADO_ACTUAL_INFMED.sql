--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20170114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1398
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 20161006 Versión inicial 
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_ESTADO_ACTUAL_INFMED'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'
	AS
		SELECT AUX.* FROM (
			  SELECT ICO.ICO_ID, HIC.ACT_ID, DDAIC.DD_AIC_CODIGO, HIC.HIC_FECHA, HIC.HIC_MOTIVO, 
			  ROW_NUMBER() OVER (PARTITION BY HIC.ACT_ID ORDER BY HIC.HIC_FECHA DESC) REF
			  FROM '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST HIC
			  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = HIC.ACT_ID
			  INNER JOIN '||V_ESQUEMA||'.DD_AIC_ACCION_INF_COMERCIAL DDAIC ON DDAIC.DD_AIC_ID = HIC.DD_AIC_ID
			  ) AUX
			WHERE AUX.REF = 1';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
  
END;
/

EXIT;