--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20220321
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17466
--## PRODUCTO=NO
--## 
--## Finalidad:
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_ICO_INFO_COMERCIAL';
    V_COUNT NUMBER(16);

    --Array que contiene los registros que se van a crear
    TYPE T_COL IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_COL IS TABLE OF T_COL;
    V_COL T_ARRAY_COL := T_ARRAY_COL(
        T_COL('DD_ECT_ID'),
        T_COL('ICO_APTO_PUBLICIDAD'),
        T_COL('ICO_ACTIVOS_VINC'),
        T_COL('ICO_FECHA_EMISION_INFORME'),
        T_COL('ICO_CONDICIONES_LEGALES'),
        T_COL('DD_EAC_ID'),
        T_COL('ICO_ZONA'),
        T_COL('ICO_DISTRITO'),
        T_COL('ICO_JUSTIFICACION_VENTA'),
        T_COL('ICO_JUSTIFICACION_RENTA'),
        T_COL('ICO_CUOTACP_ORIENTATIVA'),
        T_COL('ICO_DERRAMACP_ORIENTATIVA'),
        T_COL('ICO_FECHA_ESTIMACION_VENTA'),
        T_COL('ICO_FECHA_ESTIMACION_RENTA'),
        T_COL('ICO_INFO_DESCRIPCION'),
        T_COL('ICO_INFO_DISTRIBUCION_INTERIOR'),
        T_COL('DD_DIS_ID'),
        T_COL('ICO_RECIBIO_IMPORTE_ADM'),
        T_COL('ICO_IBI_IMPORTE_ADM'),
        T_COL('ICO_DERRAMA_IMPORTE_ADM'),
        T_COL('ICO_DET_DERRAMA_IMPORTE_ADM'),
        T_COL('ICO_VALOR_MAX_VPO'),
        T_COL('ICO_NUM_TERRAZA_DESCUBIERTA'),
        T_COL('ICO_DESC_TERRAZA_DESCUBIERTA'),
        T_COL('ICO_NUM_TERRAZA_CUBIERTA'),
        T_COL('ICO_DESC_TERRAZA_CUBIERTA'),
        T_COL('ICO_DESPENSA_OTRAS_DEP'),
        T_COL('ICO_LAVADERO_OTRAS_DEP'),
        T_COL('ICO_AZOTEA_OTRAS_DEP'),
        T_COL('ICO_OTROS_OTRAS_DEP'),
        T_COL('ICO_PRESIDENTE_NOMBRE'),
        T_COL('ICO_PRESIDENTE_TELF'),
        T_COL('ICO_ADMINISTRADOR_NOMBRE'),
        T_COL('ICO_ADMINISTRADOR_TELF'),
        T_COL('ICO_EXIS_COM_PROP')
    );
    V_TMP_COL T_COL;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO CAMPOS ANTIGUOS ACT_ICO_INFO_COMERCIAL');

    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);

        V_MSQL := 'SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_TMP_COL(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('  [INFO]: DROP COLUMN '||V_TABLA||'.'||V_TMP_COL(1));

            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' DROP COLUMN '||V_TMP_COL(1);
            EXECUTE IMMEDIATE V_MSQL;
        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO]: LA COLUMNA '||V_TABLA||'.'||V_TMP_COL(1)||' NO EXISTE');
        END IF;
    
    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
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