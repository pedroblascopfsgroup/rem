--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20181018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2236
--## PRODUCTO=NO
--##
--## Finalidad: TABLAS CONFIG 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	

DBMS_OUTPUT.put_line('[1] Cambiar dd_cra_id en CPP_CONFIG_PTDAS_PREP');



V_SQL := 'update '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP cpp set
          cpp.dd_cra_id = 42, usuariomodificar = ''REMVIP-2275'', fechamodificar = sysdate
          where cpp.dd_cra_id = 61';
EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla CPP_CONFIG_PTDAS_PREP');




DBMS_OUTPUT.put_line('[2] Cambiar dd_cra_id');


V_SQL := 'update '||V_ESQUEMA||'.ccc_config_ctas_contables ccc set
          ccc.dd_cra_id = 42, usuariomodificar = ''REMVIP-2275'', fechamodificar = sysdate
          where ccc.dd_cra_id = 61';
EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla ccc_config_ctas_contables');




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

