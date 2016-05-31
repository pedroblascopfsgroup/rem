--/*
--##########################################
--## AUTOR=Sergio Hernández Gasó
--## FECHA_CREACION=20160226
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=VOLUMETRIA CARGA CONTRATOS PCR
--## PRODUCTO=NO
--## Finalidad: Permite la carga de contratos sin oficina asignada.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 VersiÃ³n inicial
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
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
DBMS_OUTPUT.put_line('--INICIO--');

V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFI_OFICINAS set ofi_nombre = ''CENTRO EMPRESA'' where ofi_codigo = 100 ';
EXECUTE IMMEDIATE(V_MSQL);
DBMS_OUTPUT.put_line('UPDATE OFICINAS OK');


COMMIT;  

DBMS_OUTPUT.put_line('--FIN--');

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;

    DBMS_OUTPUT.put_line('Error:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line(ERR_MSG);
  
    ROLLBACK;
        RAISE;
END;
/
EXIT;   
