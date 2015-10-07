--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20151007
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=PRODUCTO-286
--## PRODUCTO=SI
--##
--## Finalidad: Cambia el tipo Tarea de Notificacion a Tarea para el subtipo EVENTO PROPUESTA 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
BEGIN	

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''PROP_EVENT''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] El subtipo PROP_EVENT ya existe por lo tanto modificaremos el registro');
		V_SQL := 'UPDATE '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE SET DD_TAR_ID=1 WHERE DD_STA_CODIGO = ''PROP_EVENT''';
		DBMS_OUTPUT.PUT_LINE('[INFO] Subtipo PROP_EVENT modificado OK');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] El subtipo PROP_EVENT no existe por lo tanto crearemos el registro');
		
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;	
          
      	V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_STA_SUBTIPO_TAREA_BASE (' ||
                  'DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_STA_GESTOR, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TGE_ID, DTYPE)' ||
                  'VALUES (' ||
                  	V_ENTIDAD_ID || ',1,''PROP_EVENT'',''Evento Propuesta'',''Evento Propuesta'',NULL,''PROP'',SYSDATE,NULL, NULL, NULL, NULL, 0, NULL, ''EXTSubtipoTarea'')';
		EXECUTE IMMEDIATE V_MSQL;                  	
        DBMS_OUTPUT.PUT_LINE('[INFO] Subtipo PROP_EVENT creado OK');
          		
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