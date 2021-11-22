--/*
--##########################################
--## AUTOR=Julian Dolz
--## FECHA_CREACION=20211028
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15600
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ZON_PEF_USU los datos añadidos en T_ARRAY_FUNCION.
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

    V_TEXT1 VARCHAR2(2400 CHAR):= 'USUARIOS_BC'; -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    --			UUS_MAIL			CODIGO PERFIL
	T_FUNCION('bkaiser@buildingcenter.es'),
	T_FUNCION('maquintana@buildingcenter.es'),
	T_FUNCION('dcozar@buildingcenter.es'),
	T_FUNCION('mgracia@buildingcenter.es'),
	T_FUNCION('gaparicio@buildingcenter.es'),
	T_FUNCION('cotano@buildingcenter.es'),
	T_FUNCION('biglesias@buildingcenter.es'),
	T_FUNCION('dalfonso@buildingcenter.es'),
	T_FUNCION('Jhuarte@buildingcenter.es'),
	T_FUNCION('xcasas@buildingcenter.es'),
	T_FUNCION('ecipres@buildingcenter.es'),
	T_FUNCION('sprados@buildingcenter.es'),
	T_FUNCION('igarcia@buildingcenter.es'),
	T_FUNCION('m.serra@buildingcenter.es'),
	T_FUNCION('dserrano@buildingcenter.es'),
	T_FUNCION('jmunoz@buildingcenter.es'),
	T_FUNCION('scardona@buildingcenter.es'),
	T_FUNCION('ccarreno@buildingcenter.es'),
	T_FUNCION('Mmelendez@buildingcenter.es'),
	T_FUNCION('anavarro@buildingcenter.es'),
	T_FUNCION('ccabrera@buildingcenter.es'),
	T_FUNCION('mnogueras@buildingcenter.es'),
	T_FUNCION('sdiez@buildingcenter.es'),
	T_FUNCION('jarceda@buildingcenter.es'),
	T_FUNCION('bduarte@buildingcenter.es'),
	T_FUNCION('jacosta@buildingcenter.es'),
	T_FUNCION('mbastidas@buildingcenter.es'),
	T_FUNCION('dcastro@buildingcenter.es'),
	T_FUNCION('jgonzalezgu@buildingcenter.es'),
	T_FUNCION('sgonzalezg@buildingcenter.es'),
	T_FUNCION('ohita@buildingcenter.es'),
	T_FUNCION('cibanez@buildingcenter.es'),
	T_FUNCION('xdelatorriente@buildingcenter.es'),
	T_FUNCION('jmartin@buildingcenter.es'),
	T_FUNCION('dfigueras@buildingcenter.es'),
	T_FUNCION('lcosta@buildingcenter.es'),
	T_FUNCION('bbarrau@buildingcenter.es'),
	T_FUNCION('xalert@buildingcenter.es'),
	T_FUNCION('malins@buildingcenter.es'),
	T_FUNCION('lgarriga@buildingcenter.es'),
	T_FUNCION('hborge@buildingcenter.es'),
	T_FUNCION('pparra@buildingcenter.es'),
	T_FUNCION('gbarcelo@buildingcenter.es'),
	T_FUNCION('amontoro@buildingcenter.es'),
	T_FUNCION('rtejada@buildingcenter.es'),
	T_FUNCION('emoreno@buildingcenter.es'),
	T_FUNCION('esameno@buildingcenter.es'),
	T_FUNCION('smoreno@buildingcenter.es'),
	T_FUNCION('rgarcia@buildingcenter.es'),
	T_FUNCION('pperez@buildingcenter.es'),
	T_FUNCION('parmas@buildingcenter.es'),
	T_FUNCION('ipont@buildingcenter.es'),
	T_FUNCION('erisoto@buildingcenter.es'),
	T_FUNCION('smurtra@buildingcenter.es'),
	T_FUNCION('jguigou@buildingcenter.es'),
	T_FUNCION('egambon@buildingcenter.es'),
	T_FUNCION('atejedor@buildingcenter.es'),
	T_FUNCION('cbernal@buildingcenter.es'),
	T_FUNCION('jgarciaa@buildingcenter.es'),
	T_FUNCION('cmartinez@buildingcenter.es'),
	T_FUNCION('jgiralt@buildingcenter.es'),
	T_FUNCION('rtorres@buildingcenter.es'),
	T_FUNCION('dcasals@buildingcenter.com'),
	T_FUNCION('acalderon@buildingcenter.es'),
	T_FUNCION('abrunet@buildingcenter.es'),
	T_FUNCION('angel.m.perez@caixabank.com'),
	T_FUNCION('angel.navarro@caixabank.com'),
	T_FUNCION('araceli.garcia.t@caixabank.com'),
	T_FUNCION('dchulani@buildingcenter.es'),
	T_FUNCION('fcabrera@buildingcenter.es'),
	T_FUNCION('fmaeso@caixabank.com'),
	T_FUNCION('fruz@buildingcenter.es'),
	T_FUNCION('ggual@buildingcenter.es'),
	T_FUNCION('jmunozla@buildingcenter.es'),
	T_FUNCION('jcarreto@buildingcenter.es'),
	T_FUNCION('jgarciag@buildingcenter.es'),
	T_FUNCION('lperez@buildingcenter.es'),
	T_FUNCION('mbeltran@buildingcenter.es'),
	T_FUNCION('maria.concepcion.sanchez@caixabank.com'),
	T_FUNCION('mmarquez@buildingcenter.es'),
	T_FUNCION('mcambronero@buildingcenter.es'),
	T_FUNCION('mcaceres@buildingcenter.es'),
	T_FUNCION('mabadia@buildingcenter.es'),
	T_FUNCION('mbarroso@buildingcenter.es'),
	T_FUNCION('ocappa@buildingcenter.es'),
	T_FUNCION('operena@buildingcenter.es'),
	T_FUNCION('portega@buildingcenter.es'),
	T_FUNCION('rserrano@buildingcenter.es'),
	T_FUNCION('roberto.garcia.j@caixabank.com'),
	T_FUNCION('sserrano@caixabank.com'),
	T_FUNCION('smarina@buildingcenter.es'),
	T_FUNCION('smata@buildingcenter.es'),
	T_FUNCION('xalert@buildingcenter.es'),
	T_FUNCION('icobo@axiscorporate.com'),
	T_FUNCION('jmonge@axiscorporate.com'),
	T_FUNCION('diaz@axiscorporate.com'),
	T_FUNCION('jvteixeira@axiscorporate.com'),
	T_FUNCION('aroig@buildingcenter.es'),
	T_FUNCION('tgarciamachinena@buildingcenter.es')
	  

    );
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '%'; 
    V_MSQL_1 VARCHAR2(4000 CHAR);

BEGIN	        

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ZON_PEF_USU] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
            
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_MAIL = '''||TRIM(V_TMP_FUNCION(1))||''' ';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] El usuario con correo '''||TRIM(V_TMP_FUNCION(1))||''' no existe.');

			ELSE

				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE PEF_ID = 
							(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TEXT1)||''') 
								AND USU_ID = 
									(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_MAIL = '''||TRIM(V_TMP_FUNCION(1))||''')';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

				IF V_NUM_TABLAS > 0 THEN	  
					DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ZON_PEF_USU...no se modifica nada.');

				ELSE
					V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU' ||
								' (ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
								' SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
								' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),' ||
								' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TEXT1)||'''),' ||
								' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_MAIL = '''||TRIM(V_TMP_FUNCION(1))||'''),' ||
								' ''HREOS-15600'',SYSDATE,0 FROM DUAL';
			    	
					EXECUTE IMMEDIATE V_MSQL_1;
					DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.ZON_PEF_USU insertados correctamente.');
					
		    		END IF;
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: PEF_PERFILES ACTUALIZADO CORRECTAMENTE ');


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
