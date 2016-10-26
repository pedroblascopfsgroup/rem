--/*
--##########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161025
--## ARTEFACTO=migracion
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-962
--## PRODUCTO=NO
--## Finalidad: Tabla auxiliar utilizada para generar los tramites de las ofertas.
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

    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar utilizada para generar los tramites de las ofertas.'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('******** MIG2_TRA_TRAMITES_OFERTAS ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS... Comprobaciones previas');
	
	-- Verificar si la tabla nueva ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG2_TRA_TRAMITES_OFERTAS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
  
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG2_TRA_TRAMITES_OFERTAS... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS CASCADE CONSTRAINTS';
		
	END IF;
	
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.MIG2_TRA_TRAMITES_OFERTAS...');
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS
	(
		OFR_ID					NUMBER(16),
		ACT_ID					NUMBER(16),
		TBJ_ID					NUMBER(16),
		TBJ_NUM_TRABAJO			NUMBER(16),
		TPO_ID					NUMBER(16),
		TAP_ID					NUMBER(16),
		TRA_ID					NUMBER(16),
		TAR_ID					NUMBER(16),
		TEX_ID					NUMBER(16),
		USU_ID					NUMBER(16),
		SUP_ID					NUMBER(16)
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS... Tabla creada.');
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS... OK');

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
