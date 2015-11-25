--/*
--##########################################
--## AUTOR=PedroB
--## FECHA_CREACION=20150703
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.2
--## INCIDENCIA_LINK=CIERRE_DEUDAS
--## PRODUCTO=SI
--##
--## Adaptado a BP : Pedro Blasco
--## Finalidad: DDL de modificación de la tabla de asuntos para que un campo nuevo tenga valor por defecto
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

V_SQL := 'select COUNT(1) from all_tab_cols where UPPER(OWNER)='''||V_ESQUEMA||''' and UPPER(table_name)=''ASU_ASUNTOS'' and UPPER(column_name)=''ERROR_ENVIO_CDD''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS;

IF V_NUM_COLS = 0 THEN
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.ASU_ASUNTOS ADD ERROR_ENVIO_CDD NUMBER(1) DEFAULT 0';
ELSE
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.ASU_ASUNTOS MODIFY ERROR_ENVIO_CDD NUMBER(1) DEFAULT 0';
END IF;

EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ASU_ASUNTOS... Tabla modificada');  

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