--/*
--##########################################
--## AUTOR= Miguel Sanchez
--## FECHA_CREACION=20180119
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATE MASIVO ACTIVOS
--## INSTRUCCIONES:  
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
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema

V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
V_TABLA VARCHAR2(4000 CHAR);
V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar


BEGIN

V_TABLA:='GFM_MAPEO';

-- ******** TMP_GFM_GENERA_FICHEROS_MIGRACION *******
	DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 

	-- Creacion Tabla TMP_GFM_GENERA_FICHEROS_MIGRACION

	-- Comprobamos si existe la tabla   
		V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	-- Si existe la tabla no hacemos nada
		IF V_NUM_TABLAS = 1 THEN 
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Tabla YA EXISTE');
		ELSE
			--Creamos la tabla
			V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.'||V_TABLA||'
			( 
				INTERFAZ VARCHAR2(100 CHAR), 
				DAT_ORIGEN VARCHAR2(100 CHAR), 
				DAT_NUESTRO VARCHAR2(100 CHAR),
				TABLA VARCHAR2(100 CHAR),
				COLUMNAS NUMBER(10),
				DDL VARCHAR2(100 CHAR),
				CTL VARCHAR2(100 CHAR)
			)';

			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
		END IF;
    
EXCEPTION
WHEN OTHERS THEN
ERR_NUM := SQLCODE;
ERR_MSG := SQLERRM;
DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
DBMS_OUTPUT.put_line(ERR_MSG);
DBMS_OUTPUT.put_line(V_SQL);
DBMS_OUTPUT.put_line(V_MSQL);
ROLLBACK;
RAISE;   
END;
/
EXIT;
