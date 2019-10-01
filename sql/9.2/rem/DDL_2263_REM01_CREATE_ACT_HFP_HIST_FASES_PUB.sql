--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20190930
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7794
--## PRODUCTO=NO
--## Finalidad: Nueva tabla ACT_HFP_HIST_FASES_PUB
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(27 CHAR) := 'ACT_HFP_HIST_FASES_PUB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla en la que se registrará cada alteración de la Fase/subfase de publicación'; -- Vble. para los comentarios de las tablas	
    
 BEGIN 
	
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla 
    IF V_NUM_TABLAS = 1 THEN 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla existente');
  	
  	ELSE
  	
		DBMS_OUTPUT.PUT_LINE('[INICIO] ' || V_ESQUEMA || '.'||V_TABLA||'... Se va ha crear.');  		
		--Creamos la tabla
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
			 HFP_ID				NUMBER(16,0)
			, DD_FSP_ID			NUMBER(16,0) NOT NULL
			, DD_SFP_ID			NUMBER(16,0) NOT NULL
			, USU_ID			NUMBER(16,0) NOT NULL
			, HFP_FECHA_INI			TIMESTAMP(6) NOT NULL
			, HFP_FECHA_FIN			TIMESTAMP(6)
			, HFP_COMENTARIO			VARCHAR2(4000 CHAR)
			, VERSION NUMBER(1,0) DEFAULT 0 NOT NULL
			, USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL
			, FECHACREAR TIMESTAMP(6) NOT NULL
			, USUARIOMODIFICAR VARCHAR2(50 CHAR)
			, FECHAMODIFICAR TIMESTAMP(6)
			, USUARIOBORRAR VARCHAR2(50 CHAR)
			, FECHABORRAR TIMESTAMP(6)
			, BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL
			, CONSTRAINT PK_HFP_ID PRIMARY KEY(HFP_ID)
			, CONSTRAINT FK_HFP_DD_FSP_ID FOREIGN KEY (DD_FSP_ID) REFERENCES '|| V_ESQUEMA ||'.DD_FSP_FASE_PUBLICACION (DD_FSP_ID)
			, CONSTRAINT FK_HFP_DD_SFP_ID FOREIGN KEY (DD_SFP_ID) REFERENCES '|| V_ESQUEMA ||'.DD_SFP_SUBFASE_PUBLICACION (DD_SFP_ID)
			, CONSTRAINT FK_HFP_USU_ID FOREIGN KEY (USU_ID) REFERENCES '|| V_ESQUEMA_M ||'.USU_USUARIOS (USU_ID)
			)';

		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
		
		--Creamos comentario
		EXECUTE IMMEDIATE 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';
		
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.HFP_ID 		IS ''Identificador unico'' ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.DD_FSP_ID      	IS ''Fase en la que se encuentra la publicación. FK DD_FSP_FASE_PUBLICACION.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.DD_SFP_ID      	IS ''Subfase en la que se encuentra la publicación. FK DD_SFP_SUBFASE_PUBLICACION.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.USU_ID      		IS ''Usuario que realiza el cambio de fase. FK USU_USUARIOS.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.HFP_FECHA_INI     IS '' Fecha inicio de la fase.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.HFP_FECHA_FIN     IS ''Fecha fin de la fase.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.HFP_COMENTARIO    IS ''Campo comentario''  ';		
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.VERSION 			IS ''Indica la versión del registro.'''; 
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.USUARIOCREAR    	IS ''Indica el usuario que creo el registro.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.FECHACREAR      	IS ''Indica la fecha en la que se creo el registro.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.USUARIOMODIFICAR 	IS ''Indica el usuario que modificó el registro.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.FECHAMODIFICAR   	IS ''Indica la fecha en la que se modificó el registro.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.USUARIOBORRAR   	IS ''Indica el usuario que borró el registro.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.FECHABORRAR    	IS ''Indica la fecha en la que se borró el registro.''  ';
		EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.BORRADO        	IS ''Indicador de borrado.''  ';
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentarios creados.');		
		
		-- Creamos sequence
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
		EXECUTE IMMEDIATE V_SQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia creada');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');
  		
    END IF;    
	
COMMIT;
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso terminado.');
 
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
