--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-802
--## PRODUCTO=NO
--## Finalidad: Quitar a todos los perfiles activos las funciones SOLICITAR_EXP_MANUAL... SEGUIMIENTO/RECUPERACION
--##			y asignarles la nueva función: SOLICITAR_EXP_MANUAL_GESTION_DEUDA
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
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    
    V_NUM NUMBER; 
    V_FUN_ID NUMBER; --Vble. para adquerir la funcion id
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	-- Asignamos la nueva función a los perfiles activos
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION =''SOLICITAR_EXP_MANUAL_GESTION_DEUDA''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM = 1 THEN
		V_SQL := 'SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION =''SOLICITAR_EXP_MANUAL_GESTION_DEUDA''';
		EXECUTE IMMEDIATE V_SQL INTO V_FUN_ID;
	
		-- Insertamos la función a aquellos perfiles activos, que no la tuvieran ya.
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
 				SELECT '||V_FUN_ID||', PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL FUN_PEF, 0, ''DML'', SYSDATE, 0 
				FROM '||V_ESQUEMA||'.PEF_PERFILES 
				WHERE BORRADO = 0 AND NOT PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID ='||V_FUN_ID||' AND BORRADO = 0)';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Nueva función SOLICITAR_EXP_MANUAL_GESTION_DEUDA agregrada a los perfiles activos');
	ELSE
		RAISE_APPLICATION_ERROR(-20101, 'Todavía no se ha creado la función SOLICITAR_EXP_MANUAL_GESTION_DEUDA. Ejecutar primero: sql/9.2/producto/DML_007_MASTER_FUNCIONES_CREACION_MANUAL_EXP.sql');
	END IF;
	
	-- Borramos las funciones de creación de expediente manuales de seguimiento y recuperación
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.FUN_PEF SET BORRADO = 1
	 			WHERE FUN_ID IN (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION IN (''SOLICITAR_EXP_MANUAL_RECUPERACIONES'', ''SOLICITAR_EXP_MANUAL_SEGUIMIENTO''))
	 					AND PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE BORRADO = 0)';
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_MSQL); 
	EXECUTE IMMEDIATE V_MSQL; 	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados las funciones de creación de expediente manuales de seguimiento y recuperación de los perfiles activos');
	
	V_MSQL := 'DELETE '||V_ESQUEMA||'.FUN_PEF
	 			WHERE FUN_ID IN (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION IN (''SOLICITAR_EXP_MANUAL_RECUPERACIONES'', ''SOLICITAR_EXP_MANUAL_SEGUIMIENTO''))
	 					AND PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE BORRADO = 0)';
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_MSQL); 
	EXECUTE IMMEDIATE V_MSQL; 	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados las funciones de creación de expediente manuales de seguimiento y recuperación de los perfiles activos');	
	
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
