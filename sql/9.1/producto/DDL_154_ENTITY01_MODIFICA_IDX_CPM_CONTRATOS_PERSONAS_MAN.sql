--/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20150125
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1.0
--## INCIDENCIA_LINK=PRODUCTO-527
--## PRODUCTO=SI
--## Finalidad: Modificar UNIQUE INDEX PEM_PERSONAS_MANUALES
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
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_STRING VARCHAR2(10); -- Vble. para validar la existencia de si el campo es nulo
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos la existencia de la UNIQUE UK_CPM_CONTRATOS_PERSONAS');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_CPM_CONTRATOS_PERSONAS'' AND TABLE_OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''CPM_CONTRATOS_PERSONAS_MAN'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
	
	IF V_COUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] La UNIQUE UK_CPM_CONTRATOS_PERSONAS aún no esta creada.');
	ELSE
		V_MSQL := 'DROP INDEX UK_CPM_CONTRATOS_PERSONAS';
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.UK_CPM_CONTRATOS_PERSONAS ON '||V_ESQUEMA||'.CPM_CONTRATOS_PERSONAS_MAN (PEM_ID, CNT_ID, DD_TIN_ID,BORRADO) COMPUTE STATISTICS';
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla CPM_CONTRATOS_PERSONAS_MAN ha sido creada correctamente.');
	END IF;		
	
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
