--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ BARBERA	
--## FECHA_CREACION=20160301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2223
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** DD_ENP_ENTIDADES_PROPIETARIAS ********'); 
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ENP_ENTIDADES_PROPIETARIAS WHERE DD_ENP_CODIGO IN(''3058'')';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ENP_ENTIDADES_PROPIETARIAS.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ENP_ENTIDADES_PROPIETARIAS (DD_ENP_ID,DD_ENP_CODIGO,DD_ENP_DESCRIPCION,DD_ENP_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_DD_ENP_ENTIDADES_PROPI.NEXTVAL,''3058'',''CAJAMAR'',''CAJAMAR'',''0'',''INICIAL'',SYSDATE,0 )';
				
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ENP_ENTIDADES_PROPIETARIAS');
		
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
