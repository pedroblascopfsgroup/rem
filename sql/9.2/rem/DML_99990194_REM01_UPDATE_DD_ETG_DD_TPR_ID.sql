--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.10
--## INCIDENCIA_LINK=HREOS-3217
--## PRODUCTO=NO
--##
--## Finalidad: Añadir el tipo de proveedor a ciertos registros que lo necesitan
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'DD_ETG_EQV_TIPO_GASTO_RU';
    V_CAMPO VARCHAR2(30 CHAR) := 'DD_TPR_ID';
    V_EXISTS NUMBER(1);
    TYPE T_JBV IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
    V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
    --10 con 28 y 30 es Junta de compensación para EJEC. PROPIEDAD: OBRAS Y MANTENIM.
    --09 con 29 y 31 es Entidad de conservación para COMUNIDADES EUC
    --Borramos filas con código 'DE'
        T_JBV('10','28'),
        T_JBV('10','30'),
        T_JBV('09','29'),
        T_JBV('09','31'),
        T_JBV('DE','50'),
        T_JBV('DE','43'),
        T_JBV('DE','44'),
        T_JBV('DE','45'),
        T_JBV('DE','84'),
        T_JBV('DE','85'));
    V_TMP_JBV T_JBV;
    COUNTER NUMBER(16) := 0;
    COUNT_DEL NUMBER(16) := 0;
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Añadiendo tipos de proveedor.');
    --COMPROBAMOS QUE EFECTIVAMENTE EXISTA EL CAMPO A RELLENAR
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_CAMPO||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 1 THEN
        --RELLENAMOS EL CAMPO
        FOR I IN V_JBV.FIRST .. V_JBV.LAST
        LOOP
            V_TMP_JBV := V_JBV(I);
            IF V_TMP_JBV(1) = 'DE' THEN
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                    SET BORRADO = 1, USUARIOBORRAR = ''HREOS-3217'', FECHABORRAR = SYSDATE 
                    WHERE DD_ETG_CODIGO = '''||V_TMP_JBV(2)||''' AND BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                COUNT_DEL := COUNT_DEL + SQL%ROWCOUNT;
            ELSE
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' T1
                    SET T1.DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '''||V_TMP_JBV(1)||''')
                        , T1.USUARIOMODIFICAR = ''HREOS-3217'', T1.FECHAMODIFICAR = SYSDATE
                    WHERE T1.DD_ETG_CODIGO = '''||V_TMP_JBV(2)||''' 
                        AND NVL(T1.DD_TPR_ID,0) <> (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '''||V_TMP_JBV(1)||''')';
                EXECUTE IMMEDIATE V_MSQL;
                COUNTER := COUNTER + SQL%ROWCOUNT;
            END IF;
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tabla o el campo sobre el que se intenta realizar la operación.');
    END IF;
        
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||COUNTER||' Tipos de proveedor añadidos.');
    DBMS_OUTPUT.PUT_LINE('[INFO] '||COUNT_DEL||' Tipos de acción eliminados.');
    DBMS_OUTPUT.PUT_LINE('[FIN]');
	
EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        ROLLBACK;
        RAISE;          
END;
/
EXIT