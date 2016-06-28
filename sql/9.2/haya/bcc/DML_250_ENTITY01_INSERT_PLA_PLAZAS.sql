--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20160624
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.6
--## INCIDENCIA_LINK=RECOVERY-2114
--## PRODUCTO=NO
--## Finalidad: DML ,
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

    V_PEF_ID NUMBER(16); -- Vble. para guardar el id del perfil 
    V_FUN_ID NUMBER(16); -- Vble. para guardar el id de la funcion 
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** DD_PLA_PLAZAS ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_PLA_PLAZAS... Comprobaciones previas CATARROJA'); 

    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''46471''';

	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS < 1 THEN	  

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_PLA_PLAZAS (DD_PLA_ID, DD_PLA_CODIGO, DD_PLA_DESCRIPCION, DD_PLA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO, DD_JUZ_ID, DTYPE) VALUES ( '||V_ESQUEMA||'.S_DD_PLA_PLAZAS.NEXTVAL, ''46471'', ''CATARROJA'', ''CATARROJA'',''RECOVERY-2114'', SYSDATE, 0, NULL, ''LINTipoPlaza'')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_PLA_PLAZAS');
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_JUZ_JUZGADOS_PLAZA SET DD_PLA_ID = (SELECT DD_PLA_ID FROM '||V_ESQUEMA||'.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''46471'') WHERE DD_JUZ_DESCRIPCION LIKE ''%CATARROJA%''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados los juzgados de Cataroja a su plaza');
				
	ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] La plaza CATARROJA (46470) ya existe en la tabla '||V_ESQUEMA||'.DD_PLA_PLAZAS.');
    	  	
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
