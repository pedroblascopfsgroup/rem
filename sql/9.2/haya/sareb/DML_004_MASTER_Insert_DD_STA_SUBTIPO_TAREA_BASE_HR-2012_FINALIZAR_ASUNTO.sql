--/*
--##########################################
--## AUTOR=SALVADOR GORRITA
--## FECHA_CREACION=20160310
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2012
--## PRODUCTO=SI
--## Finalidad: DML insercion DD_STA_SUBTIPO_TAREA_BASE para toma decisión supervisor expedientes judiciales
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE... Empezando a insertar datos');

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''PCO_DSUPDOC''';
  
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, VERSION, 
		USUARIOCREAR, FECHACREAR, BORRADO, DD_TGE_ID, DTYPE) VALUES ('|| V_ESQUEMA_M ||'.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL, 
		(SELECT DD_TAR_ID FROM '|| V_ESQUEMA_M ||'.DD_TAR_TIPO_TAREA_BASE WHERE DD_TAR_CODIGO = ''1''), 
		''PCO_DSUPDOC'', ''Toma de decisión del Supervisor de Expedientes Judiciales'',''Toma de decisión del Supervisor de Expedientes Judiciales'', 0, ''DD'', sysdate, 0, 
		(SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUP_PCO''), ''EXTSubtipoTarea'')';
		
		EXECUTE IMMEDIATE V_MSQL;
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TAR_TIPO_TAREA_BASE... Ya existe un registro con el código PCO_DSUPDOC');
	END IF;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE... Datos insertados.');
	
	
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
