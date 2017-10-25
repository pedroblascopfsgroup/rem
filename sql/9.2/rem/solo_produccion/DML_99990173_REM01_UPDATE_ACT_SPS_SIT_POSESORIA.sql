--/*
--##########################################
--## AUTOR=Simeon Nikolaev
--## FECHA_CREACION=20171005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2950
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica act_sps_sit_posesoria
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
	V_USUARIO VARCHAR2(100 CHAR) := 'HREOS-2950';
    V_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('102794'),
		T_TIPO_DATA('102795'),
		T_TIPO_DATA('103087'),
		T_TIPO_DATA('103088'),
		T_TIPO_DATA('103089'),
		T_TIPO_DATA('103090'),
		T_TIPO_DATA('103143'),
		T_TIPO_DATA('103472'),
		T_TIPO_DATA('103473'),
		T_TIPO_DATA('103474'),
		T_TIPO_DATA('103475'),
		T_TIPO_DATA('103476'),
		T_TIPO_DATA('104877'),
		T_TIPO_DATA('104878'),
		T_TIPO_DATA('104879'),
		T_TIPO_DATA('104880'),
		T_TIPO_DATA('105079'),
		T_TIPO_DATA('105080'),
		T_TIPO_DATA('105081'),
		T_TIPO_DATA('105306'),
		T_TIPO_DATA('105307'),
		T_TIPO_DATA('105308'),
		T_TIPO_DATA('119812'),
		T_TIPO_DATA('119813'),
		T_TIPO_DATA('119814'),
		T_TIPO_DATA('119815'),
		T_TIPO_DATA('119991'),
		T_TIPO_DATA('119992'),
		T_TIPO_DATA('119993'),
		T_TIPO_DATA('120152'),
		T_TIPO_DATA('120153'),
		T_TIPO_DATA('120154'),
		T_TIPO_DATA('120335'),
		T_TIPO_DATA('120336'),
		T_TIPO_DATA('120337'),
		T_TIPO_DATA('120338'),
		T_TIPO_DATA('122612'),
		T_TIPO_DATA('122613'),
		T_TIPO_DATA('122674'),
		T_TIPO_DATA('122675'),
		T_TIPO_DATA('122676'),
		T_TIPO_DATA('122677'),
		T_TIPO_DATA('122678'),
		T_TIPO_DATA('122789'),
		T_TIPO_DATA('123174'),
		T_TIPO_DATA('123175'),
		T_TIPO_DATA('124821'),
		T_TIPO_DATA('124822'),
		T_TIPO_DATA('124857'),
		T_TIPO_DATA('124858'),
		T_TIPO_DATA('124859'),
		T_TIPO_DATA('125040'),
		T_TIPO_DATA('125041'),
		T_TIPO_DATA('125403'),
		T_TIPO_DATA('125404'),
		T_TIPO_DATA('125405'),
		T_TIPO_DATA('125406'),
		T_TIPO_DATA('125407'),
		T_TIPO_DATA('125408'),
		T_TIPO_DATA('125409'),
		T_TIPO_DATA('125775'),
		T_TIPO_DATA('125776'),
		T_TIPO_DATA('125777'),
		T_TIPO_DATA('125939'),
		T_TIPO_DATA('125940'),
		T_TIPO_DATA('125941'),
		T_TIPO_DATA('125942'),
		T_TIPO_DATA('125943'),
		T_TIPO_DATA('125944'),
		T_TIPO_DATA('126210'),
		T_TIPO_DATA('126211'),
		T_TIPO_DATA('126212'),
		T_TIPO_DATA('126465'),
		T_TIPO_DATA('126466'),
		T_TIPO_DATA('126467'),
		T_TIPO_DATA('126571'),
		T_TIPO_DATA('126572'),
		T_TIPO_DATA('126573'),
		T_TIPO_DATA('126574'),
		T_TIPO_DATA('126732'),
		T_TIPO_DATA('126779'),
		T_TIPO_DATA('127068'),
		T_TIPO_DATA('127069'),
		T_TIPO_DATA('127070'),
		T_TIPO_DATA('127136'),
		T_TIPO_DATA('127137'),
		T_TIPO_DATA('127202'),
		T_TIPO_DATA('127203'),
		T_TIPO_DATA('127254'),
		T_TIPO_DATA('127255'),
		T_TIPO_DATA('127256'),
		T_TIPO_DATA('127628'),
		T_TIPO_DATA('127629')


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
	        
	        --Si existe lo modificamos
	        IF V_NUM_TABLAS > 0 THEN				
	          
	          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO ');
	       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
	                    'SET SPS_OCUPADO = 1, SPS_CON_TITULO = 0' ||
						', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||
						', USUARIOBORRAR = NULL, FECHABORRAR = NULL, BORRADO = 0 '||
						'WHERE ACT_ID = '||V_ID_ACTIVO||'';
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
	          
	       --Si no existe, lo insertamos   
	       ELSE
	       
	          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO ');
	          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
	          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
	                      'SPS_ID, ACT_ID , SPS_OCUPADO, SPS_CON_TITULO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
	                      'SELECT '|| V_ID || ',
	                      '||V_ID_ACTIVO||', 1, 0,
						   0, '''||V_USUARIO||''',SYSDATE,0 
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