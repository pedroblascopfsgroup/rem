--/*
--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20180315
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3936
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    ------------------------------COLUMNA DD_MTO_ORDEN----------------------------

    V_SQL := 'SELECT COUNT(1)
    			FROM ALL_TAB_COLUMNS
    			WHERE OWNER = '''||V_ESQUEMA||'''
    			AND TABLE_NAME = ''DD_MTO_MOTIVOS_OCULTACION''
    			AND COLUMN_NAME = ''DD_MTO_ORDEN''
    		 ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLUMNAS;

    IF V_NUM_COLUMNAS = 0 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO NUEVO ATRIBUTO...');
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION
                	ADD DD_MTO_ORDEN NUMBER(5)
                ';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] OK MODIFICACION. ATRIBUTO DD_MTO_MOTIVOS_OCULTACION.DD_MTO_ORDEN CREADO');
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE EL ATRIBUTO DD_MTO_MOTIVOS_OCULTACION.DD_MTO_ORDEN');
    END IF;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION.DD_MTO_ORDEN IS ''Orden de prioridad en los motivos de ocultación.''';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_MTO_ORDEN creado.');
   
    DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');



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
