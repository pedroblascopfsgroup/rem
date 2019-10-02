--/*
--###########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5273
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAR AUX USUARIOS Y USU_USUARIOS
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-5273';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	        T_TIPO_DATA('B87105821','usuario_borrado.1'),
		T_TIPO_DATA('B98562036','usuario_borrado.2'),
		T_TIPO_DATA('B82450727','usuario_borrado.3'),
		T_TIPO_DATA('B98306012','usuario_borrado.4'),
		T_TIPO_DATA('21430198V','usuario_borrado.5'),
		T_TIPO_DATA('22518378K','usuario_borrado.6'),
		T_TIPO_DATA('B58409269','usuario_borrado.7'),
		T_TIPO_DATA('B66610239','usuario_borrado.8'),
		T_TIPO_DATA('B35921642','usuario_borrado.9'),
		T_TIPO_DATA('B85736023','usuario_borrado.10'),
		T_TIPO_DATA('B26459560','usuario_borrado.11'),
		T_TIPO_DATA('B96818828','usuario_borrado.12'),
		T_TIPO_DATA('J82522061','usuario_borrado.13'),
		T_TIPO_DATA('J64395726','usuario_borrado.14'),
		T_TIPO_DATA('B85752905','usuario_borrado.15'),
		T_TIPO_DATA('B85345452','usuario_borrado.16'),
		T_TIPO_DATA('B63899660','usuario_borrado.17'),
		T_TIPO_DATA('B72265986','usuario_borrado.18'),
		T_TIPO_DATA('B98020001','usuario_borrado.19'),
		T_TIPO_DATA('B93115921','usuario_borrado.20'),
		T_TIPO_DATA('B90107731','usuario_borrado.21'),
		T_TIPO_DATA('B86880127','usuario_borrado.22'),
		T_TIPO_DATA('B84105899','usuario_borrado.23'),
		T_TIPO_DATA('A79222709','usuario_borrado.24'),
		T_TIPO_DATA('B80463565','usuario_borrado.25'),
		T_TIPO_DATA('B91703777','usuario_borrado.26'),
		T_TIPO_DATA('05239632V','usuario_borrado.27'),
		T_TIPO_DATA('B82270240','usuario_borrado.28'),
		T_TIPO_DATA('B46635991','usuario_borrado.29'),
		T_TIPO_DATA('E07306210','usuario_borrado.30'),
		T_TIPO_DATA('B65428583','usuario_borrado.31'),
		T_TIPO_DATA('B04466256','usuario_borrado.32'),
		T_TIPO_DATA('B04405403','usuario_borrado.33'),
		T_TIPO_DATA('B61425682','usuario_borrado.34'),
		T_TIPO_DATA('J04678785','usuario_borrado.35'),
		T_TIPO_DATA('B04254793','usuario_borrado.36'),
		T_TIPO_DATA('A54496005','usuario_borrado.37'),
		T_TIPO_DATA('B57657207','usuario_borrado.38'),
		T_TIPO_DATA('B24503245','usuario_borrado.39'),
		T_TIPO_DATA('11814281D','usuario_borrado.40'),
		T_TIPO_DATA('29193980B','usuario_borrado.41'),
		T_TIPO_DATA('02715571F','usuario_borrado.42'),
		T_TIPO_DATA('02251334W','usuario_borrado.43'),
		T_TIPO_DATA('52086132X','usuario_borrado.44'),
		T_TIPO_DATA('51935765V','usuario_borrado.45'),
		T_TIPO_DATA('08938380M','usuario_borrado.46'),
		T_TIPO_DATA('51621412M','usuario_borrado.47'),
		T_TIPO_DATA('01922998Z','usuario_borrado.48'),
		T_TIPO_DATA('50834347T','usuario_borrado.49'),
		T_TIPO_DATA('51903049F','usuario_borrado.50'),
		T_TIPO_DATA('07472312A','usuario_borrado.51'),
		T_TIPO_DATA('02912870N','usuario_borrado.52'),
		T_TIPO_DATA('11827176R','usuario_borrado.53'),
		T_TIPO_DATA('B46786141','usuario_borrado.54'),
		T_TIPO_DATA('B53580643','usuario_borrado.55'),
		T_TIPO_DATA('B78077070','usuario_borrado.56'),
		T_TIPO_DATA('B46994737','usuario_borrado.57'),
		T_TIPO_DATA('E04711990','usuario_borrado.58'),
		T_TIPO_DATA('B73156424','usuario_borrado.59'),
		T_TIPO_DATA('B04336301','usuario_borrado.60'),
		T_TIPO_DATA('73760763Q','usuario_borrado.61'),
		T_TIPO_DATA('B04264982','usuario_borrado.62'),
		T_TIPO_DATA('B04506614','usuario_borrado.63'),
		T_TIPO_DATA('B04697728','usuario_borrado.64'),
		T_TIPO_DATA('B53966560','usuario_borrado.65'),
		T_TIPO_DATA('B54624119','usuario_borrado.66'),
		T_TIPO_DATA('A03319530','usuario_borrado.67'),
		T_TIPO_DATA('B92687458','usuario_borrado.68'),
		T_TIPO_DATA('36510931H','usuario_borrado.69'),
		T_TIPO_DATA('B60718533','usuario_borrado.70'),
		T_TIPO_DATA('B65742108','usuario_borrado.71'),
		T_TIPO_DATA('B76094838','usuario_borrado.72'),
		T_TIPO_DATA('B82846825','usuario_borrado.73'),
		T_TIPO_DATA('B85485753','usuario_borrado.74'),
		T_TIPO_DATA('20825171M','usuario_borrado.75'),
		T_TIPO_DATA('G81659781','usuario_borrado.76'),
		T_TIPO_DATA('11834651R','usuario_borrado.77'),
		T_TIPO_DATA('B25623182','usuario_borrado.78'),
		T_TIPO_DATA('B58507575','usuario_borrado.79'),
		T_TIPO_DATA('20812046J','usuario_borrado.80'),
		T_TIPO_DATA('44520007B','usuario_borrado.81'),
		T_TIPO_DATA('B84129592','usuario_borrado.82'),
		T_TIPO_DATA('B85133545','usuario_borrado.83'),
		T_TIPO_DATA('B98198658','usuario_borrado.84'),
		T_TIPO_DATA('B25308131','usuario_borrado.85'),
		T_TIPO_DATA('B73610776','usuario_borrado.86'),
		T_TIPO_DATA('B84385319','usuario_borrado.87'),
		T_TIPO_DATA('B98030398','usuario_borrado.88'),
		T_TIPO_DATA('08038901X','usuario_borrado.89'),
		T_TIPO_DATA('52195408J','usuario_borrado.90'),
		T_TIPO_DATA('09432512M','usuario_borrado.91'),
		T_TIPO_DATA('05428826K','usuario_borrado.92'),
		T_TIPO_DATA('05462299Y','usuario_borrado.93'),
		T_TIPO_DATA('71650202G','usuario_borrado.94'),
		T_TIPO_DATA('50468716T','usuario_borrado.95'),
		T_TIPO_DATA('49023484L','usuario_borrado.96'),
		T_TIPO_DATA('02778491E','usuario_borrado.97'),
		T_TIPO_DATA('08945178H','usuario_borrado.98'),
		T_TIPO_DATA('05426871K','usuario_borrado.99'),
		T_TIPO_DATA('47462005X','usuario_borrado.100'),
		T_TIPO_DATA('52001413T','usuario_borrado.101'),
		T_TIPO_DATA('46876914Q','usuario_borrado.102'),
		T_TIPO_DATA('02295852S','usuario_borrado.103'),
		T_TIPO_DATA('02616729L','usuario_borrado.104'),
		T_TIPO_DATA('08039865P','usuario_borrado.105'),
		T_TIPO_DATA('02790931L','usuario_borrado.106'),
		T_TIPO_DATA('05426070W','usuario_borrado.107'),
		T_TIPO_DATA('20267591Z','usuario_borrado.108'),
		T_TIPO_DATA('05446408P','usuario_borrado.109'),
		T_TIPO_DATA('24258785H','usuario_borrado.110'),
		T_TIPO_DATA('50460252T','usuario_borrado.111'),
		T_TIPO_DATA('11772162A','usuario_borrado.112'),
		T_TIPO_DATA('44602609C','usuario_borrado.113'),
		T_TIPO_DATA('75862982N','usuario_borrado.114'),
		T_TIPO_DATA('29052129R','usuario_borrado.115'),
		T_TIPO_DATA('50102084B','usuario_borrado.116'),
		T_TIPO_DATA('09184389Y','usuario_borrado.117'),
		T_TIPO_DATA('12449131J','usuario_borrado.118'),
		T_TIPO_DATA('B24634198','usuario_borrado.119'),
		T_TIPO_DATA('09422052X','usuario_borrado.120'),
		T_TIPO_DATA('39452196C','usuario_borrado.121'),
		T_TIPO_DATA('43782920M','usuario_borrado.122'),
		T_TIPO_DATA('71662924F','usuario_borrado.123'),
		T_TIPO_DATA('09405641K','usuario_borrado.124'),
		T_TIPO_DATA('11443554L','usuario_borrado.125'),
		T_TIPO_DATA('04191646B','usuario_borrado.126'),
		T_TIPO_DATA('10905685M','usuario_borrado.127'),
		T_TIPO_DATA('71657479J','usuario_borrado.128'),
		T_TIPO_DATA('71767993N','usuario_borrado.129'),
		T_TIPO_DATA('32889264T','usuario_borrado.130'),
		T_TIPO_DATA('07082048F','usuario_borrado.131'),
		T_TIPO_DATA('71662385C','usuario_borrado.132'),
		T_TIPO_DATA('09009254Q','usuario_borrado.133'),
		T_TIPO_DATA('52619172W','usuario_borrado.134'),
		T_TIPO_DATA('71885921L','usuario_borrado.135'),
		T_TIPO_DATA('76942225A','usuario_borrado.136'),
		T_TIPO_DATA('53558001V','usuario_borrado.137'),
		T_TIPO_DATA('10901173R','usuario_borrado.138'),
		T_TIPO_DATA('71772524N','usuario_borrado.139'),
		T_TIPO_DATA('09377263W','usuario_borrado.140'),
		T_TIPO_DATA('71660082V','usuario_borrado.141'),
		T_TIPO_DATA('71649760E','usuario_borrado.142'),
		T_TIPO_DATA('71881241S','usuario_borrado.143'),
		T_TIPO_DATA('36129639V','usuario_borrado.144'),
		T_TIPO_DATA('39426136L','usuario_borrado.145'),
		T_TIPO_DATA('48337882R','usuario_borrado.146'),
		T_TIPO_DATA('51108027A','usuario_borrado.147'),
		T_TIPO_DATA('51107756P','usuario_borrado.148'),
		T_TIPO_DATA('47396225X','usuario_borrado.149'),
		T_TIPO_DATA('78547165A','usuario_borrado.150'),
		T_TIPO_DATA('50734674D','usuario_borrado.151'),
		T_TIPO_DATA('09036524P','usuario_borrado.152'),
		T_TIPO_DATA('28649420E','usuario_borrado.153'),
		T_TIPO_DATA('47224934T','usuario_borrado.154'),
		T_TIPO_DATA('51647662N','usuario_borrado.155'),
		T_TIPO_DATA('36931546D','usuario_borrado.156'),
		T_TIPO_DATA('47294808T','usuario_borrado.157'),
		T_TIPO_DATA('70590549F','usuario_borrado.158'),
		T_TIPO_DATA('24871325E','usuario_borrado.159'),
		T_TIPO_DATA('B41689837','usuario_borrado.160'),
		T_TIPO_DATA('02874944J','usuario_borrado.161'),
		T_TIPO_DATA('B57644189','usuario_borrado.162'),
		T_TIPO_DATA('B57813479','usuario_borrado.163'),
		T_TIPO_DATA('47833409X','usuario_borrado.164'),
		T_TIPO_DATA('06270838A','usuario_borrado.165'),
		T_TIPO_DATA('34989690C','usuario_borrado.166'),
		T_TIPO_DATA('52184397L','usuario_borrado.167'),
		T_TIPO_DATA('43756102M','usuario_borrado.168'),
		T_TIPO_DATA('02912517G','usuario_borrado.169'),
		T_TIPO_DATA('04843135W','usuario_borrado.170'),
		T_TIPO_DATA('53103618E','usuario_borrado.171'),
		T_TIPO_DATA('44879986V','usuario_borrado.172'),
		T_TIPO_DATA('52649732H','usuario_borrado.173'),
		T_TIPO_DATA('49148664X','usuario_borrado.174'),
		T_TIPO_DATA('09041098M','usuario_borrado.175'),
		T_TIPO_DATA('02900594H','usuario_borrado.176'),
		T_TIPO_DATA('31861013X','usuario_borrado.177'),
		T_TIPO_DATA('07957175A','usuario_borrado.178'),
		T_TIPO_DATA('53365743Q','usuario_borrado.179'),
		T_TIPO_DATA('50101078V','usuario_borrado.180'),
		T_TIPO_DATA('43116723A','usuario_borrado.181'),
		T_TIPO_DATA('53463773C','usuario_borrado.182'),
		T_TIPO_DATA('02282113F','usuario_borrado.183'),
		T_TIPO_DATA('11854581J','usuario_borrado.184'),
		T_TIPO_DATA('B15704364','usuario_borrado.185'),
		T_TIPO_DATA('41499591R','usuario_borrado.186'),
		T_TIPO_DATA('40559874H','usuario_borrado.187'),
		T_TIPO_DATA('53418977M','usuario_borrado.188'),
		T_TIPO_DATA('11847308P','usuario_borrado.189'),
		T_TIPO_DATA('02641048G','usuario_borrado.190'),
		T_TIPO_DATA('05293091D','usuario_borrado.191'),
		T_TIPO_DATA('47043581W','usuario_borrado.192'),
		T_TIPO_DATA('51637306Y','usuario_borrado.193'),
		T_TIPO_DATA('47456865E','usuario_borrado.194'),
		T_TIPO_DATA('44858702P','usuario_borrado.195'),
		T_TIPO_DATA('52659872S','usuario_borrado.196'),
		T_TIPO_DATA('52701241F','usuario_borrado.197'),
		T_TIPO_DATA('51484093L','usuario_borrado.198'),
		T_TIPO_DATA('20253621M','usuario_borrado.199'),
		T_TIPO_DATA('53048030W','usuario_borrado.200'),
		T_TIPO_DATA('05284288S','usuario_borrado.201'),
		T_TIPO_DATA('51258960X','usuario_borrado.202'),
		T_TIPO_DATA('46686562N','usuario_borrado.203'),
		T_TIPO_DATA('50690732C','usuario_borrado.204'),
		T_TIPO_DATA('44904379F','usuario_borrado.205'),
		T_TIPO_DATA('41558133N','usuario_borrado.206'),
		T_TIPO_DATA('B85735967','usuario_borrado.207'),
		T_TIPO_DATA('B29830577','usuario_borrado.208'),
		T_TIPO_DATA('B45608270','usuario_borrado.209'),
		T_TIPO_DATA('50801610S','usuario_borrado.210'),
		T_TIPO_DATA('B82622713','usuario_borrado.211'),
		T_TIPO_DATA('J82985573','usuario_borrado.212'),
		T_TIPO_DATA('B19504851','usuario_borrado.213'),
		T_TIPO_DATA('22624330N','usuario_borrado.214'),
		T_TIPO_DATA('B84216993','usuario_borrado.215'),
		T_TIPO_DATA('J91899609','usuario_borrado.216'),
		T_TIPO_DATA('B98658206','usuario_borrado.217'),
		T_TIPO_DATA('B63572267','usuario_borrado.218'),
		T_TIPO_DATA('B97999254','usuario_borrado.219'),
		T_TIPO_DATA('B98438633','usuario_borrado.220'),
		T_TIPO_DATA('A28430882','usuario_borrado.221'),
		T_TIPO_DATA('B60985421','usuario_borrado.222'),
		T_TIPO_DATA('B82127358','usuario_borrado.223'),
		T_TIPO_DATA('B86797065','usuario_borrado.224'),
		T_TIPO_DATA('B65737322','usuario_borrado.225'),
		T_TIPO_DATA('A62690953','usuario_borrado.226'),
		T_TIPO_DATA('B98278799','usuario_borrado.227'),
		T_TIPO_DATA('B86561677','usuario_borrado.228'),
		T_TIPO_DATA('46859715K','usuario_borrado.229'),
		T_TIPO_DATA('B98257116','usuario_borrado.230'),
		T_TIPO_DATA('A04337309','usuario_borrado.231'),
		T_TIPO_DATA('B04604195','usuario_borrado.232'),
		T_TIPO_DATA('B98327943','usuario_borrado.233'),
		T_TIPO_DATA('B85084135','usuario_borrado.234'),
		T_TIPO_DATA('B28205904','usuario_borrado.235'),
		T_TIPO_DATA('B98380629','usuario_borrado.236'),
		T_TIPO_DATA('A04028023','usuario_borrado.237'),
		T_TIPO_DATA('A04048088','usuario_borrado.238'),
		T_TIPO_DATA('B18386375','usuario_borrado.239'),
		T_TIPO_DATA('B04524583','usuario_borrado.240'),
		T_TIPO_DATA('B04490587','usuario_borrado.241'),
		T_TIPO_DATA('B04307120','usuario_borrado.242'),
		T_TIPO_DATA('B04341699','usuario_borrado.243'),
		T_TIPO_DATA('B04630075','usuario_borrado.244'),
		T_TIPO_DATA('A15168156','usuario_borrado.245'),
		T_TIPO_DATA('B29770922','usuario_borrado.246'),
		T_TIPO_DATA('A46092128','usuario_borrado.247'),
		T_TIPO_DATA('A04038014','usuario_borrado.248'),
		T_TIPO_DATA('B04482691','usuario_borrado.249'),
		T_TIPO_DATA('A04028205','usuario_borrado.250'),
		T_TIPO_DATA('B02118115','usuario_borrado.251'),
		T_TIPO_DATA('B30473599','usuario_borrado.252'),
		T_TIPO_DATA('A07022288','usuario_borrado.253'),
		T_TIPO_DATA('53443485H','usuario_borrado.254'),
		T_TIPO_DATA('02878451R','usuario_borrado.255'),
		T_TIPO_DATA('08944474G','usuario_borrado.256'),
		T_TIPO_DATA('50699304J','usuario_borrado.257'),
		T_TIPO_DATA('3943365C','usuario_borrado.258'),
		T_TIPO_DATA('33944952B','usuario_borrado.259'),
		T_TIPO_DATA('51450360G','usuario_borrado.260'),
		T_TIPO_DATA('51423979G','usuario_borrado.261'),
		T_TIPO_DATA('13757245W','usuario_borrado.262'),
		T_TIPO_DATA('45091053J','usuario_borrado.263'),
		T_TIPO_DATA('02720574L','usuario_borrado.264'),
		T_TIPO_DATA('47033179L','usuario_borrado.265'),
		T_TIPO_DATA('A28842045','usuario_borrado.266')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := '
    	UPDATE '||V_ESQUEMA||'.AUX_USUARIOS_NUEVO_ANTIGUO T1
    	SET T1.USU_ID = NULL';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('	[INFO]: '||SQL%ROWCOUNT||' USU_ID BORRADOS EN TABLA AUXILIAR');

    DBMS_OUTPUT.PUT_LINE('	[INFO]: ACTUALIZAR AUX USUARIOS');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.AUX_USUARIOS_NUEVO_ANTIGUO WHERE USERNAME_ACTUAL = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
        
        IF V_NUM_TABLAS > 0 THEN		
			
			V_MSQL := '
				UPDATE '||V_ESQUEMA||'.AUX_USUARIOS_NUEVO_ANTIGUO
				SET USERNAME_DEFINITIVO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
				WHERE USERNAME_ACTUAL = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('	[INFO]: ACTUALIZADO CORRECTAMENTE EL USUARIO '||TRIM(V_TMP_TIPO_DATA(1))||' EN TABLA AUXILIAR');

			IF TRIM(V_TMP_TIPO_DATA(2)) LIKE 'usuario_borrado.%' THEN

				V_MSQL := '
					UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS T1
					SET BORRADO = 1, USUARIOBORRAR = '''||V_USUARIO||''', FECHABORRAR = SYSDATE, USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
					WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('	[INFO]: BORRADO CORRECTAMENTE EL USUARIO '||TRIM(V_TMP_TIPO_DATA(1))||' EN TABLA USU_USUARIOS');

			ELSE

				V_MSQL := '
					UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS T1
					SET USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''', USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
					WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
						AND NOT EXISTS (
							SELECT 1
							FROM '||V_ESQUEMA_M||'.USU_USUARIOS T2
							WHERE T2.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
							)';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('	[INFO]: ACTUALIZADO CORRECTAMENTE EL USUARIO '||TRIM(V_TMP_TIPO_DATA(1))||' EN TABLA USU_USUARIOS');

			END IF;
		
		ELSE
			  
			V_MSQL := '
				INSERT INTO '||V_ESQUEMA||'.AUX_USUARIOS_NUEVO_ANTIGUO 
					VALUES (
						NULL
						, '''||TRIM(V_TMP_TIPO_DATA(2))||'''
						, '''||TRIM(V_TMP_TIPO_DATA(1))||'''
						)';
			EXECUTE IMMEDIATE V_MSQL;

			IF SQL%ROWCOUNT > 0 THEN
				
				DBMS_OUTPUT.PUT_LINE('	[INFO]: INSERTADO CORRECTAMENTE EL USUARIO '||TRIM(V_TMP_TIPO_DATA(1))||'');
				
				V_MSQL := '
					UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS T1
					SET USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''', USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
					WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
						AND NOT EXISTS (
							SELECT 1
							FROM '||V_ESQUEMA_M||'.USU_USUARIOS T2
							WHERE T2.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
							)';
				EXECUTE IMMEDIATE V_MSQL;

				IF SQL%ROWCOUNT > 0  THEN

					DBMS_OUTPUT.PUT_LINE('	[INFO]: ACTUALIZADO CORRECTAMENTE EL USUARIO '||TRIM(V_TMP_TIPO_DATA(1))||' EN TABLA USU_USUARIOS');

				ELSE

					DBMS_OUTPUT.PUT_LINE('	[INFO]: NO EXISTE EL ANTIGUO USUARIO O YA EXISTE EL NUEVO USUARIO PARA LA PAREJA 
						'||TRIM(V_TMP_TIPO_DATA(1))||'/'||TRIM(V_TMP_TIPO_DATA(2))||' EN LA TABLA USU_USUARIOS');

				END IF;
			
			END IF;
			
		END IF;	
		
    END LOOP;

    V_MSQL := '
    	MERGE INTO '||V_ESQUEMA||'.AUX_USUARIOS_NUEVO_ANTIGUO T1
    	USING '||V_ESQUEMA_M||'.USU_USUARIOS T2
    	ON (T1.USERNAME_DEFINITIVO = T2.USU_USERNAME)
    	WHEN MATCHED THEN UPDATE SET
    		T1.USU_ID = T2.USU_ID';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('	[INFO]: '||SQL%ROWCOUNT||' USU_ID ACTUALIZADOS EN TABLA AUXILIAR');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
