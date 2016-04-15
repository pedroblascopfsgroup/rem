WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA02'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    USUARIO varchar2(20 CHAR) := 'MIGRAHAYA02';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] CAJAMAR MIGRACION SUBASTAS FICTICIAS NO ENVIADAS');


    v_sql := 'INSERT INTO '||v_esquema||'.SUB_SUBASTA(SUB_ID, ASU_ID, PRC_ID, DD_ESU_ID, FECHACREAR, USUARIOCREAR, FECHAMODIFICAR, USUARIOMODIFICAR)
		SELECT '||v_esquema||'.S_SUB_SUBASTA.NEXTVAL, ASU_ID, PRC_ID, DD_ESU_ID, FECHACREAR, USUARIOCREAR, FECHAMODIFICAR, USUARIOMODIFICAR FROM(
		SELECT DISTINCT ASU.ASU_ID, MAE.PRC_ID, 8 AS DD_ESU_ID, SYSDATE AS FECHACREAR, '''||USUARIO||''' AS USUARIOCREAR, SYSDATE AS FECHAMODIFICAR, ''CMREC-3078 - SUB_NO_ENVIADA'' AS USUARIOMODIFICAR
		FROM '||v_esquema||'.MIG_PROCEDIMIENTOS_CABECERA CAB, '||v_esquema||'.MIG_MAESTRA_HITOS MAE, '||v_esquema||'.ASU_ASUNTOS ASU
		WHERE CAB.ULTIMO_HITO IN (''34'',''35'',''36'',''37'',''38'',''39'',''53'',''54'',''55'',''56'',''57'',''58'',''63'',''64'',''65'',''66'',''67'',''68'',''69'')
		AND MAE.CD_PROCEDIMIENTO = CAB.CD_PROCEDIMIENTO
		AND MAE.DD_TPO_CODIGO = ''H002''
		AND TO_CHAR(CAB.CD_PROCEDIMIENTO) = ASU.ASU_ID_EXTERNO
		AND NOT EXISTS(SELECT 1
			       FROM '||v_esquema||'.MIG_PROCEDIMIENTOS_SUBASTAS SUB
			       WHERE SUB.CD_PROCEDIMIENTO=CAB.CD_PROCEDIMIENTO)
		)';

    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - INSERT INTO SUB_SUBASTA - SUBASTAS FICTICIAS NO ENVIADAS. '||SQL%ROWCOUNT||' Filas');
    Commit;

    v_sql := 'UPDATE '||v_esquema||'.SUB_SUBASTA
		SET DD_ESU_ID = 8, --PTE CELEBRACION (SI ESTA CELEBRADA, SE UPDATEA POSTERIORMENTE)
		    DD_REC_ID = NULL,
		    DD_MSS_ID = NULL,
		    DD_MCS_ID = NULL,
		    DD_TSU_ID = 1
		WHERE USUARIOCREAR = '''||USUARIO||'''';

    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - INSERT INTO SUB_SUBASTA - SUBASTAS UPDATE (1). '||SQL%ROWCOUNT||' Filas');
    Commit;

    v_sql := 'UPDATE '||v_esquema||'.SUB_SUBASTA SUB
		SET DD_REC_ID = 3 -- (ACE	Continuar Subasta)
		WHERE EXISTS( SELECT 1
			      FROM '||v_esquema||'.MIG_MAESTRA_HITOS MAE
			      WHERE MAE.PRC_ID = SUB.PRC_ID
			      AND MAE.TAP_CODIGO = ''H002_ObtenerValidacionComite'')';

    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - INSERT INTO SUB_SUBASTA - SUBASTAS UPDATE (2). '||SQL%ROWCOUNT||' Filas');
    Commit;


DBMS_OUTPUT.PUT_LINE('[FIN] CAJAMAR MIGRACION SUBASTAS FICTICIAS NO ENVIADAS');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;
