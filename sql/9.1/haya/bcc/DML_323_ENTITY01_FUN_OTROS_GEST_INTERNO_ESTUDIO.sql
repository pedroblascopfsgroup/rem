--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20151125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc22
--## INCIDENCIA_LINK=PRODUCTO-475
--## PRODUCTO=NO
--##
--## Finalidad: Agregar la función: MODIFICAR_RIESGO_OPERACIONAL a los perfiles de Haya-Cajamar:
--##                Gestor Interno (HAYAGEST)
--##                Gestor de Estudio (FULLPRECON)
--##
--## INSTRUCCIONES: Relanzable
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_ID_PERFIL NUMBER(16);
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando que exista la función MODIFICAR_RIESGO_OPERACIONAL');
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN WHERE FUN.FUN_DESCRIPCION = ''MODIFICAR_RIESGO_OPERACIONAL'' AND FUN.BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Obteniendo el FUN_ID de la función MODIFICAR_RIESGO_OPERACIONAL');
		V_SQL := 'SELECT FUN.FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN WHERE FUN.FUN_DESCRIPCION = ''MODIFICAR_RIESGO_OPERACIONAL'' AND FUN.BORRADO = 0 ';
    	EXECUTE IMMEDIATE V_SQL INTO V_ID_PERFIL;
    	
    	DBMS_OUTPUT.PUT_LINE('[INFO] FUN_ID: '||V_ID_PERFIL);
    	
    	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF  (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
					'SELECT '||V_ID_PERFIL||' AS FUN_ID, PEF.PEF_ID, S_FUN_PEF.NEXTVAL AS FP_ID, 0 AS VERSION, ''DML'' AS USUARIOCREAR, SYSDATE AS FECHACREAR, 0 AS BORRADO ' ||
					'FROM '||V_ESQUEMA||'.PEF_PERFILES PEF ' ||
					'WHERE PEF.PEF_CODIGO = ''HAYAGEST'' OR PEF.PEF_CODIGO = ''FULLPRECON'' ';
		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada la función: MODIFICAR_RIESGO_OPERACIONAL a los perfiles: Gestor Interno(HAYAGEST) y Gestor de Estudio(FULLPRECON)');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe la función MODIFICAR_RIESGO_OPERACIONAL o tiene más de un código');
	END IF;
	
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