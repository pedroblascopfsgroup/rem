--/*
--##########################################
--## AUTOR=Enrique_Badenes
--## FECHA_CREACION=20160503
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK= PRODUCTO-1293
--## PRODUCTO=SI
--##
--## Finalidad: Insertar en fun_pef funciones "ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES" y "ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES" para los perfiles siguientes:
--##				Gestor de Riesgos, Gestor de Seguimiento, Director territorial de riesgos, Director territorial, Servicios Centrales, Supervisor SSCC, Oficina.
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
		
	DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio insert en FUN_PEF...');
	
 	DBMS_OUTPUT.PUT_LINE('[INFO] Insertando la funcion "ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES" a los perfiles requeridos...');
	V_MSQL:= q'[INSERT INTO ]'||V_ESQUEMA||q'[.FUN_PEF(FUN_ID,PEF_ID,FP_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
					SELECT (SELECT fun.FUN_ID FROM ]'||V_ESQUEMA_M||q'[.fun_funciones fun WHERE fun.FUN_DESCRIPCION = 'ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES'),
				    pef.pef_id,s_fun_pef.nextval,0,'PRODUCTO-1293',sysdate,0
					FROM ]'||V_ESQUEMA||q'[.pef_perfiles pef WHERE pef.BORRADO   = 0
					AND pef.PEF_CODIGO IN ('GES_RIESGOS','GES_SEGUIMIENTO','DIR_TERRITORIAL_RIESGOS','DIR_TERRITORIAL','SER_CENTRALES','SUP_SSCC','OFI_OFICINA')
					AND NOT EXISTS (SELECT * FROM ]'||V_ESQUEMA||q'[.fun_pef funPef WHERE funPef.PEF_ID = pef.PEF_ID 
									AND funPef.FUN_ID= (SELECT fun.FUN_ID FROM ]'||V_ESQUEMA_M||q'[.fun_funciones fun
							 							WHERE fun.FUN_DESCRIPCION = 'ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES') 
														AND funPef.borrado=0)]';
  	EXECUTE IMMEDIATE V_MSQL;
 	DBMS_OUTPUT.PUT_LINE('[INFO] Insertados en FUN_PEF la funcion "ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES" a los perfiles correspondientes.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Insertando la funcion "ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES" a los perfiles requeridos...');
  	V_MSQL:= q'[INSERT INTO ]'||V_ESQUEMA||q'[.FUN_PEF(FUN_ID,PEF_ID,FP_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
					SELECT (SELECT fun.FUN_ID FROM ]'||V_ESQUEMA_M||q'[.fun_funciones fun WHERE fun.FUN_DESCRIPCION = 'ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES'),
				    pef.pef_id,s_fun_pef.nextval,0,'PRODUCTO-1293',sysdate,0
					FROM ]'||V_ESQUEMA||q'[.pef_perfiles pef WHERE pef.BORRADO   = 0
					AND pef.PEF_CODIGO IN ('GES_RIESGOS','GES_SEGUIMIENTO','DIR_TERRITORIAL_RIESGOS','DIR_TERRITORIAL','SER_CENTRALES','SUP_SSCC','OFI_OFICINA')
					AND NOT EXISTS (SELECT * FROM ]'||V_ESQUEMA||q'[.fun_pef funPef WHERE funPef.PEF_ID = pef.PEF_ID 
									AND funPef.FUN_ID= (SELECT fun.FUN_ID FROM ]'||V_ESQUEMA_M||q'[.fun_funciones fun
							 							WHERE fun.FUN_DESCRIPCION = 'ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES') 
														AND funPef.borrado=0)]';
  	EXECUTE IMMEDIATE V_MSQL;
 	DBMS_OUTPUT.PUT_LINE('[INFO] Insertados en FUN_PEF la funcion "ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES" a los perfiles correspondientes.');
 	
 	-- Quitar funcion ROLE_OCULTAR_ARBOL_OBJETIVOS_PENDIENTES a todos los perfiles
 	DBMS_OUTPUT.PUT_LINE('[INFO] Borrando la funcion "ROLE_OCULTAR_ARBOL_OBJETIVOS_PENDIENTES" de todos los perfiles de la tabla FUN_PEF...');
  	V_MSQL:= q'[DELETE FROM ]'||V_ESQUEMA||q'[.fun_pef funPef WHERE funPef.FUN_ID = (SELECT fun.fun_id FROM ]'||V_ESQUEMA_M||q'[.fun_funciones fun  WHERE fun.FUN_DESCRIPCION = 'ROLE_OCULTAR_ARBOL_OBJETIVOS_PENDIENTES')]';
  	EXECUTE IMMEDIATE V_MSQL;
  	-- Quitar funcion ROLE_OCULTAR_ARBOL_OBJETIVOS_PENDIENTES a todos los perfiles
 	DBMS_OUTPUT.PUT_LINE('[INFO] Borrando la funcion "ROLE_OCULTAR_ARBOL_GESTION_CLIENTES" de todos los perfiles de la tabla FUN_PEF...');
  	V_MSQL:= q'[DELETE FROM ]'||V_ESQUEMA||q'[.fun_pef funPef WHERE funPef.FUN_ID = (SELECT fun.fun_id FROM ]'||V_ESQUEMA_M||q'[.fun_funciones fun  WHERE fun.FUN_DESCRIPCION = 'ROLE_OCULTAR_ARBOL_GESTION_CLIENTES')]';
  	EXECUTE IMMEDIATE V_MSQL;
  	
  	-- Borrar funcion ROLE_OCULTAR_ARBOL_OBJETIVOS_PENDIENTES
  	DBMS_OUTPUT.PUT_LINE('[INFO] Borrando la funcion "ROLE_OCULTAR_ARBOL_GESTION_CLIENTES" de tabla FUN_FUNCIONES...');
  	V_MSQL:= q'[DELETE FROM ]'||V_ESQUEMA_M||q'[.fun_funciones fun WHERE fun.FUN_DESCRIPCION = 'ROLE_OCULTAR_ARBOL_OBJETIVOS_PENDIENTES']';
  	EXECUTE IMMEDIATE V_MSQL;

	-- Borrar funcion ROLE_OCULTAR_ARBOL_GESTION_CLIENTES
  	DBMS_OUTPUT.PUT_LINE('[INFO] Borrando la funcion "ROLE_OCULTAR_ARBOL_GESTION_CLIENTES" de tabla FUN_FUNCIONES...');
  	V_MSQL:= q'[DELETE FROM ]'||V_ESQUEMA_M||q'[.fun_funciones fun WHERE fun.FUN_DESCRIPCION = 'ROLE_OCULTAR_ARBOL_GESTION_CLIENTES']';
  	EXECUTE IMMEDIATE V_MSQL;
  	
 	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[Fin] Script finalizado.');


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
  	