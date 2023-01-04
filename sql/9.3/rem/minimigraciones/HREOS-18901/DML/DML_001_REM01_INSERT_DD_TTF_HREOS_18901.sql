--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20221103
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18901
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion tarifas Divarian en la tabla ACT_CFT_CONFIG_TARIFA.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'AUX_HREOS_18901'; -- Variable para tabla de salida para el borrado	
	V_TABLA_TIPO VARCHAR2(40 CHAR):='DD_TTF_TIPO_TARIFA';--Variable para la tabla de volcado
    V_TABLA_TARIFA VARCHAR2(100 CHAR):='ACT_CFT_CONFIG_TARIFA';
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);--Variable para consultar la existencia de registros en la tabla
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar
	V_NUM NUMBER(16); --Variable para comprobar si existen registros
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-18901';
	

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));	

	V_MSQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA||'.'||V_TABLA_TIPO||' WHERE DD_TTF_CODIGO NOT IN (SELECT CODIGO FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' GROUP BY CODIGO)';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

	IF V_NUM >0 THEN

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE VOLCADO SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TIPO||'.');

	V_SQL := ('INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TIPO||' (
				  DD_TTF_ID
				, DD_TTF_CODIGO
				, DD_TTF_DESCRIPCION
				, DD_TTF_DESCRIPCION_LARGA
				, VERSION
				, USUARIOCREAR
				, FECHACREAR
				, BORRADO
			  )
				SELECT 
					  '||V_ESQUEMA||'.S_'||V_TABLA_TIPO||'.NEXTVAL
					, REGEXP_REPLACE( TMP.CODIGO, ''[[:space:]]'', '''' )
					, SUBSTR(TMP.DESCRIPCION_TIPO_TARIF,1,100)
					, TMP.DESCRIPCION_TIPO_TARIF
					, 0
					, '''||V_USUARIO||'''
					, SYSDATE
					, 0
				FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
				WHERE  TMP.CODIGO NOT IN (SELECT DD_TTF_CODIGO FROM '||V_ESQUEMA||'.'||V_TABLA_TIPO||')'
				);

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_TIPO);  
	COMMIT;
	END IF;    


	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecuci�n:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;