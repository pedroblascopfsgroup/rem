--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20151102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar los activos.
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar los activos.'; -- Vble. para los comentarios de las tablas

BEGIN


	--##COMPROBACION EXISTENCIA TABLA y secuencia BORRAR PRIMERO
	select count(1) INTO V_NUM_TABLAS from all_tables 
	where table_name = 'ACT_ACTIVO' and OWNER = V_ESQUEMA;
	
	if V_NUM_TABLAS > 0 then 
	DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la tabla ACT_ACTIVO: se ELIMINA...');
	EXECUTE IMMEDIATE 'drop table '||V_ESQUEMA||'.ACT_ACTIVO cascade constraint';
	DBMS_OUTPUT.PUT_LINE('OK');
	END IF;

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_ACT_ACTIVO'' and sequence_owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN			
		V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_ACT_ACTIVO';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ACT_ACTIVO... Secuencia eliminada');    
	END IF; 
	
	-- Comprobamos si existe la secuencia para el numero de activo
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_ACT_NUM_ACTIVO_REM'' and sequence_owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN			
		V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_ACT_NUM_ACTIVO_REM';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ACT_NUM_ACTIVO_REM... Secuencia eliminada');    
	END IF; 

	--##CREACION DE TABLA, secuencia PK y FK de tabla

	
	--Creamos la secuencia
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ACT_ACTIVO...');
	V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_ACT_ACTIVO';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ACT_ACTIVO... Secuencia creada');

	--Creamos la secuencia para ACT_NUM_ACTIVO_REM
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ACT_NUM_ACTIVO_REM...');
	V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_ACT_NUM_ACTIVO_REM';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ACT_NUM_ACTIVO_REM... Secuencia creada');
	
	
	
	
	-- Creamos la tabla
  	DBMS_OUTPUT.PUT('[INFO] Tabla ACT_ACTIVO: CREADA...');	     	 
	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.ACT_ACTIVO
   (	
	ACT_ID 						NUMBER(16,0)                NOT NULL,
	ACT_NUM_ACTIVO	     		NUMBER(16,0)                NOT NULL,     
	ACT_NUM_ACTIVO_REM     		NUMBER(16,0)                NOT NULL, 
	ACT_NUM_ACTIVO_UVEM			NUMBER(16,0),
	ACT_NUM_ACTIVO_SAREB		VARCHAR(55 CHAR),
	ACT_NUM_ACTIVO_PRINEX		NUMBER(16,0),		
	ACT_RECOVERY_ID				NUMBER(16,0),
	BIE_ID 						NUMBER(16,0),
	ACT_DESCRIPCION				VARCHAR2(250 CHAR),
	DD_RTG_ID 					NUMBER(16,0),
	DD_TPA_ID					NUMBER(16,0),
	DD_SAC_ID					NUMBER(16,0),
	DD_EAC_ID					NUMBER(16,0),
	DD_TUD_ID					NUMBER(16,0),
	DD_TTA_ID					NUMBER(16,0),
	DD_STA_ID					NUMBER(16,0),
	DD_CRA_ID					NUMBER(16,0),
	DD_ENO_ID					NUMBER(16,0),
	DD_ENO_ORIGEN_ANT_ID		NUMBER(16,0),
	DD_SCM_ID					NUMBER(16,0),
	ACT_DIVISION_HORIZONTAL		NUMBER(1,0),
	ACT_FECHA_REV_CARGAS		DATE,
	ACT_CON_CARGAS				NUMBER(1),
	ACT_GESTION_HRE  			NUMBER(1,0),
	ACT_VPO						NUMBER(1,0),
	ACT_LLAVES_NECESARIAS		NUMBER(1,0),
	ACT_LLAVES_HRE				NUMBER(1,0),
	ACT_LLAVES_FECHA_RECEP		DATE,
	ACT_LLAVES_NUM_JUEGOS		NUMBER(8,0),
	ACT_ADMISION				NUMBER(1,0),
	ACT_GESTION					NUMBER(1,0),
	ACT_SELLO_CALIDAD			NUMBER(1,0),
	--DD_EPA_ADMISION_ID		NUMBER(16,0),
	--DD_EPA_GESTION_ID			NUMBER(16,0),
	--DD_EPA_PRECIO_ID			NUMBER(16,0),
	--DD_EPA_PUBLICACION_ID		NUMBER(16,0),
	--DD_EPA_COMERCIALIZAR_ID	NUMBER(16,0),
	SDV_ID						NUMBER(16,0),
	CPR_ID						NUMBER(16,0),
	VERSION 					NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
	USUARIOCREAR 				VARCHAR2(10 CHAR) 			NOT NULL ENABLE, 
	FECHACREAR 					TIMESTAMP (6) 				NOT NULL ENABLE, 
	USUARIOMODIFICAR 			VARCHAR2(10 CHAR), 
	FECHAMODIFICAR 				TIMESTAMP (6), 
	USUARIOBORRAR 				VARCHAR2(10 CHAR), 
	FECHABORRAR 				TIMESTAMP (6), 
	BORRADO 					NUMBER(1,0) 				DEFAULT 0
   )';
  DBMS_OUTPUT.PUT_LINE('OK');

-- Creamos indice	
V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.ACT_ACTIVO_PK ON '||V_ESQUEMA|| '.ACT_ACTIVO(ACT_ID) TABLESPACE '||V_TABLESPACE_IDX;	
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACT_ACTIVO_PK... Indice creado.');


-- Creamos primary key
V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_ACTIVO ADD (CONSTRAINT ACT_ACTIVO_PK PRIMARY KEY (ACT_ID) USING INDEX)';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACT_ACTIVO_PK... PK creada.');
	 
DBMS_OUTPUT.PUT_LINE('OK');


-- Creamos comentario	
V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.ACT_ACTIVO IS '''||V_COMMENT_TABLE||'''';		
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACT_ACTIVO... Comentario creado.');
  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Tabla y referencias creadas.');
	
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