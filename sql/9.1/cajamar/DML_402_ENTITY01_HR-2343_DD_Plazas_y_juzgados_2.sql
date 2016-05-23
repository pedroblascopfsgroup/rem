--/*
--##########################################
--## AUTOR=Pepe Tamarit
--## FECHA_CREACION=20160506
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HR-2343
--## PRODUCTO=NO
--## Finalidad: DML
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLUMN   NUMBER(16); -- Vble. para validar la existencia de una columna.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_VIEW     NUMBER(16); -- Vble. para validar la existencia de una vista.
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

   dbms_output.enable(1000000);

   -- 16000 - CUENCA
   -- 41400 - ECIJA
      
   -- Reactivar las plazas Cuenca y Ecija
   V_MSQL := 'update '||V_ESQUEMA||'.dd_pla_plazas 
                 set borrado = 0, 
                     usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate, 
                     usuarioborrar = null, 
                     fechaborrar = null
               where dd_pla_codigo in (''16000'', ''41400'')';
   EXECUTE IMMEDIATE V_MSQL;
 
   -- Asociar juzgados a 16000 - CUENCA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''16000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''40285'',''38905'',''40185'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 41400 - ECIJA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''41400''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''40245'')';
   EXECUTE IMMEDIATE V_MSQL;
        
   commit;   
   
   dbms_output.put_line( 'FIN DEL PROCESO' );

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;
END;
/
EXIT;
