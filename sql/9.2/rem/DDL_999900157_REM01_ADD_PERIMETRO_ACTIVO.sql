--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20180306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3897
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLUMNAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN

    -------------------------------COLUMNA PAC_CHECK_PUBLICAR-------------------------

    V_SQL := 'SELECT COUNT(1)
                FROM ALL_TAB_COLUMNS
                WHERE OWNER = '''||V_ESQUEMA||'''
                AND TABLE_NAME = ''ACT_PAC_PERIMETRO_ACTIVO''
                AND COLUMN_NAME = ''PAC_CHECK_PUBLICAR''
             ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLUMNAS;

    IF V_NUM_COLUMNAS = 0 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO NUEVO ATRIBUTO...');
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO
                	ADD PAC_CHECK_PUBLICAR NUMBER(1,0)
                ';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] OK MODIFICACION. ATRIBUTO ACT_PAC_PERIMETRO_ACTIVO.PAC_CHECK_PUBLICAR CREADO');
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE EL ATRIBUTO ACT_PAC_PERIMETRO_ACTIVO.PAC_CHECK_PUBLICAR');
    END IF;

    --------------------------------COLUMNA PAC_FECHA_PUBLICAR--------------------------

    V_SQL := 'SELECT COUNT(1)
    			FROM ALL_TAB_COLUMNS
    			WHERE OWNER = '''||V_ESQUEMA||'''
    			AND TABLE_NAME = ''ACT_PAC_PERIMETRO_ACTIVO''
    			AND COLUMN_NAME = ''PAC_FECHA_PUBLICAR''
    		 ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLUMNAS;

    IF V_NUM_COLUMNAS = 0 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO NUEVO ATRIBUTO...');
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO
                	ADD PAC_FECHA_PUBLICAR DATE
                ';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] OK MODIFICACION. ATRIBUTO ACT_PAC_PERIMETRO_ACTIVO.PAC_FECHA_PUBLICAR CREADO');
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE EL ATRIBUTO ACT_PAC_PERIMETRO_ACTIVO.PAC_FECHA_PUBLICAR');
    END IF;

    ------------------------------COLUMNA PAC_MOTIVO_PUBLICAR----------------------------

    V_SQL := 'SELECT COUNT(1)
    			FROM ALL_TAB_COLUMNS
    			WHERE OWNER = '''||V_ESQUEMA||'''
    			AND TABLE_NAME = ''ACT_PAC_PERIMETRO_ACTIVO''
    			AND COLUMN_NAME = ''PAC_MOTIVO_PUBLICAR''
    		 ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLUMNAS;

    IF V_NUM_COLUMNAS = 0 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO NUEVO ATRIBUTO...');
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO
                	ADD PAC_MOTIVO_PUBLICAR VARCHAR2(255 CHAR)
                ';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] OK MODIFICACION. ATRIBUTO ACT_PAC_PERIMETRO_ACTIVO.PAC_MOTIVO_PUBLICAR CREADO');
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE EL ATRIBUTO ACT_PAC_PERIMETRO_ACTIVO.PAC_MOTIVO_PUBLICAR');
    END IF;
   
    DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');

    ------------------------------ERROR HANDLER-------------------------------------------

EXCEPTION
  	WHEN OTHERS THEN 
    	DBMS_OUTPUT.PUT_LINE('KO!');
    	err_num := SQLCODE;
   		err_msg := SQLERRM;    
   		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
   		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
   		DBMS_OUTPUT.PUT_LINE(err_msg);
   		ROLLBACK;
   		RAISE;          
END;

/

EXIT;
