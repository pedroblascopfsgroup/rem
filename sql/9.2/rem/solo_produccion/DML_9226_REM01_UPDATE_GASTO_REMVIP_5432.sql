--/*
--#########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20191022
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5432
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5432'; -- USUARIOCREAR/USUARIOMODIFICAR.

    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Cambiando propietario a GPV_GASTOS_PROVEEDOR ');
	
	
	V_MSQL := ' UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
	            SET PRO_ID = ( SELECT PRO_ID
               			   FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO
               			   WHERE PRO_DOCIDENTIF = ''V83829614''
               			   AND BORRADO = 0
             			 )
		    WHERE GPV_NUM_GASTO_HAYA = ''10897707''
		';
	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza el propietario '||SQL%ROWCOUNT||' GASTO/S '); 
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
