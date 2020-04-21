--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200331
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6780
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
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6780';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR PROVEEDOR TRABAJO');

	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = 9000144378' INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN

	V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO 
	            SET USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
			FECHAMODIFICAR   = SYSDATE, 
                   	PVC_ID = (SELECT PVC_ID FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO WHERE PVE_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = ''110115587'') AND PVC_PRINCIPAL = 1)
                    	WHERE TBJ_NUM_TRABAJO = 9000144378';	

		EXECUTE IMMEDIATE V_SQL;

        	V_COUNT := V_COUNT + 1;

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] El trabajo no existe!');
				
	END IF;
    
     DBMS_OUTPUT.PUT_LINE('[INFO]  REGISTRO ACTUALIZADO');  

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
