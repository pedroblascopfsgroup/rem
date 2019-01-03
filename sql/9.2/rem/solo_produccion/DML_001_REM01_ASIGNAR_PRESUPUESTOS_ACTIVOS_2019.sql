--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2959
--## PRODUCTO=NO
--## Finalidad: DML creación de presupuestos para activos ejercicio 2019.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-2959';
    V_MSQL VARCHAR2(4000 CHAR);
    V_MAX_PTO_ID NUMBER(16,0);
    V_EJE_ID NUMBER(16,0);
    V_ANYO_EJERCICIO NUMBER(16,0):= 2019;
    V_COUNT NUMBER(16):= 0;
    
    CURSOR ACTIVOS_SIN_PRESUPUESTO IS  SELECT ACT.ACT_ID FROM REM01.ACT_ACTIVO ACT 
                                        INNER JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
                                        WHERE ACT.BORRADO = 0 AND SCM.DD_SCM_CODIGO  <> '05' AND ACT.BORRADO = 0
                                        MINUS
                                        SELECT PTO.ACT_ID FROM REM01.ACT_EJE_EJERCICIO EJE 
                                        INNER JOIN REM01.ACT_PTO_PRESUPUESTO PTO ON PTO.EJE_ID = EJE.EJE_ID
                                        INNER JOIN REM01.ACT_ACTIVO ACT ON PTO.ACT_ID = ACT.ACT_ID
                                        INNER JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
                                        WHERE EJE.EJE_ANYO = V_ANYO_EJERCICIO AND PTO.BORRADO = 0 AND ACT.BORRADO = 0
                                        AND SCM.DD_SCM_CODIGO  <> '05';
    									
    						
    FILA ACTIVOS_SIN_PRESUPUESTO%ROWTYPE;
    
BEGIN
	
  DBMS_OUTPUT.put_line('[INICIO] Ejecutando inserción de presupuestos...........');
	      
	SELECT EJE.EJE_ID INTO V_EJE_ID FROM ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = V_ANYO_EJERCICIO;
	
	OPEN ACTIVOS_SIN_PRESUPUESTO;

	LOOP
  		FETCH ACTIVOS_SIN_PRESUPUESTO INTO FILA;
  		EXIT WHEN ACTIVOS_SIN_PRESUPUESTO%NOTFOUND;
  		
		V_MSQL := 'SELECT '||V_ESQUEMA||'.S_ACT_PTO_PRESUPUESTO.NEXTVAL FROM DUAL';
                
		EXECUTE IMMEDIATE V_MSQL INTO V_MAX_PTO_ID;
		
  		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO(
                     PTO_ID
                    ,ACT_ID
                    ,EJE_ID
                    ,PTO_IMPORTE_INICIAL
                    ,PTO_FECHA_ASIGNACION
                    ,USUARIOCREAR
                    ,FECHACREAR
                    )VALUES(
					'||V_MAX_PTO_ID||'
					,'||FILA.ACT_ID||'
					,'||V_EJE_ID||'
					,CASE  
						WHEN (SELECT PTO_IMPORTE_INICIAL FROM '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO WHERE EJE_ID = (SELECT EJE_ID FROM ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2018'') AND ACT_ID = '||FILA.ACT_ID||') IS NOT NULL
							THEN (SELECT PTO_IMPORTE_INICIAL FROM '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO WHERE EJE_ID = (SELECT EJE_ID FROM ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2018'') AND ACT_ID = '||FILA.ACT_ID||')
						ELSE 
							1000000
						END 
					, SYSDATE
					, '''||V_USUARIOMODIFICAR||'''
					, SYSDATE)';
                
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		V_COUNT := V_COUNT + 1 ;
  		
	END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han INSERTADO '||V_COUNT||' presupuestos ');
    
	CLOSE ACTIVOS_SIN_PRESUPUESTO;
	
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
