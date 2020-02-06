--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200123
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6026
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6026';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Inserta nuevos registros en ACT_GES_DIST_GESTORES');
										
	 V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES
		  ( ID, COD_CARTERA, TIPO_GESTOR, USERNAME, NOMBRE_USUARIO, COD_PROVINCIA, USUARIOCREAR, FECHACREAR, VERSION, BORRADO )
		   SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
		   COD_CARTERA,
		   TIPO_GESTOR,
		   ''mblascop'',
		   '' María Blasco del Pico'',
		   COD_PROVINCIA,
		   ''REMVIP-6026'',
		   SYSDATE,
		   0,
		   0
		   FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES	
		   WHERE COD_CARTERA = ''8''
		   AND TIPO_GESTOR = ''SUPACT''
		   AND USERNAME = ''amartinezb'' '; 
 

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Creados '||SQL%ROWCOUNT||' registros en ACT_GES_DIST_GESTORES ');  


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_GES_DIST_GESTORES - Borrado lógico ');
										
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES
		   SET BORRADO = 1,
		       USUARIOBORRAR = ''REMVIP-6026'',
		       FECHABORRAR = SYSDATE				  
		   WHERE COD_CARTERA = ''8''
		   AND TIPO_GESTOR = ''SUPACT''
		   AND USERNAME = ''amartinezb'' '; 
 

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_GES_DIST_GESTORES ');  


-----------------------------------------------------------------------------------------------------------------

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
