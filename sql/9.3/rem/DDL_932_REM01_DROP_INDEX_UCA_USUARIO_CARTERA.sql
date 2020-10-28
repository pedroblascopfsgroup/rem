--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201028
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-8279
--## PRODUCTO=NO
--## 
--## Finalidad: Eliminación de índice que bloquea añadir USU_ID duplicados, necesario para añadir en un usuario dos subcarteras
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

	V_ESQUEMA VARCHAR2(20 CHAR):= '#ESQUEMA#';
	V_TABLA_CARTERA VARCHAR2(100 CHAR):= 'UCA_USUARIO_CARTERA';
	V_INDEX VARCHAR2(100 CHAR):= 'UCA_USUARIO_CARTERA_USUUNIQUE';

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Eliminar índice '||V_INDEX||' de la tabla '||V_ESQUEMA||'.'||V_TABLA_CARTERA||'');  

	EXECUTE IMMEDIATE 'DROP INDEX '||V_ESQUEMA||'.'||V_INDEX||'';

	DBMS_OUTPUT.PUT_LINE('[FIN] INDICE '||V_INDEX||' BORRADO'); 
	
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
