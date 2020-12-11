--/*
--#########################################
--## AUTOR= Carlos Santos Vílchez
--## FECHA_CREACION=20201201
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8454
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar subestado de cargas
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
	V_TABLA_CARGAS VARCHAR2(100 CHAR):= 'ACT_CRG_CARGAS';
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-8454';
	V_SQL VARCHAR2(4000 CHAR);

BEGIN						


	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACIÓN DE SUBESTADO DE CARGAS');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_CARGAS||' T1
		        USING (
					SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_8454 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
					WHERE ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
        		) T2 
        	  ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE
					SET T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
	    				T1.FECHAMODIFICAR   = SYSDATE,
						T1.DD_SCG_ID = (SELECT DD_SCG_ID FROM '||V_ESQUEMA||'.DD_SCG_SUBESTADO_CARGA WHERE DD_SCG_CODIGO = 16)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS EN '||V_TABLA_CARGAS);  

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
EXIT
