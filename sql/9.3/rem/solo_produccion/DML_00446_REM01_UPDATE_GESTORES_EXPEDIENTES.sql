--/*
--##########################################
--## AUTOR=Ivan Repiso
--## FECHA_CREACION=20200904
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7668
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización gestor formalización expediente 
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
	V_USU VARCHAR2(30 CHAR):= 'REMVIP-7668';
	V_KOUNT NUMBER(16);
	V_GEH_ID NUMBER(16); -- Vble. para el id gestor identidad hist
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error

    V_USUARIO VARCHAR2(30 CHAR):= 'jcarbonellm';
    V_GESTOR VARCHAR2(30 CHAR):= 'GFORM';

	CURSOR EXPEDIENTES IS 
        SELECT ECO.ECO_ID,GEE.GEE_ID,GEH.GEH_ID FROM REM01.eco_expediente_comercial ECO
					INNER JOIN REM01.gch_gestor_eco_historico GCH ON GCH.ECO_ID = ECO.ECO_ID
					INNER JOIN REM01.gco_gestor_add_eco GCO ON GCO.ECO_ID = ECO.ECO_ID
					INNER JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID 
						AND GEE.DD_TGE_ID = (SELECT DD_TGE_ID FROM REMMASTER.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = 'GFORM') AND GEE.BORRADO = 0
					INNER JOIN REM01.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GCH.GEH_ID 
						AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM REMMASTER.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = 'GFORM') AND GEH.GEH_FECHA_HASTA IS NULL AND GEH.BORRADO = 0
					INNER JOIN REMMASTER.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID
					WHERE USU.USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = 'jcarbonell');

    FILA EXPEDIENTES%ROWTYPE;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	

	--Comprobamos la existencia de usuario jcarbonellm
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USUARIO||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT = 1 THEN
	
		OPEN EXPEDIENTES;
		
		V_KOUNT := 0;
		
		LOOP
			FETCH EXPEDIENTES INTO FILA;
			EXIT WHEN EXPEDIENTES%NOTFOUND;
					
			--ACTUALIZAMOS REGISTROS EN LA GEE
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD SET 
				USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USUARIO||'''),
				USUARIOMODIFICAR = '''||V_USU||''',
				FECHAMODIFICAR = SYSDATE
				WHERE GEE_ID = '''||FILA.GEE_ID||'''';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS EN GEE: '|| SQL%ROWCOUNT ||' REGISTROS');
			
			--Actualizamos la fecha fin del gestor antiguo en GEH
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST SET
				GEH_FECHA_HASTA = TO_DATE(SYSDATE, ''DD/MM/YY''),
				USUARIOMODIFICAR = '''||V_USU||''', 
				FECHAMODIFICAR = SYSDATE 
				WHERE GEH_ID = '''||FILA.GEH_ID||'''';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS EN GEH:  '|| SQL%ROWCOUNT ||' REGISTROS ');
				
			--Obtenemos el id de gestor entidad hist > GEH_ID
			V_MSQL := 'SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.nextval FROM dual';
			EXECUTE IMMEDIATE V_MSQL INTO V_GEH_ID;	
				
			--INSERTAMOS EN LA GEH
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST
				(GEH_ID,USU_ID,DD_TGE_ID,GEH_FECHA_DESDE,USUARIOCREAR,FECHACREAR) VALUES (
				'||V_GEH_ID||', (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USUARIO||'''),
				(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_GESTOR||'''), SYSDATE,
				'''||V_USU||''', SYSDATE)';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS EN GEH:  '|| SQL%ROWCOUNT ||' REGISTROS ');
				
			--INSERTAMOS EN LA GCH
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.gch_gestor_eco_historico
				(GEH_ID, ECO_ID) VALUES ('||V_GEH_ID||', '||FILA.ECO_ID||')';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS EN GCH:  '|| SQL%ROWCOUNT ||' REGISTROS ');

			V_KOUNT := V_KOUNT + 1;

		END LOOP;
		
		DBMS_OUTPUT.PUT_LINE('  [INFO] Se han iterado con '||V_KOUNT||' expedientes');
		CLOSE EXPEDIENTES;

	ELSE 

		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE USUARIO '''||V_USUARIO||'''');

	END IF;
	COMMIT;
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
