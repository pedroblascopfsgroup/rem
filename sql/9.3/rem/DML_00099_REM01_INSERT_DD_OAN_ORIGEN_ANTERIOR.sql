--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200915
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6339
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_OAN_ORIGEN_ANTERIOR los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##	    0.2 REMVIP-8073 - Añadidos mas valores al diccionario
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_OAN_ORIGEN_ANTERIOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'REMVIP-6339';
    V_ID_TIPO_SEGMENTO NUMBER(16); --Vble para extraer el ID del registro a modificar, si procede.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01', 'Aportación'),
        T_TIPO_DATA('02', 'Contencioso'),
        T_TIPO_DATA('03', 'Compraventa'),
        T_TIPO_DATA('04', 'Dación en pago'),
        T_TIPO_DATA('05', 'Cartera histórica'),
        T_TIPO_DATA('06', 'Cesión de remate'),
        T_TIPO_DATA('07', 'Permuta materializada'),
        T_TIPO_DATA('08', 'Leasing'),
        T_TIPO_DATA('09', 'Resto contenciosos'),
        T_TIPO_DATA('10', 'Por Proc. Recuperat.'),
	T_TIPO_DATA('11', 'Especial'),
	T_TIPO_DATA('12', 'Por Proc. Judicial'),
	T_TIPO_DATA('13', 'Otros'),
	T_TIPO_DATA('14', 'Desarrollo propio'),
	T_TIPO_DATA('15', 'Permuta sin materializar'),
	T_TIPO_DATA('16', 'Subastas'),
	T_TIPO_DATA('17', 'Renting'),
	T_TIPO_DATA('18', 'Compra 100% participada')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores en DD_OAN_ORIGEN_ANTERIOR -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_OAN_ORIGEN_ANTERIOR ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
    	
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        -- Comprobamos si existe la tabla   
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 
		
        	--Comprobamos el dato a insertar
          	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_OAN_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          	--Si existe modificamos los valores
          	IF V_NUM_TABLAS > 0 THEN
          
	            V_MSQL := 'SELECT DD_OAN_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_OAN_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
	            EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO_SEGMENTO;
	
	            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
				            'SET DD_OAN_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''''||
				            ', DD_OAN_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
				            ', DD_OAN_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
				            ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||
				            'WHERE DD_OAN_ID = '''||V_ID_TIPO_SEGMENTO||'''';
	            EXECUTE IMMEDIATE V_MSQL;
	            
			--Si no existe insertamos los registros
           	ELSE
        
	            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	            
	            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_OAN_CODIGO, DD_OAN_DESCRIPCION, DD_OAN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
	            			VALUES ('''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', 0, '''||V_INCIDENCIA||''', SYSDATE, 0)';
	            EXECUTE IMMEDIATE V_MSQL;
	            
	            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADO CORRECTAMENTE');
          
        	END IF;
        	
        ELSE
        
        	DBMS_OUTPUT.PUT_LINE('LA TABLA DD_OAN_ORIGEN_ANTERIOR NO EXISTE');
        	
        END IF;
	END LOOP;
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_OAN_ORIGEN_ANTERIOR MODIFICADO CORRECTAMENTE ');

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
