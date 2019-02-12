--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20190113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2926
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2926'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA USU_ID');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T1
				USING (SELECT GEE.*
						FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
						JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
						JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID
						WHERE ACT.DD_CRA_ID = 43
						AND GEE.DD_TGE_ID = 561) T2 ON (T1.GEE_ID = T2.GEE_ID)
				WHEN MATCHED THEN
				UPDATE SET T1.USU_ID = 74586,
				USUARIOMODIFICAR = ''REMVIP-2926'',
				FECHAMODIFICAR = SYSDATE';
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZACION COLUMNA USU_ID TERMINADA');
	
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
