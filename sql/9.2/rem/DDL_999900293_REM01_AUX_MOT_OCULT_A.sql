--/*
--##########################################
--## AUTOR=JIN LI, HU
--## FECHA_CREACION=20181004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4525
--## PRODUCTO=NO
--## Finalidad: DDL Creación de tabla AUX_MOT_OCULT_A
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_MOT_OCULT_A'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
  
BEGIN
    
    -----------------------
    ---     TABLA       ---
    -----------------------
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME ='''||V_TEXT_TABLA||''' AND OWNER='''||V_ESQUEMA||''''
    INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
		V_SQL:= ' CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ( 
		  OCULTO					  	NUMBER,
		  DD_MTO_CODIGO				  	VARCHAR2(20 CHAR),
		  ACT_ID			  			NUMBER(16,0)
		  )';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('['||V_TEXT_TABLA||' CREADA]');
		
    END IF;
      
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
