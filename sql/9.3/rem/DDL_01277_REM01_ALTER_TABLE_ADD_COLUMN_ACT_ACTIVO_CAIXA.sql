--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220310
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17156
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: Agregar nueva columna a la tabla ACT_ACTIVO_CAIXA
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-17156'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO_CAIXA'; 		-- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('DD_CBC_ID', 'NUMBER(16,0)','', 'Segmentación cartera', 'FK_ACT_CAIXA_DD_CBC_ID',	V_ESQUEMA||'.DD_CBC_CARTERA_BC', 'DD_CBC_ID')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP_TIPO_DATA(1)||''' 
														 and TABLE_NAME = '''||V_TABLA||''' 
														 and OWNER = '''||V_ESQUEMA||'''';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
		
			V_MSQL := 'ALTER TABLE '||V_TABLA|| ' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' '||V_TMP_TIPO_DATA(3)||')';		   
			EXECUTE IMMEDIATE V_MSQL;

            -- Añadimos LA CLAVE AJENA si tiene
	            IF V_TMP_TIPO_DATA(5) != 'NO' THEN
					DBMS_OUTPUT.PUT_LINE('  [INFO] Inicio creación FK del campo '||V_TMP_TIPO_DATA(1)||''); 
	                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT '||V_TMP_TIPO_DATA(5)||' FOREIGN KEY ('||V_TMP_TIPO_DATA(1)||')
		  								REFERENCES '||V_TMP_TIPO_DATA(6)||' ('||V_TMP_TIPO_DATA(7)||') ON DELETE SET NULL ENABLE';
					DBMS_OUTPUT.PUT_LINE('  [INFO] FK del campo '||V_TMP_TIPO_DATA(1)||' creada'); 
	  			END IF;

            V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(4)||'''';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AGREGADA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2));
		
		ELSE 

            V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_TMP_TIPO_DATA(5)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
                IF  V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Inicio creación FK del campo '||V_TMP_TIPO_DATA(1)||''); 
	                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT '||V_TMP_TIPO_DATA(5)||' FOREIGN KEY ('||V_TMP_TIPO_DATA(1)||')
		  								REFERENCES '||V_TMP_TIPO_DATA(6)||' ('||V_TMP_TIPO_DATA(7)||') ON DELETE SET NULL ENABLE';
                ELSE 
			        DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' YA EXISTE');
                END IF;

		END IF;
		
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA ACT_ACTIVO_CAIXA');
	
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
