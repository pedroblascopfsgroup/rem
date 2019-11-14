--/*
--##########################################
--## AUTOR=ALVARO GARCIA
--## FECHA_CREACION=20191007
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7803
--## PRODUCTO=NO
--## Finalidad: Añadir check en columa de la tabla ACT_GTP_GES_TRANS_PERMITIDAS
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GTP_GES_TRANS_PERMITIDAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CONSTRAINT_NAME VARCHAR2(2400 CHAR) := 'CHECK_DD_CONJUNTO';
    V_CONTRAINT_RESTRICTION VARCHAR2(2400 CHAR) := '((DD_TGE_ID IS NULL AND DD_TPR_ID IS NOT NULL) OR (DD_TGE_ID IS NOT NULL AND DD_TPR_ID IS NULL))';

BEGIN
	-- Verificar si la CONSTRAINTS ya existe. Si ya existe la CONSTRAINTS, no se hace nada con esta
	  V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_CONSTRAINT_NAME||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		--No existe la CONSTRAINT y la creamos
		DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en '||V_ESQUEMA||'.'||V_TEXT_TABLA||'] -------------------------------------------');
		V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA||' ADD CONSTRAINT '||V_CONSTRAINT_NAME||' CHECK '||V_CONTRAINT_RESTRICTION||' ENABLE';

		EXECUTE IMMEDIATE V_MSQL;
		--DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
		DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_CONSTRAINT_NAME||' CONSTRAINT INSERTADA en tabla ');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_CONSTRAINT_NAME||' CONSTRAINT YA	EXISTE, no hace nada. ');
	END IF;
	
	
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.put_line('---------------------------QUERY---------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL);



          ROLLBACK;
          RAISE;          

END;

/

EXIT
