--/*
--##########################################
--## AUTOR=Juan Beltran
--## FECHA_CREACION=20190912
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7668
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza DD_CCA_COMUNIDAD
--## INSTRUCCIONES:
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_CCA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_CCA IS TABLE OF T_TIPO_CCA;
    V_TIPO_CCA T_ARRAY_CCA := T_ARRAY_CCA(      
		T_TIPO_CCA('18'	,'Ceuta'),
		T_TIPO_CCA('19'	,'Melilla')
    ); 
    V_TMP_TIPO_CCA T_TIPO_CCA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	-- LOOP para insertar/modificar los valores en DD_CCA_RES_VALIDACION_NUSE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION/MODIFICACION EN DD_CCA_COMUNIDAD] ');
    FOR I IN V_TIPO_CCA.FIRST .. V_TIPO_CCA.LAST
      LOOP
      
        V_TMP_TIPO_CCA := V_TIPO_CCA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_CCA_COMUNIDAD WHERE DD_CCA_CODIGO = '''||TRIM(V_TMP_TIPO_CCA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_CCA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.DD_CCA_COMUNIDAD '||
                    'SET DD_CCA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_CCA(2))||''''|| 
					', USUARIOMODIFICAR = ''HREOS-7668'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_CCA_CODIGO = '''||TRIM(V_TMP_TIPO_CCA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_CCA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_CCA_COMUNIDAD.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_CCA_COMUNIDAD (' ||
                      'DD_CCA_ID, DD_CCA_CODIGO, DD_CCA_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_CCA(1)||''','''||TRIM(V_TMP_TIPO_CCA(2))||''', 0, ''HREOS-7668'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_CCA_COMUNIDAD ACTUALIZADO CORRECTAMENTE ');
   

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

