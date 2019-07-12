--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190711
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4734
--## PRODUCTO=NO
--## 
--## Finalidad: [REMVIP-4734] Incongruencias histórico de publicaciones. Activos reservados y vendidos.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
	V_TABLA_AUX VARCHAR2(40 CHAR) := 'AUX_REMVIP_4734'; --Vble. para la tabla auxiliar.
	V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.

BEGIN

	DBMS_OUTPUT.put_line('[INICIO]');
	DBMS_OUTPUT.put_line('[INFO] Creación de la tabla auxiliar');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_AUX||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM > 0 THEN
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA_AUX||'';
		EXECUTE IMMEDIATE V_MSQL;
	END IF;

	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA_AUX||'
				(
					ACT_ID NUMBER(16,0) NOT NULL,
					AHP_RESERVA NUMBER(16,0),
					AHP_VENTA NUMBER(16,0),
					FECHA_PUBLICACION DATE,
					FECHA_RESERVA DATE,
					FECHA_VENTA DATE
				)';
	EXECUTE IMMEDIATE V_MSQL;

/************************* PASO 1 *************************/

	DBMS_OUTPUT.put_line('[INFO] Inicio del PASO 1');
	
	-- ACTIVOS RESERVADOS NO PUBLICADOS EN AHP Y SÍ EN HEP

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_AUX||'
				SELECT ACT.ACT_ID, AHP.AHP_ID AS AHP_RESERVA, NULL, HEP.HEP_FECHA_DESDE AS FECHA_PUBLICACION, RES.RES_FECHA_FIRMA AS FECHA_RESERVA, NULL
				FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''04''
				JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.DD_EPV_ID = 4 AND APU.DD_TCO_ID IN (1,2) AND TO_DATE(APU.APU_FECHA_INI_VENTA,''DD/MM/YY'') < TO_DATE(''21/11/18'',''DD/MM/YY'')
				JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_ID = APU.DD_MTO_V_ID AND MTO.DD_MTO_CODIGO = ''07''
				JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP ON AHP.ACT_ID = ACT.ACT_ID AND AHP.AHP_FECHA_INI_VENTA IS NOT NULL AND AHP.AHP_FECHA_FIN_VENTA IS NULL AND AHP.BORRADO = 0
				JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO_2 ON MTO_2.DD_MTO_ID = AHP.DD_MTO_V_ID AND MTO_2.DD_MTO_CODIGO = ''07''
				JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
				JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON AO.OFR_ID = OFR.OFR_ID
				JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND DD_EOF_CODIGO = ''01''
				JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
				JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO = ''06''
				JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID
				JOIN (
					SELECT HEP.ACT_ID, HEP.HEP_FECHA_DESDE,
					ROW_NUMBER () OVER (PARTITION BY HEP.ACT_ID ORDER BY TO_DATE(HEP.HEP_FECHA_DESDE, ''DD/MM/YY'') ASC) RN
					FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP WHERE HEP.DD_EPU_ID IN (1,2,4,7) AND HEP.BORRADO = 0
				) HEP ON HEP.ACT_ID = ACT.ACT_ID AND HEP.RN = 1
				WHERE NOT EXISTS (SELECT * FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION HIS WHERE HIS.ACT_ID = ACT.ACT_ID AND HIS.BORRADO = 0 AND HIS.DD_EPV_ID = 3)';
	EXECUTE IMMEDIATE V_MSQL;

	-- INSERTAMOS EL REGISTRO DE PUBLICACIÓN

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION (
					AHP_ID
					,ACT_ID
					,DD_EPV_ID
					,DD_EPA_ID
					,DD_TCO_ID
					,DD_MTO_V_ID
					,AHP_CHECK_PUBLICAR_V
					,AHP_CHECK_OCULTAR_V
					,AHP_CHECK_OCULTAR_PRECIO_V
					,AHP_CHECK_PUB_SIN_PRECIO_V
					,AHP_CHECK_PUBLICAR_A
					,AHP_CHECK_OCULTAR_A
					,AHP_CHECK_OCULTAR_PRECIO_A
					,AHP_CHECK_PUB_SIN_PRECIO_A
					,AHP_FECHA_INI_VENTA
					,AHP_FECHA_FIN_VENTA
					,VERSION
					,USUARIOCREAR
					,FECHACREAR
					,BORRADO
					,ES_CONDICONADO_ANTERIOR
				)
				SELECT '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL
					,ACT_ID
					,3
					,1
					,1
					,NULL
					,1,0,0,0
					,0,0,0,0
					,FECHA_PUBLICACION
					,FECHA_RESERVA
					,0
					,''REMVIP-4734''
					,SYSDATE
					,0
					,0
				FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||'';
	EXECUTE IMMEDIATE V_MSQL;

	-- ACTUALIZAMOS LA FECHA DE INICIO DE RESERVA

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
				USING (
					SELECT DISTINCT AHP_RESERVA, FECHA_RESERVA FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||'
				) T2
				ON (T1.AHP_ID = T2.AHP_RESERVA)
				WHEN MATCHED THEN UPDATE SET
					T1.AHP_FECHA_INI_VENTA = T2.FECHA_RESERVA
					,T1.USUARIOMODIFICAR = ''REMVIP-4734''
					,T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	-- ACTUALIZAMOS LA FECHA INICIO REGISTRO DE LA APU

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION T1
		USING (
			SELECT DISTINCT ACT_ID, FECHA_RESERVA FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||'
		) T2
		ON (T1.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN UPDATE SET
			T1.APU_FECHA_INI_VENTA = T2.FECHA_RESERVA
			,T1.USUARIOMODIFICAR = ''REMVIP-4734''
			,T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

/************************* PASO 2 *************************/

	DBMS_OUTPUT.put_line('[INFO] Inicio del PASO 2');

	-- ACTIVOS VENDIDOS NO PUBLICADOS EN AHP Y SÍ EN HEP

	V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA_AUX||'';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_AUX||'
				SELECT ACT.ACT_ID, AHP_2.AHP_ID AS AHP_RESERVA, AHP.AHP_ID AS AHP_VENTA, HEP.HEP_FECHA_DESDE AS FECHA_PUBLICACION, RES.RES_FECHA_FIRMA AS FECHA_RESERVA, ECO.ECO_FECHA_VENTA AS FECHA_VENTA
				FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''05''
				JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.DD_EPV_ID = 4 AND APU.DD_TCO_ID IN (1,2) AND TO_DATE(APU.APU_FECHA_INI_VENTA,''DD/MM/YY'') < TO_DATE(''21/11/18'',''DD/MM/YY'')
				JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_ID = APU.DD_MTO_V_ID AND MTO.DD_MTO_CODIGO = ''13''
				JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP ON AHP.ACT_ID = ACT.ACT_ID AND AHP.AHP_FECHA_INI_VENTA IS NOT NULL AND AHP.AHP_FECHA_FIN_VENTA IS NULL AND AHP.BORRADO = 0
				JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO_2 ON MTO_2.DD_MTO_ID = AHP.DD_MTO_V_ID AND MTO_2.DD_MTO_CODIGO = ''13''
				LEFT JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP_2 ON AHP_2.ACT_ID = ACT.ACT_ID AND AHP_2.AHP_FECHA_INI_VENTA IS NOT NULL AND AHP_2.AHP_FECHA_FIN_VENTA IS NOT NULL AND AHP_2.BORRADO = 0
				LEFT jOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO_3 ON MTO_3.DD_MTO_ID = AHP_2.DD_MTO_V_ID AND MTO_3.DD_MTO_CODIGO = ''07''
				JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
				JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON AO.OFR_ID = OFR.OFR_ID
				JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND DD_EOF_CODIGO = ''01''
				JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
				JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO = ''08''
				JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID
				JOIN (
					SELECT HEP.ACT_ID, HEP.HEP_FECHA_DESDE,
					ROW_NUMBER () OVER (PARTITION BY HEP.ACT_ID ORDER BY TO_DATE(HEP.HEP_FECHA_DESDE, ''DD/MM/YY'') ASC) RN
					FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP WHERE HEP.DD_EPU_ID IN (1,2,4,7) AND HEP.BORRADO = 0
				) HEP ON HEP.ACT_ID = ACT.ACT_ID AND HEP.RN = 1
				WHERE NOT EXISTS (SELECT * FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION HIS WHERE HIS.ACT_ID = ACT.ACT_ID AND HIS.BORRADO = 0 AND HIS.DD_EPV_ID = 3)';
	EXECUTE IMMEDIATE V_MSQL;
    
	-- INSERTAMOS EL REGISTRO DE PUBLICACIÓN

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION (
					AHP_ID
					,ACT_ID
					,DD_EPV_ID
					,DD_EPA_ID
					,DD_TCO_ID
					,DD_MTO_V_ID
					,AHP_CHECK_PUBLICAR_V
					,AHP_CHECK_OCULTAR_V
					,AHP_CHECK_OCULTAR_PRECIO_V
					,AHP_CHECK_PUB_SIN_PRECIO_V
					,AHP_CHECK_PUBLICAR_A
					,AHP_CHECK_OCULTAR_A
					,AHP_CHECK_OCULTAR_PRECIO_A
					,AHP_CHECK_PUB_SIN_PRECIO_A
					,AHP_FECHA_INI_VENTA
					,AHP_FECHA_FIN_VENTA
					,VERSION
					,USUARIOCREAR
					,FECHACREAR
					,BORRADO
					,ES_CONDICONADO_ANTERIOR
				)
				SELECT '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL
					,ACT_ID
					,3
					,1
					,1
					,NULL
					,1,0,0,0
					,0,0,0,0
					,FECHA_PUBLICACION
					,FECHA_RESERVA
					,0
					,''REMVIP-4778''
					,SYSDATE
					,0
					,0
				FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||'';
	EXECUTE IMMEDIATE V_MSQL;

	-- ACTUALIZAMOS LA FECHA DE INICIO DE RESERVA SI TIENE REGISTRO RESERVA

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
				USING (
					SELECT AHP_RESERVA, FECHA_RESERVA, FECHA_VENTA FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' WHERE AHP_RESERVA IS NOT NULL
				) T2
				ON (T1.AHP_ID = T2.AHP_RESERVA)
				WHEN MATCHED THEN UPDATE SET
					T1.AHP_FECHA_INI_VENTA = T2.FECHA_RESERVA
					,T1.AHP_FECHA_FIN_VENTA = T2.FECHA_VENTA
					,T1.USUARIOMODIFICAR = ''REMVIP-4778''
					,T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
    
	-- INSERTAMOS EL REGISTRO DE RESERVA SI NO LO TIENE

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION (
					AHP_ID
					,ACT_ID
					,DD_EPV_ID
					,DD_EPA_ID
					,DD_TCO_ID
					,DD_MTO_V_ID
					,AHP_CHECK_PUBLICAR_V
					,AHP_CHECK_OCULTAR_V
					,AHP_CHECK_OCULTAR_PRECIO_V
					,AHP_CHECK_PUB_SIN_PRECIO_V
					,AHP_CHECK_PUBLICAR_A
					,AHP_CHECK_OCULTAR_A
					,AHP_CHECK_OCULTAR_PRECIO_A
					,AHP_CHECK_PUB_SIN_PRECIO_A
					,AHP_FECHA_INI_VENTA
					,AHP_FECHA_FIN_VENTA
					,VERSION
					,USUARIOCREAR
					,FECHACREAR
					,BORRADO
					,ES_CONDICONADO_ANTERIOR
				)
				SELECT '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL
					,ACT_ID
					,4
					,1
					,1
					,(SELECT DD_MTO_ID FROM '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = ''07'')
					,1,1,0,0
					,0,0,0,0
					,FECHA_RESERVA
					,FECHA_VENTA
					,0
					,''REMVIP-4778''
					,SYSDATE
					,0
					,0
				FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' WHERE AHP_RESERVA IS NULL';
	EXECUTE IMMEDIATE V_MSQL;

	-- ACTUALIZAMOS LA FECHA DE INICIO DE VENTA

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
				USING (
					SELECT AHP_VENTA, FECHA_VENTA FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||'
				) T2
				ON (T1.AHP_ID = T2.AHP_VENTA)
				WHEN MATCHED THEN UPDATE SET
					T1.AHP_FECHA_INI_VENTA = T2.FECHA_VENTA
					,T1.USUARIOMODIFICAR = ''REMVIP-4778''
					,T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	-- ACTUALIZAMOS LA FECHA INICIO REGISTRO DE LA APU

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION T1
		USING (
			SELECT DISTINCT ACT_ID, FECHA_VENTA FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||'
		) T2
		ON (T1.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN UPDATE SET
			T1.APU_FECHA_INI_VENTA = T2.FECHA_VENTA
			,T1.USUARIOMODIFICAR = ''REMVIP-4734''
			,T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.put_line('[INFO] Borrado de la tabla auxiliar');

	V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA_AUX||'';
	EXECUTE IMMEDIATE V_MSQL;

	COMMIT;
	DBMS_OUTPUT.put_line('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
