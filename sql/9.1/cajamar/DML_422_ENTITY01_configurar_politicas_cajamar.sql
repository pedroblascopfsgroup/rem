--/*
--##########################################
--## AUTOR=Alberto B.
--## FECHA_CREACION=20160229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=CMREC-2309
--## PRODUCTO=NO
--## Finalidad: DML - Actualización de los scripts de validación de la tarea
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
	V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** TPL_TIPO_POLITICA ********'); 

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TPL_TIPO_POLITICA SET DD_POL_ID = (SELECT DD_POL_ID FROM '||V_ESQUEMA||'.DD_POL_POLITICAS WHERE DD_POL_CODIGO = ''2'') WHERE TPL_CODIGO IN (''TPL25'',''TPL26'', ''TPL27'', ''TPL28'', ''TPL29'', ''TPL30'')';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TPL_TIPO_POLITICA');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TPL_TIPO_POLITICA WHERE TPL_CODIGO = ''TPL40''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro existente en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,RD_ID,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.nextval,''TPL40'',(select ten_id from '||V_ESQUEMA||'.ten_tendencia where ten_codigo = ''ASC''),''Expansiva'',''Expansiva'',''0'',''0'',null,(select dd_pol_id from '||V_ESQUEMA||'.dd_pol_politicas where dd_pol_codigo = ''1''),''0'',''0'',''DML'',sysdate,null,null,null,null,''0'')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro INSERTADO en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');	
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TPL_TIPO_POLITICA WHERE TPL_CODIGO = ''TPL45''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro existente en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,RD_ID,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.nextval,''TPL45'',(select ten_id from '||V_ESQUEMA||'.ten_tendencia where ten_codigo = ''MAN''),''Adecuado Nivel de Riesgos'',''Adecuado Nivel de Riesgos'',''0'',''0'',null,(select dd_pol_id from '||V_ESQUEMA||'.dd_pol_politicas where dd_pol_codigo = ''1''),''0'',''0'',''DML'',sysdate,null,null,null,null,''0'')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro INSERTADO en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TPL_TIPO_POLITICA WHERE TPL_CODIGO = ''TPL50''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro existente en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	ELSE	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,RD_ID,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.nextval, ''TPL50'',(select ten_id from '||V_ESQUEMA||'.ten_tendencia where ten_codigo = ''MAN''),''Seguir Evolución de Riesgos'',''Seguir Evolución de Riesgos'',''0'',''0'',null,(select dd_pol_id from '||V_ESQUEMA||'.dd_pol_politicas where dd_pol_codigo = ''1''),''0'',''0'',''DML'',sysdate,null,null,null,null,''0'')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro INSERTADO en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TPL_TIPO_POLITICA WHERE TPL_CODIGO = ''TPL55''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro existente en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	ELSE	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,RD_ID,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.nextval, ''TPL55'',(select ten_id from '||V_ESQUEMA||'.ten_tendencia where ten_codigo = ''MAN''),''Seguir Evolución de Riesgos'',''Seguir Evolución de Riesgos'',''0'',''0'',null,(select dd_pol_id from '||V_ESQUEMA||'.dd_pol_politicas where dd_pol_codigo = ''4''),''0'',''0'',''DML'',sysdate,null,null,null,null,''0'')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro INSERTADO en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TPL_TIPO_POLITICA WHERE TPL_CODIGO = ''TPL65''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro existente en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	ELSE	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,RD_ID,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.nextval, ''TPL65'',(select ten_id from '||V_ESQUEMA||'.ten_tendencia where ten_codigo = ''MAN''),''Afianzar Nivel de Riesgos'',''Afianzar Nivel de Riesgos'',''0'',''0'',null,(select dd_pol_id from '||V_ESQUEMA||'.dd_pol_politicas where dd_pol_codigo = ''4''),''0'',''0'',''DML'',sysdate,null,null,null,null,''0'')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro INSERTADO en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TPL_TIPO_POLITICA WHERE TPL_CODIGO = ''TPL70''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro existente en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	ELSE	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,RD_ID,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.nextval, ''TPL70'',(select ten_id from '||V_ESQUEMA||'.ten_tendencia where ten_codigo = ''DES''),''Reducir Nivel de Riesgos'',''Reducir Nivel de Riesgos'',''0'',''0'',null,(select dd_pol_id from '||V_ESQUEMA||'.dd_pol_politicas where dd_pol_codigo = ''4''),''0'',''0'',''DML'',sysdate,null,null,null,null,''0'')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro INSERTADO en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	END IF;
		
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TPL_TIPO_POLITICA WHERE TPL_CODIGO = ''TPL75''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro existente en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	ELSE	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,RD_ID,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.nextval, ''TPL75'',(select ten_id from '||V_ESQUEMA||'.ten_tendencia where ten_codigo = ''DES''),''Extinguir Nivel de Riesgos'',''Extinguir Nivel de Riesgos'',''0'',''0'',null,(select dd_pol_id from '||V_ESQUEMA||'.dd_pol_politicas where dd_pol_codigo = ''4''),''0'',''0'',''DML'',sysdate,null,null,null,null,''0'')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro INSERTADO en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	END IF;
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.DD_POL_POLITICAS WHERE DD_POL_CODIGO IN (''POL21'',''POL22'',''POL23'',''POL24'',''POL25'',''POL26'')';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros borrados en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	
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
