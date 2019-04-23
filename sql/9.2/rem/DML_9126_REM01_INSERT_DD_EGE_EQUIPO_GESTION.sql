--/*
--##########################################
--## AUTOR=MARIAM LLISO
--## FECHA_CREACION=20190423
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-6202
--## PRODUCTO=NO
--## 
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EGE_EQUIPO_GESTION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    
    
    
BEGIN

    -- Verificar si la tabla ya existe
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
    
    IF V_NUM_TABLAS = 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||' NO EXISTE.');
    
    ELSE 

        DBMS_OUTPUT.PUT_LINE('[INICIO] CREACION DE REGISTROS PARA EL DICCIONARIO '||V_TEXT_TABLA);
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_EGE_ID, DD_EGE_CODIGO, DD_EGE_DESCRIPCION, DD_EGE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR) 
        VALUES (S_'||V_TEXT_TABLA||'.NEXTVAL, ''01'', ''Mayorista'', ''Mayorista'', ''9.2'', ''HREOS-6202'', SYSDATE)';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INICIO] CREACION DE REGISTROS PARA EL DICCIONARIO '||V_TEXT_TABLA);
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_EGE_ID, DD_EGE_CODIGO, DD_EGE_DESCRIPCION, DD_EGE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR) 
        VALUES (S_'||V_TEXT_TABLA||'.NEXTVAL, ''02'', ''Minorista'', ''Minorista'', ''9.2'', ''HREOS-6202'', SYSDATE)';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] CREADOS REGISTROS PARA EL DICCIONARIO '||V_TEXT_TABLA);

    END IF;


	COMMIT;

EXCEPTION
WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('KO!');
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