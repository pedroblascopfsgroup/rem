--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO= 9.3
--## INCIDENCIA_LINK=HREOS-12532
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar en la tabla DD_TAL_TIPO_ALQUILER
--## INSTRUCCIONES:
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
    V_TABLA VARCHAR2(30 CHAR) := 'DD_TAL_TIPO_ALQUILER';
    V_FIELD VARCHAR2(30 CHAR) := 'DD_TAL_ARRENDAMIENTO_SOCIAL';
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-12532';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('03', '1'),
        T_TIPO_DATA('07', '1'),
        T_TIPO_DATA('08', '1'),
        T_TIPO_DATA('09', '1'),
        T_TIPO_DATA('10', '1'),
        T_TIPO_DATA('11', '1'),
        T_TIPO_DATA('12', '1'),
        T_TIPO_DATA('13', '1'),
        T_TIPO_DATA('14', '1'),
        T_TIPO_DATA('15', '1'),
        T_TIPO_DATA('16', '1'),
        T_TIPO_DATA('17', '1')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_SQL := 'SELECT COUNT(1) 
            FROM ALL_TAB_COLUMNS 
            WHERE COLUMN_NAME = '''||V_FIELD||''' 
                AND TABLE_NAME = '''||V_TABLA||''' 
                AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN
	
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                SET '||V_FIELD||' = '||V_TMP_TIPO_DATA(2)||'
                WHERE DD_TAL_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
                    AND NVL('||V_FIELD||', -1) <> '||V_TMP_TIPO_DATA(2)||'
                    AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL;

            IF SQL%ROWCOUNT = 1 THEN
                
                DBMS_OUTPUT.PUT_LINE('  [INFO] El código '||V_TMP_TIPO_DATA(1)||' de la tabla '||V_TABLA||' se ha actualizado correctamente en el campo '||V_FIELD||' al valor '||V_TMP_TIPO_DATA(2)||'.');

            ELSIF SQL%ROWCOUNT = 0 THEN

                DBMS_OUTPUT.PUT_LINE('  [INFO] El código '||V_TMP_TIPO_DATA(1)||' de la tabla '||V_TABLA||' ya tenía el valor '||V_TMP_TIPO_DATA(1)||' en el campo '||V_FIELD||'.');

            END IF;

        ELSE

            DBMS_OUTPUT.PUT_LINE('  [INFO] No existe la tabla ('||V_TABLA||') o el campo a actualizar ('||V_FIELD||')');

        END IF;

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
        ERR_NUM := SQLCODE;
        ERR_MSG := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
        DBMS_OUTPUT.PUT_LINE(ERR_MSG);
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        ROLLBACK;
        RAISE;          
END;
/
EXIT
