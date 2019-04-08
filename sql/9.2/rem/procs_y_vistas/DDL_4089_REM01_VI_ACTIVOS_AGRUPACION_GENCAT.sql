--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.4.0
--## INCIDENCIA_LINK=HREOS-5653
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

    CUENTA NUMBER(16); -- Vble. para validar la existencia de vista.
    
BEGIN
	
--VI_ACTIVOS_AGRUPACION_GENCAT v0.1

  SELECT COUNT(1) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_ACTIVOS_AGRUPACION_GENCAT' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA > 0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AGRUPACION_GENCAT...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_ACTIVOS_AGRUPACION_GENCAT';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AGRUPACION_GENCAT... borrada OK');
  END IF;

  SELECT COUNT(1) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_ACTIVOS_AGRUPACION_GENCAT' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA > 0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AGRUPACION_GENCAT...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_ACTIVOS_AGRUPACION_GENCAT';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AGRUPACION_GENCAT... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AGRUPACION_GENCAT...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AGRUPACION_GENCAT
      AS
        SELECT AGA.AGR_ID, COUNT (DISTINCT ACT.ACT_ID) AS CONTADOR
        FROM '|| V_ESQUEMA ||'.VI_ACTIVOS_AFECTOS_GENCAT ACT
        JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
        GROUP BY AGA.AGR_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AGRUPACION_GENCAT...Creada OK');
  
END;
/

EXIT;