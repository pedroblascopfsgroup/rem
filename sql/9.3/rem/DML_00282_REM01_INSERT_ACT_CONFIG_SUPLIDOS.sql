--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200506
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6642
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos iniciales a la tabla ACT_CONFIG_SUPLIDOS.
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
	
    V_ID VARCHAR2(16);
    V_CRA_ID VARCHAR2(16);
    V_SCR_ID VARCHAR2(16);
    V_TGA_ID VARCHAR2(16);
    V_STG_ID VARCHAR2(16);
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_CONFIG_SUPLIDOS';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-10216';
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
			    -- (DD_CRA_CODIGO, DD_SCR_CODIGO, DD_TGA_CODIGO, DD_STG_CODIGO)
		T_TIPO_DATA('07', '151', '11', NULL),
		T_TIPO_DATA('07', '152', '11', NULL),
		T_TIPO_DATA('07', '151', '11', '53'),
		T_TIPO_DATA('07', '152', '11', '53')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	
      -- PRIMERO OBTENEMOS LOS IDS DE LOS VALORES NO NULLABLES
      
      V_MSQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_MSQL INTO V_CRA_ID;
      
      V_MSQL := 'SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
      EXECUTE IMMEDIATE V_MSQL INTO V_TGA_ID;
      
      -- CONSTRUYO LA BASE DE LA QUERY PARA VER SI EL DATO ESTÁ YA INSERTADO.
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_CRA_ID = '|| V_CRA_ID ||' ';
      
      -- COMO NO SE PUEDEN COMPARAR LOS NULOS CON EL OPERADOR '=', TENGO QUE COMPROBAR SI ES NULO O NO Y AÑADIR LA COMPROBACIÓN CORRESPONDIENTE.
      IF TRIM(V_TMP_TIPO_DATA(2)) IS NULL THEN
      	V_SCR_ID := 'NULL';
      	
      	V_SQL := V_SQL || ' AND DD_SCR_ID IS NULL ';
  	  ELSE
      	V_MSQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
      	EXECUTE IMMEDIATE V_MSQL INTO V_SCR_ID;
      	
      	V_SQL := V_SQL || ' AND DD_SCR_ID = '|| V_SCR_ID ||' ';
      END IF;
      
      -- EL DD_TGA_ID NO ES NULABLE, POR LO QUE AÑADO LA COMPROBACIÓN DIRECTAMENTE.
      V_SQL := V_SQL || ' AND DD_TGA_ID = '|| V_TGA_ID ||' ';
      
      -- COMO NO SE PUEDEN COMPARAR LOS NULOS CON EL OPERADOR '=', TENGO QUE COMPROBAR SI ES NULO O NO Y AÑADIR LA COMPROBACIÓN CORRESPONDIENTE.
      IF TRIM(V_TMP_TIPO_DATA(4)) IS NULL THEN
      	V_STG_ID := 'NULL';
      	
      	V_SQL := V_SQL || ' AND DD_STG_ID IS NULL ';
      ELSE      	
	      V_MSQL := 'SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''';
	      EXECUTE IMMEDIATE V_MSQL INTO V_STG_ID;
	      
	      V_SQL := V_SQL || ' AND DD_STG_ID = '|| V_STG_ID ||' ';
      END IF;
      
      V_SQL := V_SQL || ' AND BORRADO = 0 ';
      
      --Comprobamos el dato a insertar
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      --Si no existe lo insertamos
      IF V_NUM_TABLAS = 0 THEN				
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO CON DD_CRA_CODIGO: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', DD_SCR_CODIGO: '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', DD_TGA_ID: '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' Y DD_STG_CODIGO: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
    	V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := '
          	INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' 
				(SUP_ID, DD_CRA_ID, DD_SCR_ID, DD_TGA_ID, DD_STG_ID, VERSION, USUARIOCREAR, FECHACREAR)
  			VALUES (
	            '|| V_ID ||',
	            '|| V_CRA_ID ||', 
	            '|| V_SCR_ID ||',
	            '|| V_TGA_ID ||',
	            '|| V_STG_ID ||',
	            0, 
				'''||V_USUARIO||''',
				SYSDATE
				)';
      DBMS_OUTPUT.PUT_LINE(V_MSQL);
      
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
        
      ELSE
      	
      	DBMS_OUTPUT.PUT_LINE('[INFO]: YA ESTÁ INSERTADO EL REGISTRO CON DD_CRA_CODIGO: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', DD_SCR_CODIGO: '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', DD_TGA_ID: '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' Y DD_STG_CODIGO: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
        
      END IF;

    END LOOP;
  COMMIT;
   

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
