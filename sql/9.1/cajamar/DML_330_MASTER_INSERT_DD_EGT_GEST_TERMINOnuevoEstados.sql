--/*
--##########################################
--## AUTOR=Alberto b.
--## FECHA_CREACION=20151125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc23
--## INCIDENCIA_LINK=CMREC-1153
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
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES

BEGIN	
    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_EGT_EST_GEST_TERMINO WHERE DD_EGT_CODIGO = ''PO''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe LA FUNCION');
	
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_EGT_EST_GEST_TERMINO(DD_EGT_ID,DD_EGT_CODIGO,DD_EGT_DESCRIPCION,DD_EGT_DESCRIPCION_LARGA,VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) VALUES ('||V_ESQUEMA_M||'.S_DD_EGT_EST_GEST_TERMINO.nextVal, ''PO'', ''Pendiente oficina'', ''Pendiente oficina'',0,''CMREC-1153'',SYSDATE,NULL,NULL,NULL,NULL,0)';  
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		execute immediate V_MSQL;
	  	DBMS_OUTPUT.PUT_LINE('OK modificado');
	END IF;
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_EGT_EST_GEST_TERMINO WHERE DD_EGT_CODIGO = ''PM''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe LA FUNCION');
	
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_EGT_EST_GEST_TERMINO(DD_EGT_ID,DD_EGT_CODIGO,DD_EGT_DESCRIPCION,DD_EGT_DESCRIPCION_LARGA,VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) VALUES ('||V_ESQUEMA_M||'.S_DD_EGT_EST_GEST_TERMINO.nextVal, ''PM'', ''Pendiente minuta'', ''Pendiente minuta'',0,''CMREC-1153'',SYSDATE,NULL,NULL,NULL,NULL,0)';  
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		execute immediate V_MSQL;
	  	DBMS_OUTPUT.PUT_LINE('OK modificado');
	END IF;
	
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