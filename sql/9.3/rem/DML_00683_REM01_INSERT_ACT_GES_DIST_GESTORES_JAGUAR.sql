--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211028
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16066
--## PRODUCTO=NO
--##
--## Finalidad:	Añade en la tabla ACT_GES_DIST_GESTORES los datos del array T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-16066';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND3 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (		
    		    -- TGE | CRA | EAC | TCR | PRV | LOC | POSTAL | USERNAME | NOMBRE_APELLIDO | SCRA

    T_TIPO_DATA('GIAADMT','07','','','4','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','11','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','14','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','18','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','21','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','23','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','29','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','41','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','22','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','44','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','50','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','33','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','7','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','35','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','38','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','39','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','5','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','9','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','24','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','34','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','37','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','40','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','42','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','47','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','49','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','2','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','13','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','16','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','19','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','45','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','8','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','17','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','25','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','43','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','51','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','3','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','12','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','46','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','6','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','10','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','15','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','27','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','32','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','36','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','28','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','52','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','30','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','31','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','1','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','20','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','48','','','GIAADMT02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','26','','','GIAADMT02','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','4','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','11','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','14','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','18','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','21','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','23','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','29','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','41','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','22','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','44','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','50','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','33','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','7','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','35','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','38','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','39','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','5','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','9','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','24','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','34','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','37','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','40','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','42','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','47','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','49','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','2','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','13','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','16','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','19','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','45','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','8','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','17','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','25','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','43','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','51','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','3','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','12','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','46','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','6','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','10','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','15','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','27','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','32','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','36','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','28','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','52','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','30','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','31','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','1','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','20','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','48','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','26','','','GTOPLUS06','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','4','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','11','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','14','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','18','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','21','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','23','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','29','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','41','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','22','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','44','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','50','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','33','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','7','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','35','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','38','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','39','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','5','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','9','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','24','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','34','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','37','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','40','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','42','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','47','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','49','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','2','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','13','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','16','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','19','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','45','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','8','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','17','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','25','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','43','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','51','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','3','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','12','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','46','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','6','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','10','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','15','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','27','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','32','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','36','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','28','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','52','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','30','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','31','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','1','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','20','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','48','','','GTOPOSTV07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','26','','','GTOPOSTV07','','70')

         
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- LOOP para insertar o modificar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_COND1 := 'IS NULL';
	V_COND2 := 'IS NULL';
	V_COND3 := 'IS NULL';

        IF (V_TMP_TIPO_DATA(4) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(4))||''' ';
        END IF;
        IF (V_TMP_TIPO_DATA(6) is not null) THEN
			V_COND2 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
        END IF;
 	IF (V_TMP_TIPO_DATA(10) is not null)  THEN
			V_COND3 := '= '''||TRIM(V_TMP_TIPO_DATA(10))||''' ';
        END IF;
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  '||V_COND1||' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND2||' '||
					' AND COD_POSTAL IS NULL '||
					' AND COD_SUBCARTERA '||V_COND3||' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = '''||V_USU||''' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO  IS NULL '||
					' AND COD_TIPO_COMERZIALZACION '||V_COND1||' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND2||' '||
					' AND COD_POSTAL IS NULL '||
					' AND COD_SUBCARTERA '||V_COND3||' ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
          
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||TRIM(V_TMP_TIPO_DATA(5))||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, '''||V_USU||''',SYSDATE,0, '''||TRIM(V_TMP_TIPO_DATA(10))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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
