--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20151102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SAC_SUBTIPO_ACTIVO los datos añadidos en T_ARRAY_DATA
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
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA(1	,'01'	,'No urbanizable (rústico)'				,'No urbanizable (rústico)'			,'SU'		,'01'		,'NO URBANIZABLE'),
        T_TIPO_DATA(1	,'02'	,'Urbanizable no programado'			,'Urbanizable no programado'		,'SU'		,'02'		,'URBANIZABLE NO PROGRAMADO'),		
        T_TIPO_DATA(1	,'03'	,'Urbanizable programado'				,'Urbanizable programado'			,'SU'		,'03'		,'URBANIZABLE PROGRAMADO'),
        T_TIPO_DATA(1	,'04'	,'Urbano (solar)'						,'Urbano (solar)'					,'SU'		,'04'		,'URBANO/SOLAR/PARCELA'),
        T_TIPO_DATA(2	,'05'	,'Unifamiliar aislada'					,'Unifamiliar aislada'				,'VI'		,'03'		,'CHALET AISLADO'),
		T_TIPO_DATA(2	,'06'	,'Unifamiliar adosada'					,'Unifamiliar adosada'				,'VI'		,'04'		,'CHALET ADOSADO'),
		T_TIPO_DATA(2	,'07'	,'Unifamiliar pareada'					,'Unifamiliar pareada'				,'VI'		,'04'		,'CHALET ADOSADO'),
		T_TIPO_DATA(2	,'08'	,'Unifamiliar casa de pueblo'			,'Unifamiliar casa de pueblo'		,'VI'		,'05'		,'CASA UNIFAMILIAR'),
		T_TIPO_DATA(2	,'09'	,'Piso'									,'Piso'								,'VI'		,'01'		,'PISO'),
		T_TIPO_DATA(2	,'10'	,'Piso dúplex'							,'Piso dúplex'						,'VI'		,'02'		,'DÚPLEX'),
		T_TIPO_DATA(2	,'11'	,'Ático'								,'Ático'							,'VI'		,'01'		,'PISO'),
		T_TIPO_DATA(2	,'12'	,'Estudio/Loft'							,'Estudio/Loft'						,'VI'		,'01'		,'PISO'),
		T_TIPO_DATA(3	,'13'	,'Local comercial'						,'Local comercial'					,'CO'		,'01'		,'LOCAL'),
		T_TIPO_DATA(3	,'14'	,'Oficina'								,'Oficina'							,'CO'		,'02'		,'OFICINA'),
		T_TIPO_DATA(3	,'15'	,'Almacén'								,'Almacén'							,'CO'		,'03'		,'ALMACÉN'),
		T_TIPO_DATA(3	,'16'	,'Hotel'								,'Hotel'							,'OT'		,'04'		,'REGIMEN HOTELERO'),
		T_TIPO_DATA(4	,'17'	,'Nave aislada'							,'Nave aislada'						,'IN'		,'02'		,'NAVE AISLADA'),
		T_TIPO_DATA(4	,'18'	,'Nave adosada'							,'Nave adosada'						,'IN'		,'01'		,'NAVE ADOSADA'),
		T_TIPO_DATA(5	,'19'	,'Aparcamiento'							,'Aparcamiento'						,'OT'		,'02'		,'GARAJE'),
		T_TIPO_DATA(5	,'20'	,'Hotel/Apartamentos turísticos'		,'Hotel/Apartamentos turísticos'	,'ED'		,'06'		,'HOTELERO'),
		T_TIPO_DATA(5	,'21'	,'Oficina'								,'Oficina'							,'ED'		,'07'		,'OFICINAS'),
		T_TIPO_DATA(5	,'22'	,'Comercial'							,'Comercial'						,'ED'		,'02'		,'COMERCIAL'),	
		T_TIPO_DATA(6	,'23'	,'En construcción (promoción)'			,'En construcción (promoción)'		,'OT'		,'05'		,'OTROS'),
		T_TIPO_DATA(7	,'24'	,'Garaje'								,'Garaje'							,'OT'		,'02'		,'GARAJE'),
		T_TIPO_DATA(7	,'25'	,'Trastero'								,'Trastero'							,'OT'		,'03'		,'TRASTERO'),
		T_TIPO_DATA(7	,'26'	,'Otros'								,'Otros'							,'OT'		,'05'		,'OTROS')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SAC_SUBTIPO_ACTIVO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SAC_SUBTIPO_ACTIVO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO '||
                    'SET DD_SAC_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''''|| 
					', DD_SAC_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', DD_TPA_COD_UVEM = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
					', DD_SAC_COD_UVEM = '''||TRIM(V_TMP_TIPO_DATA(6))||''''||
					', DD_SAC_DESC_UVEM = '''||TRIM(V_TMP_TIPO_DATA(7))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_SAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SAC_SUBTIPO_ACTIVO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO (' ||
                      'DD_SAC_ID, DD_TPA_ID, DD_SAC_CODIGO, DD_SAC_DESCRIPCION, DD_SAC_DESCRIPCION_LARGA, DD_TPA_COD_UVEM, DD_SAC_COD_UVEM, DD_SAC_DESC_UVEM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''','''||TRIM(V_TMP_TIPO_DATA(6))||''','''||TRIM(V_TMP_TIPO_DATA(7))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SAC_SUBTIPO_ACTIVO ACTUALIZADO CORRECTAMENTE ');
   

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