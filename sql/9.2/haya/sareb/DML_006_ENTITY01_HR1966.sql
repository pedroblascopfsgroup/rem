--/*
--##########################################
--## AUTOR=Salvador Gorrita de Gracia
--## FECHA_CREACION=20160226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=HR-1966
--## PRODUCTO=NO
--## Finalidad: DML - Actualización de los scripts de validación de la tarea
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN

        DBMS_OUTPUT.PUT_LINE('******** SUB_SUBASTA ********'); 

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.SUB_SUBASTA SET PRC_ID = 1000000000040717  WHERE SUB_ID = 1000000000001291';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.SUB_SUBASTA');

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
