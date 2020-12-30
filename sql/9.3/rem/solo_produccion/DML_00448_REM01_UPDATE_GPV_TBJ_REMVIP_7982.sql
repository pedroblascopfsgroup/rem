--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200908
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7982
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-7982';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			

-----------------------------------------------------------------------------------------------------------------
	    
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar GPV_TBJ');
                                        
    V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_TBJ
				SET 
					BORRADO = 1,
               		USUARIOBORRAR = ''' || V_USUARIO || ''',
			    	FECHABORRAR   = SYSDATE 	
                WHERE GPV_ID IN (                                        
                                   SELECT GPV_ID
                                   FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
                                   WHERE GPV_NUM_GASTO_HAYA IN (11226719,11968111)                                            
                                 )';
	

	EXECUTE IMMEDIATE V_SQL;	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros');  

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
