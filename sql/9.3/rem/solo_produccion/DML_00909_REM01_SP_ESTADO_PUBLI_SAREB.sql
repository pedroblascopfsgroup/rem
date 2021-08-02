--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20210616
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-0000
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_MSQL VARCHAR(4000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'remmaster'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(200 CHAR);
	V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-0000';
   	PL_OUTPUT VARCHAR2(32000 CHAR);
    	P_ACT_ID NUMBER;
    	P_ALL_ACTIVOS NUMBER;
   	V_MAX_PTO_ID NUMBER(16,0);
    	V_EJE_ID NUMBER(16,0);
    	V_COUNT NUMBER(16):= 0;
    	V_COUNT2 NUMBER(16):= 0;
    	HORA_INI TIMESTAMP;
    	HORA_FIN TIMESTAMP;
    	v_n  INTERVAL DAY TO SECOND ;

BEGIN			
	
	HORA_INI := SYSTIMESTAMP;
    
	    DBMS_OUTPUT.put_line('[INICIO] Ejecutando actualizacion estados publicacion ...........'||HORA_INI||' ');
	  				
	   REM01.SP_CAMBIO_ESTADO_PUBLICACION_VM (null,1,''||V_USUARIOMODIFICAR||'');
	
	    HORA_FIN := SYSTIMESTAMP;
	    
	    v_n := HORA_FIN - HORA_INI;
	    
  	COMMIT;
	
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
