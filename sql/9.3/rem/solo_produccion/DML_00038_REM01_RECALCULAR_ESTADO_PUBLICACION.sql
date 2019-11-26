--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5440
--## PRODUCTO=NO
--## 
--## Finalidad: RECALCULAR SITUACION COMERCIAL Y ESTADO DE PUBLICACION
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

	V_MSQL VARCHAR(4000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(200 CHAR);
	V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5440_V2';
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
      
    
    	CURSOR ESTADO_PUBLI_RECALCULAR IS SELECT ACT.ACT_ID , ACT.ACT_NUM_ACTIVO
					  FROM REM01.AUX_REMVIP_5440_V2 PERIM 
					  INNER JOIN REM01.ACT_ACTIVO ACT ON PERIM.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO 
					  WHERE PERIM.PROCESADO = 0;
    
    						
        FILA ESTADO_PUBLI_RECALCULAR%ROWTYPE;

BEGIN			
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Recalcular Situacion comercial '); 

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.AUX_REMVIP_5440_V2 
		   SET DD_SCM_ID = ( SELECT DD_SCM_ID 
				     FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
				     WHERE ACT.ACT_NUM_ACTIVO = AUX_REMVIP_5440_V2.ACT_NUM_ACTIVO )
	           WHERE 1=1 ';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTUALIZADOS');


	--DBMS_OUTPUT.PUT_LINE('	[INFO] Se procede a borrar la situación comercial de los activos migrados.'); 
	
	--V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET DD_SCM_ID = NULL 
	--			WHERE ACT_NUM_ACTIVO IN ( SELECT ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.AUX_REMVIP_5440_V2)';

	--EXECUTE IMMEDIATE V_MSQL;

	--DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTUALIZADOS');
				
	--COMMIT;
	
	--DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de recalcular Situacion comercial'); 
	
	--REM01.SP_ASC_ACT_SIT_COM_VACIOS_V2(0);
	
	--DBMS_OUTPUT.PUT_LINE('[FIN] Recalcular Situacion comercial');

	--COMMIT;

	HORA_INI := SYSTIMESTAMP;
    
	    DBMS_OUTPUT.put_line('[INICIO] Ejecutando actualizacion estados publicacion ...........'||HORA_INI||' ');
	  
	       	 
		OPEN ESTADO_PUBLI_RECALCULAR;
	
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
	  		FETCH ESTADO_PUBLI_RECALCULAR INTO FILA;
	  		EXIT WHEN ESTADO_PUBLI_RECALCULAR%NOTFOUND;
	  				
	  		REM01.SP_CAMBIO_ESTADO_PUBLICACION (FILA.ACT_ID,1,''||V_USUARIOMODIFICAR||'');

			-- Actualiza el campo procesado = 1		
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.AUX_REMVIP_5440_V2 
		   		   SET PROCESADO = 1
			           WHERE ACT_NUM_ACTIVO = ' || FILA.ACT_NUM_ACTIVO ;

			EXECUTE IMMEDIATE V_MSQL;
		  		
	  		V_COUNT := V_COUNT + 1 ;
			V_COUNT2 := V_COUNT2 +1 ;
		
			IF V_COUNT2 = 100 THEN
			    
			    COMMIT;
			    
			    DBMS_OUTPUT.PUT_LINE('	[INFO] Se actualizan '||V_COUNT2||' activos ');
			    V_COUNT2 := 0;
			    
			END IF;
	  		
		END LOOP;
	
	    DBMS_OUTPUT.PUT_LINE('	[INFO] Se actualizan '||V_COUNT2||' activos ');
	    
	    DBMS_OUTPUT.PUT_LINE('	[INFO] Se han RECALCULADO '||V_COUNT||' ESTADOS DE PUBLICACION ');
	    
	    CLOSE ESTADO_PUBLI_RECALCULAR;
	
	    HORA_FIN := SYSTIMESTAMP;
	    
	    DBMS_OUTPUT.PUT_LINE('[FIN] Ha finalizado la ejecución ');
	    
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
