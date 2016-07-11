--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20160609
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


  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ACTIVO_NOTIFICACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVO_NOTIFICACION...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_ACTIVO_NOTIFICACION';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVO_NOTIFICACION... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVO_NOTIFICACION...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_ACTIVO_NOTIFICACION 
	AS
		SELECT ACT.ACT_ID, ACT.ACT_NUM_ACTIVO, TO_NUMBER(DECODE(MEI.IRG_VALOR,''null'',null,MEI.IRG_VALOR)) AS IDTAREA
		FROM '|| V_ESQUEMA ||'.MEJ_IRG_INFO_REGISTRO MEI
		JOIN '|| V_ESQUEMA ||'.MEJ_REG_REGISTRO MEJ ON MEJ.REG_ID = MEI.REG_ID
		JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT_ID = MEJ.TRG_EIN_ID
		WHERE IRG_CLAVE IN (''ID_TAREA'', ''ID_NOTIF'', ''ID_TAREA_ORIGINAL'', ''ID_TAREA_RESP'')';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVO_NOTIFICACION...Creada OK');
  
END;
/

EXIT;
