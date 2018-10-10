--/*
--##########################################
--## AUTOR=Maria Presencia
--## FECHA_CREACION=20181009
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4583
--## PRODUCTO=NO
--## Finalidad: DDL Creación de tabla REP_REVISION_POSESION
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

  V_TABLA VARCHAR2(2400 CHAR) := 'REP_REVISION_POSESION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
  V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla con los activos con el indicador de posesión'; -- Vble. para los comentarios de las tablas

  
BEGIN
    

	
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla la borramos
    IF V_NUM_TABLAS = 1 THEN 
	-- Borramos la tabla
    	 V_SQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla eliminada');  		
    END IF;

    DBMS_OUTPUT.PUT_LINE('[INICIO] ' || V_ESQUEMA || '.'||V_TABLA||'... Se va ha crear.');  		
	--Creamos la tabla
	V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
			 ACT_ID NUMBER(16,0) NOT NULL
			, REP_POSESION NUMBER(1,0) DEFAULT 0 NOT NULL
			, REP_OCUPADO NUMBER(1,0) DEFAULT 0 NOT NULL
			, REP_CON_TITULO NUMBER(1,0) DEFAULT 0 NOT NULL
			, VERSION NUMBER(3) DEFAULT 0 NOT NULL
			, USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL
			, FECHACREAR TIMESTAMP(6) NOT NULL
			, USUARIOMODIFICAR VARCHAR2(50 CHAR)
			, FECHAMODIFICAR TIMESTAMP(6)
			, USUARIOBORRAR VARCHAR2(50 CHAR)
			, FECHABORRAR TIMESTAMP(6)
			, BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL
			)
		  ';

	EXECUTE IMMEDIATE V_SQL;
	
	
	-- Creamos foreign key ACT_ID
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_REVPOS_ACTIVO FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_REVPOS_ACTIVO... Foreign key creada.');
	
	-- Añadimos los comentarios a las columnas
	V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario TABLA creado.');
		

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

EXIT;
