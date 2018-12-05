--/*
--##########################################
--## AUTOR=Maria Presencia
--## FECHA_CREACION=20181011
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.4
--## INCIDENCIA_LINK=HREOS-4629
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla AUX_ACT_TRASPASO_GALEON.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'AUX_ACT_TRASPASO_GALEON'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-4629';

	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla con los activos para la migracion Galeon'; -- Vble. para los comentarios de las tablas

	
    
 BEGIN
 
 
	
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla la borramos
    IF V_NUM_TABLAS = 1 THEN 
	-- Borramos la tabla
    	 V_SQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla eliminada');  		
    END IF;

    DBMS_OUTPUT.PUT_LINE('[INICIO] ' || V_ESQUEMA || '.'||V_TABLA||'... Se va ha crear.');  		
	--Creamos la tabla
	V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
			 ACT_NUM_ACTIVO_ANT NUMBER(16,0),
			 ACT_NUM_ACTIVO_NUV NUMBER(16,0),
			 REF_CATASTRAL		VARCHAR2(50 CHAR),
			 DD_CRA_ID			NUMBER(16,0)
			)';

	EXECUTE IMMEDIATE V_SQL;
	
	

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
