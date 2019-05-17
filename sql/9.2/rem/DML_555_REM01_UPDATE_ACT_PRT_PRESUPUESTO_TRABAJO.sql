--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190517
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4234
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar la pestaña patrimonio para cuando el estado alquiler es nulo se cambia a Libre, es decir, Libre ahora es la opción predeterminada.
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
    V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-4234';

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE ('[INICIO] Empieza la ejecucion ');
	
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO WHERE PVC_ID = 97937';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
    
    IF V_COUNT > 0 THEN
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO SET 
					PVC_ID = 127803 
				,   USUARIOMODIFICAR = '''||V_USUARIO||'''
				,   FECHAMODIFICAR = SYSDATE
				where PVC_ID = 97937';
	
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE ('Filas actualizadas ' || SQL%ROWCOUNT);

	END IF;
	
	DBMS_OUTPUT.PUT_LINE ('[FIN] Fin de la ejecucion ');
	
	COMMIT;
	
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
