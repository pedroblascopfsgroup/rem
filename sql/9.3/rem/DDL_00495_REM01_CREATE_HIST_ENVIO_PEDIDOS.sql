--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210917
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11982
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de la tabla 'HIST_ENVIO_PEDIDOS'
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(40 CHAR) := 'HIST_ENVIO_PEDIDOS';
    TABLE_COUNT NUMBER(1);

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE.');

    
ELSE

    EXECUTE IMMEDIATE 
    'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||
    '(
        GPV_ID	                    NUMBER(16,0),
        FECHA_ENVIO_PRPTRIO	        DATE,
        VERSION 					NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
        USUARIOCREAR 				VARCHAR2(50 CHAR) 			NOT NULL ENABLE, 
        FECHACREAR 					TIMESTAMP (6) 				NOT NULL ENABLE, 
        USUARIOMODIFICAR 			VARCHAR2(50 CHAR), 
        FECHAMODIFICAR 				TIMESTAMP (6), 
        USUARIOBORRAR 				VARCHAR2(50 CHAR), 
        FECHABORRAR 				TIMESTAMP (6), 
        BORRADO 					NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE			
    )'
    ;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  

END IF;

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
