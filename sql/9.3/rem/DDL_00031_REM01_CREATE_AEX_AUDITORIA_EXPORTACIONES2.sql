--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20191122
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5696
--## PRODUCTO=NO
--## Finalidad: DDL
--##      
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##
--##        0.1 Versión inicial
--##		0.2 - Guillem Rey - Crear secuencia y tabla
--##		1.0 - GUILLEM REY - DROPEAR SI EXISTE.
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
 
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_SELECT VARCHAR2(4000 CHAR); -- SENTENCIA DE SELECT PARA CONSULTAR EXISTENCIA (ANTERIORMENTE V_SQL)
	V_SENTENCIA VARCHAR2(32000 CHAR); -- SENTENCIA A EJECUTAR (ANTERIORMENTE V_MSQL)
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- CONFIGURACIÓN ESQUEMA
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- CONFIGURACIÓN ESQUEMA
	V_TABLA VARCHAR2(30 CHAR):= 'AEX_AUDITORIA_EXPORTACIONES'; -- DECLARA LA TABLA
	V_NUM NUMBER(16); -- ALOJA EL RETORNO DE LA SENTENCIA SELECT

BEGIN
	V_SELECT := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	 
	EXECUTE IMMEDIATE V_SELECT INTO V_NUM; 
 
	IF V_NUM > 0 THEN		
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la secuencia S_'||V_TABLA);	
		
		V_SELECT := 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
		EXECUTE IMMEDIATE V_SELECT;			
		DBMS_OUTPUT.PUT_LINE('[INFO] Eliminada la SECUENCIA S_'||V_TABLA);
	END IF;
	
	V_SELECT := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
	EXECUTE IMMEDIATE V_SELECT;			
	DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);  
	

	V_SELECT:= 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	 
	EXECUTE IMMEDIATE V_SELECT INTO V_NUM;
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificando la existencia de la tabla....');
	 
	IF V_NUM > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' ya existente en '||V_ESQUEMA||'.');
		
		V_SELECT := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';		
		EXECUTE IMMEDIATE V_SELECT;			
		DBMS_OUTPUT.PUT_LINE('[INFO] Eliminada la TABLA '||V_TABLA);
		
	END IF;
	DBMS_OUTPUT.PUT_LINE('[INFO] Creando la tabla '||V_TABLA||' en '||V_ESQUEMA||'.');
	
	V_SENTENCIA:= 	'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
					AEX_ID 					NUMBER(16,0) NOT NULL,
					USU_ID 					NUMBER(16,0) NOT NULL,
					AEX_FECHA_EXPORTACION 	TIMESTAMP(6) NOT NULL,
					AEX_BUSCADOR 			VARCHAR2(50 char),
					AEX_NUM_REGISTROS 		NUMBER(16,0),
					AEX_ACCION 				NUMBER(1.0),
					AEX_FILTROS 			VARCHAR2(1024 CHAR),
					VERSION 				NUMBER(38) NOT NULL,
					USUARIOCREAR 			VARCHAR2(50 CHAR) NOT NULL,
                    FECHACREAR 				TIMESTAMP(6) NOT NULL,
                    USUARIOMODIFICAR 		VARCHAR2(50 CHAR),
                    FECHAMODIFICAR 			TIMESTAMP(6),
                    USUARIOBORRAR 			VARCHAR2(50 CHAR),
                    FECHABORRAR 			TIMESTAMP(6),
                    BORRADO 				NUMBER(1,0) DEFAULT 0 NOT NULL,
                    CONSTRAINT PK_AEX_ID2 PRIMARY KEY (AEX_ID),
                    CONSTRAINT FK_USU_USUARIOS2 FOREIGN KEY (USU_ID) REFERENCES '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID)
					)';
	EXECUTE IMMEDIATE V_SENTENCIA;

	DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA||' en '||V_ESQUEMA||'.');
	DBMS_OUTPUT.PUT_LINE('[INFO] Se procede con la creación de los comentarios');
	
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.AEX_ID        				is ''Identificador registro''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.USU_ID        				is ''Usuario que exporta''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.AEX_FECHA_EXPORTACION       is '' Fecha/hora en la que se exporta''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.AEX_BUSCADOR        		is ''Buscador donde se exporta (activos, agrupaciones, trabajos, avisos, gastos, proveedores, tareas, alertas, publicaciones, ofertas)''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.AEX_NUM_REGISTROS        	is ''Número de registros que se exporta''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.AEX_ACCION        			is ''Acción que realiza el usuario (1->Exportar / 0->Cancelar)''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.AEX_FILTROS        			is ''Filtros usados en la exportación''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.VERSION    					IS ''Versión del documento.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.USUARIOCREAR   				IS ''Indica el usuario que creo el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.FECHACREAR   				IS ''Indica la fecha en la que se creo el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.USUARIOMODIFICAR 			IS ''Indica el usuario que modificó el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.FECHAMODIFICAR   			IS ''Indica la fecha en la que se modificó el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.USUARIOBORRAR   			IS ''Indica el usuario que borró el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.FECHABORRAR    				IS ''Indica la fecha en la que se borró el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.AEX_AUDITORIA_EXPORTACIONES.BORRADO        				IS ''Indicador de borrado.''  ';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' creada en '||V_ESQUEMA||'.');

	 
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');


	EXCEPTION
	
     WHEN OTHERS THEN
     
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(SQLERRM);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;