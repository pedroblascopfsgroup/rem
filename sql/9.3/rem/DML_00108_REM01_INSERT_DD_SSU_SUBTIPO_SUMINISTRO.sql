--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20200617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10433
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SSU_SUBTIPO_SUMINISTRO los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SSU_SUBTIPO_SUMINISTRO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-10433';
    V_ID_TIPO_SEGMENTO NUMBER(16); --Vble para extraer el ID del registro a modificar, si procede.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('PRI', 'Privativo'),
        T_TIPO_DATA('COM', 'Zonas comunes')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores en DD_SSU_SUBTIPO_SUMINISTRO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SSU_SUBTIPO_SUMINISTRO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
    	
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        -- Comprobamos si existe la tabla   
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 
		
        	--Comprobamos el dato a insertar
          	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_SSU_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          	--Si existe modificamos los valores
          	IF V_NUM_TABLAS > 0 THEN
          
	            V_MSQL := 'SELECT DD_SSU_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_SSU_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
	            EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO_SEGMENTO;
	
	            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
				            'SET DD_SSU_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''''||
				            ', DD_SSU_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
				            ', DD_SSU_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
				            ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||
				            'WHERE DD_SSU_ID = '''||V_ID_TIPO_SEGMENTO||'''';
	            EXECUTE IMMEDIATE V_MSQL;
	            
			--Si no existe insertamos los registros
           	ELSE
        
	            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	            
	             V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          		EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
	            
	            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_SSU_ID, DD_SSU_CODIGO, DD_SSU_DESCRIPCION, DD_SSU_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
	            			VALUES ('||V_ID||','''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', 0, '''||V_INCIDENCIA||''', SYSDATE, 0)';
	            EXECUTE IMMEDIATE V_MSQL;
	            
	            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADO CORRECTAMENTE');
          
        	END IF;
        	
        ELSE
        
        	DBMS_OUTPUT.PUT_LINE('LA TABLA DD_SSU_SUBTIPO_SUMINISTRO NO EXISTE');
        	
        END IF;
	END LOOP;
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SSU_SUBTIPO_SUMINISTRO MODIFICADO CORRECTAMENTE ');

EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;

		DBMS_OUTPUT.PUT_LINE(V_MSQL);
  		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
  		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
  		DBMS_OUTPUT.PUT_LINE(ERR_MSG);

  		ROLLBACK;
        RAISE;          

END;
/
EXIT