--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-cj
--## INCIDENCIA_LINK=PRODUCTO-954
--## PRODUCTO=SI
--## Finalidad: DML
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** DD_STA_SUBTIPO_TAREA_BASE ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando DD_STA_SUBTIPO_TAREA_BASE'); 
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CONTACOBR''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_EXISTE;
	
	IF V_NUM_EXISTE = 0 THEN 
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID,DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_ID,DTYPE) VALUES ('||V_ESQUEMA_M||'.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL,''1'',''CONTACOBR'',''Contabilizar Cobros'',''Contabilización de Cobros'',''1'',''0'',''PROD-954'',SYSDATE,null,null,null,null,''0'',''386'',''EXTSubtipoTarea'')';
		EXECUTE IMMEDIATE V_MSQL;	
		DBMS_OUTPUT.PUT_LINE('[INFO] DD_STA_SUBTIPO_TAREA_BASE INSERTADO');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] DD_STA_SUBTIPO_TAREA_BASE YA existe');
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