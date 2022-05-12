--/*
--##########################################
--## AUTOR=SANTI MONZÓ
--## FECHA_CREACION=20220512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17840
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra lógicamente en ACT_LGE_LOCALIZACION_GEST los datos añadidos en T_ARRAY_DATA
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
    DD_SEG_ID NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    V_TABLA VARCHAR2(30 CHAR) := 'ACT_LGE_LOCALIZACION_GEST';  -- Tabla a modificar  
    V_TABLA_DD_SEG VARCHAR2(30 CHAR) := 'DD_SEG_SUBESTADO_GESTION';
    V_USR VARCHAR2(30 CHAR) := 'HREOS-17840'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_CDG VARCHAR2(30 CHAR) := 'SEG';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

        T_TIPO_DATA('NO_COLAB'),
        T_TIPO_DATA('CON_CONT'),
        T_TIPO_DATA('CONT_ERR'),
        T_TIPO_DATA('CONT_FALL'),
        T_TIPO_DATA('INC'),
        T_TIPO_DATA('INC_PAG'),
        T_TIPO_DATA('REG'),
        T_TIPO_DATA('SIN_DEU'),
        T_TIPO_DATA('SIN_INI'),
        T_TIPO_DATA('SIN_TIT')
	    
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para borrar lógicamente los valores en ACT_LGE_LOCALIZACION_GEST -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR LOGICAMENTE EN '||V_TABLA||'] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a borrar (si esta borrado en DD_SEG_SUBESTADO_GESTION)
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_DD_SEG||' WHERE BORRADO = 1 AND DD_'||V_CDG||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe y esta borrado
        IF V_NUM_TABLAS > 0 THEN	

        --Obtenemos el DD_SEG_ID
        V_SQL := 'SELECT DD_SEG_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_SEG||' WHERE BORRADO = 1 AND DD_'||V_CDG||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO DD_SEG_ID;

          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS LOS REGISTROS CON ID = '''|| DD_SEG_ID ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' '||
                  	'SET BORRADO = 1,				   	
					USUARIOBORRAR = '''||V_USR||''', 
                    FECHABORRAR = SYSDATE 
					WHERE DD_SEG_ID = '''||DD_SEG_ID||'''';
                   
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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



   
