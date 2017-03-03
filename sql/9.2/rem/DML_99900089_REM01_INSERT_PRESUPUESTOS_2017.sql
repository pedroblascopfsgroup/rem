--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170303
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1700
--## PRODUCTO=NO
--## Finalidad: DML creación de presupuestos para activos ejercicio #ANYO#.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    err_num NUMBER; -- Numero de errores.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(4000 CHAR);
    V_MAX_PTO_ID NUMBER(16,0);
    V_EJE_ID NUMBER(16,0);
    V_ANYO_EJERCICIO NUMBER(16,0):= #ANYO#;
    
    CURSOR ACTIVOS_SIN_PRESUPUESTO IS SELECT ACT_ID FROM ACT_ACTIVO WHERE BORRADO = 0 MINUS
              						  SELECT PTO.ACT_ID FROM ACT_EJE_EJERCICIO EJE, ACT_PTO_PRESUPUESTO PTO
    									WHERE EJE.EJE_ANYO = V_ANYO_EJERCICIO AND PTO.EJE_ID = EJE.EJE_ID AND PTO.BORRADO = 0;
    									
    						
    FILA ACTIVOS_SIN_PRESUPUESTO%ROWTYPE;
    
BEGIN
	
  DBMS_OUTPUT.put_line('[INFO] Ejecutando inserción de presupuestos...........');
	      
	SELECT MAX(PTO.PTO_ID) INTO V_MAX_PTO_ID FROM ACT_PTO_PRESUPUESTO PTO;
	SELECT EJE.EJE_ID INTO V_EJE_ID FROM ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = V_ANYO_EJERCICIO;
	
	OPEN ACTIVOS_SIN_PRESUPUESTO;

	LOOP
  		FETCH ACTIVOS_SIN_PRESUPUESTO INTO FILA;
  		EXIT WHEN ACTIVOS_SIN_PRESUPUESTO%NOTFOUND;
  		
		V_MAX_PTO_ID := V_MAX_PTO_ID + 1;
		
  		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO(PTO_ID, ACT_ID, EJE_ID, PTO_IMPORTE_INICIAL, PTO_FECHA_ASIGNACION, USUARIOCREAR, FECHACREAR)
					VALUES('||V_MAX_PTO_ID||', '
          ||FILA.ACT_ID||', '
          ||V_EJE_ID||', 50000, SYSDATE, '''||V_ESQUEMA||''', 
          SYSDATE)';

  		EXECUTE IMMEDIATE V_MSQL;
  		
  	

	END LOOP;
	CLOSE ACTIVOS_SIN_PRESUPUESTO;
	  
  
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