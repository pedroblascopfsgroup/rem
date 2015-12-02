--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20151013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=PRODUCTO-109
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
        T_TIPO_CCA('01'	,'Andalucía'),
		T_TIPO_CCA('02'	,'Aragón'),
		T_TIPO_CCA('03'	,'Asturias, Principado de'),
		T_TIPO_CCA('04'	,'Balears, Illes'),
		T_TIPO_CCA('05'	,'Canarias'),
		T_TIPO_CCA('06'	,'Cantabria'),
		T_TIPO_CCA('07'	,'Castilla y León'),
		T_TIPO_CCA('08'	,'Castilla - La Mancha'),
		T_TIPO_CCA('09'	,'Cataluña'),
		T_TIPO_CCA('10'	,'Comunitat Valenciana'),
		T_TIPO_CCA('11'	,'Extremadura'),
		T_TIPO_CCA('12'	,'Galicia'),
		T_TIPO_CCA('13'	,'Madrid, Comunidad de'),
		T_TIPO_CCA('14'	,'Murcia, Región de'),
		T_TIPO_CCA('15'	,'Navarra, Comunidad Foral de'),
		T_TIPO_CCA('16'	,'País Vasco'),
		T_TIPO_CCA('17'	,'Rioja, La')
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
					', USUARIOMODIFICAR = ''DD'' , FECHAMODIFICAR = SYSDATE '||
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
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_CCA(1)||''','''||TRIM(V_TMP_TIPO_CCA(2))||''', 0, ''DD'',SYSDATE,0 FROM DUAL';
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

