--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20151015
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=BKREC-943 rollback
--## PRODUCTO=SI
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    CUENTA NUMBER(10);  -- Vble. auxiliar para ver si existe el indice a borrar.
BEGIN	

  -- BORRADO DE INDICES
  DBMS_OUTPUT.PUT_LINE('INICIO DROP INDEX '|| V_ESQUEMA ||'.EXP_EXPEDIENTES_INDEX6...');
  SELECT COUNT(*) INTO CUENTA FROM ALL_INDEXES WHERE INDEX_NAME = 'EXP_EXPEDIENTES_INDEX6' AND TABLE_OWNER=V_ESQUEMA AND TABLE_NAME='EXP_EXPEDIENTES';    
  IF CUENTA>0 THEN
	  EXECUTE IMMEDIATE 'DROP INDEX '|| V_ESQUEMA ||'.EXP_EXPEDIENTES_INDEX6';  
  DBMS_OUTPUT.PUT_LINE('DROP INDEX '|| V_ESQUEMA ||'.EXP_EXPEDIENTES_INDEX6...Borrado');
  END IF;
	
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