--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160422
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
	--T_TIPO_DATA('1','GESTACT' ,'Pintor32', 'Gestor del activo', '', '', '', '1'),
	T_TIPO_DATA('1','GESTADM' ,'Pintor32', 'Gestor de admisión', '', '', '', '1'),
	T_TIPO_DATA('1','SUPER' ,'Pintor32', 'Super Administrador', '', '', '', '1'),
	T_TIPO_DATA('1','SUPADM' ,'Pintor32', 'Supervisor de admisión', '', '', '', '1'),
	T_TIPO_DATA('1','SUPACT' ,'Pintor32', 'Supervisor del activo', '', '', '', '0'),
	--T_TIPO_DATA('1','HIPOSERVI' ,'Pintor32', 'ALBERTO', 'URGUIZA', '', 'albertourquiza@hiposervi.com', '0'),
	T_TIPO_DATA('1','TECTRAMIT' ,'Pintor32', 'VERÓNICA', 'BEDIA', 'GARCÍA', 'veronica.bedia@tecnotramit.com', '0'),
	T_TIPO_DATA('1','TINSA' ,'Pintor32', 'TINSA CERTIFY', '', '', 'pruebashrem@gmail.com', '0'),
	T_TIPO_DATA('1','saragon','ah1m45','SARA','ARAGÓN','GUTIÉRREZ','saragon@haya.es','0'),
	T_TIPO_DATA('1','bbaviera','bi3n25','BELEN','BAVIERA','GARCÍA','bbaviera@haya.es','0'),
	T_TIPO_DATA('1','tecnotrami','cj4o29','VERÓNICA','BEDIA','GARCÍA','veronica.bedia@tecnotramit.com','0'),
	T_TIPO_DATA('1','jberenguer','dk4p10','JOSÉ','BERENGUER','ALEIXANDRE','jberenguer@haya.es','0'),
	T_TIPO_DATA('1','jcanovas','el8q87','JAVIER','CANOVAS','ADAN','jcanovas@haya.es','0'),--supervisor gestor activo
	T_TIPO_DATA('1','mcanton','fm6r08','MARÍA DOLORES','CANTON','SOLBAS','mcanton@haya.es','0'),
	T_TIPO_DATA('1','mcaselles','gn0s63','MARÍA DEL ROSARIO','CASELLES','HERNÁNDEZ','mcaselles@haya.es','0'),
	T_TIPO_DATA('1','ccompany','ho7t96','CARMEN','COMPANY','PERIS','ccompany@haya.es','0'),--super-usuario
	T_TIPO_DATA('1','acuerpo','ip4v57','ALBERTO','CUERPO','ROMERO','acuerpo@haya.es','0'),
	T_TIPO_DATA('1','ndelaossa','jq5w13','NURIA','DE LA OSSA','MONTALBAN','ndelaossa@haya.es','0'),
	T_TIPO_DATA('1','rdl','kr8x25','RAFAEL','DOMINGUEZ','LEÓN','rdl@haya.es','0'),
	T_TIPO_DATA('1','rdura','ls1y52','RAÚL','DURÁ','GARCÉS','rdura@haya.es','0'),
	T_TIPO_DATA('1','lfabe','mt4z24','LAURA','FABE','HERNANDEZ','lfabe@haya.es','0'),--supervisor gestor activo
	T_TIPO_DATA('1','nfernandez','nv5a00','NADIA','FERNANDEZ','SERRANO','nfernandezs@haya.es','0'),--gestores admision
	T_TIPO_DATA('1','mgarciade','ow2b26','MARÍA DEL MAR','GARCIA','DELGADO','mgarciade@haya.es','0'),
	T_TIPO_DATA('1','hgimenez','px9c67','HECTOR','GIMENEZ','BEA','hgimenez@haya.es','0'),
	T_TIPO_DATA('1','mgodoy','qy7d42','MARIO ROQUE','GODOY','ROSARIO','mgodoy@haya.es','0'),
	T_TIPO_DATA('1','rguirado','rz2e28','ROSA FERNANDA','GUIRADO','MIRAS','rguirado@haya.es','0'),
	T_TIPO_DATA('1','nhorcajo','sa5f21','NATALIA','HORCAJO','GAVIRA','nhorcajo@haya.es','0'),--supervisor gestor activo
	T_TIPO_DATA('1','ckuhnel','tb8g09','CARMEN','KUHNEL','ALEMÁN','ckuhnel@haya.es','0'),
	T_TIPO_DATA('1','jlengua','vc6h57','JOSE PASCUAL','LENGUA','VICENTE','jlengua@haya.es','0'),
	T_TIPO_DATA('1','mmacip','wd1i24','MARÍA JESUS','MACIP','ABADIA','mmacip@haya.es','0'),
	T_TIPO_DATA('1','amartinezb','xe3j76','ANTONIO','MARTINEZ','BERZOSA','amartinezb@haya.es','0'),--supervisor gestor activo
	T_TIPO_DATA('1','aml','yf9k27','ANA MARÍA','MEZQUITA','LLORENS','aml@haya.es','0'),
	T_TIPO_DATA('1','cmolina','zg1l36','CRISTINA','MOLINA','VICENTE','cmolina@haya.es','0'),
	T_TIPO_DATA('1','mmontaner','ah6m31','MAITE','MONTANER','GARCIA','mmontaner@haya.es','0'),--gestores admision
	T_TIPO_DATA('1','cmorales','bi8n83','MARÍA CARMEN','MORALES','ARISTEGUI','cmorales@haya.es','0'),
	T_TIPO_DATA('1','morandeira','cj3o99','MARÍA DEL CARMEN','MORANDEIRA','GUERRERO','mmorandeira@haya.es','0'),--supervisor admision
	T_TIPO_DATA('1','gmoreno','dk4p82','GABRIELA','MORENO','MARTÍN','gmoreno@haya.es','0'),
	T_TIPO_DATA('1','pmoruno','el0q40','PURIFICACIÓN','MORUNO','CASTILLO','pmoruno@haya.es','0'),
	T_TIPO_DATA('1','jlpelaz','fm6r17','JOSE LUIS','PELAZ','GÓMEZ','jlpelaz@haya.es','0'),
	T_TIPO_DATA('1','mperez','gn8s11','MARÍA','PEREZ','ALONSO','mperez@haya.es','0'),
	T_TIPO_DATA('1','jpoyatos','ho1t41','JUAN FRANCISCO','POYATOS','ÁLVAREZ','jpoyatos@haya.es','0'),--super-usuario
	T_TIPO_DATA('1','aruiza','ip1v09','ANTONIO','RUIZ','ÁVILA','aruiza@haya.es','0'),
	T_TIPO_DATA('1','bruiz','jq0w29','BEATRIZ','RUIZ','FUENTES','bruiz@haya.es','0'),--supervisor gestor activo
	T_TIPO_DATA('1','ogf','kr3x93','IRENE','SARDINERO','','isardinero@grupogf.es','0'),
	T_TIPO_DATA('1','cserrano','ls0y42','CARMEN MARÍA','SERRANO','MORALES','cserrano@haya.es','0'),--supervisor gestor activo
	T_TIPO_DATA('1','itavera','mt5z01','IRENE','TAVERA','ALONSO','itavera@haya.es','0'),
	T_TIPO_DATA('1','hvictor','nv1a12','HECTOR','VÍCTOR','RODERO','hvictor@haya.es','0'),--super-usuario
	T_TIPO_DATA('1','bizquierdo','ow9b35','BORJA','IZQUIERDO','JIMÉNEZ','bizquierdo@haya.es','0'),
	T_TIPO_DATA('1','adesco','px4c47','AMPARO','DESCO','DURA','adesco@haya.es','0'),
	T_TIPO_DATA('1','jortega','qy0d35','JESSICA','ORTEGA','GIL','jortega@haya.es','0'),
	T_TIPO_DATA('1','ccf','rz4e69','JUAN CARLOS','CRISTIA','FEMENIA','ccf@haya.es','0'),
	T_TIPO_DATA('1','mle','sa7f46','CARMEN','LLAMAS','ELVIRA','mle@haya.es','0'),
	T_TIPO_DATA('1','mriquelme','tb1g56','MARIA ELENA','RIQUELME','LOPEZ','mriquelme@haya.es','0'),
	T_TIPO_DATA('1','mmartinm','vc6h70','MARIANO','MARTIN','MATILLA','mmartinm@haya.es','0'),
	T_TIPO_DATA('1','ollorca','wd1i57','OSCAR','LLORCA','LOPEZ','ollorca@haya.es','0'),
	T_TIPO_DATA('1','osalazar','xe3j49','OSCAR','SALAZAR','PARDO','osalazar@haya.es','0'),
	T_TIPO_DATA('1','ssalcedo','yf0k69','SORAYA','SALCEDO','JIMENEZ','ssalcedo@haya.es','0'),
	T_TIPO_DATA('1','vgl','zg1l45','VICKY','GARCIA','LLISTO','vgl@haya.es','0')
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
