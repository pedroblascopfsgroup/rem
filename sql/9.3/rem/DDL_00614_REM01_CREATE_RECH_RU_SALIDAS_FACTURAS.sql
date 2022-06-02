--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220422
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17495
--## PRODUCTO=NO
--## Finalidad: Creación tablas: RECH_RU_SALIDAS_FACTURAS y AUX_RECH_RU_SALIDAS_FACTURAS
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
	TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLA IS TABLE OF T_TABLA;
	
    M_TABLA T_ARRAY_TABLA := T_ARRAY_TABLA(	
		T_TABLA('RECH_RU_SALIDAS_FACTURAS'),
		T_TABLA('AUX_RECH_RU_SALIDAS_FACTURAS')
    ); 
    V_TMP_TABLA T_TABLA;

BEGIN

	FOR I IN M_TABLA.FIRST .. M_TABLA.LAST
    LOOP
	V_TMP_TABLA := M_TABLA(I);

			DBMS_OUTPUT.PUT_LINE('********' ||V_TMP_TABLA(1)|| '********'); 
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TMP_TABLA(1)||'... Comprobaciones previas');

	
			-- Verificar si la tabla ya existe
			V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TMP_TABLA(1)||''' and owner = '''||V_ESQUEMA||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TMP_TABLA(1)||'... Ya existe. Se borrará.');
				EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TMP_TABLA(1)||' CASCADE CONSTRAINTS';
				
			END IF;

			-- Comprobamos si existe la secuencia
			V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TMP_TABLA(1)||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TMP_TABLA(1)||'... Ya existe. Se borrará.');  
				EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TMP_TABLA(1)||'';
				
			END IF; 
			
			
			-- Creamos la tabla
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TMP_TABLA(1)||'...');
			V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TMP_TABLA(1)||'
			(
				RU_ID           			NUMBER(16,0)                  NOT NULL,
				GPV_ID						NUMBER(16,0)                  NOT NULL,
				GPV_NUM_GASTO_HAYA			NUMBER(16,0)                  NOT NULL,
				DD_EGA_ID        			NUMBER(16,0)           		  NOT NULL,
				DD_EAP_ID        			NUMBER(16,0)           		  NOT NULL,
				GGE_FECHA_EAP				DATE          		 		  NOT NULL,
				ACT_ID						NUMBER(16,0),
				GLD_ID						NUMBER(16,0),
				DD_LES_ID					NUMBER(16,0)           		  NOT NULL,
				FECHA_PROCESADO				DATE           				  NOT NULL,
				GGE_CLIENTE_PAGADOR			NUMBER(16,0),
				TABLA						VARCHAR2(40 CHAR)			  NOT NULL,
				VERSION 					NUMBER(38,0) 		    	  DEFAULT 0 NOT NULL ENABLE, 
				USUARIOCREAR 				VARCHAR2(50 CHAR) 	    	  NOT NULL ENABLE, 
				FECHACREAR 					TIMESTAMP (6) 		    	  NOT NULL ENABLE, 
				USUARIOMODIFICAR 			VARCHAR2(50 CHAR), 
				FECHAMODIFICAR 				TIMESTAMP (6), 
				USUARIOBORRAR 				VARCHAR2(50 CHAR), 
				FECHABORRAR 				TIMESTAMP (6), 
				BORRADO 					NUMBER(1,0) 		    	  DEFAULT 0 NOT NULL ENABLE
			)
			';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TMP_TABLA(1)||'... Tabla creada.');
			

			-- Creamos indice	
			V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TMP_TABLA(1)||'_PK ON '||V_ESQUEMA|| '.'||V_TMP_TABLA(1)||'(RU_ID) TABLESPACE '||V_TABLESPACE_IDX;		
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TMP_TABLA(1)||'_PK... Indice creado.');
			
			
			-- Creamos primary key
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_TABLA(1)||' ADD (CONSTRAINT '||V_TMP_TABLA(1)||'_PK PRIMARY KEY (RU_ID) USING INDEX)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TMP_TABLA(1)||'_PK... PK creada.');


			-- Creamos sequence
			V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TMP_TABLA(1)||'';		
			EXECUTE IMMEDIATE V_MSQL;		
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TMP_TABLA(1)||'... Secuencia creada');

	END LOOP;
	
	
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
