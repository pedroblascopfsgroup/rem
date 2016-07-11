--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160421
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de Usuarios REM
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


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
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);

  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	--T_TIPO_DATA('1','GESTACT' ,'Pintor32', 'Gestor del activo', '', '', '', '1'),
	T_TIPO_DATA('1','A164878' ,'Pintor32', 'SARA', 'ARAGÓN', 'GUTIÉRREZ', 'saragon@haya.es', '0'),
	T_TIPO_DATA('1','A164892' ,'Pintor32', 'BELEN', 'BAVIERA', 'GARCÍA', 'bbaviera@haya.es', '0'),
	T_TIPO_DATA('1','A164740' ,'Pintor32', 'JOSÉ', 'BERENGUER', 'ALEIXANDRE', 'jberenguer@haya.es', '0'),
	T_TIPO_DATA('1','MR001' ,'Pintor32', 'MARÍA DOLORES', 'CANTON', 'SOLBAS', 'mcanton@haya.es', '0'),
	T_TIPO_DATA('1','MR002' ,'Pintor32', 'MARÍA DEL ROSARIO', 'CASELLES', 'HERNÁNDEZ', 'mcaselles@haya.es', '0'),
	T_TIPO_DATA('1','A158377' ,'Pintor32', 'ALBERTO', 'CUERPO', 'ROMERO', 'acuerpo@haya.es', '0'),
	T_TIPO_DATA('1','MR003' ,'Pintor32', 'NURIA', 'DE LA OSSA', 'MONTALBAN', 'ndelaossa@haya.es', '0'),
	T_TIPO_DATA('1','A164755' ,'Pintor32', 'RAFAEL', 'DOMINGUEZ', 'LEÓN', 'rdl@haya.es', '0'),
	T_TIPO_DATA('1','A136655' ,'Pintor32', 'RAÚL', 'DURÁ', 'GARCÉS', 'rdura@haya.es', '0'),
	T_TIPO_DATA('1','MR004' ,'Pintor32', 'MARÍA DEL MAR', 'GARCIA', 'DELGADO', 'mgarciade@haya.es', '0'),
	T_TIPO_DATA('1','A166035' ,'Pintor32', 'MARIO ROQUE', 'GODOY', 'ROSARIO', 'mgodoy@haya.es', '0'),
	T_TIPO_DATA('1','MR005' ,'Pintor32', 'ROSA FERNANDA', 'GUIRADO', 'MIRAS', 'rguirado@haya.es', '0'),
	T_TIPO_DATA('1','A166034' ,'Pintor32', 'CARMEN', 'KUHNEL', 'ALEMÁN', 'ckuhnel@haya.es', '0'),
	T_TIPO_DATA('1','A164884' ,'Pintor32', 'JOSE PASCUAL', 'LENGUA', 'VICENTE', 'jlengua@haya.es', '0'),
	T_TIPO_DATA('1','MR006' ,'Pintor32', 'MARÍA JESUS', 'MACIP', 'ABADIA', 'mmacip@haya.es', '0'),
	T_TIPO_DATA('1','A164869' ,'Pintor32', 'ANA MARÍA', 'MEZQUITA', 'LLORENS', 'aml@haya.es', '0'),
	T_TIPO_DATA('1','MR007' ,'Pintor32', 'CRISTINA', 'MOLINA', 'VICENTE', 'cmolina@haya.es', '0'),
	T_TIPO_DATA('1','MR008' ,'Pintor32', 'MARÍA CARMEN', 'MORALES', 'ARISTEGUI', 'cmorales@haya.es', '0'),
	T_TIPO_DATA('1','A121643' ,'Pintor32', 'GABRIELA', 'MORENO', 'MARTÍN', 'gmoreno@haya.es', '0'),
	T_TIPO_DATA('1','MR009' ,'Pintor32', 'PURIFICACIÓN', 'MORUNO', 'CASTILLO', 'pmoruno@haya.es', '0'),
	T_TIPO_DATA('1','A166039' ,'Pintor32', 'JOSE LUIS', 'PELAZ', 'GÓMEZ', 'jlpelaz@externos.bankiahabitat.es', '0'),
	T_TIPO_DATA('1','MR010' ,'Pintor32', 'MARÍA', 'PEREZ', 'ALONSO', 'mperez@haya.es', '0'),
	T_TIPO_DATA('1','A137949' ,'Pintor32', 'ANTONIO', 'RUIZ', 'ÁVILA', 'aruiza@haya.es', '0'),
	T_TIPO_DATA('1','A141178' ,'Pintor32', 'IRENE', 'TAVERA', 'ALONSO', 'itavera@haya.es', '0'),
	T_TIPO_DATA('1','A108677' ,'Pintor32', 'JAVIER', 'CANOVAS', 'ADAN', 'jcanovas@haya.es', '0'),--supervisor gestor activo
	T_TIPO_DATA('1','A121298' ,'Pintor32', 'ANTONIO', 'MARTINEZ', 'BERZOSA', 'amartinezb@haya.es', '0'),--supervisor gestor activo
	T_TIPO_DATA('1','A166036' ,'Pintor32', 'NATALIA', 'HORCAJO', 'GAVIRA', 'nhorcajo@haya.es', '0'),--supervisor gestor activo
	T_TIPO_DATA('1','MR011' ,'Pintor32', 'BEATRIZ', 'RUIZ', 'FUENTES', 'bruiz@haya.es', '0'),--supervisor gestor activo
	T_TIPO_DATA('1','MR012' ,'Pintor32', 'CARMEN MARÍA', 'SERRANO', 'MORALES', 'cserrano@haya.es', '0'),--supervisor gestor activo
	T_TIPO_DATA('1','GESTADM' ,'Pintor32', 'Gestor de admisión', '', '', '', '1'),
	T_TIPO_DATA('1','MR013' ,'Pintor32', 'NADIA', 'FERNANDEZ', 'SERRANO', 'nfernandezs@haya.es', '0'),--gestores admision
	T_TIPO_DATA('1','MR014' ,'Pintor32', 'MAITE', 'MONTANER', 'GARCIA', 'mmontaner@haya.es', '0'),--gestores admision
	T_TIPO_DATA('1','SUPER' ,'Pintor32', 'Super Administrador', '', '', '', '1'),
	T_TIPO_DATA('1','MR015' ,'Pintor32', 'JUAN FRANCISCO', 'POYATOS', 'ÁLVAREZ', 'jpoyatos@haya.es', '0'),--super-usuario
	T_TIPO_DATA('1','MR016' ,'Pintor32', 'CARMEN', 'COMPANY', 'PERIS', 'ccompany@haya.es', '0'),--super-usuario
	T_TIPO_DATA('1','MR017' ,'Pintor32', 'HECTOR', 'VÍCTOR', 'RODERO', 'hvictor@haya.es', '0'),--super-usuario
	T_TIPO_DATA('1','SUPADM' ,'Pintor32', 'Supervisor de admisión', '', '', '', '1'),
	T_TIPO_DATA('1','MR018' ,'Pintor32', 'MARÍA DEL CARMEN', 'MORANDEIRA', 'GUERRERO', 'mmorandeira@haya.es', '0'),--supervisor admision
	T_TIPO_DATA('1','SUPACT' ,'Pintor32', 'Supervisor del activo', '', '', '', '0'),
	T_TIPO_DATA('1','MR019' ,'Pintor32', 'LAURA', 'FABE', 'HERNANDEZ', 'ifabe@haya.es', '0'),--supervisor gestor activo
	--T_TIPO_DATA('1','HIPOSERVI' ,'Pintor32', 'ALBERTO', 'URGUIZA', '', 'albertourquiza@hiposervi.com', '0'),
	T_TIPO_DATA('1','OGF' ,'Pintor32', 'IRENE', 'SARDINERO', '', 'isardinero@grupogf.es', '0'),
	T_TIPO_DATA('1','TECTRAMIT' ,'Pintor32', 'VERÓNICA', 'BEDIA', 'GARCÍA', 'veronica.bedia@tecnotramit.com', '0'),
	T_TIPO_DATA('1','TINSA' ,'Pintor32', 'TINSA CERTIFY', '', '', 'pruebashrem@gmail.com', '0'),
	T_TIPO_DATA('1','MR020' ,'Pintor32', 'HECTOR', 'GIMENEZ', 'BEA', '', '0')
  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


 
   -- LOOP para insertar los valores en USU_USUARIOS -----------------------------------------------------------------
   DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USU_USUARIOS ');
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       --Comprobamos el dato a insertar
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe lo modificamos
       IF V_NUM_TABLAS > 0 THEN				         
			
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USU_USUARIOS...no se modifica nada.');
			
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
        
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_USU_USUARIOS.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.USU_USUARIOS (' ||
                      'USU_ID,
                       ENTIDAD_ID,
                       USU_USERNAME,
                       USU_PASSWORD,
                       USU_NOMBRE,
                       USU_APELLIDO1,
				       USU_APELLIDO2,
                       USU_MAIL,
                       USU_GRUPO,
                       USU_FECHA_VIGENCIA_PASS,
                       USUARIOCREAR,
                       FECHACREAR,
                       BORRADO) ' ||
                      'SELECT '|| V_ID || ',
                      '''||V_TMP_TIPO_DATA(1)||''',
                      '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(5))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(6))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(7))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(8))||''',
                      SYSDATE+730,
                      ''DML'',
                      SYSDATE,
                      0 
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      
       END IF;
       
    END LOOP;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: USU_USUARIOS ACTUALIZADO CORRECTAMENTE ');
 

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
