--/*
--##########################################
--## AUTOR=Salvador Puertes
--## FECHA_CREACION=20180704
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.9.3
--## INCIDENCIA_LINK=HREOS-4251
--## PRODUCTO=NO
--##
--## Finalidad: UPDATE fila de TAP_TAREA_PROCEDIMIENTO - Campo Aceptar y Ampliar para Liberbank en T004_AutorizacionPropietario
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
   
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO Comprobaciones previo UPDATE TAP_TAREA_PROCEDIMIENTO'); 

  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T004_AutorizacionPropietario'' AND TAP_SCRIPT_DECISION NOT LIKE ''valores[''''T004_AutorizacionPropietario''''][''''comboAmpliacion''''] == DDSiNo.SI || valores[''''T004_AutorizacionPropietario''''][''''comboAmpliacionYAutorizacion''''] == DDSiNo.SI ? ''''OK'''' : ''''KO'''''' ';
  DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN
      V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T004_AutorizacionPropietario''''][''''comboAmpliacion''''] == DDSiNo.SI || valores[''''T004_AutorizacionPropietario''''][''''comboAmpliacionYAutorizacion''''] == DDSiNo.SI ? ''''OK'''' : ''''KO'''''' WHERE TAP_CODIGO = ''T004_AutorizacionPropietario''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||sql%rowcount||' Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] el campo ya actualizado en la tabla '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO.');
  END IF;
  
    COMMIT;
  
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