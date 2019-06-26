--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190327
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5932
--## PRODUCTO=NO
--## Finalidad: PUNTO 3.3.1 - D
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'HREOS-5932-PUNTO3-VA';
    V_MSQL VARCHAR2(4000 CHAR);
    V_MAX_PTO_ID NUMBER(16,0);
    V_EJE_ID NUMBER(16,0);
    V_COUNT NUMBER(16):= 0;
    V_COUNT2 NUMBER(16):= 0;
    
      
    
    CURSOR OFERTAS_A_ELIMINAR IS  SELECT DISTINCT  
												  ACT.ACT_NUM_ACTIVO
												, OFR.OFR_ID 
												, ECO.ECO_NUM_EXPEDIENTE 
												, TRA.TRA_ID
												, TEX.TAR_ID
										FROM REM01.ACT_ACTIVO ACT 
											INNER JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO <> '05'
											INNER JOIN REM01.ACT_APU_ACTIVO_PUBLICACION APU on act.act_id = apu.act_id
                                            inner join REM01.DD_TCO_TIPO_COMERCIALIZACION tco on tco.dd_tco_id = apu.dd_tco_id
                                            INNER JOIN REM01.ACT_OFR AFR ON ACT.ACT_ID = AFR.ACT_ID
											INNER JOIN REM01.OFR_OFERTAS OFR ON OFR.OFR_ID = AFR.OFR_ID AND OFR.BORRADO = 0
											INNER JOIN REM01.DD_TOF_TIPOS_OFERTA tof on tof.dd_tof_id = ofr.dd_tof_id
											LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
											LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID AND EEC.DD_EEC_CODIGO NOT IN ('08','09','16')
											INNER JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF on EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.DD_EOF_CODIGO <> '02'
											LEFT JOIN REM01.ACT_TRA_TRAMITE TRA ON TRA.ACT_ID = ACT.ACT_ID AND TRA.TRA_FECHA_FIN IS NULL
											LEFT JOIN REM01.TAC_TAREAS_ACTIVOS TAC on TAC.TRA_ID = TRA.TRA_ID AND TAC.BORRADO = 0
											LEFT JOIN REM01.TEX_TAREA_EXTERNA TEX on TAC.TAR_ID = TEX.TAR_ID AND TEX.BORRADO = 0
											LEFT JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
											LEFT JOIN REM01.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID AND TPO.DD_TPO_CODIGO in ('T013')
										WHERE ACT.USUARIOMODIFICAR like 'HREOS-5932-PUNTO3%' and TOF.DD_TOF_CODIGO = '01' and tco.dd_tco_codigo in ('03');
    									
    						
    FILA OFERTAS_A_ELIMINAR%ROWTYPE;
    
BEGIN
	
  DBMS_OUTPUT.put_line('[INICIO] Ejecutando borrado de tareas y ofertas ...........');	      	
	      	
	OPEN OFERTAS_A_ELIMINAR;
	
	V_COUNT := 0;
	V_COUNT2 := 0;
	
	LOOP
  		FETCH OFERTAS_A_ELIMINAR INTO FILA;
  		EXIT WHEN OFERTAS_A_ELIMINAR%NOTFOUND;
  				
  		V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET 
						DD_EOF_ID = (SELECT EOF.DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = ''02'')
					  , USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
					  , FECHAMODIFICAR = SYSDATE
					WHERE OFR_ID = '||FILA.OFR_ID||'';
    
        					
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		IF FILA.ECO_NUM_EXPEDIENTE IS NOT NULL THEN
  		
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET 
							DD_EEC_ID = (SELECT EEC.DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = ''02'')
						  , ECO_FECHA_ANULACION = SYSDATE
						  , USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
						WHERE ECO_NUM_EXPEDIENTE = '||FILA.ECO_NUM_EXPEDIENTE||'';
			
			 	
            EXECUTE IMMEDIATE V_MSQL;
            
		IF FILA.TRA_ID IS NOT NULL THEN	
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TRA_TRAMITE SET 
							TRA_FECHA_FIN = SYSDATE
						  , USUARIOBORRAR = '''||V_USUARIOMODIFICAR||'''
						  , FECHABORRAR = SYSDATE
						  , BORRADO = 1
						WHERE TRA_ID = '||FILA.TRA_ID||'';
			 	
			EXECUTE IMMEDIATE V_MSQL;
        END IF;    
        
		IF FILA.TAR_ID IS NOT NULL THEN	
            
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET 
							TAR_FECHA_FIN = SYSDATE
						  , TAR_TAREA_FINALIZADA = 1
						  , USUARIOBORRAR = '''||V_USUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
						  , BORRADO = 1
						WHERE TAR_ID = '||FILA.TAR_ID||'';
			 	
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA SET 
							USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
						  , USUARIOBORRAR = '''||V_USUARIOMODIFICAR||'''
						  , FECHABORRAR = SYSDATE
						  , BORRADO = 1
						WHERE TAR_ID = '||FILA.TAR_ID||'';
			 	
			EXECUTE IMMEDIATE V_MSQL;
        
        END IF;    
			
		END IF;
 		
  		  		
  		V_COUNT := V_COUNT + 1 ;
        V_COUNT2 := V_COUNT2 +1 ;
        
        IF V_COUNT2 = 100 THEN
            
            COMMIT;
            
            DBMS_OUTPUT.PUT_LINE('[INFO] Se comitean '||V_COUNT2||' registros ');
            V_COUNT2 := 0;
            
        END IF;
  		
	END LOOP;
	
    DBMS_OUTPUT.PUT_LINE('[INFO] Se comitean '||V_COUNT2||' registros ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han DADO DE BAJA '||V_COUNT||' OFERTAS y TRAMITES ASOCIADOS ');
    
	CLOSE OFERTAS_A_ELIMINAR;
	
    DBMS_OUTPUT.PUT_LINE('[FIN] Ha finalizado la ejecución');
      
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

