--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-671
--## PRODUCTO=NO
--##
--## Finalidad:
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
    V_DDNAME VARCHAR2(30):= 'PEF_PERFILES';
BEGIN	

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE PEF_CODIGO= ''PROCUCAJAMAR''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el PROCUCAJAMAR '||V_DDNAME||'.');
	
	ELSE
		-- SE CREA EL PERFIL
	  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
	  '(PEF_ID, PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PEF_CODIGO, PEF_ES_CARTERIZADO, DTYPE) values '||
	  '('||V_ESQUEMA||'.S_PEF_PERFILES.nextval,''Perfil de consulta usuario procurador'',''Perfil de consulta usuario procurador'',''0'',''PROD-671'',sysdate,''0'',''PROCUCAJAMAR'',''0'',''EXTPerfil'') ';
	
	  DBMS_OUTPUT.PUT_LINE('OK modificado');
	
	END IF;
	
	-- LE INSERTAMOS LAS MISMAS FUNCIONES QUE TIENE EL PERFIL HAYAGESTEXT (exceptuando un par y las que se han creado en DML_143 y que no le hayan sido ya asignadas)
	DBMS_OUTPUT.PUT_LINE('[INFO] Insertando funciones al perfil PROCUCAJAMAR.');		 
	 V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
				' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
				' SELECT fp.FUN_ID, (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''PROCUCAJAMAR''), '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''PROD-671'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.FUN_PEF fp' ||
					' WHERE fp.PEF_ID=(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAGESTEXT'')' ||
					' AND fp.FUN_ID NOT IN (SELECT FUN_ID FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID=(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO =''PROCUCAJAMAR''))' ||
					' AND fp.FUN_ID IN (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION != ''VER_TAB_GESTORES'' AND FUN_DESCRIPCION != ''VER-OBSERVACIONES-ASUNTO'' ' ||
					' AND FUN_DESCRIPCION != ''ROLE_EDIT_CABECERA_ASUNTO'' AND FUN_DESCRIPCION != ''ENVIO_CIERRE_DEUDA'' AND FUN_DESCRIPCION != ''ROLE_EDIT_CABECERA_PROCEDIMIENTO'' '||
					' AND FUN_DESCRIPCION !=''TAB_ASUNTO_TITULOS'' AND FUN_DESCRIPCION !=''TAB_ASUNTO_ACUERDOS'' AND FUN_DESCRIPCION !=''TAB_ASUNTO_ADJUNTOS'' '||
					' AND FUN_DESCRIPCION !=''TAB_ASUNTO_CONVENIOS'' AND FUN_DESCRIPCION !=''TAB_ASUNTO_FASECOMUN'' AND FUN_DESCRIPCION !=''TAB_PRC_ADJUNTO'' '||
					' AND FUN_DESCRIPCION !=''TAB_PRC_DECISION'' AND FUN_DESCRIPCION !=''TAB_PRC_CONTRATO'' '||
					' AND FUN_DESCRIPCION !=''TAB_BIEN_PROCEDIMIENTOS'' AND FUN_DESCRIPCION !=''TAB_BIEN_DATOSENTIDAD'' AND FUN_DESCRIPCION !=''TAB_BIEN_RELACIONES'')';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Funciones del perfil HAYAGESTEXT insertadas en el perfil PROCUCAJAMAR. Excepto algunos que no necesita');
	DBMS_OUTPUT.PUT_LINE('[INFO] Funciones sueltas añadidas para el perfil PROCUCAJAMAR ');
	 V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
				' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
				' SELECT fun.FUN_ID, (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''PROCUCAJAMAR''), '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''PROD-671'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES fun WHERE ' ||
					' fun.FUN_DESCRIPCION = ''SOLO_CONSULTA'' ' ||
					' AND fun.FUN_ID NOT IN (SELECT FUN_ID FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID=(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO =''PROCUCAJAMAR''))';
	EXECUTE IMMEDIATE V_MSQL;				
					
	DBMS_OUTPUT.PUT_LINE('[INFO] Funciones insertadas.');
	
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');

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
  	