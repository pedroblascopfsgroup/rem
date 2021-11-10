--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210811
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14716
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'AUX_SIC_SITUACION_CARGAS'
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_ESQUEMA_M VARCHAR2(20 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'AUX_SIC_SITUACION_CARGAS';
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script

BEGIN

V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
    
END IF;

DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TABLA||']');

V_SQL:= 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                    ( ACT_NUM_ACTIVO        NUMBER(16,0)    NOT NULL
                    , CARGA_ANTES           NUMBER(1,0)     
                    , CARGA_DESPUES         NUMBER(1,0)             )';

EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE('['||V_TABLA||' CREADA]');  

COMMIT;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;

