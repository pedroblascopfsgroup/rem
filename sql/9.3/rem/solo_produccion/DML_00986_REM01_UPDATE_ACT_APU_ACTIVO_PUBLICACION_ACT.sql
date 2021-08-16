--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210729
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10251
--## PRODUCTO=NO
--## 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_MSQL VARCHAR(4000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(200 CHAR);
	V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'CCONV_SAREB';
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
      
    
    	CURSOR ESTADO_PUBLI_RECALCULAR IS SELECT ACT.ACT_ID 
					  FROM REM01.AUX_ESPARTA_PUBL_ACT PERIM 
					  INNER JOIN REM01.ACT_ACTIVO ACT ON PERIM.ACT_ID = ACT.ACT_ID 
					  WHERE PERIM.PROCESADO = 0;
    
    						
        FILA ESTADO_PUBLI_RECALCULAR%ROWTYPE;

BEGIN			

	HORA_INI := SYSTIMESTAMP;
    
	    DBMS_OUTPUT.put_line('[INICIO] Ejecutando actualizacion estados publicacion ...........'||HORA_INI||' ');
	  
	       	 
		OPEN ESTADO_PUBLI_RECALCULAR;
	
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
	  		FETCH ESTADO_PUBLI_RECALCULAR INTO FILA;
	  		EXIT WHEN ESTADO_PUBLI_RECALCULAR%NOTFOUND;
	  				
	  		REM01.SP_CAMBIO_ESTADO_PUBLICACION_VM (FILA.ACT_ID,1,''||V_USUARIOMODIFICAR||'');

			-- Actualiza el campo procesado = 1		
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.AUX_ESPARTA_PUBL_ACT
		   		   SET PROCESADO = 1
			           WHERE ACT_ID = ' || FILA.ACT_ID ;

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
	    
	    DBMS_OUTPUT.PUT_LINE('[FIN] Ha finalizado la ejecución '||HORA_FIN||' ');
	    
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