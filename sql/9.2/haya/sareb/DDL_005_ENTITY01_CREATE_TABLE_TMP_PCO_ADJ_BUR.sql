--/*
--##########################################
--## AUTOR=MIGUEL ANGEL SANCHEZ
--## FECHA_CREACION=02-03-2016
--## ARTEFACTO=PCO_BUROFAX
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2029
--## PRODUCTO=NO
--## Finalidad: DDL creacion tablas -TMP_PCO_ADJ_BUR 
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: TMP_PCO_ADJ_BUR.');
    
V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_PCO_ADJ_BUR'' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN

    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_PCO_ADJ_BUR(
        ADJ_ID NUMBER(16,0), 
	ADA_ID NUMBER(16,0), 
	ENV_ID NUMBER(16,0), 
	PRC_ID NUMBER(16,0), 
	ASU_ID NUMBER(16,0), 
	ADJ_NOMBRE VARCHAR2(50 CHAR)
                    )'
                    ;
EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('    [INFO] tabla creada.');	
ELSE
	DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla ya existe');
END IF;

DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;          
END;
/
EXIT
