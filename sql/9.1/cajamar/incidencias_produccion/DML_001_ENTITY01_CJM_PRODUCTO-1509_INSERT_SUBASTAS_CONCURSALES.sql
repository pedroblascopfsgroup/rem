--/*
--##########################################
--## AUTOR=JAIME SANCHEZ CUENCA
--## FECHA_CREACION=20160523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.3
--## INCIDENCIA_LINK=PRODUCTO-1509
--## PRODUCTO=NO
--## Finalidad: DML que inserta subastas concursales
--##           
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    USUARIO varchar2(20 CHAR) := 'MIGRACM01';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] CAJAMAR MIGRACION SUBASTAS FICTICIAS NO ENVIADAS');


    v_sql := 'INSERT INTO '||v_esquema||'.SUB_SUBASTA(SUB_ID, ASU_ID, PRC_ID, DD_ESU_ID, DD_TSU_ID, FECHACREAR, USUARIOCREAR, FECHAMODIFICAR, USUARIOMODIFICAR)
	SELECT '||v_esquema||'.S_SUB_SUBASTA.NEXTVAL, ASU_ID, PRC_ID, DD_ESU_ID, DD_TSU_ID, FECHACREAR, USUARIOCREAR, FECHAMODIFICAR, USUARIOMODIFICAR FROM(
	    SELECT DISTINCT ASU.ASU_ID, MAE.PRC_ID, 3 AS DD_ESU_ID, 1 AS DD_TSU_ID, SYSDATE AS FECHACREAR, '''||USUARIO||''' AS USUARIOCREAR, SYSDATE AS FECHAMODIFICAR, 
			    ''PRODUCTO-1509: INSERT SUBASTAS CONCURSALES'' AS USUARIOMODIFICAR, CAB.FECHA_SUBASTA AS SUB_FECHA_SENYALAMIENTO
		FROM '||v_esquema||'.MIG_CONCURSOS_CABECERA CAB, '||v_esquema||'.MIG_MAESTRA_HITOS MAE, '||v_esquema||'.ASU_ASUNTOS ASU
		WHERE CAB.FECHA_SUBASTA IS NOT NULL
		AND MAE.CD_PROCEDIMIENTO = CAB.CD_CONCURSO
		AND MAE.DD_TPO_CODIGO = ''CJ004''
		AND TO_CHAR(CAB.CD_CONCURSO) = ASU.ASU_ID_EXTERNO
		AND TO_DATE(CAB.FECHA_SUBASTA,''DD/MM/RRRR'') < TO_DATE(SYSDATE,''DD/MM/RRRR'')
		AND NOT EXISTS(SELECT 1
			 FROM '||v_esquema||'.MIG_PROCEDIMIENTOS_SUBASTAS SUB
			 WHERE SUB.CD_PROCEDIMIENTO=CAB.CD_CONCURSO)
	    UNION
	    SELECT DISTINCT ASU.ASU_ID, MAE.PRC_ID, 8 AS DD_ESU_ID, 1 AS DD_TSU_ID, SYSDATE AS FECHACREAR, '''||USUARIO||''' AS USUARIOCREAR, SYSDATE AS FECHAMODIFICAR, 
			    ''PRODUCTO-1509: INSERT SUBASTAS CONCURSALES'' AS USUARIOMODIFICAR, CAB.FECHA_SUBASTA AS SUB_FECHA_SENYALAMIENTO
		FROM '||v_esquema||'.MIG_CONCURSOS_CABECERA CAB, '||v_esquema||'.MIG_MAESTRA_HITOS MAE, '||v_esquema||'.ASU_ASUNTOS ASU
		WHERE CAB.FECHA_SUBASTA IS NOT NULL
		AND MAE.CD_PROCEDIMIENTO = CAB.CD_CONCURSO
		AND MAE.DD_TPO_CODIGO = ''CJ004''
		AND TO_CHAR(CAB.CD_CONCURSO) = ASU.ASU_ID_EXTERNO
		AND TO_DATE(CAB.FECHA_SUBASTA,''DD/MM/RRRR'') >= TO_DATE(SYSDATE,''DD/MM/RRRR'')
		AND NOT EXISTS(SELECT 1
			 FROM '||v_esquema||'.MIG_PROCEDIMIENTOS_SUBASTAS SUB
			 WHERE SUB.CD_PROCEDIMIENTO=CAB.CD_CONCURSO)
	)';

    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - INSERT INTO SUB_SUBASTA - SUBASTAS CONCURSALES: '||SQL%ROWCOUNT||' Filas');
    commit;

DBMS_OUTPUT.PUT_LINE('[FIN] CAJAMAR MIGRACION SUBASTAS CONCURSALES');

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
