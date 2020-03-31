--/*
--#########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6643
--## PRODUCTO=NO
--## 
--## Finalidad: Script que añade en ACT_TAS_TASACION.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(50 CHAR) := 'TMP_ACTUALIZAR_TASACION_REM'; -- Variable para tabla 	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);--Variable para consultar la existencia de registros en la tabla
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar
	V_NUM NUMBER(16); --Variable para comprobar si existen registros
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6643';
	

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));		   
	
	V_MSQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TTAS 
							LEFT JOIN  '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = TTAS.ACT_NUM_ACTIVO
							WHERE ACT.BIE_ID  NOT IN (SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_VALORACIONES WHERE  USUARIOCREAR =  '''||V_USUARIO||''' )';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

	IF V_NUM = 0 THEN

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE VOLCADO SOBRE LA TABLA '||V_ESQUEMA||'.ACT_TAS_TASACION');

        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_TAS_TASACION (
			                        ACT_ID, 
									BIE_VAL_ID, 
									TAS_ID, 
									FECHACREAR,
			                        USUARIOCREAR,	VERSION, BORRADO, 
									TAS_FECHA_INI_TASACION, 
									TAS_IMPORTE_TAS_FIN)
                             SELECT 
										(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = TTAS.ACT_NUM_ACTIVO),
	                                    (SELECT BIE_VAL_ID FROM '||V_ESQUEMA||'.BIE_VALORACIONES 
																			WHERE BIE_ID = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = TTAS.ACT_NUM_ACTIVO) 
																			AND USUARIOCREAR =  '''||V_USUARIO||'''),
	                                    '||V_ESQUEMA||'.S_ACT_TAS_TASACION.NEXTVAL,
	                                    SYSDATE,
	                                    '''||V_USUARIO||''',
	                                    0,
	                                    0,
	                                   	TO_DATE(SUBSTR(TTAS.TAS_FECHA_INI_TASACION_PRINEX,1,10), ''YYYY/MM/DD''),
	                                    TO_NUMBER(TTAS.IMPORTE_TASACION_REM, ''99999999.99'')                                       
                               FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TTAS';


			EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros');  
	COMMIT;
	END IF;

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
