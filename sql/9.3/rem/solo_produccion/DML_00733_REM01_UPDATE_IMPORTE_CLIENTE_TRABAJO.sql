--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210304
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9136
--## PRODUCTO=NO
--## 
--## Finalidad: MODIFICAR TRABAJOS
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9136'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_TABLA VARCHAR2(50 CHAR):= 'ACT_TBJ_TRABAJO'; --Vble. Tabla a modificar proveedores

	V_COUNT NUMBER(16):=0; -- Vble. para comprobar
    V_COUNT_TOTAL NUMBER(16):=0; -- Vble. para comprobar
    V_NUM_TABLAS NUMBER(16); -- Vble. para comprobar
    

    --IMPORTE_TOTAL -> IMPORTE CLIENTE
    --IMPORTE_PRESUPUESTO -> IMPORTE PROVEEDOR

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1024);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	TBJ_NUM_TRABAJO | IMPORTE_CLIENTE

	T_TIPO_DATA('916964383546','46,30'),
    T_TIPO_DATA('916964383545','345,20'),
    T_TIPO_DATA('9000305916','345,20'),
    T_TIPO_DATA('9000273892','763,85'),
    T_TIPO_DATA('9000268652','677,10'),
    T_TIPO_DATA('9000260032','348,28'),
    T_TIPO_DATA('916964352743','1711,58'),
    T_TIPO_DATA('916964367662','99,34'),
    T_TIPO_DATA('916964359895','1907,71'),
    T_TIPO_DATA('9000210985','33,87'),
    T_TIPO_DATA('916964373854','358,89'),
    T_TIPO_DATA('916964373849','358,89'),
    T_TIPO_DATA('916964373843','358,89'),
    T_TIPO_DATA('916964372897','358,89'),
    T_TIPO_DATA('916964373842','358,89'),
    T_TIPO_DATA('916964373852','358,89'),
    T_TIPO_DATA('916964373855','358,89'),
    T_TIPO_DATA('916964373847','358,89'),
    T_TIPO_DATA('916964373845','358,89'),
    T_TIPO_DATA('916964372879','358,89'),
    T_TIPO_DATA('916964372887','358,89'),
    T_TIPO_DATA('916964372885','358,89'),
    T_TIPO_DATA('916964340721','1802,28'),
    T_TIPO_DATA('916964368497','575,00'),
    T_TIPO_DATA('916964383566','21,68'),
    T_TIPO_DATA('916964383556','21,68'),
    T_TIPO_DATA('916964383562','21,68'),
    T_TIPO_DATA('916964383554','21,68'),
    T_TIPO_DATA('916964383561','21,68'),
    T_TIPO_DATA('916964383553','21,68'),
    T_TIPO_DATA('916964383577','21,68'),
    T_TIPO_DATA('916964383555','21,68'),
    T_TIPO_DATA('916964383565','21,68'),
    T_TIPO_DATA('916964383568','21,68'),
    T_TIPO_DATA('916964383558','21,68'),
    T_TIPO_DATA('916964383551','21,68')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS IMPORTES TRABAJOS');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

        V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TBJ_NUM_TRABAJO='''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN

            V_MSQL:= 'SELECT TBJ_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TBJ_NUM_TRABAJO='''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET                 
                    TBJ_IMPORTE_TOTAL = TO_NUMBER('''||TRIM(V_TMP_TIPO_DATA(2))||'''),
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                WHERE TBJ_ID = '||V_ID||' ';

            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] TRABAJO '''||TRIM(V_TMP_TIPO_DATA(1))||''' MODIFICADO CORRECTAMENTE  ');
            
            V_COUNT:=V_COUNT+1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL TRABAJO: '''||TRIM(V_TMP_TIPO_DATA(1))||''' ');
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('[FIN] MODIFICADOS CORRECTAMENTE TRABAJOS: '||V_COUNT||' DE '||V_COUNT_TOTAL||'');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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