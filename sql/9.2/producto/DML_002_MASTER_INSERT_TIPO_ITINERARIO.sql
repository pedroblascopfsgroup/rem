--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-796
--## PRODUCTO=NO
--## Finalidad: Crear el tipo de itinerario: Gestión de deuda
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = ''DEU''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM=0 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS (DD_TIT_ID, DD_TIT_CODIGO, DD_TIT_DESCRIPCION, DD_TIT_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA_M||'.S_DD_TIT_TIPO_ITINERARIOS.NEXTVAL, ''DEU'', ''Gestión deuda'', ''Itinerario de gestión de deuda'', 0, ''DML'', SYSDATE, 0)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertado en '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el tipo de itinerario: Gestión de deuda.');
	END IF;
	
	-- Actualización del diccionario de estados itinerario
	-- Primero cambiamos el orden del estado Formalizar Propuesta, para anexar los 2 en medio
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS SET DD_EST_ORDEN = 7 WHERE DD_EST_CODIGO = ''FP'' 
				AND DD_EIN_ID = (SELECT DD_EIN_ID FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION WHERE DD_EIN_CODIGO = ''2'')';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Orden del estado Formalizar Propuesta actualizado');
	
	-- Creamos el nuevo estado Sancionado si no existe ya
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''SANC''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM=0 THEN
		V_SQL := 'SELECT DD_EIN_ID FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION WHERE DD_EIN_CODIGO = ''2''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID, DD_EIN_ID, DD_EST_ORDEN, DD_EST_CODIGO, DD_EST_DESCRIPCION, DD_EST_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
					 VALUES ('||V_ESQUEMA_M||'.S_DD_EST_EST_ITI.NEXTVAL, '||V_NUM||', ''6'', ''SANC'', ''Sancionado'', ''Sancionado'', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Estado: Sancionado insertado...');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el estado Sancionado');
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
