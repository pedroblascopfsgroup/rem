--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20220914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18718
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla nueva de configuración
--## INSTRUCCIONES:
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
    
    V_TABLA VARCHAR2(27 CHAR) := 'HFA_HIST_FIRMA_ADENDA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla utilizada para la configuración de cálculo de portal'; -- Vble. para los comentarios de las tablas	
    
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
			HFA_ID							NUMBER(16,0),
			OFR_ID						NUMBER(16,0) NOT NULL ENABLE,
			HFA_FIRMADO					NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
			HFA_FECHA					DATE,
			HFA_MOTIVO 					VARCHAR2(200 CHAR),
			VERSION 					NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR					VARCHAR2(50 CHAR)	NOT NULL ENABLE, 
			FECHACREAR					TIMESTAMP (6)		NOT NULL ENABLE, 
			USUARIOMODIFICAR				VARCHAR2(50 CHAR), 
			FECHAMODIFICAR					TIMESTAMP (6), 
			USUARIOBORRAR					VARCHAR2(50 CHAR), 
			FECHABORRAR					TIMESTAMP (6), 
			BORRADO					NUMBER(1,0)			DEFAULT 0 NOT NULL ENABLE,

			CONSTRAINT PK_HFA_ID PRIMARY KEY (HFA_ID),
			CONSTRAINT FK_HFA_OFR_ID FOREIGN KEY (OFR_ID) REFERENCES OFR_OFERTAS(OFR_ID)
			)';
		--DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
		--Creamos la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
		IF V_COUNT = 0 THEN
			V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);
		END IF;
		--Creamos comentario
		V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');		
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
