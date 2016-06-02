--/*
--##########################################
--## AUTOR=Rachel
--## FECHA_CREACION=20160318
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-cj
--## INCIDENCIA_LINK=CMREC-1849
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 
    V_NUM_EXISTE NUMBER(16);  
    ERR_NUM NUMBER(25); 
    ERR_MSG VARCHAR2(1024 CHAR); 
BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[INFO] Configuración de directorio de salida de burofaxes'); 

    V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''directorioPdfBurofaxPCO''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_EXISTE;
    IF V_NUM_EXISTE > 0 THEN      
        DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD');
    ELSE
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''directorioPdfBurofaxPCO'', ''/recovery/app-server/output/burofax'', ''Directorio donde se almacenan los acrhivos pdf de los BUROFAXES'', 0, ''DD'', sysdate, 0)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD');
    END IF;

    DBMS_OUTPUT.PUT_LINE('[INFO] Configuración de plantillas'); 
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD SET PEN_VALOR=''/recovery/app-server/plantillas/'' where PEN_PARAM = ''directorioPlantillasLiquidacion''';
    EXECUTE IMMEDIATE V_MSQL;

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
