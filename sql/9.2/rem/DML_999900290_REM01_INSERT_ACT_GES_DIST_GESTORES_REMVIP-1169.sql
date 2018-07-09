--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180705
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1169';
	V_TABLA VARCHAR(50 CHAR) := 'ACT_GES_DIST_GESTORES';
	V_TABLA_PRV VARCHAR(50 CHAR) := 'DD_PRV_PROVINCIA';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_COUNT NUMBER;

    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_GES_DIST_GESTORES] ');

			
			-- Si existe la FUNCION
							
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' DIST 
						JOIN '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV ON PRV.DD_PRV_CODIGO = DIST.COD_PROVINCIA AND PRV.DD_PRV_ID IN (8, 17, 25, 43, 28, 45)
						WHERE DIST.USUARIOCREAR = '''||V_USUARIO||''' 
						AND DIST.USERNAME = ''pinos02''
						AND DIST.NOMBRE_USUARIO = ''GESTORIA PINOS XXI,S.L. Administración ''
				
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
								''GIAADMT'',
								''08'',
								PRV.DD_PRV_CODIGO,
								''pinos02'',
								''GESTORIA PINOS XXI,S.L. Administración '',
								'''||V_USUARIO||''',
								SYSDATE
								FROM '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV WHERE PRV.DD_PRV_ID IN ( 8, 17, 25, 43, 28, 45)	
						';
					
					EXECUTE IMMEDIATE V_SQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');
				
					
				END IF;
				
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' DIST 
						JOIN '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV ON PRV.DD_PRV_CODIGO = DIST.COD_PROVINCIA AND PRV.DD_PRV_ID NOT IN (8, 17, 25, 43, 28, 45)
						WHERE DIST.USUARIOCREAR = '''||V_USUARIO||'''
						AND DIST.USERNAME = ''tecnotra02''
						AND DIST.NOMBRE_USUARIO = ''TECNOTRAMIT GESTION SL. Administración Usuario  genérico''
				
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
								''GIAADMT'',
								''08'',
								PRV.DD_PRV_CODIGO,
								''tecnotra02'',
								''TECNOTRAMIT GESTION SL. Administración Usuario  genérico'',
								'''||V_USUARIO||''',
								SYSDATE
								FROM '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV WHERE PRV.DD_PRV_ID NOT IN ( 8, 17, 25, 43, 28, 45)	
					';
					
					EXECUTE IMMEDIATE V_SQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');
					
				
				END IF;
				
				
				
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DD_OPM_OPERACION_MASIVA ACTUALIZADO CORRECTAMENTE ');
   

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
