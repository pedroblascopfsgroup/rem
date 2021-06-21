--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210616
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-0000
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Versión con ofertas express
--##		0.3 Modificaciones motivo "No adecuado" y "Revisión publicación"
--##		0.4 Optimización de tiempos
--##		0.5 HREOS-5562, Ocultación Automática, motivo "Revisión publicación", eliminar el join con la tabla TMP_PUBL_ACT
--##		0.6 REMVIP-4301 - Cambios ocultación Revisión publicación
--##		0.7 REMVIP-4622 - Ocultación alquilado
--##		0.8 HREOS-9509 - Ocultacion Adecuacion DD_ADA 05
--##		0.9 REMVIP-6642 - Ocultacion Adecuacion DD_ADA 06
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_MSQL VARCHAR(4000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(200 CHAR);
	V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'cAMBIO_PUBLICACION_SAREB';
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
					  FROM REM01.AUX_CAMBIO_PUBLICACION_SAREB PERIM 
					  INNER JOIN REM01.ACT_ACTIVO ACT ON PERIM.ACT_ID = ACT.ACT_ID 
					  WHERE PERIM.PROCESADO = 0;
    
    						
        FILA ESTADO_PUBLI_RECALCULAR%ROWTYPE;

BEGIN			
	
/*
EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA||'.AUX_CAMBIO_PUBLICACION_SAREB
		as (
			SELECT 
            act.act_id, 0 as PROCESADO
            FROM REM01.act_activo act
            join REM01.dd_cra_cartera cra on cra.dd_cra_id = act.dd_cra_id and cra.borrado = 0
            join REM01.act_apu_activo_publicacion apu on apu.act_id = act.act_id and apu.borrado = 0
            left join REM01.dd_epv_estado_pub_venta epv on apu.dd_epv_id = epv.dd_epv_id and epv.borrado = 0
            left join REM01.dd_epa_estado_pub_alquiler epa on apu.dd_epa_id = epa.dd_epa_id and epa.borrado = 0
            join REM01.act_pac_perimetro_activo pac on pac.act_id = act.act_id
            where cra.dd_cra_codigo = ''02''
            and (epv.dd_epv_codigo = ''03'' OR epa.dd_epa_codigo = ''03'')
            and pac.pac_check_publicar = 0
		)'
;
*/

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
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.AUX_CAMBIO_PUBLICACION_SAREB
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
