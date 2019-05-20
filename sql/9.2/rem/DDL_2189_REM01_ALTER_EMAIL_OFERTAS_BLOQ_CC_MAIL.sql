--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190515
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK=REMVIP-4256
--## PRODUCTO=NO
--## Finalidad: Modificar tamaño EMAIL_OFERTAS_BLOQ.CC_MAIL
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_EXISTS NUMBER(1);

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Alter Tables');
    

            --COMPROBAMOS EXISTENCIA TABLA
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = ''EMAIL_OFERTAS_BLOQ''';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;

            IF V_EXISTS = 1 THEN
                --COMPROBAMOS EXISTENCIA COLUMNA
                V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''CC_MAIL'' AND TABLE_NAME = ''EMAIL_OFERTAS_BLOQ'' AND OWNER = '''||V_ESQUEMA||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
                
                IF V_EXISTS = 1 THEN
                    EXECUTE IMMEDIATE V_MSQL;
                    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.EMAIL_OFERTAS_BLOQ MODIFY CC_MAIL VARCHAR2( 2000 CHAR ) ';
                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.PUT_LINE('[INFO] Columna CC_MAIL modificada en tabla EMAIL_OFERTAS_BLOQ.');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] No existe la columna CC_MAIL en la tabla EMAIL_OFERTAS_BLOQ.');
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tabla EMAIL_OFERTAS_BLOQ');
            END IF;
    
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
