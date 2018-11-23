--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20180405
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3995
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar el diccionario de OPM.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_OPM_OPERACION_MASIVA';
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Inicio de borrado de operaciones masivas');

    EXECUTE IMMEDIATE 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
                SET FECHABORRAR = SYSDATE
                ,USUARIOBORRAR = ''HREOS-3995''
                ,BORRADO = 1
                WHERE DD_OPM_CODIGO IN (''ADPF'', ''ADDF'', ''APUB'', ''AOAC'', ''ADAC'', ''AOPR'', ''ADPR'', ''ADPR'', ''ADPU'')';

    DBMS_OUTPUT.PUT_LINE('[END] Finalizado correctamente');

    COMMIT;
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;