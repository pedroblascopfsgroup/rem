--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220222
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10738
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar nuevo municipio en DD_UPO_UNID_POBLACIONAL
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10738'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='DD_UPO_UNID_POBLACIONAL'; --Vble. auxiliar para almacenar la tabla a insertar
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    	--      DD_LOC_CODIGO	       DESCRIPCION						  DD_UPO_CODIGO
        T_TIPO_DATA('03099'			,'ORIHUELA COSTA'		        ,  '030990800'),
        T_TIPO_DATA('17101'			,'RIUCLAR'		              ,  '171010501'),
        T_TIPO_DATA('18089'			,'BALCONES (LOS)'	          ,  '180890103'),
        T_TIPO_DATA('30009'			,'HURTADO'	                ,  '300090305'),
        T_TIPO_DATA('38001'			,'QUINTA (LA)'	            ,  '380012602'),
        T_TIPO_DATA('38001'			,'TAUCHO'	                  ,  '380012603'),
        T_TIPO_DATA('46046'			,'DROVA (LA)'	              ,  '460460102'),
        T_TIPO_DATA('46211'			,'MONTE REAL'	              ,  '462110102')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en DD_UPO_UNID_POBLACIONAL -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCIÓN EN DD_UPO_UNID_POBLACIONAL] ');
        
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE DD_UPO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si no existe lo insertamos
        IF V_NUM_TABLAS < 1 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	         

            V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.'||V_TABLA||' (' ||
                          ' DD_UPO_ID
                          , DD_LOC_ID
                          , DD_UPO_CODIGO
                          , DD_UPO_DESCRIPCION
                          , DD_UPO_DESCRIPCION_LARGA
                          , USUARIOCREAR
                          , FECHACREAR
                        ) VALUES (
                      	'|| V_ID ||'
                        ,(SELECT DD_LOC_ID FROM '|| V_ESQUEMA_M ||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
                        ,'''||TRIM(V_TMP_TIPO_DATA(3))||'''
                        ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                        ,'''||TRIM(V_TMP_TIPO_DATA(2))||''' 	
                        ,'''||V_USUARIO||'''
                        ,SYSDATE)';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
       --Si existe, no hacemos nada
       ELSE
       DBMS_OUTPUT.PUT_LINE('[INFO]: LA UNIDAD POBLACIONAL A INSERTAR YA EXISTE');       
        
       END IF;
      END LOOP;
    
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