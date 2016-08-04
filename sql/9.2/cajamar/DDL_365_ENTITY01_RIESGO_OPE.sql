--/*
--##########################################
--## AUTOR=Carlos Lopez
--## FECHA_CREACION=20160720
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=CMREC-2495
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
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN


  DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR TABLA DATA_RULE_ENGINE ');

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''CODIGO_PRODUCTO'' and table_name=''RIESGO_OPE_DATOS_GENER_CONVIV'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
    V_SQL := 'UPDATE  ' || V_ESQUEMA || '.RIESGO_OPE_DATOS_GENER_CONVIV SET CODIGO_PRODUCTO = NULL '; 
    EXECUTE IMMEDIATE V_SQL;	

  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.RIESGO_OPE_DATOS_GENER_CONVIV MODIFY CODIGO_PRODUCTO VARCHAR2(5 CHAR)'; 
	  EXECUTE IMMEDIATE V_SQL;	
	  DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO EL CAMPO RIESGO_OPE_DATOS_GENER_CONVIV.CODIGO_PRODUCTO');

  END IF;
 


  /*******************************************/
  DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZAR TABLA RIESGO_OPE_DATOS_GENER_CONVIV ');

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
