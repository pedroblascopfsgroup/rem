--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200121
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6168
--## PRODUCTO=NO
--## Finalidad: DML creación de presupuestos
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6168';
    V_MSQL VARCHAR2(4000 CHAR);
    V_MAX_PTO_ID NUMBER(16,0);
    V_EJE_ID NUMBER(16,0);   
  	V_ACT_ID NUMBER(16,0);
    
BEGIN
	
	DBMS_OUTPUT.put_line('[INICIO] Ejecutando inserción de presupuestos...........');


	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_ACT_PTO_PRESUPUESTO.NEXTVAL FROM DUAL';                
	EXECUTE IMMEDIATE V_MSQL INTO V_MAX_PTO_ID;
	
	V_MSQL := 'SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2018''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EJE_ID;
    
    V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = ''7072310''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;
		
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
				,'||V_ACT_ID||'
				,'||V_EJE_ID||'
				,1000000
				, SYSDATE
				, '''||V_USUARIOMODIFICAR||'''
				, SYSDATE)';
                
	EXECUTE IMMEDIATE V_MSQL;
  		
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
