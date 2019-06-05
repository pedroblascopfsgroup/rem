--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190528
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-4376
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR NOMBRE DE USUARIO
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
V_SQL VARCHAR2(10000 CHAR);
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES T1
			USING (
				SELECT * FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES ACT 
        			WHERE ACT.TIPO_GESTOR LIKE ''GFORM'' 
       				AND ACT.USERNAME LIKE ''jrodriguez''
			) T2 
			ON (T1.ID = T2.ID)
			WHEN MATCHED THEN UPDATE SET
   			USERNAME = ''jdrodriguez'', 
    			NOMBRE_USUARIO = ''DIEGO RODRIGUEZ HIDALGO'',
			T1.USUARIOMODIFICAR = ''REMVIP-4376'',
			T1.FECHAMODIFICAR = SYSDATE'
			;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' FILAS ACTUALIZADAS.');  

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_SQL);
        ROLLBACK;
        RAISE;
END;

/

EXIT

