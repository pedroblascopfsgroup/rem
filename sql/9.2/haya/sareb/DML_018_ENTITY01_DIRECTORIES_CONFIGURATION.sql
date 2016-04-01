--/*
--##########################################
--## AUTOR=Rachel
--## FECHA_CREACION=20160330
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
    TYPE T_TIPO IS TABLE OF VARCHAR2(500 CHAR);
    TYPE T_ARRAY IS TABLE OF T_TIPO;
    V_TIPO T_ARRAY := T_ARRAY(
      T_TIPO('directorioPdfBurofaxPCO', '/recovery/haya/app-server/sareb/output/burofax', 'Directorio donde se generan los burofaxes'),
      T_TIPO('directorioPlantillasLiquidacion', '/recovery/haya/app-server/sareb/plantillas/', 'Directorio donde se almacenan las plantillas de los documentos de LIQUIDACION')
    );
    V_TMP_TIPO T_TIPO;

BEGIN

    FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
    LOOP
        V_TMP_TIPO := V_TIPO(I);
        DBMS_OUTPUT.PUT_LINE('[INFO] Configuración de: ' ||V_TMP_TIPO(1));
        V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = '''||V_TMP_TIPO(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_EXISTE;
        IF V_NUM_EXISTE > 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD. Actualizando valor...');
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD SET PEN_VALOR='''||V_TMP_TIPO(2)||''' where PEN_PARAM = '''||V_TMP_TIPO(1)||'''';
            EXECUTE IMMEDIATE V_MSQL;
        ELSE
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.s_pen_param_entidad.nextval, '''||V_TMP_TIPO(1)||''', '''||V_TMP_TIPO(2)||''', '''||V_TMP_TIPO(3)||''', 0, ''DD'', sysdate, 0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD');
        END IF;
    END LOOP; 

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
