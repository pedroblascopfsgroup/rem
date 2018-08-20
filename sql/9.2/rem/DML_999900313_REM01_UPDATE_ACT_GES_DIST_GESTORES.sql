--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20180820
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1397
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de gestores de bankia
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
    --TIPO_GESTOR, NOMBRE_USUARIO, COD_PROVINCIA, COD_CARTERA, USERNAME
    	T_TIPO_DATA('GFORM','Alba Campos','51','03','acampos'),
	T_TIPO_DATA('GFORM','Alba Campos','28','03', 'acampos'),
	T_TIPO_DATA('GFORM','Alba Campos','52','03', 'acampos'),
	T_TIPO_DATA('GFORM','JULIO ENRIQUE CARBONELL MORA  ','3','03', 'jcarbonellm'),
	T_TIPO_DATA('GFORM','JULIO ENRIQUE CARBONELL MORA  ','12','03', 'jcarbonellm'),
	T_TIPO_DATA('GFORM','JULIO ENRIQUE CARBONELL MORA  ','46','03', 'jcarbonellm'),
	T_TIPO_DATA('GIAFORM','GUTIERREZ-LABRADOR, S.L.','52','03','gl03'),
	T_TIPO_DATA('GIAFORM','GESTORIA MONTALVO, S.L.P.','5','03', 'montalvo03'),
	T_TIPO_DATA('GIAFORM','GESTORES ADMINISTRATIVOS REUNIDOS SAE','7','03','garsa03'),
	T_TIPO_DATA('GIAFORM','GESTORIA MONTALVO, S.L.P.','9','03','montalvo03'),
	T_TIPO_DATA('GIAFORM','GESTORES ADMINISTRATIVOS REUNIDOS SAE','35','03','garsa03'),
	T_TIPO_DATA('GIAFORM','GESTORIA MONTALVO, S.L.P.','24','03','montalvo03'),
	T_TIPO_DATA('GIAFORM','GESTORIA MONTALVO, S.L.P.','34','03','montalvo03'),
	T_TIPO_DATA('GIAFORM','GESTORIA MONTALVO, S.L.P.','37','03','montalvo03'),
	T_TIPO_DATA('GIAFORM','GESTORES ADMINISTRATIVOS REUNIDOS SAE','38','03','garsa03'),
	T_TIPO_DATA('GIAFORM','GESTORIA MONTALVO, S.L.P.','40','03','montalvo03'),
	T_TIPO_DATA('GIAFORM','GESTORIA MONTALVO, S.L.P.','42','03','montalvo03'),
	T_TIPO_DATA('GIAFORM','GESTORIA MONTALVO, S.L.P.','47','03','montalvo03'),
	T_TIPO_DATA('GIAFORM','GESTORIA MONTALVO, S.L.P.','49','03','montalvo03')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_GES_DIST_GESTORES] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES GES
					WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
					' AND USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND NOMBRE_USUARIO != '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' ';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN		

			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL GESTOR DE FORMALIZACIÓN DE BANKIA EN LA ACT_GES_DIST_GESTORES');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES
					SET NOMBRE_USUARIO = '||TRIM(V_TMP_TIPO_DATA(2))||',
					    USUARIOMODIFICAR = ''REMVIP-1397'',
					    FECHAMODIFICAR = SYSDATE
					    WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					    ' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
					    ' AND USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					    ' AND NOMBRE_USUARIO != '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					    ' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' ';
			EXECUTE IMMEDIATE V_MSQL;
			

			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE EL GESTOR '''||TRIM(V_TMP_TIPO_DATA(1))||' , '||TRIM(V_TMP_TIPO_DATA(2))||' , 
						'||TRIM(V_TMP_TIPO_DATA(3))||' , '||TRIM(V_TMP_TIPO_DATA(4))||''' EN ACT_GES_DIST_GESTORES ');
			
		--El gestor no existe
		ELSE
			  DBMS_OUTPUT.PUT_LINE('[INFO]: GESTOR '''||TRIM(V_TMP_TIPO_DATA(1))||' , '||TRIM(V_TMP_TIPO_DATA(2))||' , '||TRIM(V_TMP_TIPO_DATA(3))||' , 
						'||TRIM(V_TMP_TIPO_DATA(4))||''' NO ACTUALIZADO');
		END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_GES_DIST_GESTORES ACTUALIZADA CORRECTAMENTE ');
   

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


