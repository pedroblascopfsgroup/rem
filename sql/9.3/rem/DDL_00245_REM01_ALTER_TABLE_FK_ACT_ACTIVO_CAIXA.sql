--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14495
--## PRODUCTO=NO
--## Finalidad: Añadir constraint a la tabla ACT_ACTIVO_CAIXA
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO_CAIXA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    
    
    /* -- ARRAY PARA BORRAR FK */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(			
        -- 		    NOMBRE FK               NOMBRE COLUMNA
        T_ALTER('FK_DD_ECA_ID',            'DD_ECA_ID')
	);
	V_T_ALTER T_ALTER;

    
BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *********');

	
	
	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);

		-- Verificar si la columna ya existe.
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(2)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_MSQL||'');
        	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||'');
		IF V_NUM_TABLAS = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(2)||'... No existe.');
		ELSE
			V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEXT_TABLA||''' AND CONSTRAINT_NAME = '''||V_T_ALTER(1)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_MSQL||'');
        	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||'');
			IF V_NUM_TABLAS = 0 THEN
				--Si la FK NO existe, la creamos
				DBMS_OUTPUT.PUT_LINE('[INFO] No existe Fk, la creamos '||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] -------------------------------------------');
                V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_DD_ECA_ID FOREIGN KEY (DD_ECA_ID) REFERENCES '||V_ESQUEMA||'.DD_ECA_EST_COM_ALQUILER (DD_ECA_ID))';
	            EXECUTE IMMEDIATE V_MSQL;
	            DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_ECA_ID... Foreign key creada.');

            ELSE
               
                DBMS_OUTPUT.PUT_LINE('[La FK ya existe]');
                
			END IF;
		END IF;
	END LOOP;
	
	
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
