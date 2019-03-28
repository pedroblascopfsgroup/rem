--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20190328
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5845
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
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-5845';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		
         T_TIPO_DATA('GGADM', '7', '', '', '1', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '20', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '48', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '3', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '12', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '46', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '15', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '27', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '32', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '36', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '26', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '33', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '35', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '38', '', '', 'f&g01', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '39', '', '', 'f&g01', 'F&G', '138'),        
         T_TIPO_DATA('GGADM', '7', '', '', '11', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '4', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '14', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '18', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '21', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '23', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '29', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '41', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '5', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '9', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '24', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '34', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '37', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '40', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '42', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '47', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '49', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '6', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '10', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '7', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '22', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '44', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '50', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '31', '', '', 'mediterraneo01', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '8', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '17', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '25', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '43', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '13', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '16', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '19', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '45', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '2', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '28', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '30', '', '', 'pinos01', 'GESTORIA PINOS XXI,S.L.', '138'), 
         T_TIPO_DATA('GIAFORM', '7', '', '', '', '', '', 'ogf03', 'OGF', '138'),
         T_TIPO_DATA('GFORM', '7', '', '', '', '', '', 'iba', 'IRENE BERENGUER ALEIXANDRE', '138'),
         T_TIPO_DATA('GFORMADM', '7', '', '', '', '', '', 'iba', 'IRENE BERENGUER ALEIXANDRE', '138'),
         T_TIPO_DATA('GESTCOMALQ', '', '', '', '', '', '', 'dleganes', 'Daniel', '138'), 
         T_TIPO_DATA('GALQ', '7', '', '', '', '', '', 'dleganes', 'Daniel', '138'),
         T_TIPO_DATA('GAREO', '7', '', '', '', '', '', 'acarabal', 'Aida', '138'), 
         T_TIPO_DATA('GADM', '7', '', '', '', '', '', 'acarabal', 'Aida', '138'),  
         T_TIPO_DATA('GAREO', '7', '', '', '', '', '', 'usugruadm', 'USUARIO', '138'), 
         T_TIPO_DATA('GADM', '7', '', '', '', '', '', 'usugruadm', 'USUARIO', '138'),
         T_TIPO_DATA('GEDI', '7', '', '', '', '', '', 'bbaviera', 'BELEN', '138'), 
         T_TIPO_DATA('GSUE', '7', '', '', '', '', '', 'bbaviera', 'BELEN', '138'), 
         T_TIPO_DATA('GGADM', '7', '', '', '1', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '20', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '48', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '3', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '12', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '46', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '15', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '27', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '32', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '36', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '26', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '33', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '35', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '38', '', '', 'f&g02', 'F&G', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '39', '', '', 'f&g02', 'F&G', '138'),        
         T_TIPO_DATA('GGADM', '7', '', '', '11', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '4', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '14', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '18', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '21', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '23', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '29', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '41', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '5', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '9', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '24', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '34', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '37', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '40', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '42', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '47', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '49', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '6', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '10', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '7', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '22', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '44', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '50', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '31', '', '', 'mediterraneo02', 'Mediterraneo', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '8', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '17', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '25', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '43', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '13', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '16', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '19', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '45', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '2', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '28', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'),
         T_TIPO_DATA('GGADM', '7', '', '', '30', '', '', 'pinos02', 'GESTORIA PINOS XXI,S.L.', '138'), 
         T_TIPO_DATA('GTOCED', '7', '', '2', '8', '', '', 'tecnotra04', 'TECNOTRAMIT GESTION SL.', '138'),
         T_TIPO_DATA('GTOCED', '7', '', '2', '17', '', '', 'tecnotra04', 'TECNOTRAMIT GESTION SL.', '138'),
         T_TIPO_DATA('GTOCED', '7', '', '2', '25', '', '', 'tecnotra04', 'TECNOTRAMIT GESTION SL.', '138'),
         T_TIPO_DATA('GTOCED', '7', '', '2', '44', '', '', 'tecnotra04', 'TECNOTRAMIT GESTION SL.', '138'),
         T_TIPO_DATA('GTOCED', '7', '', '2', '43', '', '', 'tecnotra04', 'TECNOTRAMIT GESTION SL.', '138'),
         T_TIPO_DATA('GTOCED', '7', '', '2', '31', '', '', 'ogf04', 'OFICINA DE GESTION DE FIRMAS SL', '138')


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
	IF (V_TMP_TIPO_DATA(6) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
        END IF;
        			
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', '''||TRIM(V_TMP_TIPO_DATA(9))||''' '||
						', 0, '''||V_USU||''',SYSDATE, 0, '''||TRIM(V_TMP_TIPO_DATA(10))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
        
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
