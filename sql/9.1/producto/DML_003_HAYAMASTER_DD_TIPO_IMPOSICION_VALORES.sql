--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150713
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=HR-970
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** DD_TPI_TIPO_IMPOSICION ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION WHERE DD_TPI_CODIGO = ''16'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION (DD_TPI_ID,DD_TPI_CODIGO,DD_TPI_DESCRIPCION,DD_TPI_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA_M||'.S_DD_TPI_TIPO_IMPOSICION.nextval,''16'',''16%'',''16%'',0,''DML'',sysdate,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION.');
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION WHERE DD_TPI_CODIGO = ''21'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION (DD_TPI_ID,DD_TPI_CODIGO,DD_TPI_DESCRIPCION,DD_TPI_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values('||V_ESQUEMA_M||'.S_DD_TPI_TIPO_IMPOSICION.nextval,''21'',''21%'',''21%'',0,''DML'',sysdate,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION.');
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
