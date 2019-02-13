--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20190124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3118
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-3118'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ELIMINAR ASOCIACION REPETIDAS DE GASTO-ACTIVO');
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GPV_ACT TA
				WHERE EXISTS (SELECT GPV_ACT_ID 
								FROM (SELECT T1.GPV_ACT_ID, T1.GPV_ID, T1.ACT_ID, ROW_NUMBER() OVER (PARTITION BY T1.GPV_ID, T1.ACT_ID ORDER BY T1.GPV_ACT_ID ASC) AS RN
										FROM '||V_ESQUEMA||'.GPV_ACT T1
										WHERE EXISTS (SELECT 1
														FROM '||V_ESQUEMA||'.GPV_ACT T2
														WHERE T1.GPV_ACT_ID <> T2.GPV_ACT_ID
														AND T1.ACT_ID = T2.ACT_ID
														AND T1.GPV_ID = T2.GPV_ID)) TB
				WHERE RN > 1
				AND TA.GPV_ACT_ID = TB.GPV_ACT_ID)';
	
	EXECUTE IMMEDIATE V_MSQL;
    
	DBMS_OUTPUT.PUT_LINE('[FIN] REGISTROS REPETIDOS ELIMINADOS');
		
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
