--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20191031
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5562
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_GES_DIST_GESTORES los datos añadidos en T_ARRAY_DATA
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(		
		-- CERBERUS - APPLE  - GESTORES DE FORMALIZACIÓN
    				-- TGE	  	CRA	  	 SCR	EAC		TCR		PRV	 	LOC  	POSTAL		USERNAME					
		T_TIPO_DATA('GFORM',	'07',	'138',	'',		'',		'4',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'6',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'10',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'11',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'14',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'18',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'21',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'22',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'23',	'',		'',			'pdiez'),		
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'29',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'41',	'',		'',			'pdiez'),		
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'44',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'50',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'51',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'52',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'30',	'',		'',			'pdiez'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'33',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'35',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'38',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'39',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'3',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'12',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'46',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'15',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'27',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'32',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'36',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'28',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'31',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'1',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'48',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'20',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'26',	'',		'',			'mfuentesm'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'7',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'2',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'13',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'16',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'19',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'45',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'5',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'9',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'24',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'34',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'37',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'40',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'42',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'47',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'49',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'8',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'17',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'25',	'',		'',			'jdella'),
		T_TIPO_DATA('GFORM',	'07',	'138',	'' ,	'',		'43',	'',		'',			'jdella')
				
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||					
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_SUBCARTERA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' '||					
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION IS NULL '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(6))||''' '||
					' AND COD_MUNICIPIO IS NULL'||
					' AND COD_POSTAL IS NULL '||
					' AND USERNAME = '''||TRIM(V_TMP_TIPO_DATA(9))||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe NO hacemos nada, ni siquera UPDATE, los datos que vienen sirven de identificador único (Solo para gestor Formalización, es un caso especial)
        IF V_NUM_TABLAS > 0 THEN				

          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO EXISTE - NO SE HACE NADA');
          
       --Si no existe, lo insertamos   
       ELSE
       
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_SUBCARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||V_TMP_TIPO_DATA(3)||''','''||V_TMP_TIPO_DATA(4)||''','''||V_TMP_TIPO_DATA(5)||''','||V_TMP_TIPO_DATA(6)||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''', '''||TRIM(V_TMP_TIPO_DATA(9))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(9))||''') '||
						', 0, ''REMVIP-5562'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '|| TRIM(V_TMP_TIPO_DATA(5)));
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
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
