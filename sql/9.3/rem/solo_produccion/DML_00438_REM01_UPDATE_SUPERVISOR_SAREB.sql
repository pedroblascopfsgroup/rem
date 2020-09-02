--/*
--##########################################
--## AUTOR=Ivan Repiso
--## FECHA_CREACION=20200827
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7975
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización supervisor comercial backoffice inmobiliario de los activos sareb
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
	V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
 	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
 	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USU VARCHAR2(30 CHAR):= 'REMVIP-7975';
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error

	V_USERNAME VARCHAR2(30 CHAR):= 'mruiz';
	V_GESTOR VARCHAR2(30 CHAR):= 'HAYASBOINM';
	V_CARTERA_ID VARCHAR2(30 CHAR):= '2';
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	--Comprobamos la existencia de usuario mruiz
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USERNAME||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT = 1 THEN

		--ACTUALIZAMOS CONFIG DE USUARIOS SUPERVISOR BACKOFFICE EN ACT_GES_DIST_GESTORES
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES SET 
				USERNAME = '''||V_USERNAME||''',
				NOMBRE_USUARIO = (SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USERNAME||'''),
				USUARIOMODIFICAR = '''||V_USU||''',
				FECHAMODIFICAR = SYSDATE
				WHERE COD_CARTERA = '||V_CARTERA_ID||' AND TIPO_GESTOR = '''||V_GESTOR||'''';
			
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS');

		--INSERTAMOS GEE_ID Y GEH_ID EN TABLA TEMPORAL TMP_REMVIP_7975
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_REMVIP_7975 (GEE_ID, GEH_ID) 
					SELECT GEE.GEE_ID,GEH.GEH_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
					INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.DD_TGE_ID = (SELECT DD_TGE_ID 
						FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_GESTOR||''') AND GEE.BORRADO = 0
					INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
					INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GAH.GEH_ID AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID 
						FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_GESTOR||''') AND GEH.GEH_FECHA_HASTA IS NULL AND GEH.BORRADO = 0
					WHERE ACT.DD_CRA_ID = '''||V_CARTERA_ID||'''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||SQL%ROWCOUNT||' REGISTROS ');

		COMMIT;

		-- ACTUALIZAR REGISTROS DE TABLA GEH CON FECHA FIN 
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH SET 
					GEH_FECHA_HASTA = TO_DATE(SYSDATE, ''DD/MM/YY''),
					USUARIOMODIFICAR = '''||V_USU||''',
					FECHAMODIFICAR = SYSDATE
					WHERE EXISTS (SELECT GEH_ID FROM '||V_ESQUEMA||'.TMP_REMVIP_7975 TMP WHERE TMP.GEH_ID = GEH.GEH_ID)';

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS');

		--BORRAR REGISTRO GAC Y GEE
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
					WHERE EXISTS (SELECT GEE_ID FROM '||V_ESQUEMA||'.TMP_REMVIP_7975 TMP WHERE TMP.GEE_ID = GAC.GEE_ID)';
		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS  '|| SQL%ROWCOUNT ||' REGISTROS');

		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
					WHERE EXISTS (SELECT GEE_ID FROM '||V_ESQUEMA||'.TMP_REMVIP_7975 TMP WHERE TMP.GEE_ID = GEE.GEE_ID)';
		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS  '|| SQL%ROWCOUNT ||' REGISTROS');
		
		COMMIT;
		
	ELSE 
	
		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE USUARIO '''||V_USERNAME||'''');
	
	END IF;

	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	
	EXCEPTION
	
	    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		ROLLBACK;
		RAISE;
END;
/
EXIT;