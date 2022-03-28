--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20211203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16557
--## PRODUCTO=NO
--##
--## Finalidad: INSERTAR Y ACTUALIZAR DD_UAC_UBICACION_ACTIVO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_UAC_UBICACION_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(250 CHAR) := 'HREOS-16557';
    V_NUM NUMBER(16); -- Vble. auxiliar
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('05','Turístico')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	
-- Verificar si la tabla ya existe
  	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  	IF V_NUM_TABLAS = 1 THEN
  	
  	
        DBMS_OUTPUT.PUT_LINE('Actualizar descripción de tareas de '||V_TEXT_TABLA);
        
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_UAC_CODIGO = ''01'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_UAC_DESCRIPCION = ''Zona de playa''
					, DD_UAC_DESCRIPCION_LARGA = ''Zona de playa''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE  DD_UAC_CODIGO = ''01''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);

    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_UAC_CODIGO = ''02'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_UAC_DESCRIPCION = ''Ciudad''
					, DD_UAC_DESCRIPCION_LARGA = ''Ciudad''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE  DD_UAC_CODIGO = ''02''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);

    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_UAC_CODIGO = ''03'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_UAC_DESCRIPCION = ''Pueblo''
					, DD_UAC_DESCRIPCION_LARGA = ''Pueblo''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE  DD_UAC_CODIGO = ''03''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);

    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_UAC_CODIGO = ''04'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_UAC_DESCRIPCION = ''Metropolitano''
					, DD_UAC_DESCRIPCION_LARGA = ''Metropolitano''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE  DD_UAC_CODIGO = ''04''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);

    	END IF;
    	
    	-- LOOP para insertar los valores --
	    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	      LOOP
	        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	        --Comprobar el dato a insertar.
	        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
						WHERE DD_UAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	        IF V_NUM_TABLAS = 1 THEN
	          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
	        ELSE 
	          -- Si no existe se inserta.
	          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');
	
	            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
	              DD_UAC_ID,
	              DD_UAC_CODIGO,
	              DD_UAC_DESCRIPCION,
	              DD_UAC_DESCRIPCION_LARGA,
	              USUARIOCREAR,
	              FECHACREAR
	              ) VALUES (
	               '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
	              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
	              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
	              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
	              '''||V_USUARIO||''',SYSDATE)';
	            EXECUTE IMMEDIATE V_MSQL;
	            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
	
	        END IF;
	      END LOOP;
    	
    	COMMIT;
    	
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO][FIN] NO EXISTE LA TABLA '||V_TEXT_TABLA);
	END IF;

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