--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17073
--## PRODUCTO=NO
--## Finalidad: Borrar Constraint y Cambiar nombre a columna en GLD_GASTOS_LINEA_DETALLE
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'GLD_GASTOS_LINEA_DETALLE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    
    
    /* -- ARRAY PARA BORRAR FK */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(			
        -- 		 NOMBRE FK                  NOMBRE ANTERIOR     NOMBRE NUEVO      COMENTARIO		
        T_ALTER('GLD_ENT_DD_PRO_ID_FK',     'PROMOCION',        'DD_PRO_ID'  ,    'Promoción')
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

                --Borramos columna
				DBMS_OUTPUT.PUT_LINE('[INFO] Borramos '||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(2)||'] para crear '||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(3)||']-------------------------------------------');
				
                V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP COLUMN '||V_T_ALTER(2)||'';
                
                EXECUTE IMMEDIATE V_MSQL;

                --Añadimos el campo
                V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA|| ' 
					   ADD '||V_T_ALTER(3)||' NUMBER(16,0)';

                EXECUTE IMMEDIATE V_MSQL;
                
                DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(3)||' añadido con tipo NUMBER(16,0) ');

                --Creamos FK
                 V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_T_ALTER(1)||' FOREIGN KEY ('||V_T_ALTER(3)||') REFERENCES '||V_ESQUEMA||'.DD_PRO_PROMOCIONES ('||V_T_ALTER(3)||'))';
	            
                EXECUTE IMMEDIATE V_MSQL;
	            
                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_T_ALTER(1)||'... Foreign key creada.');

                -- Creamos comentario	
				V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(3)||' IS '''||V_T_ALTER(4)||'''';		
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE('[2] '||V_MSQL);
				DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario en columna creado.');
            
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
