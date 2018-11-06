--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20181106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2443
--## PRODUCTO=NO
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2443'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION DE LAS COLUMNAS ACT_NUM_ACTIVO, ACT_RECOVERY_ID');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
			   USING (SELECT *
					  FROM '||V_ESQUEMA||'.AUX_REMVIP_2432_1) T2
			   ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO_VIEJO)
			   WHEN MATCHED THEN
				   UPDATE SET T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO_NUEVO,
				   T1.ACT_RECOVERY_ID = T2.ACT_RECOVERY_ID_NUEVO,
				   T1.USUARIOMODIFICAR = '''||V_USR||''',
				   T1.FECHAMODIFICAR = SYSDATE';
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZACION FINALIZADA');
	
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
