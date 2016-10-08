--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161006
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para registrar los propietarios (PRO_CODIGO_UVEM) inexistentes en ACT_PRO_PROPIETARIO que vienen provistos en las interfaces. FASE 2
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para registrar los propietarios (PRO_CODIGO_UVEM) inexistentes en ACT_PRO_PROPIETARIO que vienen aprovisionadas en migración. FASE 2'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('******** MIG2_PRO_NOT_EXISTS ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG2_PRO_NOT_EXISTS... Comprobaciones previas');
	

	
	-- Verificar si la tabla nueva ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG2_PRO_NOT_EXISTS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
  
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG2_PRO_NOT_EXISTS... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.MIG2_PRO_NOT_EXISTS CASCADE CONSTRAINTS';
		
	END IF;
	
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.MIG2_PRO_NOT_EXISTS...');
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG2_PRO_NOT_EXISTS
	(
		TABLA_MIG 			VARCHAR2(30 CHAR),
		PRO_CODIGO_UVEM		NUMBER(16,0),
		FECHA_COMPROBACION 	DATE
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG2_PRO_NOT_EXISTS... Tabla creada.');
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.MIG2_PRO_NOT_EXISTS IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.MIG2_PRO_NOT_EXISTS... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.MIG2_PRO_NOT_EXISTS... OK');


	COMMIT;


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

EXIT
