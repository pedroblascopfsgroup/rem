--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160616
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1960
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
        DBMS_OUTPUT.PUT_LINE('[INFO] Configuración de: plazoSiTareaVencida');
        V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''plazoSiTareaVencida''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_EXISTE;
        IF V_NUM_EXISTE > 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD. Actualizando valor...');
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD SET PEN_VALOR=''30'' where PEN_PARAM = ''plazoSiTareaVencida''';
            EXECUTE IMMEDIATE V_MSQL;
        ELSE
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PEN_USOS) VALUES ('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''plazoSiTareaVencida'', ''30'', ''Plazo por defecto que se la da a una tarea que va a nacer vencida'', 0, ''PRODUCTO-1960'', sysdate, 0, ''Plazo por defecto que se la da a una tarea que va a nacer vencida'')';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD');
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
