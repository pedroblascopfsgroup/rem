--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12615
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_GES_DIST_GESTORES los datos añadidos en T_ARRAY_DATA
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.	

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
	V_NUM_REGISTROS NUMBER(16):= 0; -- Vble. para contabilizar los registros afectados.
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-12615';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (		
    	-- TGE (1) | CRA(2) | EAC(3) | TCR(4) | PRV(5) | LOC(6) | POSTAL(7) | USERNAME(8)   	
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualor','01','02',null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualores','01','01',null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualores','01','03',null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualores','01','04',null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualores','01','05',null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualores','01','06',null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualores','01','07',null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualores','01','08',null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualores','01','09',null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','03',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','07',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','08',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','09',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','10',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','11',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','12',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','13',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','14',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','15',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','16',null,null),
		T_TIPO_DATA('GESTCOMALQ', '16', '', '', null, '', '', 'grualfoso','17',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'iplaza','01',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'iplaza','02',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'iplaza','04',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'iplaza','05',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','03',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','07',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','08',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','09',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','10',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','11',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','12',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','13',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','14',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','15',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','16',null,null),
		T_TIPO_DATA('GALQ', '16', '', '', null, '', '', 'ext.avazquez','17',null,null),		
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','01',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','02',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','04',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','05',null,null),		
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','03',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','07',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','08',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','09',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','10',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','11',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','12',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','13',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','14',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','15',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','16',null,null),
		T_TIPO_DATA('SUALQ', '16', '', '', null, '', '', 'vhernandezi','17',null,null)
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

        IF (V_TMP_TIPO_DATA(4) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(4))||''' ';
        END IF;
        IF (V_TMP_TIPO_DATA(6) is not null) THEN
			V_COND2 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
        END IF; 		
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  '||V_COND1||' '||
					' AND COD_MUNICIPIO '||V_COND2||' '||
					' AND COD_POSTAL IS NULL ' ||
					' AND TIPO_ACTIVO IS NULL ' ||
					' AND SUBTIPO_ACTIVO IS NULL ' ||
					' AND TIPO_ALQUILER IS NULL';
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
					' AND COD_MUNICIPIO '||V_COND2||' '||
					' AND COD_POSTAL IS NULL 
					 AND TIPO_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(10))||''' '|| 
					' AND SUBTIPO_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(11))||''' '|| 
					' AND TIPO_ALQUILER = '''||TRIM(V_TMP_TIPO_DATA(9))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA  '''|| TRIM(V_TMP_TIPO_DATA(8)) ||''' COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
          
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, TIPO_ALQUILER, TIPO_ACTIVO,SUBTIPO_ACTIVO,VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', '''||TRIM(V_TMP_TIPO_DATA(9))||''','''||TRIM(V_TMP_TIPO_DATA(10))||''','''||TRIM(V_TMP_TIPO_DATA(11))||''',0, '''||V_USU||''',SYSDATE, 0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA '''|| TRIM(V_TMP_TIPO_DATA(8)) ||''' COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
        
       END IF;
	   V_NUM_REGISTROS :=  V_NUM_REGISTROS + sql%rowcount;
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS AFECTADOS: ' || V_NUM_REGISTROS);
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
