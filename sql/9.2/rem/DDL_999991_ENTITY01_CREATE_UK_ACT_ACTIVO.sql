--/*
--##########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20180419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-11088
--## PRODUCTO=NO
--##
--## Finalidad: Tabla auxiliar para almacenar las filas rechazadas procedentes del fichero de altas de activos.        
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
    V_NUM_OLD_UK NUMBER(16); 
    V_NUM_NEW_UK NUMBER(16); 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');

	V_MSQL := '
	SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''UK_NUM_ACTIVO'' AND TABLE_NAME = ''ACT_ACTIVO'' AND OWNER = '''||V_ESQUEMA||'''
	';
	DBMS_OUTPUT.PUT_LINE(V_MSQL); 
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_OLD_UK;

	V_SQL := '
	SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''UK_NUM_ACTIVO_SUBCARTERA'' AND TABLE_NAME = ''ACT_ACTIVO'' AND OWNER = '''||V_ESQUEMA||'''
	';
	DBMS_OUTPUT.PUT_LINE(V_SQL); 
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_NEW_UK;

	IF V_NUM_NEW_UK < 1 THEN
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_ACTIVO ADD CONSTRAINT UK_NUM_ACTIVO_SUBCARTERA UNIQUE (ACT_NUM_ACTIVO, DD_SCR_ID, BORRADO)';
		EXECUTE IMMEDIATE V_MSQL;
	END IF;

	EXECUTE IMMEDIATE V_SQL INTO V_NUM_NEW_UK;

	IF V_NUM_NEW_UK > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] SE HA CREADO LA NUEVA CONSTRAINT UK_NUM_ACTIVO_SUBCARTERA.');
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_ACTIVO DROP CONSTRAINT UK_NUM_ACTIVO';
		IF V_NUM_OLD_UK > 0 THEN
			EXECUTE IMMEDIATE V_MSQL;
			EXECUTE IMMEDIATE 'drop INDEX uk_num_activo';
		END IF;

		V_MSQL := '
		SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''UK_NUM_ACTIVO'' AND TABLE_NAME = ''ACT_ACTIVO'' AND OWNER = '''||V_ESQUEMA||'''
		';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_OLD_UK;

		IF V_NUM_OLD_UK < 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] UK_NUM_ACTIVO BORRADA CORRECTAMENTE.');
		ELSE 
			DBMS_OUTPUT.PUT_LINE('[INFO] NO SE HA PODIDO BORRAR UK_NUM_ACTIVO.');
		END IF;

	ELSE
		DBMS_OUTPUT.PUT_LINE('[WARNING] NO SE HA PODIDO CREAR LA NUEVA CONSTRAINT UK_NUM_ACTIVO_SUBCARTERA. SIGUE ACTIVA LA CONSTRAINT UK_NUM_ACTIVO.');
	END IF;	
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
COMMIT;



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
