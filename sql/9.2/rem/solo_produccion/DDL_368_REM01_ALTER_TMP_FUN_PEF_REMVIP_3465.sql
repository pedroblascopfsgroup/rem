--/*
--##########################################
--## AUTOR=Rasul Abdulaev
--## FECHA_CREACION=20190227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3465
--## PRODUCTO=NO
--## Finalidad: Eliminar la columna que no se usa (SUPERUSUARIONEGOCIO) de la tabla TMP_FUN_PEF
--##           
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TMP_FUN_PEF'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_COLUMN VARCHAR2(50 CHAR)  := 'SUPERUSUARIONEGOCIO'; --Vble. auxiliar para almacenar el nombre de la columna de ref.

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Ejecutando proceso.');
    DBMS_OUTPUT.PUT_LINE('[INFO] Se va a comprobar que existe la columna a borrar.');
    
    V_MSQL :=  'SELECT COUNT(1) 
                FROM ALL_TAB_COLUMNS 
                WHERE OWNER = '''||V_ESQUEMA||''' 
                AND TABLE_NAME = '''||V_TEXT_TABLA||''' 
                AND COLUMN_NAME = '''||V_TEXT_COLUMN||'''';

    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	    
    
    IF V_NUM_TABLAS > 0 THEN

        V_MSQL :=   'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    DROP COLUMN '||V_TEXT_COLUMN||'';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Columna' ||V_TEXT_TABLA||'.'||V_TEXT_COLUMN||' borrada.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO] No se ha realizado ninguna acción, porque no existe la columna '||V_TEXT_COLUMN||'.');

    END IF;


EXCEPTION

    WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('[ERROR] ...KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);

    ROLLBACK;
    RAISE;          

END;
/

EXIT

