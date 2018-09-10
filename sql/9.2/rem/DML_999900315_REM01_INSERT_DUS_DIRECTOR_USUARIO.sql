--/*
--##########################################
--## AUTOR=Juanjo Arbona
--## FECHA_CREACION=20180910
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1768
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DUS_DIRECTOR_USUARIO los datos añadidos en T_ARRAY_DATA
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
        T_TIPO_DATA('39937','39278'), --mfuentes->ataboadaa
        T_TIPO_DATA('53048','39278'), --jtoro->ataboadaa
        T_TIPO_DATA('39645','39278'), --jbarbero->ataboadaa
        T_TIPO_DATA('39833','39278'), --mvgonzalez->ataboadaa
        T_TIPO_DATA('75755','39278'), --isanchezp->ataboadaa
        T_TIPO_DATA('30034','39278'), --vmaldonado->ataboadaa
        T_TIPO_DATA('39749','39992'), --lrisco->psm
        T_TIPO_DATA('30985','39992'), --D500162796->psm
        T_TIPO_DATA('39372','39992'), --avegasg->psm
        T_TIPO_DATA('39945','39992'), --mperezd->psm
        T_TIPO_DATA('39742','39992'), --ksteiert->psm
        T_TIPO_DATA('75694','39992'), --ajimeneze->psm
        T_TIPO_DATA('39347','39992'), --afraile->psm
        T_TIPO_DATA('75002','39992')  --rpuentes->psm
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DUS_DIRECTOR_USUARIO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DUS_DIRECTOR_USUARIO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DUS_DIRECTOR_USUARIO WHERE USU_ID = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND USU_DIR_ID = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' -> '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' YA EXISTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' -> '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DUS_DIRECTOR_USUARIO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DUS_DIRECTOR_USUARIO (' ||
                      'DUS_ID, USU_ID, USU_DIR_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''', 0, ''REMVIP-1768'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA DUS_DIRECTOR_USUARIO ACTUALIZADA CORRECTAMENTE ');
   

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



   
