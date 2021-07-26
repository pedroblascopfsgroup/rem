--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210724
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10195
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar tabla situacion comercial activos
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-10195';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_TEXT_TABLA VARCHAR(100 CHAR):= 'AUX_REMVIP_10195';

BEGIN			
			

-----------------------------------------------------------------------------------------------------------------

 -- Verificar si la tabla ya existe
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]  EXISTE LA TABLA AUX_REMVIP_10195');
       
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_ACTIVO - DD_EAC_ID');

										
	 V_SQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO act
				using (				
                           
               SELECT       
               aux.NUM_ACTIVO as NUM_ACTIVO
              
               FROM '||V_ESQUEMA||'.AUX_REMVIP_10195 aux
                
        		) us 
        	   ON (us.NUM_ACTIVO = act.ACT_NUM_ACTIVO AND act.BORRADO=0)
				WHEN MATCHED THEN UPDATE SET 
                    act.DD_EAC_ID = (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE BORRADO = 0 AND DD_EAC_CODIGO = ''06''),
	    			act.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    			act.FECHAMODIFICAR   = SYSDATE';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' ACTIVOS ');  

    ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA TABLA AUX_REMVIP_10195');
    
    END IF;

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
