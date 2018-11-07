--/*
--#########################################
--## AUTOR=Javier Pons
--## FECHA_CREACION=20181006
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-2450
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar la revision de calidad del activo
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

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLA VARCHAR2(40 CHAR) := 'AUX_JPR_ACT_ACTIVOS';

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	EXECUTE IMMEDIATE 'MERGE INTO REM01.ACT_ACTIVO T1
						USING (
							SELECT ID_HAYA, 
							       FECHA_SELLO 
							FROM REM01.AUX_JPR_ACT_ACTIVOS     
						) T2
						ON (T1.ACT_NUM_ACTIVO = T2.ID_HAYA)
						WHEN MATCHED THEN UPDATE SET
							T1.ACT_FECHA_SELLO_CALIDAD = T2.FECHA_SELLO,
							T1.ACT_SELLO_CALIDAD = 1,
							T1.USUARIOMODIFICAR = ''REMVIP-2450'',
							T1.FECHAMODIFICAR = SYSDATE;
	';
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' Activos a los que actualizamos los sellos de calidad.');  

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
