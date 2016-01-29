--/*
--##########################################
--## AUTOR=Alberto B
--## FECHA_CREACION=20151210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc30
--## INCIDENCIA_LINK=CMREC-1382
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
    V_NUM_BORRADO NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** ACU_CAMPOS_TIPO_ACUERDO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO... Comprobaciones previas'); 

	--COMPROBAMOS CADA TERMINO POR SI NO EXISTIERA O SI ESTUVIERA BORRADO ACTUALIZARLO
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DA_CV''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe el registro en la tabla '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO.');
	ELSE
    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1, FECHABORRAR = SYSDATE, USUARIOBORRAR = ''CMREC-1382'', DD_ENT_ACU_ID = NULL WHERE DD_TPA_CODIGO = ''DA_CV''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO');
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
