--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20230110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-13016
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
	
	V_TABLA_TMP VARCHAR2(50 CHAR) := 'AUX_REMVIP_13016'; -- Variable para tabla 	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);--Variable para consultar la existencia de registros en la tabla
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar
	V_NUM NUMBER(16); --Variable para comprobar si existen registros
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-13016';
	V_NUM_ACTIVO VARCHAR2(32000 CHAR);
	

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));		

    -- Comprobar que existen los activos
    V_MSQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' WHERE ID_HAYA IN (SELECT ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE BORRADO = 0)';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han encontrado '||V_NUM||' registros que no se encuentran en la tabla de activos');

    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' T1 USING (
                            SELECT ACT.ACT_ID, ID_HAYA FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                            JOIN '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX ON AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
                            WHERE ACT.BORRADO = 0) T2
                            ON (T1.ID_HAYA = T2.ID_HAYA)
                            WHEN MATCHED THEN UPDATE SET
                            T1.ACT_ID = T2.ACT_ID';
    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han MODIFICADO '||SQL%ROWCOUNT||' registros');

    COMMIT;

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
                                        (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_ID = AUX.ACT_ID),
                                         '||V_ESQUEMA||'.S_BIE_VALORACIONES.NEXTVAL,
                                        AUX.IMPORTE_TASACION,
                                        AUX.FECHA_TASACION,
                                        (SELECT DD_TRA_ID FROM '||V_ESQUEMA||'.DD_TRA_TASADORA WHERE DD_TRA_CODIGO = AUX.dd_tra_codigo),
                                        SYSDATE,
                                        '''||V_USUARIO||''',
                                        0,
                                        0
                                    FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX WHERE AUX.ACT_ID IS NOT NULL';

            EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros');

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
                        AUX.ACT_ID,
                        (SELECT BIE_VAL_ID FROM '||V_ESQUEMA||'.BIE_VALORACIONES
                                                            WHERE BIE_ID = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_ID = AUX.ACT_ID)
                                                            AND USUARIOCREAR =  '''||V_USUARIO||'''),
                        (SELECT DD_TTS_ID FROM '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION WHERE DD_TTS_CODIGO = ''03''),
                        '||V_ESQUEMA||'.S_ACT_TAS_TASACION.NEXTVAL,
                        AUX.IMPORTE_TASACION,
                        AUX.FECHA_TASACION,
                        (SELECT DD_TRA_DESCRIPCION FROM '||V_ESQUEMA||'.DD_TRA_TASADORA WHERE DD_TRA_CODIGO = aux.dd_tra_codigo),
                        SYSDATE,
                        '''||V_USUARIO||''',
                        0,
                        0
                FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX WHERE AUX.ACT_ID IS NOT NULL';


            EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
