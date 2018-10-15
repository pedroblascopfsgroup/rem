--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20180910
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1567
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en ACT_SPS_SIT_POSESORIA 
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
	  
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_SPS_SIT_POSESORIA';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID_ACTIVO NUMBER(16);
	V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-1567';
    V_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('120414'),
		T_TIPO_DATA('101480'),
		T_TIPO_DATA('102050'),
		T_TIPO_DATA('94685'),
		T_TIPO_DATA('101097'),
		T_TIPO_DATA('94106'),
		T_TIPO_DATA('110458'),
		T_TIPO_DATA('94368'),
		T_TIPO_DATA('108691'),
		T_TIPO_DATA('102049')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''' INTO V_ID_ACTIVO;
        
        IF V_ID_ACTIVO < 1 THEN
        
        	DBMS_OUTPUT.PUT_LINE('[WARNING] NO EXISTE EL ACTIVO '''||TRIM(V_TMP_TIPO_DATA(1))||''' NO SE HACE NADA!');
        	
        ELSE
        
	    	EXECUTE IMMEDIATE 'SELECT ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''' INTO V_ID_ACTIVO;
	        --Comprobamos el dato a insertar
	        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
	        WHERE ACT_ID = '||V_ID_ACTIVO||' ';
	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	          
	       --Si no existe, lo insertamos   
	        IF V_NUM_TABLAS = 0 THEN				
	       
	          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO ');
	          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
	          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
	                      'SPS_ID, ACT_ID , VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
	                      'SELECT '|| V_ID || ',
	                      '||V_ID_ACTIVO||', 0, '''||V_USUARIO||''',SYSDATE,0 
						   FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        END IF;
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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
