--/*
--##########################################
--## AUTOR=Alberto B
--## FECHA_CREACION=20160411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.2
--## INCIDENCIA_LINK=CMREC-3030
--## PRODUCTO=NO
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
    V_NUM_SEQUENCE NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_MAXID NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** DD_TPI_TIPO_IMPOSICION ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION... Comprobaciones previas'); 
    

    -- comprobamos la secuencia
    V_SQL := 'SELECT '||V_ESQUEMA_M||'.S_DD_TPI_TIPO_IMPOSICION.NEXTVAL FROM DUAL';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
    DBMS_OUTPUT.PUT_LINE(V_NUM_SEQUENCE);
    
    V_SQL := 'SELECT NVL(MAX(DD_TPI_ID), 0) FROM '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
    DBMS_OUTPUT.PUT_LINE(V_NUM_MAXID);
    
    WHILE V_NUM_SEQUENCE < V_NUM_MAXID LOOP
    	V_SQL := 'SELECT '||V_ESQUEMA_M||'.S_DD_TPI_TIPO_IMPOSICION.NEXTVAL FROM DUAL';
    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
    END LOOP;
    
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION WHERE DD_TPI_CODIGO = ''8''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA_m||'.DD_TPI_TIPO_IMPOSICION.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION (DD_TPI_ID,DD_TPI_CODIGO,DD_TPI_DESCRIPCION,DD_TPI_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA_M||'.S_DD_TPI_TIPO_IMPOSICION.NEXTVAL,''8'',''8%'',''8%'',''0'',''CMREC-3030'',SYSDATE,NULL,NULL,NULL,NULL,''0'')';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION');
    	
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
