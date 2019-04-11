--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20190404
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3870
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
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-3870';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		
         T_TIPO_DATA('SUPACT', '7', '', '', '1', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '2', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '3', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '4', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '5', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '6', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '7', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '8', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '9', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '10', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '11', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '12', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '13', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '14', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '15', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '16', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '17', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '18', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '19', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '20', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '21', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '22', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '23', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '24', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '25', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '26', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '27', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '28', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '29', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '30', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '31', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '32', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '33', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '34', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '35', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '36', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '37', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '38', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '39', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '40', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '41', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '42', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '43', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '44', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '45', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '46', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '47', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '48', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '49', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '50', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '51', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SUPACT', '7', '', '', '52', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '1', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '2', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '3', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '4', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '5', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '6', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '7', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '8', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '9', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '10', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '11', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '12', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '13', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '14', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '15', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '16', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '17', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '18', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '19', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '20', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '21', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '22', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '23', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '24', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '25', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '26', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '27', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '28', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '29', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '30', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '31', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '32', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '33', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '34', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '35', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '36', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '37', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '38', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '39', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '40', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '41', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '42', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '43', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '44', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '45', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '46', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '47', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '48', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '49', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '50', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '51', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138'),
         T_TIPO_DATA('SPUBL', '7', '', '', '52', '', '', 'manpuapple', 'Grupo gestor mantenimiento y publicaciones Apple', '138')
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
