--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20221226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12989
--## PRODUCTO=NO
--## 
--## Finalidad: Script que añade en BIE_VALORACIONES.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(50 CHAR) := 'AUX_REMVIP_12989'; -- Variable para tabla 	
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);--Variable para consultar la existencia de registros en la tabla
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar
	V_NUM NUMBER(16); --Variable para comprobar si existen registros
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-12989';
	V_NUM_ACTIVO VARCHAR2(32000 CHAR);
	

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));		

	-- Comprobar que existen los activos
    V_MSQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' WHERE ID_HAYA NOT IN (SELECT ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ACT_ACTIVO)';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM > 0 THEN
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han encontrado '||V_NUM||' registros que no se encuentran en la tabla de activos');	
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_TMP||' SET BORRADO = 1 WHERE ID_HAYA NOT IN (SELECT ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ACT_ACTIVO)';
	EXECUTE IMMEDIATE V_SQL;	
	
	COMMIT;	
	
	V_NUM := 0;	
	END IF;

	IF V_NUM = 0 THEN

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE VOLCADO SOBRE LA TABLA '||V_ESQUEMA||'.BIE_VALORACIONES');

	        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.BIE_VALORACIONES (
			                        BIE_ID, 
									BIE_VAL_ID, 
									BIE_IMPORTE_VALOR_TASACION,
									BIE_FECHA_VALOR_TASACION,
									DD_TRA_ID,
			                        FECHACREAR, 
									USUARIOCREAR, 
									VERSION, 
									BORRADO)
                               SELECT 
										(SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = AUX.ID_HAYA), 
                                    	 '||V_ESQUEMA||'.S_BIE_VALORACIONES.NEXTVAL,
										AUX.IMPORTE_TASACION,
                                       	AUX.FECHA_TASACION,
										(SELECT DD_TRA_ID FROM '||V_ESQUEMA||'.DD_TRA_TASADORA WHERE DD_TRA_CODIGO = AUX.dd_tra_codigo),
                                       	SYSDATE,
                                       	'''||V_USUARIO||''',
                                      	0,
                                      	0
                                    FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX WHERE AUX.BORRADO = 0';

			EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en BIE_VALORACIONES');  
	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se comprueban registros en ACT_TAS_TASACION'); 
	
	V_MSQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX 
							LEFT JOIN  '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA
							WHERE ACT.BIE_ID  NOT IN (SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_VALORACIONES WHERE  USUARIOCREAR =  '''||V_USUARIO||''' )';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

	IF V_NUM = 0 THEN

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE VOLCADO SOBRE LA TABLA '||V_ESQUEMA||'.ACT_TAS_TASACION');

        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_TAS_TASACION (
					ACT_ID, 
					BIE_VAL_ID, 
					DD_TTS_ID,
					TAS_ID,  
					TAS_IMPORTE_TAS_FIN, 
					TAS_FECHA_INI_TASACION,
					TAS_NOMBRE_TASADOR,
					FECHACREAR,
					USUARIOCREAR,	
					VERSION, 
					BORRADO)
				SELECT 
						(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = AUX.ID_HAYA),
						(SELECT BIE_VAL_ID FROM '||V_ESQUEMA||'.BIE_VALORACIONES 
															WHERE BIE_ID = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = AUX.ID_HAYA) 
															AND USUARIOCREAR =  '''||V_USUARIO||'''),
						(SELECT DD_TTS_ID FROM '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION WHERE DD_TTS_CODIGO = AUX.DD_TTS_CODIGO),									
						'||V_ESQUEMA||'.S_ACT_TAS_TASACION.NEXTVAL,
						AUX.IMPORTE_TASACION,
						AUX.FECHA_TASACION,
						(SELECT DD_TRA_DESCRIPCION FROM '||V_ESQUEMA||'.DD_TRA_TASADORA WHERE DD_TRA_CODIGO = aux.dd_tra_codigo), 
						SYSDATE,
						'''||V_USUARIO||''',
						0,
						0                                      
				FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX WHERE AUX.BORRADO = 0';


			EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en ACT_TAS_TASACION');  
	COMMIT;

	ELSE 
	DBMS_OUTPUT.PUT_LINE('[INFO] NO HAY REGISTROS EN BIE_VALORACIONES NO SE INSERTA EN ACT_tAS_TASACION');  
	END IF;

--######
	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;