--/*
--##########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160422
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Carga de datos en ACT_EJE_EJERCICIO y ACT_PTO_PRESUPUESTO
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';

BEGIN

	EXECUTE IMMEDIATE '
	TRUNCATE TABLE '||V_ESQUEMA||'.ACT_EJE_EJERCICIO
	'
	;
	
	EXECUTE IMMEDIATE '
	TRUNCATE TABLE '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO
	'
	;
	
	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.ACT_EJE_EJERCICIO(
	EJE_ID,
	EJE_ANYO,
	EJE_FECHAINI,	
	EJE_FECHAFIN,		
	EJE_DESCRIPCION,
	USUARIOCREAR, 
	FECHACREAR)
	VALUES(
	'||V_ESQUEMA||'.S_ACT_EJE_EJERCICIO.NEXTVAL,
	''2016'',
	TO_DATE(''01-01-2016'', ''DD-MM-YYYY''),
	TO_DATE(''31-12-2016'', ''DD-MM-YYYY''),
	''Ejercicio correspondiente al año 2016'',
	''MIG'',
	SYSDATE
	)
	'
	;		
	
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_EJE_EJERCICIO cargada. '||SQL%ROWCOUNT||' Filas.');
  
	COMMIT;
				
	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO(
	PTO_ID,
	ACT_ID,
	EJE_ID,
	PTO_IMPORTE_INICIAL,	
	PTO_FECHA_ASIGNACION,		
	USUARIOCREAR, 
	FECHACREAR)
	SELECT
	'||V_ESQUEMA||'.S_ACT_PTO_PRESUPUESTO.NEXTVAL,
	ACT.ACT_ID,
	EJE.EJE_ID,
	''50000'',
	EJE.EJE_FECHAINI,
	''REM01'',
	SYSDATE
	FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT, 
	'||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE
	'
	;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO cargada. '||SQL%ROWCOUNT||' Filas.');
  
	COMMIT;

EXCEPTION

	WHEN OTHERS THEN

		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------');
		DBMS_OUTPUT.put_line(SQLERRM);

    ROLLBACK;
    RAISE;

END;
/
EXIT
