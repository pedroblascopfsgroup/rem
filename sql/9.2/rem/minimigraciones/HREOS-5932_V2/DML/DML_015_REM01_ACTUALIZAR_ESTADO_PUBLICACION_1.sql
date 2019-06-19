--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190507
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5932
--## PRODUCTO=NO
--## Finalidad: RECALCULAR ESTADO PUBLICACION PUNTO 1.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE ON;


DECLARE
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'HREOS-5932';
    V_MSQL VARCHAR2(4000 CHAR);
    V_MAX_PTO_ID NUMBER(16,0);
    V_EJE_ID NUMBER(16,0);
    V_COUNT NUMBER(16):= 0;
    V_COUNT2 NUMBER(16):= 0;
    HORA_INI TIMESTAMP;
    HORA_FIN TIMESTAMP;
    v_n  INTERVAL DAY TO SECOND ;
      
    
    CURSOR ESTADO_PUBLI_RECALCULAR IS SELECT ACT.ACT_ID , ACT.ACT_NUM_ACTIVO
										FROM REM01.AUX_HREOS_5932_PERIM PERIM
										INNER JOIN REM01.ACT_ACTIVO ACT ON PERIM.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
										WHERE PERIM.USUARIOMODIFICAR = 'HREOS-5932-PUNTO1' AND PERIM.FLAG_PUBLICACION = 0
										ORDER BY PERIM.ACT_NUM_ACTIVO ASC;

    									
    						
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
  				
  		REM01.SP_CAMBIO_ESTADO_PUBLICACION (FILA.ACT_ID,1,''||V_USUARIOMODIFICAR||'');
  		
  		V_MSQL := 'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932_PERIM SET FLAG_PUBLICACION = 1 WHERE ACT_NUM_ACTIVO = '||FILA.ACT_NUM_ACTIVO||'';
        
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
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Duración la ejecución................'||EXTRACT( SECOND FROM v_n)||' segundos ');
      
  COMMIT;
  

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
