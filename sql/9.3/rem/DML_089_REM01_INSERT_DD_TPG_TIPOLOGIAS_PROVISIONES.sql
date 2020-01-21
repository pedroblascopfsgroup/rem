--/*
--######################################### 
--## AUTOR=Alfonso Rodriguez
--## FECHA_CREACION=20200121
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9116
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
    V_TABLA VARCHAR2(30 CHAR) := 'DD_TPG_TIPOLOGIAS_PROVISIONES';
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-9116';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    	-- DD_TPG_CODIGO	          DESCRIPCION						                 DESCRIPCION LARGA					 DD_TGA           DD_STG
        T_TIPO_DATA('01'			,'Recargos e intereses'			              ,'Recargos e intereses'				,'01',          '92'),
        T_TIPO_DATA('01'      ,'IBI rustica'                            ,'IBI rustica'                ,'02',          '02'),
        T_TIPO_DATA('01'      ,'IBI urbana'                             ,'IBI urbana'                 ,'01',          '01'),
        T_TIPO_DATA('02'      ,'Agua'                                   ,'Agua'                       ,'02',          '10'),
        T_TIPO_DATA('03'      ,'Alcantarillado'                         ,'Alcantarillado'             ,'02',          '09'),
        T_TIPO_DATA('04'      ,'Basura'                                 ,'Basura'                     ,'02',          '08'),
        T_TIPO_DATA('05'      ,'Judicial'                               ,'Judicial'                   ,'02',          '16'),
        T_TIPO_DATA('06'      ,'Vado'                                   ,'Vado'                       ,'02',          '11'),
        T_TIPO_DATA('07'      ,'IAAEE'                                  ,'IAAEE'                      ,'01',          '05'),
        T_TIPO_DATA('08'      ,'Plusvalia (IIVTNU) compra'              ,'Plusvalia (IIVTNU) compra'  ,'03',          '03'),
        T_TIPO_DATA('08'      ,'Plusvalia (IIVTNU) venta'               ,'Plusvalia (IIVTNU) venta'   ,'04',          '04'),
        T_TIPO_DATA('09'      ,'ICIO'                                   ,'ICIO'                       ,'01',          '06'),
        T_TIPO_DATA('10'      ,'ITPAJD'                                 ,'ITPAJD'                     ,'01',          '07'),
        T_TIPO_DATA('11'      ,'Cedula Habitabilidad'                   ,'Cedula Habitabilidad'       ,'14',          '60'),
        T_TIPO_DATA('12'      ,'Registro'                               ,'Registro'                   ,'11',          '43'),
        T_TIPO_DATA('13'      ,'Obras / Rehabilitacion / Mantenimiento' ,'Obras / Rehabilitacion / Mantenimiento'   ,'02',          '15'),
        T_TIPO_DATA('13'      ,'Otras tasas'                            ,'Otras tasas'                ,'02',          '18'),
        T_TIPO_DATA('13'      ,'Ecotasa'                                ,'Ecotasa'                    ,'02',          '12'),
        T_TIPO_DATA('13'      ,'Expedicion Documentos'                  ,'Expedicion Documentos'      ,'02',          '14'),
        T_TIPO_DATA('13'      ,'Regularizacion Catastral'               ,'Regularizacion Catastral'   ,'02',          '13'),
        T_TIPO_DATA('14'      ,'Administrador Comunidad Propietarios'   ,'Administrador Comunidad Propietarios'      ,'11',          '48')
        
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;  
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en DD_LOC_LOCALIDAD -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TPG_TIPOLOGIAS_PROVISIONES] ');
        
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TPG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
        AND DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO='''||TRIM(V_TMP_TIPO_DATA(5))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' '||
                    'SET DD_TPG_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TPG_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO='''||TRIM(V_TMP_TIPO_DATA(4))||''')'||
          ', DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO='''||TRIM(V_TMP_TIPO_DATA(5))||''')'||
					', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TPG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TPG_TIPOLOGIAS_PROVISIONES.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (' ||
                      	'DD_TPG_ID, DD_TPG_CODIGO, DD_TPG_DESCRIPCION, DD_TPG_DESCRIPCION_LARGA, DD_TGA_ID, DD_STG_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 		'||
                      	'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''' 	'||
						',(SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO='''||TRIM(V_TMP_TIPO_DATA(4))||''')			'||
            ',(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO='''||TRIM(V_TMP_TIPO_DATA(5))||''')     '||
						', 0, '''||V_USUARIO||''',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO] [GNS017] Se insertan/actualizan 21 Registros en DD_TPG_TIPOLOGIAS_PROVISIONES.');  
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    
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
