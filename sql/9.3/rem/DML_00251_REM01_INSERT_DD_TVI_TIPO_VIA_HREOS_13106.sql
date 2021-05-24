--/*
--######################################### 
--## AUTOR=Javier Urbán
--## FECHA_CREACION=20210223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13106
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TVI_TIPO_VIA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    	-- DD_TVI_ID	DD_TVI_CODIGO	    DESCRIPCION 						DESCIPCION_LARGA
        T_TIPO_DATA('61','CL','Calle','Calle'),
        T_TIPO_DATA('62','PL','Plaza','Plaza'),
        T_TIPO_DATA('63','AV','Avenida','Avenida'),
        T_TIPO_DATA('64','CT','Carretera','Carretera'),
        T_TIPO_DATA('65','UB','Urbanización','Urbanización'),
        T_TIPO_DATA('66','LU','Lugar','Lugar'),
        T_TIPO_DATA('67','PT','Partida','Partida'),
        T_TIPO_DATA('68','PA','Paseo','Paseo'),
        T_TIPO_DATA('69','PJ','Pasaje','Pasaje'),
        T_TIPO_DATA('70','CA','Camino','Camino'),
        T_TIPO_DATA('71','PG','Polígono','Polígono'),
        T_TIPO_DATA('72','RO','Ronda','Ronda'),
        T_TIPO_DATA('101','BD','BOULEVARD','BOULEVARD'),
        T_TIPO_DATA('102','CR','CARRETERA','CARRETERA'),
        T_TIPO_DATA('103','CU','CUESTA','CUESTA'),
        T_TIPO_DATA('104','ET','ESTACION','ESTACION'),
        T_TIPO_DATA('105','GL','GLORIETA','GLORIETA'),
        T_TIPO_DATA('106','PB','POBLADO','POBLADO'),
        T_TIPO_DATA('81','PR','Prolongación','Prolongación'),
        T_TIPO_DATA('82','CJ','Callejón','Callejón'),
        T_TIPO_DATA('83','CV','Camino Viejo','Camino Viejo'),
        T_TIPO_DATA('84','CN','Costanilla','Costanilla'),
        T_TIPO_DATA('85','CO','Colonia','Colonia'),
        T_TIPO_DATA('86','TV','Travesía','Travesía'),
        T_TIPO_DATA('87','RA','Rambla','Rambla')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en DD_TVI_TIPO_VIA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAR QUE EXISTE LA TABLA : '||V_TEXT_TABLA||'');
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES 
					WHERE   TABLE_NAME LIKE '''||V_TEXT_TABLA||'''';
         DBMS_OUTPUT.PUT_LINE(V_SQL);           
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN   
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE DD_TVI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS = 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.'||V_TEXT_TABLA||' ('||'
                      	 DD_TVI_ID, DD_TVI_CODIGO, DD_TVI_DESCRIPCION, DD_TVI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '||
                      	'VALUES ('''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||
						' 0, ''HREOS-13106'',SYSDATE,0)';
                        DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
       ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: EL CÓDIGO '''||TRIM(V_TMP_TIPO_DATA(2))||''' NO EXISTE');
       END IF;
      END LOOP;
    ELSE 
      DBMS_OUTPUT.PUT_LINE('[INFO]:LA TABLA  '||V_TEXT_TABLA||' NO EXISTE');
    END IF;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    
EXCEPTION
     WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('[ERROR] ...KO!');
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
