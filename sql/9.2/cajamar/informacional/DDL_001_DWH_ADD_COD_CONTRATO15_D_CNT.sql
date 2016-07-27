--/*
--##########################################
--## AUTOR=María V.
--## FECHA_CREACION=20160623
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=RECOVERY-2286
--## PRODUCTO=NO
--## 
--## Finalidad: Se añade contrato_desc para poner representación de 14 dígitos en reports contrato
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema ESQUEMA_DWH
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN 

 DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIR CAMPO CONTRATO_COD_CONTRATO_15 A D_CNT ');

 -------------- D_CNT ---------------------------------------------

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''CONTRATO_COD_CONTRATO_15'' and table_name=''D_CNT'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla D_CNT ya tiene el campo CONTRATO_COD_CONTRATO_15.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.D_CNT ADD CONTRATO_COD_CONTRATO_15 VARCHAR2(50 CHAR)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO CONTRATO_COD_CONTRATO_15 A D_CNT');

 


  DBMS_OUTPUT.PUT_LINE('[FIN] AÑADIR CAMPO PUNTUACION A D_CNT ');

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
EXIT 