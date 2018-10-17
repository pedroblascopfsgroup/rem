--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180717
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1352
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en ACT_GES_DIST_GESTORES
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1352';
	V_TABLA VARCHAR(50 CHAR) := 'ACT_GES_DIST_GESTORES';
	V_TABLA_PRV VARCHAR(50 CHAR) := 'DD_PRV_PROVINCIA';
	V_TABLA_LOC VARCHAR(50 CHAR) := 'DD_LOC_LOCALIDAD';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_COUNT NUMBER;

    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_GES_DIST_GESTORES] ');


				DBMS_OUTPUT.PUT_LINE('[INICIO]: prodriguezg');
			
							
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' DIST 
						JOIN '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV ON PRV.DD_PRV_CODIGO = DIST.COD_PROVINCIA AND PRV.DD_PRV_CODIGO IN (16, 19, 28, 45)
						WHERE DIST.USUARIOCREAR = '''||V_USUARIO||''' 
						AND DIST.USERNAME = ''prodriguezg''
						AND DIST.NOMBRE_USUARIO = ''Patricia Rodriguez Guzman''
				
				';
				EXECUTE IMMEDIATE V_SQL INTO V_COUNT;		
							
				IF V_COUNT > 0 THEN
				
					DBMS_OUTPUT.PUT_LINE('[INFO] Los registros ya estaban insertados');				
					
				ELSE
				
						V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
								(ID
								,TIPO_GESTOR
								,COD_CARTERA
								,COD_PROVINCIA
								,USERNAME
								,NOMBRE_USUARIO
								,USUARIOCREAR
								,FECHACREAR)
								SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
								''HAYAGBOINM'',
								''08'',
								PRV.DD_PRV_CODIGO,
								''prodriguezg'',
								''Patricia Rodriguez Guzman'',
								'''||V_USUARIO||''',
								SYSDATE
								FROM '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV WHERE PRV.DD_PRV_CODIGO IN (16, 19, 28)	
						';
					
					EXECUTE IMMEDIATE V_SQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');
				
					V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
								(ID
								,TIPO_GESTOR
								,COD_CARTERA
								,COD_PROVINCIA
								,COD_MUNICIPIO
								,USERNAME
								,NOMBRE_USUARIO
								,USUARIOCREAR
								,FECHACREAR)
								SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
								''HAYAGBOINM'',
								''08'',
								45,
								LOC.DD_LOC_CODIGO,
								''prodriguezg'',
								''Patricia Rodriguez Guzman'',
								'''||V_USUARIO||''',
								SYSDATE
								FROM '||V_ESQUEMA_M||'.'||V_TABLA_LOC||' LOC WHERE LOC.DD_LOC_CODIGO IN (
										''45001'',
										''45002'',
										''45014'',
										''45015'',
										''45016'',
										''45019'',
										''45023'',
										''45025'',
										''45029'',
										''45031'',
										''45032'',
										''45034'',
										''45051'',
										''45052'',
										''45055'',
										''45059'',
										''45060'',
										''45067'',
										''45070'',
										''45076'',
										''45083'',
										''45085'',
										''45088'',
										''45089'',
										''45090'',
										''45092'',
										''45094'',
										''45098'',
										''45102'',
										''45106'',
										''45107'',
										''45109'',
										''45112'',
										''45116'',
										''45119'',
										''45122'',
										''45127'',
										''45133'',
										''45136'',
										''45140'',
										''45141'',
										''45145'',
										''45153'',
										''45154'',
										''45163'',
										''45168'',
										''45169'',
										''45182'',
										''45187'',
										''45188'',
										''45190'',
										''45196'',
										''45199'',
										''45200'',
										''45203'',
										''45205''
								)	
						';
						
				EXECUTE IMMEDIATE V_SQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');
				
				END IF;
				
				DBMS_OUTPUT.PUT_LINE('[FIN]: prodriguezg');
				
				
				
				DBMS_OUTPUT.PUT_LINE('[INICIO]: lmarcos');
				
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' DIST 
						JOIN '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV ON PRV.DD_PRV_CODIGO = DIST.COD_PROVINCIA AND PRV.DD_PRV_CODIGO IN (4, 5, 6, 9, 10, 11, 14, 18, 21, 22, 23, 29, 34, 37, 40, 41, 42, 43, 47, 49, 50, 45)
						WHERE DIST.USUARIOCREAR = '''||V_USUARIO||''' 
						AND DIST.USERNAME = ''lmarcos''
						AND DIST.NOMBRE_USUARIO = ''Lucia Marcos Esteban''
				
				';
				EXECUTE IMMEDIATE V_SQL INTO V_COUNT;		
							
				IF V_COUNT > 0 THEN
				
					DBMS_OUTPUT.PUT_LINE('[INFO] Los registros ya estaban insertados');				
					
				ELSE
				
						V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
								(ID
								,TIPO_GESTOR
								,COD_CARTERA
								,COD_PROVINCIA
								,USERNAME
								,NOMBRE_USUARIO
								,USUARIOCREAR
								,FECHACREAR)
								SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
								''HAYAGBOINM'',
								''08'',
								PRV.DD_PRV_CODIGO,
								''lmarcos'',
								''Lucia Marcos Esteban'',
								'''||V_USUARIO||''',
								SYSDATE
								FROM '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV WHERE PRV.DD_PRV_CODIGO IN (4, 5, 6, 9, 10, 11, 14, 18, 21, 22, 23, 29, 34, 37, 40, 41, 42, 43, 47, 49, 50)	
						';
					
					EXECUTE IMMEDIATE V_SQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');
				
					V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
								(ID
								,TIPO_GESTOR
								,COD_CARTERA
								,COD_PROVINCIA
								,COD_MUNICIPIO
								,USERNAME
								,NOMBRE_USUARIO
								,USUARIOCREAR
								,FECHACREAR)
								SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
								''HAYAGBOINM'',
								''08'',
								45,
								LOC.DD_LOC_CODIGO,
								''lmarcos'',
								''Lucia Marcos Esteban'',
								'''||V_USUARIO||''',
								SYSDATE
								FROM '||V_ESQUEMA_M||'.'||V_TABLA_LOC||' LOC WHERE LOC.DD_LOC_CODIGO IN (
									''45003'',
									''45004'',
									''45006'',
									''45007'',
									''45009'',
									''45013'',
									''45018'',
									''45021'',
									''45028'',
									''45030'',
									''45036'',
									''45037'',
									''45038'',
									''45040'',
									''45041'',
									''45043'',
									''45045'',
									''45046'',
									''45047'',
									''45056'',
									''45058'',
									''45061'',
									''45062'',
									''45064'',
									''45066'',
									''45069'',
									''45072'',
									''45074'',
									''45077'',
									''45081'',
									''45086'',
									''45091'',
									''45095'',
									''45097'',
									''45099'',
									''45104'',
									''45105'',
									''45110'',
									''45117'',
									''45118'',
									''45125'',
									''45126'',
									''45130'',
									''45132'',
									''45134'',
									''45137'',
									''45138'',
									''45143'',
									''45147'',
									''45151'',
									''45157'',
									''45158'',
									''45901'',
									''45160'',
									''45165'',
									''45171'',
									''45172'',
									''45173'',
									''45176'',
									''45179'',
									''45180'',
									''45181'',
									''45183'',
									''45189'',
									''45201''
								)	
						';
						
				EXECUTE IMMEDIATE V_SQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');
				
				END IF;
				
				DBMS_OUTPUT.PUT_LINE('[FIN]: lmarcos');
				
				
				
				
				DBMS_OUTPUT.PUT_LINE('[INICIO]: lcarrillo');
				
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' DIST 
						JOIN '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV ON PRV.DD_PRV_CODIGO = DIST.COD_PROVINCIA AND PRV.DD_PRV_ID IN (2, 45)
						WHERE DIST.USUARIOCREAR = '''||V_USUARIO||''' 
						AND DIST.USERNAME = ''lcarrillo''
						AND DIST.NOMBRE_USUARIO = ''Lorena Carrillo Martinez''
				
				';
				EXECUTE IMMEDIATE V_SQL INTO V_COUNT;		
							
				IF V_COUNT > 0 THEN
				
					DBMS_OUTPUT.PUT_LINE('[INFO] Los registros ya estaban insertados');				
					
				ELSE
				
						V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
								(ID
								,TIPO_GESTOR
								,COD_CARTERA
								,COD_PROVINCIA
								,USERNAME
								,NOMBRE_USUARIO
								,USUARIOCREAR
								,FECHACREAR)
								SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
								''HAYAGBOINM'',
								''08'',
								PRV.DD_PRV_CODIGO,
								''lcarrillo'',
								''Lorena Carrillo Martinez'',
								'''||V_USUARIO||''',
								SYSDATE
								FROM '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV WHERE PRV.DD_PRV_CODIGO IN (2)	
						';
					
					EXECUTE IMMEDIATE V_SQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');
				
					V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
								(ID
								,TIPO_GESTOR
								,COD_CARTERA
								,COD_PROVINCIA
								,COD_MUNICIPIO
								,USERNAME
								,NOMBRE_USUARIO
								,USUARIOCREAR
								,FECHACREAR)
								SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
								''HAYAGBOINM'',
								''08'',
								45,
								LOC.DD_LOC_CODIGO,
								''lcarrillo'',
								''Lorena Carrillo Martinez'',
								'''||V_USUARIO||''',
								SYSDATE
								FROM '||V_ESQUEMA_M||'.'||V_TABLA_LOC||' LOC WHERE LOC.DD_LOC_CODIGO IN (
										''45026'',
										''45027'',
										''45050'',
										''45053'',
										''45054'',
										''45071'',
										''45078'',
										''45084'',
										''45087'',
										''45101'',
										''45115'',
										''45121'',
										''45123'',
										''45135'',
										''45142'',
										''45156'',
										''45161'',
										''45166'',
										''45167'',
										''45175'',
										''45186'',
										''45185'',
										''45195'',
										''45197'',
										''45198'',
										''45202''
								)	
						';
						
				EXECUTE IMMEDIATE V_SQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');
				
				END IF;
				
				DBMS_OUTPUT.PUT_LINE('[FIN]: lcarrillo');
				
				
				
				
				
				DBMS_OUTPUT.PUT_LINE('[INICIO]: fmorenor');
				
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' DIST 
						JOIN '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV ON PRV.DD_PRV_CODIGO = DIST.COD_PROVINCIA AND PRV.DD_PRV_CODIGO IN (3, 8, 12, 13, 17, 25, 30, 43, 46)
						WHERE DIST.USUARIOCREAR = '''||V_USUARIO||''' 
						AND DIST.USERNAME = ''fmorenor''
						AND DIST.NOMBRE_USUARIO = ''Felix Moreno Rubio''
				
				';
				EXECUTE IMMEDIATE V_SQL INTO V_COUNT;		
							
				IF V_COUNT > 0 THEN
				
					DBMS_OUTPUT.PUT_LINE('[INFO] Los registros ya estaban insertados');				
					
				ELSE
				
						V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
								(ID
								,TIPO_GESTOR
								,COD_CARTERA
								,COD_PROVINCIA
								,USERNAME
								,NOMBRE_USUARIO
								,USUARIOCREAR
								,FECHACREAR)
								SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
								''HAYAGBOINM'',
								''08'',
								PRV.DD_PRV_CODIGO,
								''fmorenor'',
								''Felix Moreno Rubio'',
								'''||V_USUARIO||''',
								SYSDATE
								FROM '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV WHERE PRV.DD_PRV_CODIGO IN (3, 8, 12, 13, 17, 25, 30, 43, 46)	
						';
					
					EXECUTE IMMEDIATE V_SQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');

				END IF;
				
				DBMS_OUTPUT.PUT_LINE('[FIN]: fmorenor');
				
				
				
				
				
				
				
				
				DBMS_OUTPUT.PUT_LINE('[INICIO]: SBACKOFFICEINMLIBER');
				
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' DIST
						WHERE DIST.USUARIOCREAR = '''||V_USUARIO||''' 
						AND DIST.USERNAME = ''SBACKOFFICEINMLIBER''
						AND DIST.NOMBRE_USUARIO = ''Supervisor Comercial BackOffice Liberbank''
				
				';
				EXECUTE IMMEDIATE V_SQL INTO V_COUNT;		
							
				IF V_COUNT > 0 THEN
				
					DBMS_OUTPUT.PUT_LINE('[INFO] Los registros ya estaban insertados');				
					
				ELSE
				
						V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
								(ID
								,TIPO_GESTOR
								,COD_CARTERA
								,USERNAME
								,NOMBRE_USUARIO
								,USUARIOCREAR
								,FECHACREAR)
								SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
								''SBACKOFFICEINMLIBER'',
								''08'',
								''SBACKOFFICEINMLIBER'',
								''Supervisor Comercial BackOffice Liberbank'',
								'''||V_USUARIO||''',
								SYSDATE
								FROM '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV WHERE PRV.DD_PRV_CODIGO IN (3, 8, 12, 13, 17, 25, 30, 43, 46)	
						';
					
					EXECUTE IMMEDIATE V_SQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');

				END IF;
				
				DBMS_OUTPUT.PUT_LINE('[FIN]: SBACKOFFICEINMLIBER');
				
				
				
				
				
				
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACT_GES_DIST_GESTORES ACTUALIZADO CORRECTAMENTE ');
   

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
EXIT;
