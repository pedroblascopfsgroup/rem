--/*
--##########################################
--## AUTOR=Juan Beltrán	
--## FECHA_CREACION=20200921
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8069
--## PRODUCTO=NO
--## Finalidad: MODIFICACION DE COLUMNAS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_SQL_2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8069'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'OFR_OFERTAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('OFR_RECOMENDACION_RC',       'NUMBER (16,0)',  'ID recomendación RC.'),
        T_TIPO_DATA('OFR_FECHA_RECOMENDACION_RC', 'DATE', 			'Fecha de recomendación RC.'),
        T_TIPO_DATA('OFR_RECOMENDACION_DC',       'NUMBER (16,0)',  'ID recomendación DC.'),
        T_TIPO_DATA('OFR_FECHA_RECOMENDACION_DC', 'DATE', 			'Fecha de recomendación DC.')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;


     /* TABLA: ACT_REG_INFO_REGISTRAL -- ARRAY CON NUEVAS FOREIGN KEYS */
    TYPE T_FK IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
        	  --NOMBRE FK                		 CAMPO FK         TABLA DESTINO FK 		  CAMPO DESTINO FK
      T_FK( 'FK_OFR_RECOMENDACION_RC',   'OFR_RECOMENDACION_RC',  'DD_RCM_RECOMENDACION',  'DD_RCM_ID'      ),
      T_FK( 'FK_OFR_RECOMENDACION_DC',   'OFR_RECOMENDACION_DC',  'DD_RCM_RECOMENDACION',  'DD_RCM_ID'      )
    );
    V_T_FK T_FK;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION OFR_OFERTAS');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP_TIPO_DATA(1)||'''
                            -- AND DATA_TYPE = '''||V_TMP_TIPO_DATA(2)||'''
							 AND TABLE_NAME = '''||V_TEXT_TABLA||''' 
							 AND OWNER = '''||V_ESQUEMA||'''';
		
		    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
        -- si existe la columna se borra y se crea correctamente
        IF V_NUM_TABLAS > 0 THEN
		
		  DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' YA EXISTE');
          -- se borra la columna
          EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP COLUMN '||V_TMP_TIPO_DATA(1)||'');
          DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA '||V_TMP_TIPO_DATA(1)||'  BORRADA');

          -- creamos la columna  
          V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';					   
		  EXECUTE IMMEDIATE V_MSQL;

		  V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';
		  EXECUTE IMMEDIATE V_MSQL;

		  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2));
				
        ELSE
		
          V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';             
          EXECUTE IMMEDIATE V_MSQL;

          V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2));
      		
		END IF;
		
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA OFR_OFERTAS');
	

	-- Solo si esta activo el indicador de creacion FK, el script creara tambien las FK
  IF V_CREAR_FK = 'SI' THEN

    -- Bucle que CREA las FK de las nuevas columnas
    FOR I IN V_FK.FIRST .. V_FK.LAST
    LOOP

      V_T_FK := V_FK(I);  

      -- Verificar si la FK ya existe. Si ya existe la FK, no se hace nada.
      V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = '''||V_T_FK(1)||'''';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
      IF V_NUM_TABLAS = 0 THEN
        --No existe la FK y la creamos
        DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_FK(1)||'] -------------------------------------------');
        V_MSQL := '
          ALTER TABLE '||V_TEXT_TABLA||'
          ADD CONSTRAINT '||V_T_FK(1)||' FOREIGN KEY
          (
            '||V_T_FK(2)||'
          )
          REFERENCES '||V_T_FK(3)||'
          (
            '||V_T_FK(4)||' 
          )
          ON DELETE SET NULL ENABLE
        ';

        EXECUTE IMMEDIATE V_MSQL;
        --DBMS_OUTPUT.PUT_LINE('[3] '||V_MSQL);
        DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_FK(1)||' creada en tabla: FK en columna '||V_T_FK(2)||' hacia '||V_T_FK(3)||'.'||V_T_FK(4)||'... OK');
      ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] ... FK '||V_T_FK(1)||' YA EXISTE ... NO SE HACE NADA.');
      END IF;

    END LOOP;

  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' AMPLIADA CON COLUMNAS NUEVAS Y FKs ... OK *************************************************');

	
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