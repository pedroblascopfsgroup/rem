--/*
--##########################################
--## AUTOR= Salvador Puertes
--## FECHA_CREACION=20190607
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.13
--## INCIDENCIA_LINK= HREOS-6592
--## PRODUCTO=NO
--##
--## Finalidad: Corregir importe total mal insertado en base de datos
--##
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- Comprobamos el dato a insertar
	-- GPV_GASTOS_PROVEEDOR 
	-- GDE_GASTOS_DETALLE_ECONOMICO
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID  WHERE GPV.GPV_NUM_GASTO_HAYA = ''10291064'' AND GPV.BORRADO=0 AND GDE.BORRADO=0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	--Si existe el código lo updateamos
	IF V_NUM_TABLAS > 0 THEN				
	  
		  DBMS_OUTPUT.PUT_LINE('	[INFO]  Existe el Gasto 10291064 . Procedemos a updatear sus importes.');
		  
		  V_MSQL :=    'UPDATE '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO SET GDE_IMPORTE_TOTAL= 
						(GDE_PRINCIPAL_SUJETO+GDE_PRINCIPAL_NO_SUJETO+GDE_RECARGO+GDE_INTERES_DEMORA+GDE_COSTAS+GDE_OTROS_INCREMENTOS+GDE_PROV_SUPLIDOS)                                            
						WHERE 
							GPV_ID IN (
								SELECT GPV.GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
									JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID 
									WHERE GPV.GPV_NUM_GASTO_HAYA = ''10291064'' AND GPV.BORRADO = 0 AND GDE.BORRADO = 0
								) 
							AND BORRADO = 0
			';
		  EXECUTE IMMEDIATE V_MSQL;
		  DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos (GDE_GASTOS_DETALLE_ECONOMICO)');
	  
   --Si no existe, no hacemos nada   
   ELSE
   
		  DBMS_OUTPUT.PUT_LINE('	[INFO] No existe el gasto 10291064. No hacemos nada.');
	
   END IF;
   
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/
EXIT
